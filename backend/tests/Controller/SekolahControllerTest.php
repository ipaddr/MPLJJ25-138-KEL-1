<?php

namespace Tests\Feature;

use App\Models\Sekolah;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class SekolahControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function loginAs($role = 'admin')
    {
        $user = User::factory()->create(['role' => $role]);
        Sanctum::actingAs($user);
        return $user;
    }

    public function test01_get_all_sekolah()
    {
        $this->loginAs();

        Sekolah::factory()->count(2)->create();

        $response = $this->getJson('/api/sekolah');
        $response->assertStatus(200)->assertJsonCount(2);
    }

    public function test02_create_sekolah_berhasil()
    {
        $this->loginAs();

        $response = $this->postJson('/api/sekolah', [
            'nama_sekolah' => 'SMAN 1 Contoh',
            'lokasi' => 'Jl. Contoh No. 1'
        ]);

        $response->assertStatus(201)->assertJsonFragment([
            'nama_sekolah' => 'SMAN 1 Contoh'
        ]);
    }

    public function test03_update_sekolah_berhasil()
    {
        $this->loginAs();

        $sekolah = Sekolah::factory()->create();

        $response = $this->putJson("/api/sekolah/{$sekolah->id_sekolah}", [
            'nama_sekolah' => 'SMAN 1 Update'
        ]);

        $response->assertStatus(200)->assertJsonFragment([
            'nama_sekolah' => 'SMAN 1 Update'
        ]);
    }

    public function test04_delete_sekolah_berhasil()
    {
        $this->loginAs();

        $sekolah = Sekolah::factory()->create();

        $response = $this->deleteJson("/api/sekolah/{$sekolah->id_sekolah}");

        $response->assertStatus(200);
        $this->assertDatabaseMissing('sekolah', [
            'id_sekolah' => $sekolah->id_sekolah
        ]);
    }

    public function test05_user_ditolak_akses_sekolah()
    {
        $user = User::factory()->create(['role' => 'user']);
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/sekolah');
        $response->assertStatus(403);
    }
}
