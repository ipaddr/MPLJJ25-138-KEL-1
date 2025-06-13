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
      Schema::table('progress', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_progress_sebelumnya')->nullable()->after('fk_id_user');
            $table->foreign('fk_id_progress_sebelumnya')->references('id_progress')->on('progress')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('progress', function (Blueprint $table) {
            $table->dropForeign(['fk_id_progress_sebelumnya']);
        });
    }
};
