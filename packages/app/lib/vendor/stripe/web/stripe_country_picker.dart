import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/widgets/custom/country_picker.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StripeCountryPickerField extends StatefulWidget {
  StripeCountryPickerField(
      {Key? key,
      this.fieldName,
      this.selected,
      this.icon,
      this.hint,
      this.items,
      this.enabled,
      this.focusNode,
      this.onTap,
      required this.onChanged})
      : assert(onChanged != null),
        super(key: key);
  final String? fieldName;
  final bool? enabled;
  final Icon? icon;
  final ValueChanged<CountryCode> onChanged;
  final CountryCode? selected;
  final String? hint;
  final List<CountryCode>? items;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  @override
  State<StatefulWidget> createState() {
    return _CountryPickerFieldState();
  }
}

class _CountryPickerFieldState extends State<StripeCountryPickerField> {
  FocusNode? _focusNode;

  initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Focus(
      focusNode: _focusNode,
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!,
        child: Material(
          child: InkWell(
            borderRadius: kInputBorderRadius,
            onTap: () async {
              widget.onTap?.call();
              FocusScope.of(context).requestFocus(_focusNode);
              await showCountrySelectionPicker(
                  context: context,
                  title: S.of(context).country,
                  selectedItem: widget.selected,
                  onChanged: widget.onChanged,
                  items: widget.items);
              FocusScope.of(context).unfocus();
            },
            child: InputDecorator(
              decoration: InputDecoration(
                  enabled: widget.enabled!,
                  // prefixIcon: widget.icon,
                  hintText: widget.hint,
                  hintStyle: theme.textTheme.subtitle1,
                  border: kEventInputBorder,
                  enabledBorder: kEventInputBorder,
                  disabledBorder: kEventInputBorder,
                  focusedBorder: kEventInputBorder,
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
                  suffixIcon: Icon(MdiIcons.chevronDown),
                  suffixStyle: theme.textTheme.caption,
                  filled: true),
              child: widget.selected != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Image.asset(
                            widget.selected!.flagUri!,
                            package: 'country_code_picker',
                            width: 24.0,
                          ),
                          width: 24.0,
                          height: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.selected!.toCountryStringOnly(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),

            // InputDecorator(
            //   decoration: InputDecoration(
            //     labelText: widget.fieldName,
            //     prefixIcon: widget.icon,
            //     hintText: widget.hint,
            //     hintStyle: theme.textTheme.subtitle1,
            //     suffixIcon: widget.selected != null
            //         ? Image.asset(
            //             widget.selected.flagUri,
            //             package: 'country_code_picker',
            //             width: 24.0,
            //           )
            //         : null,
            //     enabledBorder: kEventInputBorder,
            //     focusedBorder: kEventInputBorder,
            //     // filled: true,
            //   ),
            //   child: ConstrainedBox(
            //     constraints: const BoxConstraints(maxHeight: kinputFieldHeight),
            //     child: widget.selected != null
            //         ? Text(
            //             widget.selected.toCountryStringOnly(),
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             style: theme.textTheme.subtitle1
            //                 .copyWith(fontWeight: FontWeight.bold),
            //           )
            //         : SizedBox.shrink(),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
