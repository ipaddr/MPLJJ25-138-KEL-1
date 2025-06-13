<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StatusLaporan extends Model
{
    protected $table = 'status_laporan';
    protected $primaryKey = 'id_status_laporan';
    protected $guarded = [];
    public $timestamps = true;
}
