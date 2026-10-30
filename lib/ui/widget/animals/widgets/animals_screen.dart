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
      appBar: AppBar(title: const Text('Animals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SegmentedButton<Species?>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: null, label: Text('All')),
                    ButtonSegment(value: Species.cat, label: Text('Cats')),
                    ButtonSegment(value: Species.dog, label: Text('Dogs')),
                    ButtonSegment(value: Species.other, label: Text('Other')),
                  ],
                  selected: {species},
                  onSelectionChanged: (selection) =>
                      _goTo(context, species: selection.first, need: need),
                ),
                FilterChip(
                  label: const Text('Needs a foster home'),
                  selected: need == Need.foster,
                  onSelected: (selected) => _goTo(
                    context,
                    species: species,
                    need: selected ? Need.foster : null,
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

  Widget _list(List<Animal> animals) {
    return ListView.builder(
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return ListTile(
          onTap: () => context.go('/animals/${animal.id}'),
          leading: Icon(_speciesIcon(animal.species), size: 28),
          title: Text(animal.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${animal.breed} · ${animal.sex} · ${ageConvert(animal.ageMonths)}'),
              if (animal.need == Need.foster)
                const Text('Needs a foster home'),
            ],
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
