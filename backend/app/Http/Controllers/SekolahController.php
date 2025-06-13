<?php

namespace App\Http\Controllers;

use App\Models\Sekolah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SekolahController extends Controller
{
    public function index()
    {
        $sekolah = Sekolah::all();
        return response()->json($sekolah);
    }

    public function store(Request $request)
    {
        // hanya admin yang dapat mengakses method ini
        $this->authorizeAdmin();

        $validated = $request->validate([
            'nama_sekolah' => 'required|string',
            'lokasi' => 'required|string',
        ]);

        $sekolah = Sekolah::create($validated);

        return response()->json([
            'message' => 'Sekolah berhasil ditambahkan.',
            'data' => $sekolah,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $this->authorizeAdmin();

        $sekolah = Sekolah::findOrFail($id);

        $validated = $request->validate([
            'nama_sekolah' => 'sometimes|string',
            'lokasi' => 'sometimes|string',
        ]);

        $sekolah->update($validated);

        return response()->json([
            'message' => 'Sekolah berhasil diperbarui.',
            'data' => $sekolah,
        ]);
    }

    public function destroy($id)
    {
        $this->authorizeAdmin();

        $sekolah = Sekolah::findOrFail($id);
        $sekolah->delete();

        return response()->json(['message' => 'Sekolah berhasil dihapus.']);
    }

    private function authorizeAdmin()
    {
        $user = Auth::user();
        if (!$user || $user->role !== 'admin') {
            abort(403, 'Hanya admin yang dapat mengakses resource ini.');
        }
    }
}
