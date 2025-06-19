<?php

namespace App\Http\Controllers;

use App\Models\Laporan;
use App\Models\Foto;
use App\Models\LaporanProgress;
use App\Models\Progress;
use App\Models\TagFoto;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use App\Models\Rating;
use App\Models\StatusLaporan;

class LaporanController extends Controller
{
    // Get All
    public function index()
    {
        $laporan = Laporan::with('user', 'sekolah', 'fotos.tag', 'status')->get(); // load relasi 'user'

        // Ambil rata-rata rating per laporan
        $laporanWithRating = $laporan->map(function ($item) {
            $laporanData = $item->toArray(); // ubah model ke array
            $laporanData['rating_laporan'] = $item->rata_rata_rating; // tambahkan rating langsung

            return $laporanData; // tidak lagi pakai ['laporan' => ..., 'rating_laporan' => ...]
        });

        return response()->json([
            'data' => $laporanWithRating
        ], 200);
    }

    // GET detail laporan by ID
   public function show($id)
    {
        $laporan = Laporan::with(['user', 'sekolah', 'fotos.tag', 'status'])->findOrFail($id);

        // Ambil semua laporan milik user ini
        $laporanUserIni = Laporan::with('rating')
            ->where('fk_id_user', $laporan->fk_id_user)
            ->get();

        // Ambil semua nilai rating dari laporan-laporan milik user ini
        $semuaRating = $laporanUserIni->flatMap(function ($laporan) {
            return $laporan->rating->pluck('nilai_rating');
        });

        // Hitung rata-rata rating user
        $userRating = $semuaRating->isNotEmpty()
            ? round($semuaRating->avg(), 2)
            : 0;

        // Tambahkan rating user ke properti user
        $laporanArray = $laporan->toArray();
        $laporanArray['user']['rating'] = $userRating;

        return response()->json([
            'message' => 'Detail laporan berhasil diambil.',
            'data' => $laporanArray,
        ]);
    }

    // GET laporan hari ini
    public function laporanHariIni()
    {
        try {
            $hariIni = Carbon::now('Asia/Jakarta')->toDateString(); // WIB
            Log::info("Mengambil laporan untuk tanggal: $hariIni (WIB)");

           $laporan = Laporan::with('user', 'sekolah', 'fotos.tag')
               ->whereDate('tanggal_pelaporan', $hariIni)
               ->get();

            // Ambil rata-rata rating per laporan dan rating user
            $laporanWithRating = $laporan->map(function ($item) {
                $laporanData = $item->toArray();

                // Set rating_laporan (rata-rata untuk laporan ini saja)
                $laporanData['rating_laporan'] = $item->rata_rata_rating ?? 0;

                // Pastikan struktur user tersedia
                if (!isset($laporanData['user'])) {
                    $laporanData['user'] = [];
                }

                // Cari semua laporan milik user ini
                $laporanUserIni = Laporan::with('rating')
                    ->where('fk_id_user', $item->fk_id_user)
                    ->get();

                // Ambil semua nilai rating dari laporan-laporan milik user ini
                $semuaRating = $laporanUserIni->flatMap(function ($laporan) {
                    return $laporan->rating->pluck('nilai_rating');
                });

                // Hitung rata-rata rating user
                $laporanData['user']['rating'] = $semuaRating->isNotEmpty()
                    ? round($semuaRating->avg(), 2)
                    : 0;

                return $laporanData;
            })->values();

            return response()->json([
                'data' => $laporanWithRating
            ], 200);
            
        } catch (\Exception $e) {
            Log::error("Gagal ambil laporan hari ini: " . $e->getMessage());
            return response()->json([], 500);
        }
    }

    // GET laporan belum diterima
    public function laporanBelumDiterima()
    {
        $laporan = Laporan::with(['user', 'sekolah', 'fotos.tag'])
            ->whereDoesntHave('status', function ($query) {
                $query->where('status', 'diterima');
            })
            ->whereDoesntHave('progress') // Pastikan laporan belum ada di progress
            ->get();

        return response()->json([
            'message' => 'Laporan belum diterima berhasil diambil.',
            'data' => $laporan,
        ]);
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

    // Rate untuk update rating laporan
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
                'fk_id_user' => Auth::id("id_user"),
                'nilai_rating' => $validated['rating'],
            ]);
        }

        return response()->json(['message' => 'Rating berhasil disimpan.']);
    }

    // Get laporan yang telah diterima
    public function laporanDiterima()
    {
        // Ambil laporan yang diterima
       $laporan = Laporan::with(['user', 'sekolah', 'fotos.tag', 'progress'])
        ->whereHas('status', function ($query) {
            $query->where('status', 'diterima');
        })
        ->get();

        Log::info("Mengambil laporan yang telah diterima." . $laporan->count() . " laporan ditemukan.");

        // Ambil rata-rata rating per laporan
        $laporanWithRating = $laporan->map(function ($item) {
            $laporanData = $item->toArray();
            $laporanData['rating_laporan'] = $item->rata_rata_rating ?? 0;

            // set fk_id_progress ke ''
            $laporanData['fk_id_progress'] = '';

            // Pastikan struktur user tersedia
            if (!isset($laporanData['user'])) {
                $laporanData['user'] = [];
            }

            // Cari semua laporan milik user ini
            $laporanUserIni = Laporan::with('rating')
                ->where('fk_id_user', $item->fk_id_user)
                ->get();

            // Ambil semua nilai rating dari laporan-laporan milik user ini
            $semuaRating = $laporanUserIni->flatMap(function ($laporan) {
                return $laporan->rating->pluck('nilai_rating');
            });

            // Hitung rata-rata rating user
            $laporanData['user']['rating'] = $semuaRating->isNotEmpty()
                ? round($semuaRating->avg(), 2)
                : 0;

            return $laporanData;
        })->values();
        return response()->json([
            'data' => $laporanWithRating
        ], 200);
    }

    // Set status laporan
    public function setStatus(Request $request)
    {
        $validated = $request->validate([
            'id_laporan' => 'required|exists:laporan,id_laporan',
            'status' => 'required|in:diterima,ditolak',
        ]);
        $laporan = Laporan::findOrFail($validated['id_laporan']);

        // Buat status baru di laporan_status
        $status = StatusLaporan::create([
            'status' => $validated['status'],
            'tanggal' => now(),
        ]);

        // Update fk_id_status_laporan di tabel laporan
        $laporan->update([
            'fk_id_status_laporan' => $status->id_status_laporan,
        ]);

        return response()->json([
            'message' => 'Status laporan berhasil diubah.',
        ]);
    }

    // Get laporan yang berhubungan dengan id progress
    public function getLaporanByProgressId($id)
    {
        if (!Progress::where('id_progress', $id)->exists()) {
            return response()->json(['message' => 'Progress tidak ditemukan.'], 404);
        }

        $laporan = LaporanProgress::with(['laporan.user', 'laporan.sekolah', 'laporan.fotos.tag'])
            ->where('fk_id_progress', $id)
            ->get()
            ->pluck('laporan');

        return response()->json(['message' => 'Laporan ditemukan.', 'data' => $laporan]);
    }
}
