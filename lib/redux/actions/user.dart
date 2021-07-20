import 'package:improove/redux/models/user.dart';

class SetUser {
  final User user;

  SetUser(this.user);
}

class SetFullName {
  final String name;
  final String surname;

  SetFullName(this.name, this.surname);
}
