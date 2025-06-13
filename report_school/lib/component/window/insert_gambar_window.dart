import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../component/window/konfirmasi_window.dart';
import '../../controller/tag_foto_controller.dart';
import '../../models/tag_foto.dart';

class UploadDokumenWindow extends StatefulWidget {
  final Function(File image, TagFoto tag) onSubmit;

  const UploadDokumenWindow({super.key, required this.onSubmit});

  @override
  State<UploadDokumenWindow> createState() => _UploadDokumenWindowState();
}

class _UploadDokumenWindowState extends State<UploadDokumenWindow> {
  File? _selectedImage;
  final picker = ImagePicker();
  TagFoto? _selectedTag;
  final TextEditingController newTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tagController = Provider.of<TagFotoController>(context, listen: false);
      tagController.fetchTags();
    });
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedImage == null || _selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar dan pilih satu tag terlebih dahulu.')),
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SystemMessageCard(
            message: "Apakah Anda yakin ingin mengunggah dokumen ini?",
            yesText: "Ya",
            noText: "Batal",
          ),
        );
      },
    );

    if (result == true) {
      widget.onSubmit(_selectedImage!, _selectedTag!);
      if (mounted) {
        Navigator.pop(context); // Tutup window setelah submit
      }
    }
  }

  Future<void> _addNewTag() async {
    final namaTag = newTagController.text.trim();
    if (namaTag.isEmpty) return;

    final tagController = Provider.of<TagFotoController>(context, listen: false);
    final success = await tagController.addTag(namaTag);
    if (success) {
      newTagController.clear();
      await tagController.fetchTags(); // refresh list tag
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tag berhasil ditambahkan.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan tag (kemungkinan sudah ada).")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagCtrl = Provider.of<TagFotoController>(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    'Dokumen Pendukung',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Area Gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Pilih gambar'),
                          ],
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // Dropdown Tag
              DropdownButtonFormField<TagFoto>(
                value: _selectedTag,
                items: tagCtrl.tags.map((tag) {
                  return DropdownMenuItem(
                    value: tag,
                    child: Text(tag.namaTag),
                  );
                }).toList(),
                onChanged: (tag) {
                  setState(() => _selectedTag = tag);
                },
                decoration: const InputDecoration(
                  labelText: 'Pilih Tag',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              // Tambah Tag Baru
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newTagController,
                      decoration: InputDecoration(
                        hintText: "Tambahkan tag baru",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNewTag,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
