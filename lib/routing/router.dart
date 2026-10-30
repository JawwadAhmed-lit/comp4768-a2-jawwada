

import 'package:a2_jawwada/domain/models/animal.dart';
import 'package:a2_jawwada/ui/core/error_screen.dart';
import 'package:a2_jawwada/ui/widget/animals/widgets/animals_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/animals',
  routes:[
    GoRoute(path:'/animals',
    builder: (context, state) {
      final query = state.uri.queryParameters;
      final species = Species.values.asNameMap()[query['species']];
      final need = query['need'] == Need.foster.name ? Need.foster : null;
      return AnimalsScreen(species: species, need: need);
    },
    routes:[
      // GoRoute(path: 'id',builder: (context, state) => const ,),GoRoute(path: path),
      
    ])
  ],
   errorBuilder: (context, state) => ErrorScreen(location: state.uri.toString()),
);