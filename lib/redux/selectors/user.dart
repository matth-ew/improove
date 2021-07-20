import 'package:improove/redux/models/models.dart';

String userSelector(User user) {
  return "${user.name} ${user.surname}";
}
