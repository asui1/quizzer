// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get languageCode {
    return Intl.message(
      'en',
      name: 'languageCode',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get Trending {
    return Intl.message(
      'Trending',
      name: 'Trending',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get Rank {
    return Intl.message(
      'Rank',
      name: 'Rank',
      desc: '',
      args: [],
    );
  }

  /// `My Settings`
  String get My_Settings {
    return Intl.message(
      'My Settings',
      name: 'My_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get Setting {
    return Intl.message(
      'Setting',
      name: 'Setting',
      desc: '',
      args: [],
    );
  }

  /// `Announcement`
  String get Announcement {
    return Intl.message(
      'Announcement',
      name: 'Announcement',
      desc: '',
      args: [],
    );
  }

  /// `Inquiry`
  String get Inquiry {
    return Intl.message(
      'Inquiry',
      name: 'Inquiry',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to Logout?`
  String get Are_you_sure_to_Logout {
    return Intl.message(
      'Are you sure to Logout?',
      name: 'Are_you_sure_to_Logout',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get No {
    return Intl.message(
      'No',
      name: 'No',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get Yes {
    return Intl.message(
      'Yes',
      name: 'Yes',
      desc: '',
      args: [],
    );
  }

  /// `You are Logged out`
  String get You_are_Logged_out {
    return Intl.message(
      'You are Logged out',
      name: 'You_are_Logged_out',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get Registration {
    return Intl.message(
      'Registration',
      name: 'Registration',
      desc: '',
      args: [],
    );
  }

  /// `Register Success`
  String get Register_Success {
    return Intl.message(
      'Register Success',
      name: 'Register_Success',
      desc: '',
      args: [],
    );
  }

  /// `Unregistered User`
  String get Unregistered_User {
    return Intl.message(
      'Unregistered User',
      name: 'Unregistered_User',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get Login_Failed {
    return Intl.message(
      'Login Failed',
      name: 'Login_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Set Nickname`
  String get Set_Nickname {
    return Intl.message(
      'Set Nickname',
      name: 'Set_Nickname',
      desc: '',
      args: [],
    );
  }

  /// `Dup check`
  String get Dup_check {
    return Intl.message(
      'Dup check',
      name: 'Dup_check',
      desc: '',
      args: [],
    );
  }

  /// `Google Login Failed`
  String get Google_Login_Failed {
    return Intl.message(
      'Google Login Failed',
      name: 'Google_Login_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `Usable Nickname`
  String get Usable_Nickname {
    return Intl.message(
      'Usable Nickname',
      name: 'Usable_Nickname',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate Nickname`
  String get Duplicate_Nickname {
    return Intl.message(
      'Duplicate Nickname',
      name: 'Duplicate_Nickname',
      desc: '',
      args: [],
    );
  }

  /// `Your email is already registerd`
  String get Your_email_is_already_registerd {
    return Intl.message(
      'Your email is already registerd',
      name: 'Your_email_is_already_registerd',
      desc: '',
      args: [],
    );
  }

  /// `Successful Login`
  String get Successful_Login {
    return Intl.message(
      'Successful Login',
      name: 'Successful_Login',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get Terms_of_Use {
    return Intl.message(
      'Terms of Use',
      name: 'Terms_of_Use',
      desc: '',
      args: [],
    );
  }

  /// `When creating a quiz, if the content of the quiz contains content that may cause social controversy such as disparagement or ridicule, or if it contains content that infringes on rights such as copyright, portrait rights, or pornography, the quiz may be deleted without the consent of the creator.\nIn addition, problems arising from the quizzes you have created are entirely the user's responsibility and quizzer is not responsible for them.\nIf you agree to this, please click the AGREE button.`
  String get User_Agreement_text {
    return Intl.message(
      'When creating a quiz, if the content of the quiz contains content that may cause social controversy such as disparagement or ridicule, or if it contains content that infringes on rights such as copyright, portrait rights, or pornography, the quiz may be deleted without the consent of the creator.\nIn addition, problems arising from the quizzes you have created are entirely the user\'s responsibility and quizzer is not responsible for them.\nIf you agree to this, please click the AGREE button.',
      name: 'User_Agreement_text',
      desc: '',
      args: [],
    );
  }

  /// `AGREE`
  String get AGREE {
    return Intl.message(
      'AGREE',
      name: 'AGREE',
      desc: '',
      args: [],
    );
  }

  /// `Temp Save`
  String get Temp_Save {
    return Intl.message(
      'Temp Save',
      name: 'Temp_Save',
      desc: '',
      args: [],
    );
  }

  /// `1. Quiz Title`
  String get First_Quiz_Title {
    return Intl.message(
      '1. Quiz Title',
      name: 'First_Quiz_Title',
      desc: '',
      args: [],
    );
  }

  /// `2. Flip Style`
  String get Second_Flip_Style {
    return Intl.message(
      '2. Flip Style',
      name: 'Second_Flip_Style',
      desc: '',
      args: [],
    );
  }

  /// `3. Color Setup`
  String get Thired_Color_Setup {
    return Intl.message(
      '3. Color Setup',
      name: 'Thired_Color_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Additional Setup`
  String get Additional_Setup {
    return Intl.message(
      'Additional Setup',
      name: 'Additional_Setup',
      desc: '',
      args: [],
    );
  }

  /// `BackGround Image Setup`
  String get BackGround_Image_Setup {
    return Intl.message(
      'BackGround Image Setup',
      name: 'BackGround_Image_Setup',
      desc: '',
      args: [],
    );
  }

  /// `TopBar Image Setup`
  String get TopBar_Image_Setup {
    return Intl.message(
      'TopBar Image Setup',
      name: 'TopBar_Image_Setup',
      desc: '',
      args: [],
    );
  }

  /// `BottomBar Image Setup`
  String get BottomBar_Image_Setup {
    return Intl.message(
      'BottomBar Image Setup',
      name: 'BottomBar_Image_Setup',
      desc: '',
      args: [],
    );
  }

  /// `MainColor1`
  String get MainColor1 {
    return Intl.message(
      'MainColor1',
      name: 'MainColor1',
      desc: '',
      args: [],
    );
  }

  /// `MainColor2`
  String get MainColor2 {
    return Intl.message(
      'MainColor2',
      name: 'MainColor2',
      desc: '',
      args: [],
    );
  }

  /// `MainColor3`
  String get MainColor3 {
    return Intl.message(
      'MainColor3',
      name: 'MainColor3',
      desc: '',
      args: [],
    );
  }

  /// `FillColor1`
  String get FillColor1 {
    return Intl.message(
      'FillColor1',
      name: 'FillColor1',
      desc: '',
      args: [],
    );
  }

  /// `FillColor2`
  String get FillColor2 {
    return Intl.message(
      'FillColor2',
      name: 'FillColor2',
      desc: '',
      args: [],
    );
  }

  /// `FillColor3`
  String get FillColor3 {
    return Intl.message(
      'FillColor3',
      name: 'FillColor3',
      desc: '',
      args: [],
    );
  }

  /// `ErrorColor`
  String get ErrorColor {
    return Intl.message(
      'ErrorColor',
      name: 'ErrorColor',
      desc: '',
      args: [],
    );
  }

  /// `ErrorTextColor`
  String get ErrorTextColor {
    return Intl.message(
      'ErrorTextColor',
      name: 'ErrorTextColor',
      desc: '',
      args: [],
    );
  }

  /// `Question Text Setup`
  String get Question_Text_Setup {
    return Intl.message(
      'Question Text Setup',
      name: 'Question_Text_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Example Text Setup`
  String get Example_Text_Setup {
    return Intl.message(
      'Example Text Setup',
      name: 'Example_Text_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Answer Text Setup`
  String get Answer_Text_Setup {
    return Intl.message(
      'Answer Text Setup',
      name: 'Answer_Text_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Flip Button Setup`
  String get Flip_Button_Setup {
    return Intl.message(
      'Flip Button Setup',
      name: 'Flip_Button_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Basic Selection`
  String get Basic_Selection {
    return Intl.message(
      'Basic Selection',
      name: 'Basic_Selection',
      desc: '',
      args: [],
    );
  }

  /// `Date Selection`
  String get Date_Selection {
    return Intl.message(
      'Date Selection',
      name: 'Date_Selection',
      desc: '',
      args: [],
    );
  }

  /// `Order Sorting`
  String get Order_Sorting {
    return Intl.message(
      'Order Sorting',
      name: 'Order_Sorting',
      desc: '',
      args: [],
    );
  }

  /// `Answer Connecting`
  String get Answer_Connecting {
    return Intl.message(
      'Answer Connecting',
      name: 'Answer_Connecting',
      desc: '',
      args: [],
    );
  }

  /// `Move to Google Play Store`
  String get Open_Google_Play {
    return Intl.message(
      'Move to Google Play Store',
      name: 'Open_Google_Play',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get Grade {
    return Intl.message(
      'Grade',
      name: 'Grade',
      desc: '',
      args: [],
    );
  }

  /// `Prob.`
  String get Prob {
    return Intl.message(
      'Prob.',
      name: 'Prob',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get No_results {
    return Intl.message(
      'No results found',
      name: 'No_results',
      desc: '',
      args: [],
    );
  }

  /// `Load`
  String get Load {
    return Intl.message(
      'Load',
      name: 'Load',
      desc: '',
      args: [],
    );
  }

  /// `Quiz`
  String get Quiz {
    return Intl.message(
      'Quiz',
      name: 'Quiz',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get Preview {
    return Intl.message(
      'Preview',
      name: 'Preview',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get Close {
    return Intl.message(
      'Close',
      name: 'Close',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `I got {score} in {title}!`
  String shareText(Object score, Object title) {
    return Intl.message(
      'I got $score in $title!',
      name: 'shareText',
      desc: '',
      args: [score, title],
    );
  }

  /// `Views`
  String get Solved_num {
    return Intl.message(
      'Views',
      name: 'Solved_num',
      desc: '',
      args: [],
    );
  }

  /// `Flip Style Setup`
  String get Flip_Style_Setup {
    return Intl.message(
      'Flip Style Setup',
      name: 'Flip_Style_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Color Setup`
  String get Color_Setup {
    return Intl.message(
      'Color Setup',
      name: 'Color_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Most Popular`
  String get Popular_Quiz {
    return Intl.message(
      'Most Popular',
      name: 'Popular_Quiz',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation`
  String get Recommendation {
    return Intl.message(
      'Recommendation',
      name: 'Recommendation',
      desc: '',
      args: [],
    );
  }

  /// `Most recently created`
  String get Most_Recent {
    return Intl.message(
      'Most recently created',
      name: 'Most_Recent',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Title Setup`
  String get Quiz_Title_Setup {
    return Intl.message(
      'Quiz Title Setup',
      name: 'Quiz_Title_Setup',
      desc: '',
      args: [],
    );
  }

  /// `Enter Quiz Title`
  String get Enter_Quiz_Title {
    return Intl.message(
      'Enter Quiz Title',
      name: 'Enter_Quiz_Title',
      desc: '',
      args: [],
    );
  }

  /// `Set Title Image`
  String get Set_Title_Image {
    return Intl.message(
      'Set Title Image',
      name: 'Set_Title_Image',
      desc: '',
      args: [],
    );
  }

  /// `Add Tags`
  String get Add_Tags {
    return Intl.message(
      'Add Tags',
      name: 'Add_Tags',
      desc: '',
      args: [],
    );
  }

  /// `Enter Tags`
  String get Enter_Tags {
    return Intl.message(
      'Enter Tags',
      name: 'Enter_Tags',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Submit {
    return Intl.message(
      'Submit',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add {
    return Intl.message(
      'Add',
      name: 'Add',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get Warning {
    return Intl.message(
      'Warning',
      name: 'Warning',
      desc: '',
      args: [],
    );
  }

  /// `Leaving this page will lose all unsaved contents. Will you continue?`
  String get Leaving_warning {
    return Intl.message(
      'Leaving this page will lose all unsaved contents. Will you continue?',
      name: 'Leaving_warning',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get Exit {
    return Intl.message(
      'Exit',
      name: 'Exit',
      desc: '',
      args: [],
    );
  }

  /// `No buttons\n Only Flip`
  String get No_buttons_Only_Flip {
    return Intl.message(
      'No buttons\n Only Flip',
      name: 'No_buttons_Only_Flip',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get User_Name {
    return Intl.message(
      'User Name',
      name: 'User_Name',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get Upload {
    return Intl.message(
      'Upload',
      name: 'Upload',
      desc: '',
      args: [],
    );
  }

  /// `Move Home`
  String get Move_Home {
    return Intl.message(
      'Move Home',
      name: 'Move_Home',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get Searching {
    return Intl.message(
      'Searching...',
      name: 'Searching',
      desc: '',
      args: [],
    );
  }

  /// `No Borders`
  String get No_Borders {
    return Intl.message(
      'No Borders',
      name: 'No_Borders',
      desc: '',
      args: [],
    );
  }

  /// `Underline`
  String get Underline {
    return Intl.message(
      'Underline',
      name: 'Underline',
      desc: '',
      args: [],
    );
  }

  /// `Box Border`
  String get Box_Border {
    return Intl.message(
      'Box Border',
      name: 'Box_Border',
      desc: '',
      args: [],
    );
  }

  /// `Color Set`
  String get Color_Set {
    return Intl.message(
      'Color Set',
      name: 'Color_Set',
      desc: '',
      args: [],
    );
  }

  /// `Add Answer`
  String get Add_Answer {
    return Intl.message(
      'Add Answer',
      name: 'Add_Answer',
      desc: '',
      args: [],
    );
  }

  /// `Image selected`
  String get Image_selected {
    return Intl.message(
      'Image selected',
      name: 'Image_selected',
      desc: '',
      args: [],
    );
  }

  /// `At least 2 answers are required`
  String get At_least_2_answers_are_required {
    return Intl.message(
      'At least 2 answers are required',
      name: 'At_least_2_answers_are_required',
      desc: '',
      args: [],
    );
  }

  /// `Shuffle Answers?`
  String get Shuffle_Answers {
    return Intl.message(
      'Shuffle Answers?',
      name: 'Shuffle_Answers',
      desc: '',
      args: [],
    );
  }

  /// `Number of possible selection : `
  String get Number_of_possible_selection {
    return Intl.message(
      'Number of possible selection : ',
      name: 'Number_of_possible_selection',
      desc: '',
      args: [],
    );
  }

  /// `Select Center Date. ±20Y`
  String get Select_Center_Date_20Y {
    return Intl.message(
      'Select Center Date. ±20Y',
      name: 'Select_Center_Date_20Y',
      desc: '',
      args: [],
    );
  }

  /// `Enter Answer Dates`
  String get Enter_Answer_Dates {
    return Intl.message(
      'Enter Answer Dates',
      name: 'Enter_Answer_Dates',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get Answer {
    return Intl.message(
      'Answer',
      name: 'Answer',
      desc: '',
      args: [],
    );
  }

  /// `At least 3 answers are required`
  String get At_least_3_answers_are_required {
    return Intl.message(
      'At least 3 answers are required',
      name: 'At_least_3_answers_are_required',
      desc: '',
      args: [],
    );
  }

  /// `Selected Dates`
  String get Selected_Dates {
    return Intl.message(
      'Selected Dates',
      name: 'Selected_Dates',
      desc: '',
      args: [],
    );
  }

  /// `Enter Question`
  String get Enter_Question {
    return Intl.message(
      'Enter Question',
      name: 'Enter_Question',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Can't save without title`
  String get Cant_save_without_title {
    return Intl.message(
      'Can\'t save without title',
      name: 'Cant_save_without_title',
      desc: '',
      args: [],
    );
  }

  /// `Invalid hex code`
  String get Invalid_hex_code {
    return Intl.message(
      'Invalid hex code',
      name: 'Invalid_hex_code',
      desc: '',
      args: [],
    );
  }

  /// `Current Path: `
  String get Current_Path {
    return Intl.message(
      'Current Path: ',
      name: 'Current_Path',
      desc: '',
      args: [],
    );
  }

  /// `No image selected`
  String get No_image_selected {
    return Intl.message(
      'No image selected',
      name: 'No_image_selected',
      desc: '',
      args: [],
    );
  }

  /// `Pick Image`
  String get Pick_Image {
    return Intl.message(
      'Pick Image',
      name: 'Pick_Image',
      desc: '',
      args: [],
    );
  }

  /// `Checking Internet Connection...`
  String get Checking_Internet_Connection {
    return Intl.message(
      'Checking Internet Connection...',
      name: 'Checking_Internet_Connection',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get No_Internet_Connection {
    return Intl.message(
      'No Internet Connection',
      name: 'No_Internet_Connection',
      desc: '',
      args: [],
    );
  }

  /// `You are not connected to Internet`
  String get You_are_not_connected_to_Internet {
    return Intl.message(
      'You are not connected to Internet',
      name: 'You_are_not_connected_to_Internet',
      desc: '',
      args: [],
    );
  }

  /// `Please check your connection and try again.`
  String get Please_check_your_connection_and_try_again {
    return Intl.message(
      'Please check your connection and try again.',
      name: 'Please_check_your_connection_and_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Add Text`
  String get Add_Text {
    return Intl.message(
      'Add Text',
      name: 'Add_Text',
      desc: '',
      args: [],
    );
  }

  /// `Is Searching`
  String get Is_Searching {
    return Intl.message(
      'Is Searching',
      name: 'Is_Searching',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get Text {
    return Intl.message(
      'Text',
      name: 'Text',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get Photo {
    return Intl.message(
      'Photo',
      name: 'Photo',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign In Failed`
  String get Google_Sign_In_Failed {
    return Intl.message(
      'Google Sign In Failed',
      name: 'Google_Sign_In_Failed',
      desc: '',
      args: [],
    );
  }

  /// `There is a new version.\nPlease update.`
  String get There_is_a_new_version_Please_update {
    return Intl.message(
      'There is a new version.\nPlease update.',
      name: 'There_is_a_new_version_Please_update',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get Contact {
    return Intl.message(
      'Contact',
      name: 'Contact',
      desc: '',
      args: [],
    );
  }

  /// `Bug Report`
  String get Bug_Report {
    return Intl.message(
      'Bug Report',
      name: 'Bug_Report',
      desc: '',
      args: [],
    );
  }

  /// `Report Quiz`
  String get Report_Quiz {
    return Intl.message(
      'Report Quiz',
      name: 'Report_Quiz',
      desc: '',
      args: [],
    );
  }

  /// `Development Inquiry`
  String get Development_Inquiry {
    return Intl.message(
      'Development Inquiry',
      name: 'Development_Inquiry',
      desc: '',
      args: [],
    );
  }

  /// `Other Inquiry`
  String get Other_Inquiry {
    return Intl.message(
      'Other Inquiry',
      name: 'Other_Inquiry',
      desc: '',
      args: [],
    );
  }

  /// `Response will be given by email`
  String get Response_will_be_given_by_email {
    return Intl.message(
      'Response will be given by email',
      name: 'Response_will_be_given_by_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Youtube link.`
  String get Enter_Youtube_Link {
    return Intl.message(
      'Enter Youtube link.',
      name: 'Enter_Youtube_Link',
      desc: '',
      args: [],
    );
  }

  /// `Tag limit is 10`
  String get Tag_Limit {
    return Intl.message(
      'Tag limit is 10',
      name: 'Tag_Limit',
      desc: '',
      args: [],
    );
  }

  /// `Downloading json failed`
  String get JSON_DOWN_FAIL {
    return Intl.message(
      'Downloading json failed',
      name: 'JSON_DOWN_FAIL',
      desc: '',
      args: [],
    );
  }

  /// `Enter Inquiry`
  String get Enter_Inquiry {
    return Intl.message(
      'Enter Inquiry',
      name: 'Enter_Inquiry',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
