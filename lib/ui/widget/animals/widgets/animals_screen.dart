import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:a2_jawwada/ui/widget/animals/view_models/animals_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnimalsScreen extends ConsumerWidget {
  const AnimalsScreen({super.key, this.species, this.need});
  final Species? species;
  final Need? need;

  void _goTo(BuildContext context, {Species? species, Need? need}) {
    final query = {
      if (species != null) 'species': species.name,
      if (need != null) 'need': need.name,
    };
    context.go(
      Uri(path: '/animals', queryParameters: query.isEmpty ? null : query)
          .toString(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animals = ref.watch(animalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Adopt & Foster')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _pill(context, 'All', species == null,
                    () => _goTo(context, species: null, need: need)),
                _pill(context, 'Cats', species == Species.cat,
                    () => _goTo(context, species: Species.cat, need: need)),
                _pill(context, 'Dogs', species == Species.dog,
                    () => _goTo(context, species: Species.dog, need: need)),
                _pill(context, 'Other', species == Species.other,
                    () => _goTo(context, species: Species.other, need: need)),
                _pill(
                  context,
                  'Needs a foster home',
                  need == Need.foster,
                  () => _goTo(
                    context,
                    species: species,
                    need: need == Need.foster ? null : Need.foster,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: animals.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('$error')),
              data: (animals) => _list(filterAnimals(animals, species, need)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(
      BuildContext context, String label, bool selected, VoidCallback onTap) {
    final colors = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      shape: const StadiumBorder(),
      selectedColor: colors.primary,
      labelStyle: TextStyle(color: selected ? colors.onPrimary : colors.primary),
      onSelected: (_) => onTap(),
    );
  }

  Widget _list(List<Animal> animals) {
    return ListView.builder(
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () => context.go('/animals/${animal.id}'),
            leading: Icon(_speciesIcon(animal.species), size: 28),
            title: Text(animal.name),
            subtitle: Text(
              '${animal.breed} · ${animal.sex} · ${ageConvert(animal.ageMonths)}',
            ),
            trailing: animal.need == Need.foster
                ? const Chip(label: Text('Needs a foster home'))
                : null,
          ),
        );
      },
    );
  }

  IconData _speciesIcon(Species species) => switch (species) {
        Species.cat => Icons.pets,
        Species.dog => Icons.pets,
        Species.other => Icons.cruelty_free,
      };
}
