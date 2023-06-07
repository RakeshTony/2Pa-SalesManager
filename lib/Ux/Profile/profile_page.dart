import 'dart:io';

import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_widget.dart';
import 'package:flutter/material.dart';
import 'package:twopa_sales_manager/BaseClasses/base_state.dart';
import 'package:twopa_sales_manager/Locale/locales.dart';
import 'package:twopa_sales_manager/Theme/colors.dart';
import 'package:twopa_sales_manager/Utils/Enum/enum_r_font_weight.dart';
import 'package:twopa_sales_manager/Utils/Widgets/AppImage.dart';
import 'package:twopa_sales_manager/Utils/Widgets/app_bar_common_title_widget.dart';
import 'package:twopa_sales_manager/Utils/Widgets/custom_button.dart';
import 'package:twopa_sales_manager/Utils/Widgets/input_field_widget.dart';
import 'package:twopa_sales_manager/Utils/app_action.dart';
import 'package:twopa_sales_manager/Utils/app_icons.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_error.dart';
import 'package:twopa_sales_manager/Ux/Dialog/dialog_image_picker.dart';
import 'package:twopa_sales_manager/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:twopa_sales_manager/main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/Enum/enum_r_font_family.dart';
import '../../Utils/app_decorations.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileBody();
  }
}

class ProfileBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends BasePageState<ProfileBody, ViewModelProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _mSelectedProfilePicture;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  FocusNode _usernameNode = FocusNode();
  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _mobileNode = FocusNode();
  FocusNode _addressNode = FocusNode();

  @override
  void initState() {
    super.initState();
    var user = mPreference.value.userData;
    _usernameController.text = user.username;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _mobileController.text = user.mobile;
    _addressController.text = user.address;

    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);

    viewModel.responseStream.listen((map) {
      if (map.getStatus) {
        mPreference.value.userData = map.userData;
        if (mounted) {
          setState(() {});
          AppAction.showGeneralErrorMessage(context, map.getMessage);
        }
      }
    }, cancelOnError: false);
  }

  Future<Null> _doPickImage(ImageSource source) async {
    XFile? pickedImage =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedImage != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: kMainColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Cropper',
          ));
      if (croppedFile != null) {
        _mSelectedProfilePicture = croppedFile;
        if (mounted) setState(() {});
      }
    }
  }

  bool imageConstraint(File image) {
    if (!['png', 'jpg', 'jpeg']
        .contains(image.path.split('.').last.toString())) {
      var dialog = DialogError(
          title: "Image format should be jpg/jpeg/png.",
          actionText: "Continue",
          onActionTap: () {});
      showDialog(context: context, builder: (context) => dialog);
      return false;
    }
    if (image.lengthSync() > 100000) {
      var dialog = DialogError(
          title: "Error Uploading!",
          actionText: "Continue",
          onActionTap: () {});
      showDialog(context: context, builder: (context) => dialog);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
        decoration: decorationBackground,
      child :Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kTransparentColor,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 48,
              color: kStripColor,
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${locale.profile}",
                    style: TextStyle(
                        fontSize: 14,
                        color: kMainTextColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          AppImage(
                            _mSelectedProfilePicture != null
                                ? _mSelectedProfilePicture!.path
                                : mPreference.value.userData.icon,
                            80,
                            defaultImage: DEFAULT_PERSON,
                            isFile: _mSelectedProfilePicture != null,
                            borderWidth: 2,
                            borderColor: kMainColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: kWhiteColor,
                                  size: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: kMainButtonColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      var dialogImagePicker = DialogImagePicker(
                        (source) {
                          _doPickImage(source);
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (context) => dialogImagePicker);
                    },
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${mPreference.value.userData.name}",
                          style: TextStyle(
                              color: kColor11,
                              fontSize: 18,
                              fontWeight: RFontWeight.BOLD),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${mPreference.value.userData.mobile}",
                          style: TextStyle(
                              color: kColor11,
                              fontSize: 12,
                              fontWeight: RFontWeight.REGULAR),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${mPreference.value.userData.email}",
                          style: TextStyle(
                              color: kColor11,
                              fontSize: 12,
                              fontWeight: RFontWeight.LIGHT),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InputFieldWidget.text(
              "Username",
              margin: EdgeInsets.only(top: 14, left: 18, right: 18),
              textEditingController: _usernameController,
              focusNode: _usernameNode,
              readOnly: true,
            ),
            InputFieldWidget.text(
              "Full Name",
              margin: EdgeInsets.only(top: 14, left: 18, right: 18),
              textEditingController: _nameController,
              focusNode: _nameNode,readOnly: true,
            ),
            InputFieldWidget.number(
              locale.mobileNumber ?? "",
              margin: EdgeInsets.only(top: 14, left: 18, right: 18),
              textEditingController: _mobileController,
              focusNode: _mobileNode,readOnly: true,
            ),
            InputFieldWidget.email(
              "Email Address",
              margin: EdgeInsets.only(top: 14, left: 18, right: 18),
              textEditingController: _emailController,
              focusNode: _emailNode,readOnly: true,
            ),
            InputFieldWidget.text(
              "Address",
              margin: EdgeInsets.only(top: 14, left: 18, right: 18),
              textEditingController: _addressController,
              focusNode: _addressNode,
              readOnly: true,
            ),
            CustomButton(
              text: "${locale.submit}",
              margin: EdgeInsets.only(
                  top: 48, left: 18, right: 18, bottom: 24),
              radius: BorderRadius.all(Radius.circular(12.0)),
              onPressed: () {
                viewModel.requestProfileUpdate(
                    _nameController,
                    _mobileController,
                    _emailController,
                    _addressController,
                    _mSelectedProfilePicture);
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}
