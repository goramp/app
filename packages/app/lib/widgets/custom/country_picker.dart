import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/widgets/custom/responsive_dialog.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:goramp/generated/l10n.dart';

const double _datePickerHeaderLandscapeWidth = 152.0;
const double _datePickerHeaderPortraitHeight = 120.0;
const double _headerPaddingLandscape = 16.0;

const Size _portraitDialogSize = Size(330.0, 518.0);
const Size _landscapeDialogSize = Size(496.0, 520.0);

class CountryPickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  CountryPickerHeader({
    Key? key,
    required this.helpText,
    required this.orientation,
    this.onIconPressed,
  })  : assert(helpText != null),
        assert(orientation != null),
        super(key: key);

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  /// Callback when the user taps the icon in the header.
  ///
  /// The picker will use this to toggle between entry modes.
  final VoidCallback? onIconPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color primarySurfaceColor =
        isDark ? colorScheme.surface : colorScheme.primary;
    final Color onPrimarySurfaceColor =
        isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    final TextStyle? helpStyle = textTheme.overline?.copyWith(
      color: onPrimarySurfaceColor,
    );

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    switch (orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: _datePickerHeaderPortraitHeight,
          child: Material(
            color: primarySurfaceColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  help,
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: _datePickerHeaderLandscapeWidth,
          child: Material(
            color: primarySurfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
              ],
            ),
          ),
        );
    }
  }
}

Future<void> showCountrySelectionPicker({
  required BuildContext context,
  String? title,
  CountryCode? selectedItem,
  ValueChanged<CountryCode>? onChanged,
  VoidCallback? onConfirmed,
  VoidCallback? onCancelled,
  List<CountryCode>? items,
}) async {
  final selection = await showDialog<CountryCode>(
    context: context,
    builder: (BuildContext context) {
      return CountryPickerDialog(
        items: items,
        title: title,
        initialItem: selectedItem,
      );
    },
  );
  if (onChanged != null && selection != null) onChanged(selection);
  if (onCancelled != null && selection == null) onCancelled();
  if (onConfirmed != null && selection != null) onConfirmed();
}

class CountryPickerDialog extends StatefulWidget {
  CountryPickerDialog({
    this.title,
    required this.items,
    required this.initialItem,
  });

  final List<CountryCode>? items;
  final CountryCode? initialItem;
  final String? title;

  @override
  State<CountryPickerDialog> createState() =>
      _SelectionPickerDialogState(initialItem);
}

class _SelectionPickerDialogState extends State<CountryPickerDialog> {
  _SelectionPickerDialogState(this.selectedItem);

  CountryCode? selectedItem;

  @override
  Widget build(BuildContext context) {
    assert(context != null);
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ResponsiveDialog(
      context: context,
      landscapeDialogSize: _landscapeDialogSize,
      portraitDialogSize: _portraitDialogSize,
      hideButtons: true,
      // header: CountryPickerHeader(
      //   helpText: "SELECT COUNTRY",
      //   orientation: orientation,
      // ),
      title: S.of(context).select_country.toUpperCase(),
      child: CountrySelectionPicker(
        items: widget.items!,
        selectedItem: selectedItem,
        onChanged: (value) => Navigator.of(context).pop(
          value,
        ),
      ),
      okPressed: () => Navigator.of(context).pop(
        selectedItem,
      ),
    );
  }
}

/// This helper widget manages a scrollable checkbox list inside a picker widget.
class CountrySelectionPicker extends StatefulWidget {
  CountrySelectionPicker({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.flagWidth = 24.0,
  })  : assert(items != null),
        super(key: key);
  final double flagWidth;
  // Constants
  static const double defaultItemHeight = 40.0;

  // Events
  final ValueChanged<CountryCode?> onChanged;

  // Variables
  final List<CountryCode> items;
  final CountryCode? selectedItem;
  @override
  _CountrySelectionPickerState createState() {
    return _CountrySelectionPickerState(selectedItem);
  }
}

class _CountrySelectionPickerState extends State<CountrySelectionPicker> {
  _CountrySelectionPickerState(this.selectedValue);

