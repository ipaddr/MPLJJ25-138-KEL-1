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
      Schema::table('foto', function (Blueprint $table) {
            $table->unsignedBigInteger('fk_id_tag_foto')->nullable()->after('id_foto');
            $table->foreign('fk_id_tag_foto')->references('id_tag_foto')->on('tag_foto')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('foto', function (Blueprint $table) {
            $table->dropForeign(['fk_id_tag_foto']);
        });
    }
};
