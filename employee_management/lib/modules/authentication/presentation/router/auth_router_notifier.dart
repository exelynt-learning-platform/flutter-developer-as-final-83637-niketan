import 'dart:async';

import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;

  late final StreamSubscription<AuthState> _subscription;

  AuthRouterNotifier(this.authBloc) {
    _subscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
