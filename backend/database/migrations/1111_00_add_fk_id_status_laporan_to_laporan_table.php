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
       Schema::table('laporan', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_status_laporan')->nullable()->after('isi_laporan');
            $table->foreign('fk_id_status_laporan')->references('id_status_laporan')->on('status_laporan')->onDelete('set null');
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('laporan', function (Blueprint $table) {
            $table->dropForeign(['fk_id_status_laporan']);
        });
    }
};
