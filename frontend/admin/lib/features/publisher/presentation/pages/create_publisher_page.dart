import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/publisher_bloc.dart';
import '../bloc/publisher_event.dart';

class CreatePublisherPage extends StatefulWidget {
  const CreatePublisherPage({super.key});

  @override
  State<CreatePublisherPage> createState() => _CreatePublisherPageState();
}

class _CreatePublisherPageState extends State<CreatePublisherPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<PublisherBloc>().add(
      CreatePublisherEvent(
        name: _nameCtrl.text,
        website: _websiteCtrl.text.isEmpty ? null : _websiteCtrl.text,
        logo: _selectedImage,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Publisher'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // ================= TITLE =================
                      const Text(
                        'Informasi Publisher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ================= NAME =================
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Publisher',
                          prefixIcon: Icon(Icons.business),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                      ),

                      const SizedBox(height: 16),

                      // ================= WEBSITE =================
                      TextFormField(
                        controller: _websiteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Website (Opsional)',
                          prefixIcon: Icon(Icons.language),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ================= LOGO =================
                      const Text(
                        'Logo Publisher',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _selectedImage != null
                                ? NetworkImage(_selectedImage!.path)
                                : null,
                            child: _selectedImage == null
                                ? const Icon(
                                    Icons.image,
                                    size: 32,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.upload),
                            label: Text(
                              _selectedImage == null
                                  ? 'Pilih Logo'
                                  : 'Ganti Logo',
                            ),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ================= ACTION =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Simpan'),
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
