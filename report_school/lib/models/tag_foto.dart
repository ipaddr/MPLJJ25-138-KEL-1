class TagFoto {
  final int id;
  final String namaTag;

  TagFoto({
    required this.id,
    required this.namaTag,
  });

  factory TagFoto.fromJson(Map<String, dynamic> json) {
    return TagFoto(
      id: json['id_tag_foto'],
      namaTag: json['nama_tag'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_tag_foto': id,
    'nama_tag': namaTag,
  };
}
