import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();

  int? _categoryId;
  int? _publisherId;
  String _status = "draft";

  XFile? _image;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<PublisherBloc>().add(LoadPublishers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah News"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi News",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ================= JUDUL =================
                      TextField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: "Judul",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= KONTEN =================
                      TextField(
                        controller: _contentCtrl,
                        decoration: const InputDecoration(
                          labelText: "Konten",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 6,
                      ),

                      const SizedBox(height: 16),

                      // ================= LINK =================
                      TextField(
                        controller: _linkCtrl,
                        decoration: const InputDecoration(
                          labelText: "Link News",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ================= CATEGORY =================
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (_, state) {
                          if (state is CategoryLoaded) {
                            return DropdownButtonFormField<int>(
                              initialValue: _categoryId,
                              decoration: const InputDecoration(
                                labelText: "Category",
                                border: OutlineInputBorder(),
                              ),
                              items: state.categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _categoryId = v),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= PUBLISHER =================
                      BlocBuilder<PublisherBloc, PublisherState>(
                        builder: (_, state) {
                          if (state is PublisherLoaded) {
                            return DropdownButtonFormField<int>(
                              initialValue: _publisherId,
                              decoration: const InputDecoration(
                                labelText: "Publisher",
                                border: OutlineInputBorder(),
                              ),
                              items: state.publishers
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p.id,
                                      child: Text(p.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _publisherId = v),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= STATUS =================
                      DropdownButtonFormField<String>(
                        initialValue: _status,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "draft",
                            child: Text("Draft"),
                          ),
                          DropdownMenuItem(
                            value: "published",
                            child: Text("Published"),
                          ),
                        ],
                        onChanged: (v) => setState(() => _status = v!),
                      ),

                      const SizedBox(height: 24),

                      // ================= IMAGE =================
                      const Text(
                        "Gambar News (Wajib)",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          _image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          setState(() {});
                        },
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.grey.shade100,
                          ),
                          child: _image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image, size: 48),
                                    SizedBox(height: 8),
                                    Text("Klik untuk memilih gambar"),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _image!.path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ================= ACTION =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text("Simpan"),
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_categoryId == null || _publisherId == null || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category, Publisher & Image wajib diisi"),
        ),
      );
      return;
    }

    context.read<NewsBloc>().add(
      CreateNewsEvent(
        categoryId: _categoryId!,
        publisherId: _publisherId!,
        title: _titleCtrl.text,
        content: _contentCtrl.text,
        linkNews: _linkCtrl.text,
        status: _status,
        image: _image,
      ),
    );

    Navigator.pop(context);
  }
}
