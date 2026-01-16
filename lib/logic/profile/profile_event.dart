import '../../data/models/user_model.dart';

abstract class AccountEvent {}

class LoadAccount extends AccountEvent {}

class UpdateProfile extends AccountEvent {
  final UserModel user;
  UpdateProfile(this.user);
}

class ToggleTheme extends AccountEvent {}

class ClearCache extends AccountEvent {}

class Logout extends AccountEvent {}
