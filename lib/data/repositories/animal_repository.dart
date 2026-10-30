import 'package:a2_jawwada/data/fake_data.dart';
import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final animalRepositoryProvider = Provider((ref) => AnimalRepository());

class AnimalRepository {

static const bool failForDemo = false;

  Stream<List<Animal>> watchAnimals() async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (failForDemo) {
      throw Exception(
        'Could not reach the shelter',
      );
    }
    yield fakeAnimals;
  }
}