  CountryCode? selectedValue;
  TextEditingController? _queryTextController;
  FocusNode? _focusNode;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    _queryTextController = TextEditingController();
    _focusNode = FocusNode();
    _queryTextController!.addListener(_handleTextChange);
    super.initState();
  }

  _handleTextChange() {}

  @override
  void dispose() {
    _queryTextController!.removeListener(_handleTextChange);
    _queryTextController!.dispose();
    _focusNode!.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        if (userScroll.metrics.axis != Axis.vertical) {
          return false;
        }
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _focusNode?.unfocus();
            break;
          case ScrollDirection.reverse:
            _focusNode?.unfocus();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final String searchFieldLabel =
        MaterialLocalizations.of(context).searchFieldLabel;
    final TextStyle? searchFieldStyle = theme.inputDecorationTheme.hintStyle;
    final border = OutlineInputBorder(
        borderRadius: kInputBorderRadius,
        borderSide: BorderSide(color: theme.primaryColor));
    // final bool isDark = theme.brightness == Brightness.dark;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Container(
        child: Column(
          children: [
            Material(
              child: Container(
                child: TextField(
                  controller: _queryTextController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (String _) {
                    //_searchBloc.onTextChanged.add(queryTextController.text);
                  },
                  decoration: InputDecoration(
                    border: border,
                    hintText: searchFieldLabel,
                    hintStyle: searchFieldStyle,
                    prefixIcon: Icon(Icons.search),
                    // contentPadding:
                    //     EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 0.5,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _queryTextController!,
                builder: (context, TextEditingValue value, _) {
                  List<CountryCode> items = value.text.isEmpty
                      ? widget.items
                      : widget.items.where((item) {
                          final q = value.text.trim().toLowerCase();
                          return item.name!.toLowerCase().contains(q) ||
                              item.code!.toLowerCase().contains(q) ||
                              item.dialCode!.toLowerCase().contains(q);
                        }).toList();
                  return Scrollbar(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        bool isSelected = (item.code == selectedValue?.code);
                        // final MaterialLocalizations localizations =
                        //     MaterialLocalizations.of(context);

                        return ListTile(
                          leading: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Center(
                              child: Image.asset(
                                item.flagUri!,
                                package: 'country_code_picker',
                                width: widget.flagWidth,
                              ),
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: theme.selectedRowColor,
                          title: Text(
                            item.toCountryStringOnly(),
                          ),
                          onTap: () {
                            _focusNode!.unfocus();
                            setState(() {
                              selectedValue = item;
                              widget.onChanged(selectedValue);
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountryPickerField extends StatefulWidget {
  CountryPickerField(
      {Key? key,
      this.fieldName,
      this.selected,
      this.icon,
      this.hint,
      this.items,
      required this.onChanged})
      : assert(onChanged != null),
        super(key: key);
  final String? fieldName;
  final Icon? icon;
  final ValueChanged<CountryCode> onChanged;
  final CountryCode? selected;
  final String? hint;
  final List<CountryCode>? items;
  @override
  State<StatefulWidget> createState() {
    return CountryPickerFieldState();
  }
}

class CountryPickerFieldState extends State<CountryPickerField> {
  AppConfig? config;
  initState() {
    config = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final kEventInputBorder = OutlineInputBorder(
        borderRadius: kInputBorderRadius,
        borderSide: BorderSide(color: theme.colorScheme.primary));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.ls),
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!,
        child: Material(
          child: InkWell(
            borderRadius: kInputBorderRadius,
            onTap: () async {
              showCountrySelectionPicker(
                  context: context,
                  title: S.of(context).select_country.toUpperCase(),
                  selectedItem: widget.selected,
                  onChanged: widget.onChanged,
                  items: widget.items);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: widget.fieldName,
                prefixIcon: widget.icon,
                hintText: widget.hint,
                hintStyle: theme.textTheme.subtitle1,
                suffixIcon: widget.selected != null
                    ? Image.asset(
                        widget.selected!.flagUri!,
                        package: 'country_code_picker',
                        width: 24.0,
                      )
                    : null,
                enabledBorder: kEventInputBorder,
                focusedBorder: kEventInputBorder,
                // filled: true,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: kinputFieldHeight),
                child: widget.selected != null
                    ? Text(
                        widget.selected!.toCountryStringOnly(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
