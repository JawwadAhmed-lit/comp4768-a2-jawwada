import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:a2_jawwada/domain/models/application.dart';
import 'package:a2_jawwada/ui/widget/applications/view_models/applications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My applications')),
      body: applications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('No applications yet'));
          }
          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return ListTile(
                  onTap: () => context.go('/animals/${application.animalId}'),
                  title: Text(application.animalName),
                  subtitle: Text(
                    '${application.need == Need.foster ? 'Foster' : 'Adopt'}'
                    ' · ${application.visitTime}',
                  ),
                  trailing: TextButton(
                    onPressed: () => _withdraw(context, ref, application),
                    child: const Text('Withdraw'),
                  ),
                );

            },
          );
        },
      ),
    );
  }

  Future<void> _withdraw(
    BuildContext context,
    WidgetRef ref,
    Application application,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(
          'Withdraw your application for ${application.animalName}?',
          style: const TextStyle(fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(false),
            child: const Text('Cancel', style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () => dialogContext.pop(true),
            child: const Text('Withdraw', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref
          .read(applicationsCommandsProvider.notifier)
          .withdraw(application.animalId);
    }
  }
}
