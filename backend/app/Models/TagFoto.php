<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagFoto extends Model
{
    protected $table = 'tag_foto';
    protected $primaryKey = 'id_tag_foto';
    protected $guarded = [];
    public $timestamps = true;
}
