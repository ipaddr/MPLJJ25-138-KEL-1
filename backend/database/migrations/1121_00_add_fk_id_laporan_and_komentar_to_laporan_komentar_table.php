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
        Schema::table('laporan_komentar', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_laporan')->nullable()->after('id_laporan_komentar');
            $table->unsignedBigInteger('fk_id_komentar')->nullable()->after('fk_id_laporan');
            $table->foreign('fk_id_laporan')->references('id_laporan')->on('laporan')->onDelete('cascade');
            $table->foreign('fk_id_komentar')->references('id_komentar')->on('komentar')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('laporan_komentar', function (Blueprint $table) {
            $table->dropForeign(['fk_id_laporan']);
            $table->dropForeign(['fk_id_komentar']);
        });
    }
};
