import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

class MilestoneStateLabel extends StatelessWidget {
  final ProjectMilestone item;
  final double? fontSize;

  const MilestoneStateLabel({super.key, required this.item, this.fontSize});

  @override
  Widget build(BuildContext context) {
    var color = Colors.green;
    var text = 'Open';
    if (item.state == MilestoneState.active &&
        item.dueDate != null &&
        item.dueDate!.isBefore(DateTime.now())) {
      color = Colors.amber;
      text = 'Expired';
    } else if (item.state == MilestoneState.closed) {
      color = Colors.red;
      text = 'Closed';
    }

    return ColorLabel(
      color: color,
      text: text,
      fontSize: fontSize,
    );
  }
}
