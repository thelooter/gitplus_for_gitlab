import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

import 'groups_controller.dart';

class GroupsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupsController>(
        () => GroupsController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}
