import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/prefs_utils.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefUtils());
  }
}
