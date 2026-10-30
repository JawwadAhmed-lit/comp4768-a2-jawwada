import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:a2_jawwada/ui/widget/animals/view_models/animals_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({super.key, required this.animalId});

  final String animalId;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _validName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your name';
    return null;
  }

  String? _validPhone(String? value) {
    if (!RegExp(r'^\d{10}$').hasMatch(value ?? '')) {
      return 'Enter 10 digits';
    }
    return null;
  }

  String? _validateReason(String? value) {
    if ((value ?? '').trim().length < 30) {
      return 'Write at least 30 characters';
    }
    return null;
  }

  String? _validateAge(String? value) {
    final age = int.tryParse((value ?? '').trim());
    if (age == null) return 'You must be 18 or older to foster';
    if (age < 18) return 'You must be 18 or older to foster';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {
    final animals = ref.watch(animalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: animals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
        data: (animals) {
          final animal =
              animals.where((a) => a.id == widget.animalId).firstOrNull;
          if (animal == null) {
            return const Center(child: Text('Animal not found'));
          }
          return _form(context, animal);
        },
      ),
    );
  }

  Widget _form(BuildContext context, Animal animal) {
    final fostering = animal.need == Need.foster;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            fostering
                ? 'Foster ${animal.name}'
                : 'Adopt ${animal.name}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (!fostering) ...[
            const SizedBox(height: 4),
            Text(feeConversion(animal)),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full name'),
            validator: _validName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
            validator: _validPhone,
          ),
          const SizedBox(height: 16),
          if (fostering)
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Your age'),
              keyboardType: TextInputType.number,
              validator: _validateAge,
            )
          else
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Why is this animal a good match for you?',
              ),
              maxLines: 4,
              validator: _validateReason,
            ),
          const SizedBox(height: 24),
          Expanded(
            
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Send Application'),
            ),
          ),
        ],
      ),
    );
  }
}
