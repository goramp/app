import 'package:goramp/app_config.dart';
import 'package:provider/provider.dart';
import 'package:browser_adapter/browser_adapter.dart';

import '../index.dart';
import 'package:flutter/material.dart';

const darkIcon = AssetImage('assets/images/logo_full/dark/small/logo.png');
const _kGotokLogoSVG = 'assets/images/glogo/logo.svg';
const _kKuroLogoSVG = 'assets/images/klogo/kurobi.svg';
const _kKuroLogoPNG = 'assets/images/klogo/kurobi.png';
const _kGotokLogoPNG = 'assets/images/glogo/logo.png';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo();

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(width: 16);
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    final canvasKit = isCanvasKitRenderer();
    AppConfig config = Provider.of(context, listen: false);
    return isDesktop
        ? SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                spacing,
                ExcludeSemantics(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: config.isKuro
                        ? canvasKit
                            ? Image.network(
                                _kKuroLogoPNG,
                                height: 32.0,
                                width: 32.0,
                              )
                            : PlatformSvg.asset(
                                _kKuroLogoSVG,
                                height: 32.0,
                                width: 32.0,
                              )
                        : canvasKit
                            ? Image.network(
                                _kGotokLogoPNG,
                                height: 32.0,
                                width: 32.0,
                              )
                            : PlatformSvg.asset(
                                //isDark ? _kDarkIcon : _kLightIcon,
                                _kGotokLogoSVG,
                                color: theme.colorScheme.primary,
                                height: 32.0,
                                width: 32.0,
                              ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
