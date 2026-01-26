import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/publisher.dart';
import '../bloc/publisher_bloc.dart';
import '../bloc/publisher_event.dart';

class EditPublisherPage extends StatefulWidget {
  final Publisher publisher;

  const EditPublisherPage({super.key, required this.publisher});

  @override
  State<EditPublisherPage> createState() => _EditPublisherPageState();
}

class _EditPublisherPageState extends State<EditPublisherPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _websiteCtrl;

  XFile? _newImage;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.publisher.name);
    _websiteCtrl = TextEditingController(text: widget.publisher.website ?? '');
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _newImage = image);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<PublisherBloc>().add(
      UpdatePublisherEvent(
        id: widget.publisher.id,
        name: _nameCtrl.text,
        website: _websiteCtrl.text.isEmpty ? null : _websiteCtrl.text,
        logo: _newImage, // null jika tidak ganti logo
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final oldLogo = widget.publisher.logoUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Publisher')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 4,
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
                    // ================= HEADER =================
                    const Text(
                      'Edit Publisher',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Perbarui informasi publisher',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= NAME =================
                    _InputField(
                      controller: _nameCtrl,
                      label: 'Publisher Name',
                      icon: Icons.business,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),

                    const SizedBox(height: 16),

                    // ================= WEBSITE =================
                    _InputField(
                      controller: _websiteCtrl,
                      label: 'Website (Opsional)',
                      icon: Icons.language,
                    ),

                    const SizedBox(height: 24),

                    // ================= LOGO SECTION =================
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
                        // OLD LOGO
                        if (oldLogo != null && _newImage == null)
                          _LogoPreview(
                            title: 'Logo Saat Ini',
                            image: Image.network(
                              "http://localhost:3000/api$oldLogo",
                              fit: BoxFit.cover,
                            ),
                          ),

                        if (_newImage != null)
                          _LogoPreview(
                            title: 'Logo Baru',
                            image: Image.network(
                              _newImage!.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      icon: const Icon(Icons.image),
                      label: Text(
                        _newImage == null ? 'Ganti Logo' : 'Ganti Logo Lagi',
                      ),
                      onPressed: _pickImage,
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
                          label: const Text('Update'),
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
    );
  }
}

// ================= INPUT FIELD =================
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ================= LOGO PREVIEW =================
class _LogoPreview extends StatelessWidget {
  final String title;
  final Widget image;

  const _LogoPreview({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image,
            ),
          ),
        ],
      ),
    );
  }
}
