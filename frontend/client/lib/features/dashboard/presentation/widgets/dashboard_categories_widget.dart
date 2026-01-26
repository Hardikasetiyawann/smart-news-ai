import 'package:flutter/material.dart';
import 'package:client/gen_l10n/app_localizations.dart';
import '../../domain/entities/dashboard_category_entity.dart';

class DashboardCategoriesWidget extends StatelessWidget {
  final List<DashboardCategoryEntity> categories;
  final int selectedId;
  final ValueChanged<int> onSelected;

  const DashboardCategoriesWidget({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // menyiapkan daftar kategori dengan tambahan "All"
    final items = [
      _UiCategory(id: 0, name: l10n.dashboardAll),
      ...categories.map((c) => _UiCategory(id: c.id, name: c.name)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // judul bagian kategori
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.dashboardLatest,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // daftar kategori horizontal
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = item.id == selectedId;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(item.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2,
                        width: isActive ? 20 : 0,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// model kategori untuk UI
class _UiCategory {
  final int id;
  final String name;

  const _UiCategory({required this.id, required this.name});
}
