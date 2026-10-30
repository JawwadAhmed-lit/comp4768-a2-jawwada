import 'package:a2_jawwada/data/repositories/animal_repository.dart';
import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final animalsProvider = StreamProvider<List<Animal>>(
  (ref) => ref.watch(animalRepositoryProvider).watchAnimals(),
);
