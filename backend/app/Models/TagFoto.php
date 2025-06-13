<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagFoto extends Model
{
    protected $table = 'tag_foto';
    protected $primaryKey = 'id_tag_foto';
    protected $guarded = [];
    protected $fillable = ['nama_tag'];
    public $timestamps = true;

    public function fotos()
    {
        return $this->hasMany(Foto::class, 'fk_id_tag_foto');
    }
}
