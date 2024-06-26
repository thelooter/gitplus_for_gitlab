import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

import 'edit_issue_controller.dart';

class EditIssueBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditIssueController>(
        () => EditIssueController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}
