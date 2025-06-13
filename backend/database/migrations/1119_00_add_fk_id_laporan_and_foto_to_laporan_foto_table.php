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
        Schema::table('laporan_foto', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_laporan')->nullable()->after('id_laporan_foto');
            $table->unsignedBigInteger('fk_id_foto')->nullable()->after('fk_id_laporan');
            $table->foreign('fk_id_laporan')->references('id_laporan')->on('laporan')->onDelete('cascade');
            $table->foreign('fk_id_foto')->references('id_foto')->on('foto')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('laporan_foto', function (Blueprint $table) {
            $table->dropForeign(['fk_id_laporan']);
            $table->dropForeign(['fk_id_foto']);
        });
    }
};
