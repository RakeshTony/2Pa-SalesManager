import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/app_style_text.dart';

class InputFieldWidget {
  InputFieldWidget._();

  static Widget text(
    String label, {
    Key? key,
    FocusNode? focusNode,
    bool? allCaps,
    TextStyle? textStyle,
    bool? disableSpace,
    bool? readOnly,
    int? maxLength,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? prefixIconPadding,
    String? prefixAsset,
    String? suffixAsset,
    TextEditingController? textEditingController,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    TextStyle? hintStyle,
    Color? enableColor,
    Color? focusColor,
  }) {
    return _BuildInputFieldWidget(
      key,
      label,
      focusNode,
      RInputType.TYPE_TEXT,
      allCaps,
      textStyle,
      disableSpace,
      readOnly,
      margin,
      padding,
      prefixIconPadding,
      prefixAsset,
      suffixAsset,
      textEditingController,
      textInputAction,
      onFieldSubmitted,
      hintStyle,
      enableColor,
      focusColor,
      maxLength: maxLength,
    );
  }

  static Widget email(
    String label, {
    Key? key,
    FocusNode? focusNode,
    bool? allCaps,
    TextStyle? textStyle,
    bool? disableSpace,
    bool? readOnly,
    int? maxLength,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? prefixIconPadding,
    String? prefixAsset,
    String? suffixAsset,
    TextEditingController? textEditingController,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    TextStyle? hintStyle,
    Color? enableColor,
    Color? focusColor,
  }) {
    return _BuildInputFieldWidget(
      key,
      label,
      focusNode,
      RInputType.TYPE_EMAIL,
      allCaps,
      textStyle,
      disableSpace,
      readOnly,
      margin,
      padding,
      prefixIconPadding,
      prefixAsset,
      suffixAsset,
      textEditingController,
      textInputAction,
      onFieldSubmitted,
      hintStyle,
      enableColor,
      focusColor,
      maxLength: maxLength,
    );
  }

  static Widget number(
    String label, {
    Key? key,
    FocusNode? focusNode,
    bool? allCaps,
    TextStyle? textStyle,
    bool? disableSpace,
    bool? readOnly,
    int? maxLength,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? prefixIconPadding,
    String? prefixAsset,
    String? suffixAsset,
    TextEditingController? textEditingController,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    int? inputType = RInputType.TYPE_NUMBER,
    TextStyle? hintStyle,
    Color? enableColor,
    Color? focusColor,
  }) {
    return _BuildInputFieldWidget(
      key,
      label,
      focusNode,
      inputType,
      allCaps,
      textStyle,
      disableSpace,
      readOnly,
      margin,
      padding,
      prefixIconPadding,
      prefixAsset,
      suffixAsset,
      textEditingController,
      textInputAction,
      onFieldSubmitted,
      hintStyle,
      enableColor,
      focusColor,
      maxLength: maxLength,
    );
  }

  static Widget password(
    String label, {
    Key? key,
    FocusNode? focusNode,
    bool? allCaps,
    TextStyle? textStyle,
    bool? disableSpace,
    bool? readOnly,
    int? maxLength,
    int inputType = RInputType.TYPE_PASSWORD,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? prefixIconPadding,
    String? prefixAsset,
    String? suffixAsset,
    TextEditingController? textEditingController,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    TextStyle? hintStyle,
    Color? enableColor,
    Color? focusColor,
  }) {
    return _BuildInputFieldWidget(
      key,
      label,
      focusNode,
      inputType,
      allCaps,
      textStyle,
      disableSpace,
      readOnly,
      margin,
      padding,
      prefixIconPadding,
      prefixAsset,
      suffixAsset,
      textEditingController,
      textInputAction,
      onFieldSubmitted,
      hintStyle,
      enableColor,
      focusColor,
      maxLength: maxLength,
    );
  }
}

