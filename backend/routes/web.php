<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::get('/', function () {
    return view('welcome');
});


// Api routes for authentication
Route::middleware('guest')->group(function () {
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
