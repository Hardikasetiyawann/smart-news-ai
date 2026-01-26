import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/publisher_bloc.dart';
import '../bloc/publisher_event.dart';
import '../bloc/publisher_state.dart';
import 'create_publisher_page.dart';
import 'edit_publisher_page.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({super.key});

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  @override
  void initState() {
    super.initState();
    context.read<PublisherBloc>().add(LoadPublishers());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Publisher',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreatePublisherPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Publisher'),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // ================= CONTENT =================
          Expanded(
            child: BlocBuilder<PublisherBloc, PublisherState>(
              builder: (_, state) {
                if (state is PublisherLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PublisherLoaded) {
                  if (state.publishers.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada publisher',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: state.publishers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = state.publishers[i];
                      return _PublisherCard(
                        name: p.name,
                        website: p.website,
                        logoUrl: p.logoUrl,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPublisherPage(publisher: p),
                            ),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Publisher'),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus publisher ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );

                          // ⛔ WAJIB untuk hindari warning async context
                          if (!context.mounted) return;

                          if (confirm == true) {
                            context.read<PublisherBloc>().add(
                              DeletePublisherEvent(p.id),
                            );
                          }
                        },
                      );
                    },
                  );
                }

                if (state is PublisherError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= CARD ITEM =================
class _PublisherCard extends StatelessWidget {
  final String name;
  final String? website;
  final String? logoUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PublisherCard({
    required this.name,
    required this.website,
    required this.logoUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= LOGO =================
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: logoUrl != null
                  ? Image.network(
                      "http://localhost:3000/api$logoUrl",
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 42,
                      height: 42,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),

            const SizedBox(width: 16),

            // ================= INFO =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // WEBSITE / URL
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GestureDetector(
                          onTap: website != null
                              ? () async {
                                  final uri = Uri.parse(website!);
                                  if (await canLaunchUrl(uri)) {
                                    launchUrl(uri);
                                  }
                                }
                              : null,
                          child: Text(
                            website ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: website != null
                                  ? Colors.blue
                                  : Colors.grey.shade600,
                              decoration: website != null
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= ACTIONS =================
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionIcon(icon: Icons.edit, tooltip: 'Edit', onTap: onEdit),
                const SizedBox(width: 6),
                _ActionIcon(
                  icon: Icons.delete,
                  tooltip: 'Hapus',
                  color: Colors.red,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= ACTION ICON =================
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Icon(icon, size: 20, color: color ?? Colors.grey.shade800),
      ),
    );
  }
}
