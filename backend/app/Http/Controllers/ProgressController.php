<?php

namespace App\Http\Controllers;

use App\Models\Progress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\TagFoto;
use App\Models\Foto;
use App\Models\Laporan;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

use function Laravel\Prompts\progress;

class ProgressController extends Controller
{
    // Ambil semua data progress
    public function index()
    {
        $progress = Progress::with(['user', 'previous', 'laporan', 'fotos'])->get();
        return response()->json($progress);
    }

    // Tambah progress baru
    public function store(Request $request)
    {   
        $validated = $request->validate([
            'nama_progress' => 'required|string',
            'isi_progress' => 'required|string',
            'persen_progress' => 'required|numeric|min:0|max:100',
            'fk_id_progress_sebelumnya' => 'nullable|exists:progress,id_progress',
            'fk_id_laporan' => 'required|exists:laporan,id_laporan',
        ]);

        $progress = Progress::create([
            'nama_progress' => $validated['nama_progress'],
            'isi_progress' => $validated['isi_progress'],
            'persen_progress' => $validated['persen_progress'],
            'tanggal_progress' => now(),
            'fk_id_progress_sebelumnya' => $validated['fk_id_progress_sebelumnya'] ?? null,
            'fk_id_user' => Auth::id(),
        ]);

        // Hubungkan progress ke laporan
        Laporan::where('id_laporan', $validated['fk_id_laporan'])
            ->update(['fk_id_progress' => $progress->id_progress]);

        // Upload dan hubungkan foto jika ada
        if ($request->hasFile('fotos')) {
            foreach ($request->file('fotos') as $index => $file) {
                $path = $file->store('public/foto');

                // Ambil nama tag sesuai index
                $tagName = $request->input("tags.$index") ?? 'Tanpa Tag';

                // Cari atau buat tag
                $tag = TagFoto::firstOrCreate(['nama_tag' => $tagName]);

                // Simpan foto
                $foto = Foto::create([
                    'data_foto' => $path,
                    'fk_id_tag_foto' => $tag->id_tag_foto,
                ]);

                // Hubungkan foto dengan progress (bukan laporan)
                $progress->fotos()->attach($foto->id_foto);
            }
        }

        return response()->json([
            'message' => 'Progress berhasil dibuat.',
            'data' => $progress->load(['user', 'fotos.tag']),
        ], 201);
    }


    // Update progress (admin only)
    public function update(Request $request, $id)
    {
        $user = Auth::user();
        if ($user->role !== 'admin') {
            return response()->json(['message' => 'Hanya admin yang dapat mengubah progress.'], 403);
        }

        Log::info('Update progress request', [
            'user_id' => $user->id,
            'progress_id' => $id,
            'request_data' => $request->all()
        ]);

        $progress = Progress::findOrFail($id);

        $validated = $request->validate([
            'nama_progress' => 'sometimes|string',
            'isi_progress' => 'sometimes|string',
            'persen_progress' => 'sometimes|numeric|min:0|max:100',
            'fk_id_progress_sebelumnya' => 'nullable|exists:progress,id_progress',
            'daftar_laporan' => 'sometimes|array',
            'daftar_laporan.*' => 'exists:laporan,id_laporan'
        ]);

        $progress->update($validated);

        // Update relasi jika diberikan
        if (array_key_exists('daftar_laporan', $validated)) {
            $progress->laporan()->sync($validated['daftar_laporan']);
        }

        // Update foto jika ada
        if ($request->has('daftar_foto')) {
            $progress->fotos()->sync($request->input('daftar_foto'));
        }

        return response()->json([
            'message' => 'Progress berhasil diperbarui.',
            'data' => $progress
        ]);
    }

    // Hapus progress (admin only)
    public function destroy($id)
    {
        $user = Auth::user();
        if ($user->role !== 'admin') {
            return response()->json(['message' => 'Hanya admin yang dapat menghapus progress.'], 403);
        }

        $progress = Progress::findOrFail($id);
        $progress->delete();

        return response()->json(['message' => 'Progress berhasil dihapus.']);
    }
}
