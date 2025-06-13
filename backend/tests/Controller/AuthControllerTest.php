<?php

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class AuthControllerTest extends \Tests\TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Mail::fake();
    }

    public function test01_registrasi_pengguna_baru()
    {
        $response = $this->postJson('/api/register', [
            'username' => 'Pengguna Uji',
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(201)
            ->assertJsonFragment(['message' => 'Registrasi berhasil. Silakan cek email Anda untuk verifikasi.']);

        $this->assertDatabaseHas('users', ['email' => 'test@example.com']);

        Mail::assertSent(function (\Illuminate\Mail\Mailable $mail) {
            return $mail->hasTo('test@example.com');
        });
    }

    public function test02_tidak_bisa_registrasi_dengan_email_sama()
    {
        User::factory()->create(['email' => 'test@example.com']);

        $response = $this->postJson('/api/register', [
            'username' => 'Pengguna Uji',
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(422);
    }

    public function test03_tidak_bisa_registrasi_tanpa_field_lengkap()
    {
        $response = $this->postJson('/api/register', [
            'email' => 'test@example.com',
        ]);

        $response->assertStatus(422);
    }

    public function test04_kirim_ulang_email_verifikasi_ke_user_belum_terverifikasi()
    {
        $user = User::factory()->create(['email_verified_at' => null]);

        $response = $this->postJson('/api/resend_verification_code', [
            'email' => $user->email,
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Code verifikasi telah dikirim ulang. Silakan cek email Anda.']);

        Mail::assertSent(function (\Illuminate\Mail\Mailable $mail) use ($user) {
            return $mail->hasTo($user->email);
        });
    }

    public function test05_tidak_bisa_kirim_ulang_ke_email_terverifikasi()
    {
        $user = User::factory()->create(['email_verified_at' => now()]);

        $response = $this->postJson('/api/resend_verification_code', [
            'email' => $user->email,
        ]);

        $response->assertStatus(422)
            ->assertJsonFragment(['message' => 'Email sudah terverifikasi.']);
    }

    public function test06_verifikasi_email_dengan_kode_benar()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'email_verification_token' => '123456',
            'email_verification_token_expires_at' => now()->addMinutes(5),
        ]);

        $response = $this->postJson('/api/verify_code', [
            'email' => $user->email,
            'code' => '123456',
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Email berhasil diverifikasi. Silakan login.']);

        $this->assertNotNull($user->fresh()->email_verified_at);
    }

    public function test07_verifikasi_email_dengan_kode_salah()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'email_verification_token' => '123456',
            'email_verification_token_expires_at' => now()->addMinutes(5),
        ]);

        $response = $this->postJson('/api/verify_code', [
            'email' => $user->email,
            'code' => '654321',
        ]);

        $response->assertStatus(400)
            ->assertJsonFragment(['message' => 'Kode verifikasi salah']);
    }

    public function test08_verifikasi_email_dengan_kode_kadaluarsa()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'email_verification_token' => '123456',
            'email_verification_token_expires_at' => now()->subMinutes(1),
        ]);

        $response = $this->postJson('/api/verify_code', [
            'email' => $user->email,
            'code' => '123456',
        ]);

        $response->assertStatus(400)
            ->assertJsonFragment(['message' => 'Kode verifikasi sudah kadaluarsa']);
    }

    public function test09_verifikasi_email_yang_sudah_terverifikasi()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
            'email_verification_token' => '123456',
            'email_verification_token_expires_at' => now()->addMinutes(5),
        ]);

        $response = $this->postJson('/api/verify_code', [
            'email' => $user->email,
            'code' => '123456',
        ]);

        $response->assertStatus(422)
            ->assertJsonFragment(['message' => 'Email sudah terverifikasi. Silahkan Login']);
    }

    public function test10_kirim_token_reset_password()
    {
        $user = User::factory()->create();

        $response = $this->postJson('/api/send_verification_code_pw', [
            'email' => $user->email,
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Token reset password telah dikirim ke email Anda.']);

        $this->assertDatabaseHas('password_reset_tokens', ['email' => $user->email]);

        Mail::assertSent(function (\Illuminate\Mail\Mailable $mail) use ($user) {
            return $mail->hasTo($user->email);
        });
    }

    public function test11_reset_password_dengan_token_valid()
    {
        $user = User::factory()->create(['email_verified_at' => null]);

        DB::table('password_reset_tokens')->insert([
            'email' => $user->email,
            'token' => '654321',
            'created_at' => now(),
        ]);

        $response = $this->postJson('/api/reset_password', [
            'email' => $user->email,
            'token' => '654321',
            'password' => 'newpassword',
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Password berhasil direset.']);

        $this->assertTrue(Hash::check('newpassword', $user->fresh()->password));
        $this->assertNotNull($user->fresh()->email_verified_at);
        $this->assertDatabaseMissing('password_reset_tokens', ['email' => $user->email]);
    }

    public function test12_reset_password_dengan_token_tidak_valid()
    {
        $user = User::factory()->create();

        DB::table('password_reset_tokens')->insert([
            'email' => $user->email,
            'token' => '654321',
            'created_at' => now(),
        ]);

        $response = $this->postJson('/api/reset_password', [
            'email' => $user->email,
            'token' => '000000',
            'password' => 'newpassword',
        ]);

        $response->assertStatus(400)
            ->assertJsonFragment(['message' => 'Token tidak valid.']);
    }

    public function test13_reset_password_dengan_token_kadaluarsa()
    {
        $user = User::factory()->create();

        DB::table('password_reset_tokens')->insert([
            'email' => $user->email,
            'token' => '654321',
            'created_at' => now()->subMinutes(10),
        ]);

        $response = $this->postJson('/api/reset_password', [
            'email' => $user->email,
            'token' => '654321',
            'password' => 'newpassword',
        ]);

        $response->assertStatus(400)
            ->assertJsonFragment(['message' => 'Token sudah kadaluarsa.']);
    }

    public function test14_reset_password_dengan_field_kosong()
    {
        $user = User::factory()->create();

        $response = $this->postJson('/api/reset_password', [
            'email' => $user->email,
            'token' => '',
            'password' => '12345678',
        ]);

        $response->assertStatus(422);
    }

    public function test15_login_dengan_user_terverifikasi()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Login berhasil']);
    }

    public function test16_login_ditolak_jika_belum_verifikasi_email()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(403)
            ->assertJsonFragment(['message' => 'Silakan verifikasi email Anda sebelum login.']);
    }

    public function test17_login_gagal_dengan_password_salah()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(422);
    }

    public function test18_logout_pengguna()
    {
        $user = User::factory()->create(['email_verified_at' => now()]);
        $user = User::where('email', $user->email)->first();
        $this->actingAs($user);

        $response = $this->postJson('/api/logout');

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Logged out successfully']);
    }

    public function test19_dapatkan_info_pengguna_login()
    {
        $user = User::factory()->create(['email_verified_at' => now()]);
        $user = User::where('email', $user->email)->first();
        $this->actingAs($user);

        $response = $this->getJson('/api/get_user');

        $response->assertStatus(200)
            ->assertJsonFragment(['email' => $user->email]);
    }
}
