<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LaporanController;
use App\Http\Controllers\ProgressController;
use App\Http\Controllers\SekolahController;
use App\Http\Controllers\TagFotoController;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;

Route::get('/', function () {
    return view('welcome');
});

// Api routes for authentication
Route::middleware('guest')->withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::post('/api/register', [AuthController::class, 'register']);
    Route::post('/api/login', [AuthController::class, 'login']);
    Route::post('/api/verify_code', [AuthController::class, 'verifyCode']);
    Route::post('/api/send_verification_code', [AuthController::class, 'sendVerificationCode']);
    Route::post('/api/resend_verification_code', [AuthController::class, 'resendVerificationCode']);
    Route::post('/api/send_verification_code_pw', [AuthController::class, 'sendVerification_CodePasswordReset']);
    Route::post('/api/resend_verification_code_pw', [AuthController::class, 'resendVerification_CodePasswordReset']);
    Route::post('/api/reset_password', [AuthController::class, 'resetPassword']);
});


Route::middleware('auth')->group(function () {
    Route::post('/api/logout', [AuthController::class, 'logout']);
    Route::get('/api/get_user', [AuthController::class, 'me']);
});

// Api routes for checking if user is admin
Route::middleware('auth:sanctum')->withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::get('/api/is_admin', [AuthController::class, 'isAdmin']);
});

// Api routes for Laporan
Route::middleware('auth:sanctum')->withoutMiddleware(VerifyCsrfToken::class)->group(function ()  {
    Route::get('/api/laporan/all', [LaporanController::class, 'index']);
    Route::get('/api/laporan/hari_ini', [LaporanController::class, 'laporanHariIni']);
   //Route::get('/api/laporan', [LaporanController::class, 'index']);
    Route::get('/api/laporan_id/{id}', [LaporanController::class, 'show']);
    Route::post('/api/laporan', [LaporanController::class, 'store']);
    Route::put('/api/laporan/{id}', [LaporanController::class, 'update']);
    Route::delete('/api/laporan/{id}', [LaporanController::class, 'destroy']);

    // Route untuk rating laporan
    Route::post('/api/laporan/{id}/rating', [LaporanController::class, 'rate']);

    // Route untuk laporan yang telah di terima
    Route::get('/api/laporan/diterima', [LaporanController::class, 'laporanDiterima']);

    // Route untuk laporan yang belum di terima
    Route::get('/api/laporan/belum_diterima', [LaporanController::class, 'laporanBelumDiterima']);

    // Route untuk set laporan status
    Route::post('/api/laporan/status', [LaporanController::class, 'setStatus']);

    // Route ambil semua laporan yang berhubungan dengan id progress
    Route::get('/api/laporan_terkait/progress/{id}', [LaporanController::class, 'getLaporanByProgressId']);
});

// Api routes testing
Route::withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::get('/api/testing/laporan/hari_ini', [LaporanController::class, 'laporanHariIni']);
    Route::get('/api/testing/laporan_id/{id}', [LaporanController::class, 'show']);
    Route::get('/api/testing/laporan/diterima', [LaporanController::class, 'laporanDiterima']);
    Route::get('/api/testing/laporan/belum_diterima', [LaporanController::class, 'laporanBelumDiterima']);
    Route::get('/api/testing/progress', [ProgressController::class, 'index']);
    Route::get('/api/testing/laporan_terkait/{id}', [LaporanController::class, 'getLaporanByProgressId']);
});


// Api routes for Progress
Route::middleware('auth:sanctum')->withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::get('/api/progress/all', [ProgressController::class, 'index']);
    Route::get('/api/progress/selesai', [ProgressController::class, 'progressSelesai']);
    Route::get('/api/progress_id/{id}', [ProgressController::class, 'show']);
    Route::post('/api/progress', [ProgressController::class, 'store']);
    Route::put('/api/progress/{id}', [ProgressController::class, 'update']);
    Route::delete('/api/progress/{id}', [ProgressController::class, 'destroy']);
});

// Api untuk data sekolah
Route::middleware('auth:sanctum')->withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::get('/api/sekolah', [SekolahController::class, 'index']);
    Route::post('/api/sekolah', [SekolahController::class, 'store']);
    Route::put('/api/sekolah/{id}', [SekolahController::class, 'update']);
    Route::delete('/api/sekolah/{id}', [SekolahController::class, 'destroy']);
});


// Api untuk tag foto
Route::middleware('auth:sanctum')->withoutMiddleware(VerifyCsrfToken::class)->group(function () {
    Route::get('/api/tag-foto', [TagFotoController::class, 'index']);
    Route::post('/api/tag-foto', [TagFotoController::class, 'store']);
    Route::put('/api/tag-foto/{id}', [TagFotoController::class, 'update']);
    Route::delete('/api/tag-foto/{id}', [TagFotoController::class, 'destroy']);
});
