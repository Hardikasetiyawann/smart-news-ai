import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/gen_l10n/app_localizations.dart';

import '../../../../core/layout/app_scaffold.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/utils/image_utils.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  File? _selectedImage;

  bool _submitting = false;
  bool _hasChanged = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _hasChanged = true;
      });
    }
  }

  void _onNameChanged(String value, String originalName) {
    final changed = value.trim() != originalName.trim();
    if (changed != _hasChanged) {
      setState(() {
        _hasChanged = changed || _selectedImage != null;
      });
    }
  }

  void _save(ProfileLoaded state) {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    setState(() => _submitting = true);

    context.read<ProfileBloc>().add(
      UpdateProfile(
        fullName: newName != state.user.fullName ? newName : null,
        avatar: _selectedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final content = BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (_, curr) => curr is ProfileLoaded || curr is ProfileError,
      listener: (context, state) {
        if (state is ProfileLoaded && _submitting) {
          setState(() {
            _submitting = false;
            _selectedImage = null;
            _hasChanged = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.saveChanges} berhasil')),
          );
        }

        if (state is ProfileError) {
          setState(() => _submitting = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        // INIT SEKALI
        if (!_initialized) {
          _nameController = TextEditingController(text: state.user.fullName);
          _initialized = true;
        }

        final avatarUrl = resolveImageUrl(state.user.imageUrl);

        final ImageProvider? avatarProvider = _selectedImage != null
            ? FileImage(_selectedImage!)
            : (avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null);

        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 900
                      : isTablet
                      ? 700
                      : double.infinity,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 64
                        : isTablet
                        ? 32
                        : 16,
                    vertical: 24,
                  ),
                  children: [
                    // FOTO
                    Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: isDesktop ? 64 : 56,
                              backgroundImage: avatarProvider,
                              backgroundColor: Colors.grey.shade200,
                              child: avatarProvider == null
                                  ? Icon(
                                      Icons.person,
                                      size: isDesktop ? 64 : 56,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: const CircleAvatar(
                                  radius: 18,
                                  child: Icon(Icons.camera_alt, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tapToChangePhoto,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _onNameChanged(v, state.user.fullName),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: state.user.email,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: l10n.emailLabel,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (_hasChanged)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : () => _save(state),
                          child: Text(l10n.saveChanges),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (_submitting)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x55000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );

    return isMobile
        ? Scaffold(
            appBar: AppBar(title: Text(l10n.personalInfo), centerTitle: true),
            body: content,
          )
        : AppScaffold(
            currentIndex: 3,
            appBar: AppBar(title: Text(l10n.personalInfo)),
            body: content,
          );
  }
}
