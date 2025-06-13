<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Foto extends Model
{
    use HasFactory;
    protected $table = 'foto';
    protected $primaryKey = 'id_foto';
    protected $guarded = [];
    public $timestamps = true;

    public function tag()
    {
        return $this->belongsTo(TagFoto::class, 'fk_id_tag_foto');
    }
}
