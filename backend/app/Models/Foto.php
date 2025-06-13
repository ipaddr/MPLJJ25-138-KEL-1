<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Foto extends Model
{
    protected $table = 'foto';
    protected $primaryKey = 'id_foto';
    protected $guarded = [];
    public $timestamps = true;

    public function tag()
    {
        return $this->belongsTo(TagFoto::class, 'fk_id_tag_foto');
    }
}
