import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:a2_jawwada/ui/widget/animals/view_models/animals_view_model.dart';
import 'package:a2_jawwada/ui/widget/applications/view_models/applications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnimalRecordScreen extends ConsumerWidget {
  const AnimalRecordScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animals = ref.watch(animalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Animal')),
      body: animals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
        data: (animals) {
          final animal = animals.where((a) => a.id == id).firstOrNull;
          if (animal == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Animal not found'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/animals'),
                    child: const Text('Go to the animals'),
                  ),
                ],
              ),
            );
          }
          return _record(context, animal);
        },
      ),
    );
  }

  Widget _record(BuildContext context, Animal animal) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(animal.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          '${animal.species.name} · ${animal.breed} · ${animal.sex} · ${ageConvert(animal.ageMonths)}',
        
        ),
        const SizedBox(height: 16),
        Text(animal.description),
        const SizedBox(height: 16),
        if (animal.need == Need.foster) ...[
          if (animal.fosterReason != null) Text(animal.fosterReason!),
          const Text(
            'Fostering is free, and the shelter provides all supplies.',
          ),
        ] else
          Text(feeConversion(animal)),
        const SizedBox(height: 16),
        _ApplicationStatus(animal: animal),
      ],
    );
  }
}

class _ApplicationStatus extends ConsumerWidget {
  const _ApplicationStatus({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);

    return applications.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('$error'),
      data: (applications) {
        final applied = applications.any((a) => a.animalId == animal.id);
        if (applied) {
          return Column(
            children: [
              const Text('Application pending'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => context.go('/animals/applications'),
                child: const Text('See my applications'),
              ),
            ],
          );
        }
        return FilledButton(
          onPressed: () => context.go('/animals/${animal.id}/apply'),
          child: Text(
            animal.need == Need.foster ? 'Apply to foster' : 'Apply to adopt',
          ),
        );
      },
    );
  }
}
