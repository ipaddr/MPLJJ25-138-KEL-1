<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Analisis extends Model
{
    protected $table = 'analisis';
    protected $primaryKey = 'id_analisis';
    protected $guarded = [];
    public $timestamps = true;

    public function laporan()
    {
        return $this->belongsTo(Laporan::class, 'fk_id_laporan');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'fk_id_user');
    }
}
