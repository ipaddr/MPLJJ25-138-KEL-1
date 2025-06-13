<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
       Schema::create('analisis', function (Blueprint $table) {
            $table->id('id_analisis');
            $table->date('tanggal_analisis');
            $table->string('hasil_analisis_kerusakan')->nullable();
            $table->string('hasil_analisis_kekurangan')->nullable();
            $table->float('persenan_rusak_berat')->default(0);
            $table->float('persenan_rusak_sedang')->default(0);
            $table->float('persenan_rusak_ringan')->default(0);
            $table->timestamps();
       });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('analisis');
    }
};
