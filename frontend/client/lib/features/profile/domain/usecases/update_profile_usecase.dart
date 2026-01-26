import 'dart:io';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({String? fullName, File? avatar}) {
    return repository.updateProfile(fullName: fullName, avatar: avatar);
  }
}