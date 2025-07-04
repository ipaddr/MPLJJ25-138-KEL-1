// API configuration file
// Jika memakai emulator maka gunakan IP berikut http://10.0.2.2
// Jika memakai perangkat fisik, ganti dengan IP perangkat fisik contoh http://192.168.1.100
const String apiHost = 'http://10.0.2.2';
const String apiPort = '8000';

// HOST untuk file pendukung
const String hostFilePendukung = 'http://192.168.215.167';
const String portFilePendukung = '8000';

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
const apiIsAdmin = '$apiHost:$apiPort/api/is_admin';

// Laporan routes
const apiGetLaporanAll = '$apiHost:$apiPort/api/laporan/all';
const apiGetDetailLaporan = '$apiHost:$apiPort/api/laporan_id/{id}';
const apiCreateLaporan = '$apiHost:$apiPort/api/laporan';
String apiUpdateLaporan(int id) => '$apiHost:$apiPort/api/laporan/$id';
String apiDeleteLaporan(int id) => '$apiHost:$apiPort/api/laporan/$id';
const apiGetLaporanHariIni = '$apiHost:$apiPort/api/laporan/hari_ini';
// Route untuk memberikan rating pada laporan berdasarkan id laporan
String apiRateLaporan(int id) => '$apiHost:$apiPort/api/laporan/$id/rating';
// Route untuk mengambil data laporan di terima
const apiGetLaporanDiterima = '$apiHost:$apiPort/api/laporan/diterima';
// Route untuk mengambil data laporan belum diterima
const apiGetLaporanBelumDiterima = '$apiHost:$apiPort/api/laporan/belum_diterima';
// Route untuk set status laporan
const apiSetLaporanStatus = '$apiHost:$apiPort/api/laporan/status';
// Route untuk mengambil laporan berdasarkan id progres
String apiGetLaporanByProgress(int id) => '$apiHost:$apiPort/api/laporan_terkait/progress/$id';

// Progress routes
const apiGetProgress = '$apiHost:$apiPort/api/progress/all';
const apiGetProgressSelesai = '$apiHost:$apiPort/api/progress/selesai';
const apiCreateProgress = '$apiHost:$apiPort/api/progress';
String apiUpdateProgress(int id) => '$apiHost:$apiPort/api/progress/$id';
String apiDeleteProgress(int id) => '$apiHost:$apiPort/api/progress/$id';
// Route ambil detail progres berdasarkan id
const apiGetDetailProgress = '$apiHost:$apiPort/api/progress_id/{id}';

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