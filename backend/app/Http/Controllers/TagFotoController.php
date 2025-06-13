<?php

namespace App\Http\Controllers;

use App\Models\TagFoto;
use Illuminate\Http\Request;

class TagFotoController extends Controller
{
    public function index()
    {
        $tags = TagFoto::all();
        return response()->json($tags);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama_tag' => 'required|string|unique:tag_foto,nama_tag',
        ]);

        $tag = TagFoto::create([
            'nama_tag' => $request->nama_tag,
        ]);

        return response()->json(['message' => 'Tag berhasil dibuat.', 'data' => $tag], 201);
    }

    public function update(Request $request, $id)
    {
        $tag = TagFoto::findOrFail($id);

        $request->validate([
            'nama_tag' => 'required|string|unique:tag_foto,nama_tag,' . $id . ',id_tag_foto',
        ]);

        $tag->update([
            'nama_tag' => $request->nama_tag,
        ]);

        return response()->json(['message' => 'Tag berhasil diperbarui.', 'data' => $tag]);
    }

    public function destroy($id)
    {
        $tag = TagFoto::findOrFail($id);
        $tag->delete();

        return response()->json(['message' => 'Tag berhasil dihapus.']);
    }
}
