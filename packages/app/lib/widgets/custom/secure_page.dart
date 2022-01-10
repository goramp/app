import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/index.dart';

class SecurePage extends StatelessWidget {
  final Widget child;
  const SecurePage(this.child);

  Widget _buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Container(
      color: isDark
          ? Color.alphaBlend(theme.colorScheme.primary.withOpacity(0.08),
              theme.colorScheme.background)
          : theme.colorScheme.background,
      child: Center(child: const FeedLoader()),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        Widget body;
        if (state is AuthUnInitialized) {
          body = _buildContent(context);
        } else if (state is AuthAuthenticated) {
          body = child;
        } else {
          body = const Welcome();
        }
        return AnimatedSwitcher(duration: kThemeAnimationDuration, child: body);
      },
    );
  }
}
