import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// ENTITY
import '../../domain/entities/news.dart';

// NEWS
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';

// CATEGORY
import '../../../category/presentation/bloc/category_bloc.dart';
import '../../../category/presentation/bloc/category_event.dart';
import '../../../category/presentation/bloc/category_state.dart';

// PUBLISHER
import '../../../publisher/presentation/bloc/publisher_bloc.dart';
import '../../../publisher/presentation/bloc/publisher_event.dart';
import '../../../publisher/presentation/bloc/publisher_state.dart';

class EditNewsPage extends StatefulWidget {
  final News news;
  const EditNewsPage({super.key, required this.news});

  @override
  State<EditNewsPage> createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late TextEditingController _linkCtrl;

  late int _categoryId;
  late int _publisherId;
  late String _status;

  XFile? _image;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.news.title);
    _contentCtrl = TextEditingController(text: widget.news.content);
    _linkCtrl = TextEditingController(text: widget.news.linkNews);

    _categoryId = widget.news.categoryId;
    _publisherId = widget.news.publisherId;
    _status = widget.news.status;

    context.read<CategoryBloc>().add(LoadCategories());
    context.read<PublisherBloc>().add(LoadPublishers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit News")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  // ================= HEADER =================
                  const Text(
                    "Edit Berita",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Perbarui informasi berita",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  // ================= FORM =================
                  _InputField(
                    controller: _titleCtrl,
                    label: "Judul",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),

                  _InputField(
                    controller: _contentCtrl,
                    label: "Konten",
                    icon: Icons.article,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),

                  _InputField(
                    controller: _linkCtrl,
                    label: "Link News",
                    icon: Icons.link,
                  ),

                  const SizedBox(height: 24),

                  // ================= CATEGORY =================
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return DropdownButtonFormField<int>(
                          initialValue: _categoryId,
                          decoration: _dropdownDecoration(
                            "Category",
                            Icons.category,
                          ),
                          items: state.categories.map((c) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _categoryId = v!),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  const SizedBox(height: 16),

                  // ================= PUBLISHER =================
                  BlocBuilder<PublisherBloc, PublisherState>(
                    builder: (context, state) {
                      if (state is PublisherLoaded) {
                        return DropdownButtonFormField<int>(
                          initialValue: _publisherId,
                          decoration: _dropdownDecoration(
                            "Publisher",
                            Icons.apartment,
                          ),
                          items: state.publishers.map((p) {
                            return DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _publisherId = v!),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  const SizedBox(height: 16),

                  // ================= STATUS =================
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: _dropdownDecoration(
                      "Status",
                      Icons.flag_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(value: "draft", child: Text("Draft")),
                      DropdownMenuItem(
                        value: "published",
                        child: Text("Published"),
                      ),
                    ],
                    onChanged: (v) => setState(() => _status = v!),
                  ),

                  const SizedBox(height: 24),

                  // ================= IMAGE =================
                  OutlinedButton.icon(
                    icon: const Icon(Icons.image),
                    label: Text(
                      _image == null
                          ? "Ganti Gambar (Opsional)"
                          : "Gambar Baru Dipilih",
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      _image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 32),

                  // ================= ACTION =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Update"),
                        onPressed: () {
                          context.read<NewsBloc>().add(
                            UpdateNewsEvent(
                              id: widget.news.id,
                              categoryId: _categoryId,
                              publisherId: _publisherId,
                              title: _titleCtrl.text,
                              content: _contentCtrl.text,
                              linkNews: _linkCtrl.text,
                              status: _status,
                              image: _image,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DECORATION =================
  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

// ================= INPUT FIELD =================
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