class _BuildInputFieldWidget extends StatefulWidget {
  final String label;
  final bool? allCaps;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? enableColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool? readOnly;
  final int? inputType;
  final int? maxLength;
  final bool? disableSpace;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? prefixIconPadding;
  final String? prefixAsset;
  final String? suffixAsset;
  final TextEditingController? textEditingController;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Key? key;

  _BuildInputFieldWidget(
    this.key,
    this.label,
    this.focusNode,
    this.inputType,
    this.allCaps,
    this.textStyle,
    this.disableSpace,
    this.readOnly,
    this.margin,
    this.padding,
    this.prefixIconPadding,
    this.prefixAsset,
    this.suffixAsset,
    this.textEditingController,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintStyle,
    this.enableColor,
    this.focusColor, {
    this.maxLength,
  });

  @override
  State<StatefulWidget> createState() => _BuildInputFieldWidgetState();
}

class _BuildInputFieldWidgetState extends State<_BuildInputFieldWidget> {
  List<TextInputFormatter> _textInputFormatter = [];
  late TextInputType _textInputType;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = (widget.inputType == RInputType.TYPE_PASSWORD ||
        widget.inputType == RInputType.TYPE_NUMBER_PASSWORD);
    switch (widget.inputType) {
      case RInputType.TYPE_EMAIL:
        _textInputType = TextInputType.emailAddress;
        break;
      case RInputType.TYPE_NUMBER:
      case RInputType.TYPE_NUMBER_PASSWORD:
        _textInputType = TextInputType.number;
        break;
      default:
        _textInputType = TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: TextFormField(
        /*Enable true by rakesh*/
        enableInteractiveSelection: true,
        key: widget.key,
        maxLength: widget.maxLength,
        buildCounter: (BuildContext context,
                {int? currentLength, int? maxLength, bool? isFocused}) =>
            null,
        focusNode: widget.focusNode,
        obscureText: _obscureText,
        keyboardType: _textInputType,
        readOnly: widget.readOnly ?? false,
        inputFormatters: [
          if (widget.disableSpace ?? false)
            FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
          if (widget.inputType == RInputType.TYPE_NUMBER)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        textInputAction: widget.textInputAction,
        controller: widget.textEditingController,
        onFieldSubmitted: widget.onFieldSubmitted,
        textCapitalization: widget.allCaps ?? false
            ? TextCapitalization.characters
            : TextCapitalization.none,
        style: widget.textStyle ?? AppStyleText.inputFiledPrimaryText,
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: widget.hintStyle ?? AppStyleText.inputFiledPrimaryHint,
          isDense: true,
          filled: true,
          contentPadding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          fillColor: Colors.transparent,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.enableColor ?? kMainTextColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: widget.focusColor ?? kMainButtonColor),
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: 32,
            minWidth: 32,
          ),
          suffixIcon: widget.inputType == RInputType.TYPE_PASSWORD ||
                  widget.inputType == RInputType.TYPE_NUMBER_PASSWORD
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: kMainTextColor,
                      size: 24,
                    ),
                    onTap: () => setState(() => _obscureText = !_obscureText),
                  ),
                )
              : widget.suffixAsset != null &&
                      widget.suffixAsset?.isNotEmpty == true
                  ? Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      padding: EdgeInsets.all(2),
                      child: Image.asset(
                        widget.suffixAsset!,
                        width: 18,
                        height: 18,
                      ),
                    )
                  : null,
          prefixIconConstraints: BoxConstraints(
            minHeight: 32,
            minWidth: 32,
          ),
          prefixIcon: widget.prefixAsset != null
              ? Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.all(2),
                  child: Image.asset(
                    widget.prefixAsset!,
                    width: 24,
                    height: 24,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class RInputType {
  RInputType._();

  static const int TYPE_TEXT = 1;
  static const int TYPE_EMAIL = 2;
  static const int TYPE_NUMBER = 3;
  static const int TYPE_PASSWORD = 4;
  static const int TYPE_NUMBER_PASSWORD = 5;
}
