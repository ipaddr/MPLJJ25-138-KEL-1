<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Facades\Log;

class Progress extends Model
{
    use HasFactory;
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'progress';
    protected $primaryKey = 'id_progress';
    protected $guarded = [];
    public $timestamps = true;

    protected $fillable = [
        'nama_progress',
        'isi_progress',
        'persen_progress',
        'tanggal_progress',
        'fk_id_progress_sebelumnya',
        'fk_id_user',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'fk_id_user');
    }

    public function previous()
    {
        return $this->belongsTo(Progress::class, 'fk_id_progress_sebelumnya');
    }

    public function next()
    {
        return $this->hasMany(Progress::class, 'fk_id_progress_sebelumnya');
    }

    public function fotos()
    {
        return $this->belongsToMany(Foto::class, 'progress_foto', 'fk_id_progress', 'fk_id_foto');
    }

    public function laporan()
    {
        return $this->belongsToMany(Laporan::class, 'laporan_progress', 'fk_id_progress', 'fk_id_laporan');
    }

    public function addLaporanToProgress(int $id_laporan)
    {
        LaporanProgress::create([
            'fk_id_progress' => $this->id_progress,
            'fk_id_laporan' => $id_laporan,
        ]);

        Log::info('Laporan ditambahkan ke progress', [
            'progress_id' => $this->id_progress,
            'laporan_id' => $id_laporan,
        ]);
    }
}
