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
        Schema::table('analisis', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_laporan')->nullable()->after('id_analisis');
            $table->foreign('fk_id_laporan')->references('id_laporan')->on('laporan')->onDelete('cascade');
            $table->unique('fk_id_laporan');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('analisis', function (Blueprint $table) {
            $table->dropUnique(['fk_id_laporan']);
        });
    }
};
