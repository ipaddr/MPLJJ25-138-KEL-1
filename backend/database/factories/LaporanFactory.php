<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\User;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Laporan>
 */
class LaporanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
         return [
            'judul_laporan' => $this->faker->sentence,
            'tanggal_pelaporan' => now(),
            'isi_laporan' => $this->faker->paragraph,
            'fk_id_user' => User::factory(),
        ];
    }
}
