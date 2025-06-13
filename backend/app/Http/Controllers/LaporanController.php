<?php

namespace App\Http\Controllers;

use App\Models\Laporan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LaporanController extends Controller
{
    // Get All
    public function index()
    {
        $laporan = Laporan::all();
        return response()->json($laporan);
    }

    // Create
    public function store(Request $request)
    {
        $validated = $request->validate([
            'judul_laporan' => 'required|string',
            'tanggal_pelaporan' => 'required|date',
            'isi_laporan' => 'required|string',
        ]);

        $laporan = Laporan::create([
            'judul_laporan' => $validated['judul_laporan'],
            'tanggal_pelaporan' => $validated['tanggal_pelaporan'],
            'isi_laporan' => $validated['isi_laporan'],
            'fk_id_user' => Auth::id(),
        ]);

        return response()->json([
            'message' => 'Laporan berhasil dibuat.',
            'data' => $laporan
        ], 201);
    }

    // Update (Admin only)
    public function update(Request $request, $id)
    {
        $user = Auth::user();
        if ($user->role !== 'admin') {
            return response()->json(['message' => 'Hanya admin yang dapat mengubah laporan.'], 403);
        }

        $laporan = Laporan::findOrFail($id);

        $validated = $request->validate([
            'judul_laporan' => 'sometimes|string',
            'tanggal_pelaporan' => 'sometimes|date',
            'isi_laporan' => 'sometimes|string',
        ]);

        $laporan->update($validated);

        return response()->json([
            'message' => 'Laporan berhasil diubah.',
            'data' => $laporan
        ]);
    }

    // Delete (Admin only)
    public function destroy($id)
    {
        $user = Auth::user();
        if ($user->role !== 'admin') {
            return response()->json(['message' => 'Hanya admin yang dapat menghapus laporan.'], 403);
        }

        $laporan = Laporan::findOrFail($id);
        $laporan->delete();

        return response()->json(['message' => 'Laporan berhasil dihapus.']);
    }
}
