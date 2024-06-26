import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/modules/merge_request/merge_request.dart';
import 'package:labplus_for_gitlab/routes/app_pages.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:get/get.dart';

import 'merge_request_controller.dart';

enum MergeRequestScreenPopupActions {
  edit,
  reopen,
  close,
  delete,
  share,
  openWeb
}

class MergeRequestScreen extends GetView<MergeRequestController> {
  const MergeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    var item = controller.repository.mergeRequest.value;
    var title = controller.repository.mergeRequest.value.iid ?? '';
    var project = controller.repository.project.value;

    Widget avatar = Container();
    if (project.avatarUrl != null && project.avatarUrl!.isNotEmpty) {
      avatar = ListAvatar(avatarUrl: project.avatarUrl!);
    } else if (project.id != null) {
      avatar = CircleAvatar(
          child: Text(project.name!.toUpperCase().substring(0, 2)));
    }

    var pipelineExists =
        controller.repository.detailedMergeRequest.value.headPipeline != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('#$title'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
                <PopupMenuEntry<MergeRequestScreenPopupActions>>[
              PopupMenuItem(
                  value: MergeRequestScreenPopupActions.edit,
                  child: Text('Edit'.tr)),
              item.state == MergeRequestState.opened
                  ? PopupMenuItem(
                      value: MergeRequestScreenPopupActions.close,
                      child: Text('Close'.tr))
                  : PopupMenuItem(
                      value: MergeRequestScreenPopupActions.reopen,
                      child: Text('Reopen'.tr)),
              PopupMenuItem(
                  value: MergeRequestScreenPopupActions.share,
                  child: Text('Share'.tr)),
              PopupMenuItem(
                  value: MergeRequestScreenPopupActions.openWeb,
                  child: Text('Open in web browser'.tr)),
              const PopupMenuDivider(),
              PopupMenuItem(
                  value: MergeRequestScreenPopupActions.delete,
                  child: Text(
                    'Delete'.tr,
                    style: const TextStyle(color: Colors.red),
                  )),
            ],
            onSelected: (MergeRequestScreenPopupActions value) =>
                controller.onPopupSelected(value, context),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => controller.onRefresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.repository.loadProjectRequired.value &&
                              project.id != null)
                            Row(
                              children: [
                                avatar,
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                '${project.namespace!.fullPath!}/',
                                            style:
                                                const TextStyle(fontSize: 18)),
                                        TextSpan(
                                            text: project.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (controller.repository.loadProjectRequired.value &&
                              project.id != null)
                            const Divider(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.title != null)
                                Flexible(
                                  child: Text(item.title!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              _StateWidget(mergeRequest: item),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (item.createdAt != null)
                            Text(
                                'Created ${timeago.format(item.createdAt!)} by ${item.author!.name!}, edited ${timeago.format(item.updatedAt!)} by ${item.author!.name!}'),
                          if (item.closedBy != null) const SizedBox(height: 10),
                          if (item.closedBy != null)
                            Row(
                              children: [
                                const Text('Closed by'),
                                const SizedBox(width: 5),
                                ColorLabel(
                                    color: Colors.grey.shade200,
                                    text: item.closedBy!.name!),
                              ],
                            ),
                          if (item.mergeUser != null)
                            const SizedBox(height: 10),
                          if (item.mergeUser != null)
                            Row(
                              children: [
                                const Text('Merged by'),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: ColorLabel(
                                      color: Colors.grey.shade200,
                                      text: item.mergeUser!.name!),
                                ),
                              ],
                            ),
                          if (item.sourceBranch != null)
                            const SizedBox(height: 10),
                          if (item.sourceBranch != null)
                            Row(
                              children: [
                                const Text('Source branch'),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: ColorLabel(
                                      color: Colors.grey.shade200,
                                      text: item.sourceBranch!),
                                ),
                              ],
                            ),
                          if (item.targetBranch != null)
                            const SizedBox(height: 10),
                          if (item.targetBranch != null)
                            Row(
                              children: [
                                const Text('Target branch'),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: ColorLabel(
                                      color: Colors.grey.shade200,
                                      text: item.targetBranch!),
                                ),
                              ],
                            ),

                          /// description

                          if (item.description != null &&
                              item.description!.isNotEmpty)
                            const Divider(height: 25),
                          if (item.description != null &&
                              item.description!.isNotEmpty)
                            SafeArea(
                              bottom: false,
                              child: AppMarkdown(content: item.description!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _AssigneeCard(item),
                  pipelineExists
                      ? _PipelineStatusCard(
                          mergeRequest:
                              controller.repository.detailedMergeRequest.value)
                      : Container(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Octicons.note),
                    title: Text('Notes'.tr,
                        style: const TextStyle(
                            fontWeight: CommonConstants.fontWeightListTile)),
                    onTap: () {
                      Get.toNamed(Routes.mergeRequestNotes);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.userNotesCount.toString()),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateWidget extends StatelessWidget {
  final MergeRequest mergeRequest;

  const _StateWidget({required this.mergeRequest});

  @override
  Widget build(BuildContext context) {
    switch(mergeRequest.state) {
      case MergeRequestState.opened:
        return ColorLabel(color: Colors.green, text: "Open".tr);
      case MergeRequestState.closed:
        return ColorLabel(color: Colors.red, text: "Closed".tr);
      case MergeRequestState.locked:
        return ColorLabel(color: Colors.yellow, text: "Locked".tr);
      case MergeRequestState.merged:
        return ColorLabel(color: Colors.purple, text: "Merged".tr);
    }

    return ColorLabel(color: Colors.white, text: "Unknown".tr);  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;

  const _HeaderLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5)
      ],
    );
  }
}

class _AssigneeCard extends StatelessWidget {
  final MergeRequest item;

