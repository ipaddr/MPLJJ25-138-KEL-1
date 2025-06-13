<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Foto;
use App\Models\Laporan;
use App\Models\Progress;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ProgressControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function loginAs($role = 'user')
    {
        $user = User::factory()->create(['role' => $role]);
        Sanctum::actingAs($user);
        return $user;
    }

    public function test01_get_all_progress()
    {
        $this->loginAs();

        Progress::factory()->count(2)->create();

        $response = $this->getJson('/api/progress');
        $response->assertStatus(200)->assertJsonCount(2);
    }

    public function test02_create_progress_with_laporan_and_foto()
    {
        $this->loginAs();

        $laporan1 = Laporan::factory()->create();
        $foto1 = Foto::factory()->create();

        $response = $this->postJson('/api/progress', [
            'nama_progress' => 'Perbaikan AC',
            'isi_progress' => 'AC diperbaiki 70%',
            'persen_progress' => 70,
            'daftar_laporan' => [$laporan1->id_laporan],
            'daftar_foto' => [$foto1->id_foto],
        ]);

        $response->assertStatus(201)
                 ->assertJsonFragment(['nama_progress' => 'Perbaikan AC']);

        $this->assertDatabaseHas('laporan_progress', [
            'fk_id_laporan' => $laporan1->id_laporan
        ]);

        $this->assertDatabaseHas('progress_foto', [
            'fk_id_foto' => $foto1->id_foto
        ]);
    }

    public function test03_update_progress_by_admin()
    {
        $this->loginAs('admin');

        $progress = Progress::factory()->create([
            'nama_progress' => 'Awal',
        ]);

        $laporan = Laporan::factory()->create();

        $response = $this->putJson("/api/progress/{$progress->id_progress}", [
            'nama_progress' => 'Update',
            'daftar_laporan' => [$laporan->id_laporan]
        ]);

        $response->assertStatus(200)
                 ->assertJsonFragment(['nama_progress' => 'Update']);
    }

    public function test04_update_progress_ditolak_jika_bukan_admin()
    {
        $this->loginAs();

        $progress = Progress::factory()->create();

        $response = $this->putJson("/api/progress/{$progress->id_progress}", [
            'nama_progress' => 'Tidak bisa'
        ]);

        $response->assertStatus(403);
    }

    public function test05_delete_progress_by_admin()
    {
        $this->loginAs('admin');

        $progress = Progress::factory()->create();

        $response = $this->deleteJson("/api/progress/{$progress->id_progress}");

        $response->assertStatus(200);
        $this->assertDatabaseMissing('progress', ['id_progress' => $progress->id_progress]);
    }

    public function test06_delete_progress_ditolak_jika_user()
    {
        $this->loginAs();

        $progress = Progress::factory()->create();

        $response = $this->deleteJson("/api/progress/{$progress->id_progress}");
        $response->assertStatus(403);
    }
}
