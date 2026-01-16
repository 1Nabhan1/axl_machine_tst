import 'package:axel_tech/data/services/session_manager/cache_service.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/services/session_manager/session_storage.dart';
import 'auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthRepository authRepo;
  // final SessionService session;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthState> emit) async {
final AuthRepository authRepo = AuthRepository();
    final SessionService session = SessionService();
    final loggedIn = await session.isLoggedIn();
    emit(loggedIn ? AuthAuthenticated() : AuthUnauthenticated());
  }

  Future<void> _onLogin(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final AuthRepository authRepo = AuthRepository();
    final SessionService session = SessionService();
    final user = await authRepo.login(
      event.username,
      event.password,
    );

    if (user == null) {
      emit(AuthError('Invalid username or password'));
    } else {
      await session.setLoggedIn(true);
      emit(AuthAuthenticated());
    }
  }

  Future<void> _onRegister(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final AuthRepository authRepo = AuthRepository();
      final SessionService session = SessionService();
      final user = UserModel(
        username: event.username,
        fullName: event.fullName,
        password: event.password,
        dob: event.dob,
        profileImagePath: event.profileImagePath,
      );

      await authRepo.register(user);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
      LogoutRequested event, Emitter<AuthState> emit) async {
    final SessionService session = SessionService();
    await session.clear();
    await CacheService.clearAll(true);
    emit(AuthUnauthenticated());
  }
}
