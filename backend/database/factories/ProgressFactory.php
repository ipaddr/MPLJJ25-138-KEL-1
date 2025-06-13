<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\User;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Progress>
 */
class ProgressFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
         return [
            'nama_progress' => $this->faker->sentence,
            'isi_progress' => $this->faker->paragraph,
            'persen_progress' => rand(0, 100),
            'tanggal_progress' => $this->faker->date(),
            'fk_id_user' => User::factory(),
        ];
    }
}
