import 'package:client/features/news_detail/presentation/navigation/detail_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import 'package:client/auth_service.dart';
import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/utils/image_utils.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

// SETTINGS
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  void _openSettings(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SettingsBloc(context.read<AuthService>()),
          child: const SettingsPage(),
        ),
      ),
    );

    // reload profile HANYA jika ada perubahan
    if (result == true && context.mounted) {
      context.read<ProfileBloc>().add(LoadProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return AppScaffold(
      currentIndex: 3,
      appBar: AppBar(
        centerTitle: isMobile,
        title: Text(l10n.profile),
        actions: isMobile
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: l10n.profileSettingsTooltip,
                  onPressed: () => _openSettings(context),
                ),
              ]
            : null,
      ),
      body: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    //final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoaded) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.isDesktop(context) ? 1200 : 900,
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? 48
                      : isTablet
                      ? 32
                      : 16,
                  vertical: 16,
                ),
                children: [
                  isDesktop
                      ? _DesktopLayout(state, l10n)
                      : isTablet
                      ? _TabletLayout(state, l10n)
                      : _MobileLayout(state, l10n),
                ],
              ),
            ),
          );
        }

        if (state is ProfileError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ProfileLoaded state;
  final AppLocalizations l10n;

  const _MobileLayout(this.state, this.l10n);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileHeader(state),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),

        SizedBox(width: double.infinity, child: _LikedNews(state, l10n)),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final ProfileLoaded state;
  final AppLocalizations l10n;

  const _TabletLayout(this.state, this.l10n);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileHeader(state),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        SizedBox(width: double.infinity, child: _LikedNews(state, l10n)),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ProfileLoaded state;
  final AppLocalizations l10n;

  const _DesktopLayout(this.state, this.l10n);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 340, child: Center(child: _ProfileHeader(state))),
        const SizedBox(width: 48),
        Expanded(child: _LikedNews(state, l10n)),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileLoaded state;

  const _ProfileHeader(this.state);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = resolveImageUrl(state.user.imageUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : null,
          child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 48) : null,
        ),
        const SizedBox(height: 12),
        Text(
          state.user.fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          state.user.email,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LikedNews extends StatelessWidget {
  final ProfileLoaded state;
  final AppLocalizations l10n;

  const _LikedNews(this.state, this.l10n);

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    if (state.likedNews.isEmpty) {
      return Center(
        child: Text(
          l10n.profileEmptyLikedNews,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Text(
          l10n.profileLikedNewsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        isTablet ? _LikedNewsGrid(state) : _LikedNewsList(state),
      ],
    );
  }
}

class _LikedNewsList extends StatelessWidget {
  final ProfileLoaded state;

  const _LikedNewsList(this.state);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.likedNews.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final news = state.likedNews[index];

        return _NewsTile(news: news);
      },
    );
  }
}

class _LikedNewsGrid extends StatelessWidget {
  final ProfileLoaded state;

  const _LikedNewsGrid(this.state);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.likedNews.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.7,
      ),
      itemBuilder: (context, index) {
        final news = state.likedNews[index];
        return _NewsTile(news: news);
      },
    );
  }
}

class _NewsTile extends StatelessWidget {
  final dynamic news;

  const _NewsTile({required this.news});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final imageUrl = resolveImageUrl(news.imageUrl);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () async {
          goToNewsDetail(context, news.id);
        },

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                )
              : const Icon(Icons.image_not_supported),
        ),

        title: Text(news.title, maxLines: 2, overflow: TextOverflow.ellipsis),

        subtitle: Text(
          news.publisherName,
          style: const TextStyle(fontSize: 12),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'unlike') {
              context.read<ProfileBloc>().add(UnlikeNews(news.id));
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'unlike',
              child: Text(l10n.profileUnlikeAction),
            ),
          ],
        ),
      ),
    );
  }
}
