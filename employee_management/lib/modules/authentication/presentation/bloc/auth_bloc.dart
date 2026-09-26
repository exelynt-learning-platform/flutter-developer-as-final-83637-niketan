import 'dart:async';

import 'package:employee_management/modules/authentication/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  StreamSubscription<User?>? _authSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);

    on<LoginRequested>(_onLoginRequested);

    on<RegisterRequested>(_onRegisterRequested);

    on<ForgotPasswordRequested>(_onForgotPasswordRequested);

    on<GoogleSignInRequested>(_onGoogleSignInRequested);

    on<LogoutRequested>(_onLogoutRequested);

    on<_AuthUserChanged>(_onAuthUserChanged);

    _authSubscription = authRepository.authStateChanges.listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    // Firebase authStateChanges is already responsible
    // for notifying us about the current authentication state.
    //
    // No need to manually emit Authenticated/Unauthenticated here.
  }

  void _onAuthUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(user: event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRepository.login(email: event.email, password: event.password);

      // Don't emit Authenticated here.
      //
      // Firebase authStateChanges will emit the new user
      // and _onAuthUserChanged will update the state.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final credential = await authRepository.register(name: event.name, email: event.email, password: event.password);

      final user = credential.user;

      if (user != null) {
        emit(RegistrationSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRepository.forgotPassword(email: event.email);

      emit(PasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRepository.signInWithGoogle();

      // Don't emit Authenticated here.
      // authStateChanges handles it.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRepository.logout();

      // authStateChanges will emit null,
      // which results in Unauthenticated.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}

class _AuthUserChanged extends AuthEvent {
  final User? user;

  _AuthUserChanged(this.user);
}
