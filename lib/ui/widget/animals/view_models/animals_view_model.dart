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


String feeConversion(Animal animal) {
  final months = animal.ageMonths;
  switch (animal.species) {
    case Species.cat:
      if (months <= 6) return 'Adoption fee: \$275';
      if (months <= 131) return 'Adoption fee: \$200';
      return 'Adoption fee: \$175';
    case Species.dog:
      if (months <= 6) return 'Adoption fee: \$375';
      if (months <= 107) return 'Adoption fee: \$275';
      return 'Adoption fee: \$200';
    case Species.other:
      return 'Ask the shelter about the fee.';
  }
}

String ageConvert(int months) {
  if (months < 12) {
    return months == 1 ? '1 month' : '$months months';
  }
  final years = months ~/ 12;
  return years == 1 ? '1 year' : '$years years';
}
