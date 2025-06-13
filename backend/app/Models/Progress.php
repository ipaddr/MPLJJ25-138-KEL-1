<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Progress extends Model
{
    protected $table = 'progress';
    protected $primaryKey = 'id_progress';
    protected $guarded = [];
    public $timestamps = true;

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
}
