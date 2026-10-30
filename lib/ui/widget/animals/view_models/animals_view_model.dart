import 'package:a2_jawwada/data/repositories/animal_repository.dart';
import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final animalsProvider = StreamProvider<List<Animal>>(
  (ref) => ref.watch(animalRepositoryProvider).watchAnimals(),
);

List<Animal> filterAnimals(List<Animal> animals, Species? species, Need? need) {
  return animals
      .where((a) => species == null || a.species == species)
      .where((a) => need == null || a.need == need)
      .toList();
}

String ageConvert(int months) {
  if (months < 12) {
    return months == 1 ? '1 month' : '$months months';
  }
  final years = months ~/ 12;
  return years == 1 ? '1 year' : '$years years';
}
