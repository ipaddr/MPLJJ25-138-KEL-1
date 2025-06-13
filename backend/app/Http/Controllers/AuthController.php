<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use App\Mail\VerificationEmail;
use App\Mail\ResetPasswordEmail;
use Carbon\Carbon;

class AuthController extends Controller
{
    // Register user + kirim email verifikasi
    public function register(Request $request)
    {
        // Buat username acak kalau tidak dikirim
        if (empty($request->input('username'))) {
            // Buat username acak untuk guest user
            $username = 'Guest_' . rand(1000, 9999);
            $request->merge(['username' => $username]);
        }

        // Validasi input
        $request->validate([
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
        ]);

        // Buat user dengan email belum terverifikasi
        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'user', // Default role (yang daftar hanya bisa user)
            'rating' => 0, // Default rating
            'email_verified_at' => null,
        ]);

        $this->sendVerificationEmail($user);

        return response()->json([
            'message' => 'Registrasi berhasil. Silakan cek email Anda untuk verifikasi.'
        ], 201);
    }

    // Fungsi untuk mengirim token verifikasi code ke email
    public function sendVerificationCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!is_null($user->email_verified_at)) {
            return response()->json(['message' => 'Email sudah terverifikasi.'], 422);
        }

        // Kirim kode verifikasi
        $this->sendVerificationEmail($user);

        return response()->json([
            'message' => 'Kode verifikasi telah dikirim ke email Anda.'
        ], 200);
    }

    // Kirim ulang email verifikasi
    public function resendVerificationCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $user = User::where('email', $request->email)->first();

        // Kirim ulang email verifikasi
        $this->sendVerificationEmail($user);

        if (!$user) {
            return response()->json(['message' => 'Email tidak ditemukan.'], 404);
        }

        if ($user->email_verified_at) {
            return response()->json(['message' => 'Email sudah terverifikasi.'], 422);
        }

        return response()->json(['message' => 'Code verifikasi telah dikirim ulang. Silakan cek email Anda.'], 200);
    }

    // Verifikasi email dengan kode
    public function verifyCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'code' => 'required|digits:6',
        ]);

        $user = User::where('email', $request->email)->first();

        // Cek apakah user sudah terverifikasi
        if (!is_null($user->email_verified_at)) {
            return response()->json(['message' => 'Email sudah terverifikasi. Silahkan Login'], 422);
        }

        if ($user->email_verification_token !== $request->code) {
            return response()->json(['message' => 'Kode verifikasi salah'], 400);
        } else if (now()->greaterThan($user->email_verification_token_expires_at)) {
            return response()->json(['message' => 'Kode verifikasi sudah kadaluarsa'], 400);
        }

        $user->email_verified_at = now();
        $user->email_verification_token = null;
        $user->email_verification_token_expires_at = null;
        $user->save();

        return response()->json(['message' => 'Email berhasil diverifikasi. Silakan login.'], 200);
    }

    // send verification code for password reset
    public function sendVerification_CodePasswordReset(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $user = User::where('email', $request->email)->first();

        $this->sendResetPasswordEmail($user);

        return response()->json([
            'message' => 'Token reset password telah dikirim ke email Anda.'
        ], 200);
    }

    // Resend password reset
    public function resendVerification_CodePasswordReset(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $user = User::where('email', $request->email)->first();

        // Kirim ulang email reset password
        $this->sendResetPasswordEmail($user);

        return response()->json([
            'message' => 'Token reset password telah dikirim ulang ke email Anda.'
        ], 200);
    }

    public function resetPassword(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'token' => 'required|string',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $reset = DB::table('password_reset_tokens')->where('email', $request->email)->first();

        // Cek apakah token valid
        if (!$reset || $reset->token !== $request->token) {
            return response()->json(['message' => 'Token tidak valid.'], 400);
        }
        
        // Cek apakah token sudah kadaluarsa
        if (Carbon::parse($reset->created_at)->addMinutes(5)->isPast()) {
            return response()->json(['message' => 'Token sudah kadaluarsa.'], 400);
        }

        

        // Cek token di tabel password_reset_tokens
        $reset = DB::table('password_reset_tokens')
            ->where('email', $request->email)
            ->where('token', $request->token)
            ->first();

        if (!$reset) {
            return response()->json([
                'message' => 'Token verifikasi tidak valid atau sudah digunakan.',
            ], 400);
        }

        // Update password user dan verifikasi email
        $user = User::where('email', $request->email)->first();
        $user->password = Hash::make($request->password);
        $user->email_verified_at = now();
        $user->save();

        // Hapus token reset setelah dipakai
        DB::table('password_reset_tokens')
            ->where('email', $request->email)
            ->delete();

        return response()->json([
            'message' => 'Password berhasil direset.',
        ]);
    }

    // Login user (session-based)
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        $user = User::where('email', $request->email)->first();

        // Cek apakah user ada dan email sudah terverifikasi
        if (is_null($user->email_verified_at)) {
            return response()->json(['message' => 'Silakan verifikasi email Anda sebelum login.'], 403);
        }

        // Cek password
        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'message' => ['Password atau email salah.'],
            ]);
        }
        
        // Generate token untuk mobile app
        // Jika menggunakan Laravel Sanctum, bisa digunakan untuk mobile app
        $token = $user->createToken('mobile_token')->plainTextToken;

        // Login user
        Auth::login($user);
        
        // Response dengan data user
        $user->makeHidden(['password', 'email_verification_token', 'email_verified_at']);
        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token, // Token untuk mobile app
            'user' => $user,
        ]);
    }

    // Logout user (session-based)
    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    // Get detail user (optional)
    public function me(Request $request)
    {
        return response()->json($request->user());
    }

    // Fungsi untuk mengirim email verifikasi
    protected function sendVerificationEmail(User $user)
    {
        $verificationCode = rand(100000, 999999);
        $user->email_verification_token = $verificationCode;
        $user->email_verification_token_expires_at = now()->addMinutes(5); // Expired dalam 5 menit
        $user->save();

        Mail::to($user->email)->send(new VerificationEmail($verificationCode));
    }

    // Fungsi untuk mengirim email reset password
    protected function sendResetPasswordEmail(User $user)
    {
        $token = rand(100000, 999999); // 6 digit token

        // Simpan token dengan waktu sekarang
        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $user->email],
            [
                'token' => $token,
                'created_at' => now(),
            ]
        );

        // Kirim email
       Mail::to($user->email)->send(new ResetPasswordEmail($token));
    }

    
}
