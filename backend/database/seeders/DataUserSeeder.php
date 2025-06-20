<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DataUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('users')->insert([
            'username' => 'Guest 001',
            'email' => 'user@user.com',
            'password' => Hash::make('12345678'),
            'role' => 'user',
            'email_verified_at' => now(),
            'rating' => 0.0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
