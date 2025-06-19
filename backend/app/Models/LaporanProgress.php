<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LaporanProgress extends Model
{
    protected $table = 'laporan_progress';
    protected $guarded = [];
    public $timestamps = true;

    public function laporan()
    {
        return $this->belongsTo(Laporan::class, 'fk_id_laporan');
    }

    public function progress()
    {
        return $this->belongsTo(Progress::class, 'fk_id_progress');
    }
}