  const _AssigneeCard(this.item);

  @override
  Widget build(BuildContext context) {
    if (item.assignees!.isEmpty) {
      return Container();
    }
    return Card(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderLabel(text: 'Assigned to'),
            _AssigneeList(item)
          ],
        ),
      ),
    );
  }
}

class _AssigneeList extends StatelessWidget {
  final MergeRequest item;

  const _AssigneeList(this.item);

  @override
  Widget build(BuildContext context) {
    if (item.assignees!.length == 1) {
      return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Wrap(
          spacing: 5,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: item.assignees![0].avatarUrl?.isEmpty == false
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            color: Colors.transparent,
                            imageUrl: item.assignees![0].avatarUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            httpHeaders: {
                              'PRIVATE-TOKEN':
                                  Get.find<SecureStorage>().getToken()
                            },
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(image: imageProvider),
                              ),
                            ),
                          ),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(item.assignees![0].name!,
                      style: const TextStyle(fontSize: 16)),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Wrap(
          spacing: 5,
          children: [
            ...item.assignees!.map(
              (assignee) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: assignee.avatarUrl?.isEmpty == false
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(
                                  color: Colors.transparent,
                                  imageUrl: assignee.avatarUrl!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  httpHeaders: {
                                    'PRIVATE-TOKEN':
                                        Get.find<SecureStorage>().getToken()
                                  },
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image:
                                          DecorationImage(image: imageProvider),
                                    ),
                                  ),
                                ),
                              )
                            : const CircleAvatar(child: Icon(Icons.person)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(assignee.name!,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}

class _PipelineStatusCard extends StatelessWidget {
  final DetailedMergeRequest mergeRequest;

  const _PipelineStatusCard({required this.mergeRequest});

  @override
  Widget build(BuildContext context) {
    var statusIcon = switch (mergeRequest.headPipeline?.status) {
      "success" => const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
      "failed" => const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      "created" => const Icon(
          Icons.schedule_outlined,
          color: Colors.yellow,
        ),
      "waiting_for_resource" => const Icon(
          Icons.schedule_outlined,
          color: Colors.yellow,
        ),
      "preparing" => const Icon(
          Icons.schedule_outlined,
          color: Colors.yellow,
        ),
      "pending" => const Icon(
          Icons.schedule_outlined,
          color: Colors.yellow,
        ),
      "scheduled" => const Icon(
          Icons.schedule_outlined,
          color: Colors.yellow,
        ),
      "skipped" => const Icon(
          Icons.do_not_disturb_on,
          color: Colors.grey,
        ),
      "canceled" => const Icon(
          Icons.do_not_disturb_on,
          color: Colors.grey,
        ),
      "running" => const Icon(
          Icons.cached,
          color: Colors.blue,
        ),
      "manual" => const Icon(
          Icons.cached,
          color: Colors.blue,
        ),
      null => const Icon(
        Icons.question_mark,
      ),
      String() => const Icon(
        Icons.question_mark,
      ),
    };

    var statusString = switch (mergeRequest.headPipeline?.status) {
      "success" => "Success",
      "failed" => "Failed",
      "created" => "Created",
      "waiting_for_resource" => "Waiting for Resource",
      "preparing" => "Preparing",
      "pending" => "Pending",
      "scheduled" => "Scheduled",
      "skipped" => "Skipped",
      "canceled" => "Canceled",
      "running" => "Running",
      "manual" => "Manual",
      null => "",
      String() => throw UnimplementedError(),
    };

    return Card(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderLabel(text: 'Pipeline status'),
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      statusIcon,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(statusString),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
