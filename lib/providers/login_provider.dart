import 'package:d_method/d_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginStatusProvider = StateProvider.autoDispose((ref) => '');

setLoginStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setLoginStatus', newStatus);
  ref.read(loginStatusProvider.notifier).state = newStatus;
}
