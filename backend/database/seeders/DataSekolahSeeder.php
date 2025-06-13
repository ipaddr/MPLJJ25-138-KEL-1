<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Sekolah;

class DataSekolahSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = [
            ['nama_sekolah' => 'SMA Negeri 1 Bandung', 'lokasi' => 'Jl. Merdeka No. 10, Bandung'],
            ['nama_sekolah' => 'SMP Negeri 2 Jakarta', 'lokasi' => 'Jl. Sudirman No. 45, Jakarta'],
            ['nama_sekolah' => 'SD Negeri 3 Yogyakarta', 'lokasi' => 'Jl. Malioboro No. 8, Yogyakarta'],
            ['nama_sekolah' => 'SMK Negeri 4 Surabaya', 'lokasi' => 'Jl. Pemuda No. 12, Surabaya'],
            ['nama_sekolah' => 'SMA Negeri 5 Medan', 'lokasi' => 'Jl. Gatot Subroto No. 25, Medan'],
        ];

        foreach ($data as $item) {
            Sekolah::create($item);
        }
    }
}
