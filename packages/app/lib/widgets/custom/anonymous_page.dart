import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/index.dart';

class AnonymousPage extends StatelessWidget {
  final Widget child;
  const AnonymousPage(this.child);

  Widget _buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Container(
      color: isDark
          ? Color.alphaBlend(theme.colorScheme.primary.withOpacity(0.08),
              theme.colorScheme.background)
          : theme.colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SizedBox(
              child: PlatformCircularProgressIndicator(
                  Theme.of(context).colorScheme.secondary),
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        Widget body;
        if (State == null || state is AuthUnInitialized) {
          body =
              KeyedSubtree(key: ValueKey(state), child: _buildContent(context));
        } else if (state is AuthAuthenticated) {
          body = KeyedSubtree(key: ValueKey(state), child: child);
        } else {
          body = KeyedSubtree(
            key: ValueKey(state),
            child: FutureBuilder<User>(
              future: LoginService.loginAnonymous(),
              builder: (context, snapshot) {
                if (snapshot.hasData) return child;
                return _buildContent(context);
              },
            ),
          );
        }
        return AnimatedSwitcher(duration: kThemeAnimationDuration, child: body);
      },
    );
  }
}
