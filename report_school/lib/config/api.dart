// API configuration file
// Jika memakai emulator maka gunakan IP berikut http://10.0.2.2
// Jika memakai perangkat fisik, ganti dengan IP perangkat fisik contoh http://192.168.1.100
const String apiHost = 'http://10.0.2.2';
const String apiPort = '8000';

// Auth routes (guest only)
const apiLogin = '$apiHost:$apiPort/api/login';
const apiRegister = '$apiHost:$apiPort/api/register';
const apiVerifyCode = '$apiHost:$apiPort/api/verify_code';
const apiSendVerificationCode = '$apiHost:$apiPort/api/send_verification_code';
const apiResendVerificationCode = '$apiHost:$apiPort/api/resend_verification_code';
const apiResetPassword = '$apiHost:$apiPort/api/reset_password';
const apiSendCodeResetPw = '$apiHost:$apiPort/api/send_verification_code_pw';
const apiResendCodeResetPw = '$apiHost:$apiPort/api/resend_verification_code_pw';

// Auth routes (authenticated user only)
const apiLogout = '$apiHost:$apiPort/api/logout';
const apiGetUser = '$apiHost:$apiPort/api/get_user';

// Laporan routes
const apiGetLaporan = '$apiHost:$apiPort/api/laporan';
const apiGetDetailLaporan = '$apiHost:$apiPort/api/laporan/{id}';
const apiCreateLaporan = '$apiHost:$apiPort/api/laporan';
String apiUpdateLaporan(int id) => '$apiHost:$apiPort/api/laporan/$id';
String apiDeleteLaporan(int id) => '$apiHost:$apiPort/api/laporan/$id';

// Progress routes
const apiGetProgress = '$apiHost:$apiPort/api/progress';
const apiCreateProgress = '$apiHost:$apiPort/api/progress';
String apiUpdateProgress(int id) => '$apiHost:$apiPort/api/progress/$id';
String apiDeleteProgress(int id) => '$apiHost:$apiPort/api/progress/$id';

// Sekolah routes
const apiGetSekolah = '$apiHost:$apiPort/api/sekolah';
const apiCreateSekolah = '$apiHost:$apiPort/api/sekolah';
String apiUpdateSekolah(int id) => '$apiHost:$apiPort/api/sekolah/$id';
String apiDeleteSekolah(int id) => '$apiHost:$apiPort/api/sekolah/$id';

// Tag Foto routes
const apiGetTagFoto = '$apiHost:$apiPort/api/tag-foto';
const apiCreateTagFoto = '$apiHost:$apiPort/api/tag-foto';
String apiUpdateTagFoto(int id) => '$apiHost:$apiPort/api/tag-foto/$id';
String apiDeleteTagFoto(int id) => '$apiHost:$apiPort/api/tag-foto/$id';