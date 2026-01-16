import 'package:axel_tech/logic/profile/profile_event.dart';
import 'package:axel_tech/logic/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/account_repo.dart';
import '../../data/models/user_model.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  bool _isDarkMode = false;

  AccountBloc(this.repository) : super(AccountInitial()) {
    on<LoadAccount>(_onLoad);
    on<UpdateProfile>(_onUpdateProfile);
    on<ToggleTheme>(_onToggleTheme);
    on<ClearCache>(_onClearCache);
    on<Logout>(_onLogout);
  }

  void _onLoad(LoadAccount event, Emitter<AccountState> emit) {
    emit(AccountLoading());

    final user = repository.getUser();
    if (user == null) {
      emit(AccountError('No user found'));
      return;
    }

    emit(
      AccountLoaded(
        user: user,
        isDarkMode: _isDarkMode,
        profileCompletion: _calculateCompletion(user),
      ),
    );
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<AccountState> emit) async {
    await repository.saveUser(event.user);

    emit(
      AccountLoaded(
        user: event.user,
        isDarkMode: _isDarkMode,
        profileCompletion: _calculateCompletion(event.user),
      ),
    );
  }

  void _onToggleTheme(ToggleTheme event, Emitter<AccountState> emit) {
    if (state is AccountLoaded) {
      _isDarkMode = !_isDarkMode;
      final current = state as AccountLoaded;

      emit(
        AccountLoaded(
          user: current.user,
          isDarkMode: _isDarkMode,
          profileCompletion: current.profileCompletion,
        ),
      );
    }
  }

  void _onClearCache(ClearCache event, Emitter<AccountState> emit) async {
    await repository.clearCache();
  }

  void _onLogout(Logout event, Emitter<AccountState> emit) async {
    await repository.clearUser();
    emit(AccountLoggedOut());
  }

  double _calculateCompletion(UserModel user) {
    int total = 4;
    int filled = 0;

    if (user.username.isNotEmpty) filled++;
    if (user.fullName.isNotEmpty) filled++;
    filled++;
    filled++;

    return filled / total;
  }
}
