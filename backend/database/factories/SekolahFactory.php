<?php

namespace Database\Factories;

use App\Models\Sekolah;
use Illuminate\Database\Eloquent\Factories\Factory;

class SekolahFactory extends Factory
{
    protected $model = Sekolah::class;

    public function definition(): array
    {
        return [
            'nama_sekolah' => $this->faker->company,
            'lokasi' => $this->faker->address,
        ];
    }
}
