<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Laporan;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;

class LaporanControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function authenticateAs($role = 'user')
    {
        $user = User::factory()->createOne([
            'role' => $role,
        ]);

        Sanctum::actingAs($user);
        return $user;
    }

    public function test01_get_all_laporan_berhasil()
    {
        $this->authenticateAs();

        Laporan::factory()->count(3)->create();

        $response = $this->getJson('/api/laporan');

        $response->assertStatus(200)
                 ->assertJsonCount(3);
    }

    public function test02_create_laporan_berhasil()
    {
        $this->authenticateAs();

        $response = $this->postJson('/api/laporan', [
            'judul_laporan' => 'Kerusakan Atap',
            'tanggal_pelaporan' => now()->toDateString(),
            'isi_laporan' => 'Atap ruang kelas bocor parah.'
        ]);

        $response->assertStatus(201)
                 ->assertJsonFragment(['judul_laporan' => 'Kerusakan Atap']);
    }

    public function test03_update_laporan_oleh_admin_berhasil()
    {
        $this->authenticateAs('admin');

        $laporan = Laporan::factory()->create([
            'judul_laporan' => 'Awal',
        ]);

        $response = $this->putJson("/api/laporan/{$laporan->id_laporan}", [
            'judul_laporan' => 'Diupdate',
        ]);

        $response->assertStatus(200)
                 ->assertJsonFragment(['judul_laporan' => 'Diupdate']);
    }

    public function test04_update_laporan_oleh_user_ditolak()
    {
        $this->authenticateAs('user');

        $laporan = Laporan::factory()->create();

        $response = $this->putJson("/api/laporan/{$laporan->id_laporan}", [
            'judul_laporan' => 'Gagal Update',
        ]);

        $response->assertStatus(403);
    }

    public function test05_delete_laporan_oleh_admin_berhasil()
    {
        $this->authenticateAs('admin');

        $laporan = Laporan::factory()->create();

        $response = $this->deleteJson("/api/laporan/{$laporan->id_laporan}");

        $response->assertStatus(200);
        $this->assertDatabaseMissing('laporan', ['id_laporan' => $laporan->id_laporan]);
    }

    public function test06_delete_laporan_oleh_user_ditolak()
    {
        $this->authenticateAs('user');

        $laporan = Laporan::factory()->create();

        $response = $this->deleteJson("/api/laporan/{$laporan->id_laporan}");

        $response->assertStatus(403);
    }
}
