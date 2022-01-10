import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class ClusterChip extends StatelessWidget {
  const ClusterChip();
  @override
  Widget build(BuildContext context) {
    AppConfig config = Provider.of(context, listen: false);
    final theme = Theme.of(context);
    return config.solanaCluster == 'devnet'
        ? Padding(
            padding: EdgeInsets.all(Insets.m),
            child: Chip(
              label: Text(
                ReCase(
                  config.solanaCluster ?? '',
                ).titleCase,
                style: TextStyle(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              backgroundColor: theme.colorScheme.secondary,
            ),
          )
        : const SizedBox.shrink();
  }
}
