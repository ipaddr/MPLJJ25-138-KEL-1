<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Sekolah extends Model
{
    use HasFactory;
    protected $table = 'sekolah';
    protected $primaryKey = 'id_sekolah';
    protected $guarded = [];
    protected $fillable = ['nama_sekolah', 'lokasi'];
    public $timestamps = true;
}
