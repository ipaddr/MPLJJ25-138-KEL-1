<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Foto>
 */
class FotoFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            // Jika pakai URL /path
            'data_foto' => $this->faker->imageUrl(640, 480, 'school'),

            // Jika nanti simpan base64, bisa ganti:
            // 'data_foto' => base64_encode(file_get_contents($this->faker->image()))
        ];
    }
}
