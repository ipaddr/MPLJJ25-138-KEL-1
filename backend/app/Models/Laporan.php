<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Laporan extends Model
{
    use HasFactory;
    protected $table = 'laporan';
    protected $primaryKey = 'id_laporan';
    protected $guarded = [];
    public $timestamps = true;

    protected $fillable = [
        'judul_laporan',
        'tanggal_pelaporan',
        'isi_laporan',
        'fk_id_user',
        'fk_id_sekolah',
        'fk_id_status_laporan',
        'fk_id_progress',
    ];

    public function status()
    {
        return $this->belongsTo(StatusLaporan::class, 'fk_id_status_laporan');
    }

    public function sekolah()
    {
        return $this->belongsTo(Sekolah::class, 'fk_id_sekolah');
    }

    public function progress()
    {
        return $this->belongsTo(Progress::class, 'fk_id_progress');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'fk_id_user');
    }

    public function komentar()
    {
        return $this->hasManyThrough(Komentar::class, LaporanKomentar::class, 'fk_id_laporan', 'id_komentar', 'id_laporan', 'fk_id_komentar');
    }

    public function likes()
    {
        return $this->hasManyThrough(Like::class, LaporanLikes::class, 'fk_id_laporan', 'id_likes', 'id_laporan', 'fk_id_likes');
    }

    public function rating()
    {
        return $this->hasMany(Rating::class, 'fk_id_laporan');
    }

    public function analisis()
    {
        return $this->hasOne(Analisis::class, 'fk_id_laporan');
    }

    public function fotos()
    {
        return $this->belongsToMany(Foto::class, 'laporan_foto', 'fk_id_laporan', 'fk_id_foto');
    }

    public function progresses()
    {
        return $this->belongsToMany(Progress::class, 'laporan_progress', 'fk_id_laporan', 'fk_id_progress');
    }
}
