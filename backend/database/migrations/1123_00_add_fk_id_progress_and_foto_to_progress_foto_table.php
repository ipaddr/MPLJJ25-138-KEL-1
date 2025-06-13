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
        Schema::table('progress_foto', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_progress')->nullable()->after('id_progress_foto');
            $table->unsignedBigInteger('fk_id_foto')->nullable()->after('fk_id_progress');
            $table->foreign('fk_id_progress')->references('id_progress')->on('progress')->onDelete('cascade');
            $table->foreign('fk_id_foto')->references('id_foto')->on('foto')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('progress_foto', function (Blueprint $table) {
            $table->dropForeign(['fk_id_progress']);
            $table->dropForeign(['fk_id_foto']);
        });
    }
};
