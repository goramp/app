import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import 'dart:async';

class _ResendView extends StatelessWidget {
  final CurrentRemainingTime remainingTime;
  final TextStyle? textStyle;
  _ResendView(this.remainingTime, {this.textStyle});
  String singleDigit(int n) {
    return "$n";
  }

  String twoDigits(int n) {
    if (n >= 10) return singleDigit(n);
    return "0$n";
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mins = remainingTime.min ?? 0;
    final secs = remainingTime.sec ?? 0;
    final minstr = twoDigits(mins);
    final secstr = twoDigits(secs);
    final hrs = remainingTime.hours ?? 0;
    final days = remainingTime.days ?? 0;
    var style = textStyle ??
        theme.textTheme.caption!.copyWith(color: theme.colorScheme.primary);
    var txt = '${secstr}s';
    if (mins > 0) {
      txt = '${minstr}m : ${minstr}s';
    }
    if (hrs > 0) {
      txt = '${hrs}h : $txt';
    }
    if (days > 0) {
      txt = '${days}d : $txt';
    }
    return Text(S.of(context).resend_in(txt),
        textAlign: TextAlign.right, style: style);
  }
}

class DigitCode extends StatefulWidget {
  final bool enabled;
  final bool sending;
  final VoidCallback? onSend;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FocusNode? focusNode;
  final int maxLength;
  final double? maxWidth;

  DigitCode(
      {Key? key,
      this.enabled = false,
      this.sending = false,
      this.onSend,
      this.onFieldSubmitted,
      this.onSaved,
      this.focusNode,
      this.maxWidth,
      this.onChanged,
      this.maxLength = 6})
      : super(key: key);
  @override
  _DigitCodeState createState() => _DigitCodeState();
}

class _DigitCodeState extends State<DigitCode>
    with SingleTickerProviderStateMixin {
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  bool _startCountDown = false;
  late TextEditingController _controller;
  late ValidationBloc _validationBloc;
  late StreamSubscription<ValidationState> _validationSub;

  initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      _validationBloc.onTextChanged.add(_controller.text);
      widget.onChanged?.call(_controller.text);
    });
    _validationBloc = ValidationBloc<String>(DigitCodeValidator(
        Constants.CODE_FIELD, context.read(), 6,
        context: context));

    _validationSub = _validationBloc.state.listen((ValidationState state) {
      _handleFieldValidation(Constants.CODE_FIELD, state);
    });
  }

  bool get isValid {
    return validationStates.values.isEmpty
        ? false
        : validationStates.values.every((ValidationState state) {
            if (state is ValidationResult) {
              return state.isValid;
            }
            return false;
          });
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    setState(() {
      validationStates[fieldName] = state;
    });
    if (isValid && _controller.text.length == 6) {
      widget.onFieldSubmitted?.call(_controller.text.trim());
    }
  }

  dispose() {
    super.dispose();
    _validationBloc.dispose();
    _validationSub.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getCodeButton = TextButton.icon(
        icon: widget.sending
            ? FeedLoader(
                size: 18,
                strokeWidth: 2,
              )
            : const SizedBox.shrink(),
        label: Text("Get Code"),
        onPressed: widget.sending || !widget.enabled
            ? null
            : () {
                widget.onSend?.call();
                setState(() {
                  _startCountDown = true;
                });
              });
    return WithTextFieldValidation(
      validationEnabled: true,
      validationBloc: _validationBloc,
      textController: _controller,
      autoCorrect: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      focusNode: widget.focusNode,
      maxWidth: widget.maxWidth,
      onSaved: widget.onSaved,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      sufficIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _startCountDown
                ? CountdownTimer(
                    endWidget: getCodeButton,
                    endTime: DateTime.now()
                        .add(Duration(minutes: 1))
                        .millisecondsSinceEpoch,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      return time != null ? _ResendView(time) : getCodeButton;
                    },
                    onEnd: () {
                      setState(() {
                        _startCountDown = false;
                      });
                    },
                  )
                : getCodeButton
          ],
        ),
      ),
      labelText: 'Verification Code',
      // helperText: "",
      // errorHandler: _handleError,
    );
  }
}
