import 'package:a2_jawwada/data/repositories/application_repository.dart';
import 'package:a2_jawwada/domain/models/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the application was sent. Each form starts fresh.
final applyProvider =
    AsyncNotifierProvider.autoDispose<ApplyViewModel, bool>(ApplyViewModel.new);

class ApplyViewModel extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> send(Application application) async {
    state = const AsyncLoading();
    try {
      await ref.read(applicationRepositoryProvider).submit(application);
      if (!ref.mounted) return;
      state = const AsyncData(true);
    } catch (error, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncError(error, stackTrace);
    }
  }
}
