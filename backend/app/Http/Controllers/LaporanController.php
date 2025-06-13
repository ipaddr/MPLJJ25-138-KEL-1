<?php

namespace App\Http\Controllers;

use App\Models\Laporan;
use App\Models\Foto;
use App\Models\TagFoto;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LaporanController extends Controller
{
    // Get All
    public function index()
    {
        $laporan = Laporan::with('user')->get(); // load relasi 'user'
        return response()->json($laporan);
    }

    // GET detail laporan by ID
    public function show($id)
    {
        $laporan = Laporan::with(['user', 'sekolah', 'fotos.tag', 'status'])
            ->findOrFail($id);

        return response()->json([
            'message' => 'Detail laporan berhasil diambil.',
            'data' => $laporan
        ], 200);
    }

    // Store
    public function store(Request $request)
    {
        $validated = $request->validate([
            'judul_laporan' => 'required|string',
            'tanggal_pelaporan' => 'required|date',
            'isi_laporan' => 'required|string',
            'fk_id_sekolah' => 'required|exists:sekolah,id_sekolah',
            'tag_foto' => 'array',
            'tag_foto.*' => 'string|nullable',
        ]);

        $laporan = Laporan::create([
            'judul_laporan' => $validated['judul_laporan'],
            'tanggal_pelaporan' => $validated['tanggal_pelaporan'],
            'isi_laporan' => $validated['isi_laporan'],
            'fk_id_user' => Auth::id(),
            'fk_id_sekolah' => $validated['fk_id_sekolah'],
        ]);

        if ($request->hasFile('foto')) {
            foreach ($request->file('foto') as $index => $file) {
                $path = $file->store('public/foto');

                $tagName = $request->input("tag_foto.$index") ?? 'Tanpa Tag';

                // Cari atau buat Tag (bukan TagFoto!)
                $tag = TagFoto::firstOrCreate(['nama_tag' => $tagName]);

                // Simpan foto dengan relasi ke TagFoto
                $foto = Foto::create([
                    'data_foto' => $path,
                    'fk_id_tag_foto' => $tag->id_tag_foto, // Gunakan id_tag_foto dari TagFoto
                ]);

                // Hubungkan ke laporan
                $laporan->fotos()->attach($foto->id_foto);
            }
        }

        return response()->json([
            'message' => 'Laporan berhasil dibuat.',
            'data' => $laporan->load(['sekolah', 'fotos.tag']),
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
