import 'package:a2_jawwada/data/repositories/application_repository.dart';
import 'package:a2_jawwada/domain/models/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsProvider = StreamProvider<List<Application>>(
  (ref) => ref.watch(applicationRepositoryProvider).watchApplications(),
);

final applicationsCommandsProvider =
    NotifierProvider<ApplicationsCommands, void>(ApplicationsCommands.new);

class ApplicationsCommands extends Notifier<void> {
  @override
  void build() {}

  Future<void> withdraw(String animalId) {
    return ref.read(applicationRepositoryProvider).withdraw(animalId);
  }
}
