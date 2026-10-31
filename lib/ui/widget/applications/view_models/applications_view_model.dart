import 'package:a2_jawwada/data/repositories/application_repository.dart';
import 'package:a2_jawwada/domain/models/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsProvider = StreamProvider<List<Application>>(
  (ref) => ref.watch(applicationRepositoryProvider).watchApplications(),
);
