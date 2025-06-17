<?php

namespace App\Http\Controllers;

use App\Models\Laporan;
use App\Models\Foto;
use App\Models\TagFoto;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use App\Models\Rating;

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
        $laporan = Laporan::with(['user', 'sekolah', 'fotos.tag'])
                    ->findOrFail($id);

        // Hitung rata-rata rating dari tabel ratings
        $rating = Rating::where('fk_id_laporan', $id)->avg('nilai_rating');

        return response()->json([
            'message' => 'Detail laporan berhasil diambil.',
            'data' => $laporan,
            'rating' => $rating ?? 0,
        ]);
    }


    // GET laporan hari ini
    public function laporanHariIni()
    {
        try {
            $hariIni = Carbon::now('Asia/Jakarta')->toDateString(); // WIB
            Log::info("Mengambil laporan untuk tanggal: $hariIni (WIB)");

            $laporan = Laporan::with(['user'])
                ->whereDate('tanggal_pelaporan', $hariIni)
                ->get();

            return response()->json($laporan);
        } catch (\Exception $e) {
            Log::error("Gagal ambil laporan hari ini: " . $e->getMessage());
            return response()->json([], 200);
        }
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

    // Rate laporan
   public function rate(Request $request, $id)
    {
        $validated = $request->validate([
            'rating' => 'required|numeric|min:1|max:5',
        ]);

        $laporan = Laporan::findOrFail($id);

        // Pastikan hanya ada satu rating per user per laporan
        $existingRating = $laporan->rating()->where('fk_id_user', Auth::id())->first();

        if ($existingRating) {
            $existingRating->update(['nilai_rating' => $validated['rating']]);
        } else {
            $laporan->rating()->create([
                'fk_id_user' => Auth::id(),
                'nilai_rating' => $validated['rating'],
            ]);
        }

        return response()->json(['message' => 'Rating berhasil disimpan.']);
    }

}
