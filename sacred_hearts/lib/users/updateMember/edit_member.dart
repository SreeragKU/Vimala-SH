import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sacred_hearts/api_connection/api_connection.dart';

class EditMemberScreen extends StatefulWidget {
  final String userId;

  EditMemberScreen({required this.userId});

  @override
  _EditMemberScreenState createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _nameController;
  late TextEditingController _baptismNameController;
  late TextEditingController _petNameController;
  late TextEditingController _churchDobController;
  late TextEditingController _schoolDobController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _baptismPlaceController;
  late TextEditingController _baptismDateController;
  late TextEditingController _confirmationDateController;
  late TextEditingController _confirmationPlaceController;
  late TextEditingController _phNoController;
  late TextEditingController _dateFirstProfessionController;
  late TextEditingController _dateFinalProfessionController;
  late TextEditingController _dateBeginServiceController;
  late TextEditingController _dateRetireController;
  late TextEditingController _positionController;
  late TextEditingController _tdateController;
  late TextEditingController _dodController;
  late TextEditingController _bloodGrpController;
  late TextEditingController _illnessHistoryController;
  late TextEditingController _surgeryHistoryController;
  late TextEditingController _longTermTreatmentController;
  late TextEditingController _presentHealthController;
  late TextEditingController _talentsController;
  late TextEditingController _mottoPrinciplesController;

  List<Map<String, dynamic>> _accreditations = [];
  List<TextEditingController> _accreditationTitleControllers = [];
  List<TextEditingController> _accreditationFromControllers = [];
  List<TextEditingController> _accreditationToControllers = [];
  List<TextEditingController> _accreditationAtControllers = [];
  List<TextEditingController> _accreditationPlaceControllers = [];

  List<Map<String, dynamic>> _userSchoolDetails = [];
  List<TextEditingController> _userSchoolClassControllers = [];
  List<TextEditingController> _userSchoolMarksPercentageControllers = [];
  List<TextEditingController> _userSchoolUniversityControllers = [];
  List<TextEditingController> _userSchoolAddressControllers = [];
  List<TextEditingController> _userSchoolYearOfPassoutControllers = [];

  List<Map<String, dynamic>> _plusTwoDetails = [];
  List<TextEditingController> _plusTwoStreamControllers = [];
  List<TextEditingController> _plusTwoMarksControllers = [];
  List<TextEditingController> _plusTwoBoardControllers = [];
  List<TextEditingController> _plusTwoYearOfPassoutControllers = [];
  List<TextEditingController> _plusTwoSchoolAddressControllers = [];

  List<Map<String, dynamic>> _ugradDetails = [];
  List<TextEditingController> _ugradDegreeControllers = [];
  List<TextEditingController> _ugradSubjectControllers = [];
  List<TextEditingController> _ugradMarkControllers = [];
  List<TextEditingController> _ugradBoardControllers = [];
  List<TextEditingController> _ugradYearOfPassoutControllers = [];
  List<TextEditingController> _ugradColNameAddressControllers = [];

  List<Map<String, dynamic>> _pgDetails = [];
  List<TextEditingController> _pgPostDegreeControllers = [];
  List<TextEditingController> _pgSubjectControllers = [];
  List<TextEditingController> _pgMarkControllers = [];
  List<TextEditingController> _pgBoardControllers = [];
  List<TextEditingController> _pgYearOfPassoutControllers = [];
  List<TextEditingController> _pgColNameAddressControllers = [];

  List<Map<String, dynamic>> _familyData = [];
  List<TextEditingController> _fatherNameControllers = [];
  List<TextEditingController> _dobFatherControllers = [];
  List<TextEditingController> _dodFatherControllers = [];
  List<TextEditingController> _fatherAddressControllers = [];
  List<TextEditingController> _fatherOccupationControllers = [];
  List<TextEditingController> _fatherParishDioceseNowControllers = [];
  List<TextEditingController> _fatherParishDioceseBirthControllers = [];
  List<TextEditingController> _motherNameControllers = [];
  List<TextEditingController> _dobMotherControllers = [];
  List<TextEditingController> _dodMotherControllers = [];
  List<TextEditingController> _motherOccupationControllers = [];
  List<TextEditingController> _guardianNameControllers = [];
  List<TextEditingController> _guardianAddressPhoneControllers = [];
  List<TextEditingController> _guardianRelationControllers = [];

  List<Map<String, dynamic>> _siblingsData = [];
  List<TextEditingController> _siblingNameControllers = [];
  List<TextEditingController> _genderControllers = [];
  List<TextEditingController> _dobControllers = [];
  List<TextEditingController> _occupationControllers = [];
  List<TextEditingController> _addressControllers = [];
  List<TextEditingController> _contactNoControllers = [];

  List<Map<String, dynamic>> _prisDetails = [];
  List<TextEditingController> _prisRelativeNameControllers = [];
  List<TextEditingController> _prisAddressControllers = [];
  List<TextEditingController> _prisOrderControllers = [];
  List<TextEditingController> _prisRelationshipControllers = [];

  List<Map<String, dynamic>> _spersDetails = [];
  List<TextEditingController> _spersRelNameControllers = [];
  List<TextEditingController> _spersAddressControllers = [];
  List<TextEditingController> _spersContactNoControllers = [];

  List<Map<String, dynamic>> _profRecords = [];
  List<TextEditingController> _instiNameControllers = [];
  List<TextEditingController> _designationControllers = [];
  List<TextEditingController> _joinDateControllers = [];
  List<TextEditingController> _noOfYearsControllers = [];
  List<TextEditingController> _retireStatusControllers = [];

  List<Map<String, dynamic>> _missions = [];
  List<TextEditingController> _placeControllers = [];
  List<TextEditingController> _dutiesCongreControllers = [];
  List<TextEditingController> _dutiesApostControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _nameController = TextEditingController();
    _baptismNameController = TextEditingController();
    _petNameController = TextEditingController();
    _churchDobController = TextEditingController();
    _schoolDobController = TextEditingController();
    _birthPlaceController = TextEditingController();
    _baptismPlaceController = TextEditingController();
    _baptismDateController = TextEditingController();
    _confirmationDateController = TextEditingController();
    _confirmationPlaceController = TextEditingController();
    _phNoController = TextEditingController();
    _dateFirstProfessionController = TextEditingController();
    _dateFinalProfessionController = TextEditingController();
    _dateBeginServiceController = TextEditingController();
    _dateRetireController = TextEditingController();
    _positionController = TextEditingController();
    _tdateController = TextEditingController();
    _dodController = TextEditingController();
    _bloodGrpController = TextEditingController();
    _illnessHistoryController = TextEditingController();
    _surgeryHistoryController = TextEditingController();
    _longTermTreatmentController = TextEditingController();
    _presentHealthController = TextEditingController();
    _talentsController = TextEditingController();
    _mottoPrinciplesController = TextEditingController();

    // Initialize controllers for User School details
    _userSchoolClassControllers = List.generate(_userSchoolDetails.length, (index) => TextEditingController());
    _userSchoolMarksPercentageControllers = List.generate(_userSchoolDetails.length, (index) => TextEditingController());
    _userSchoolUniversityControllers = List.generate(_userSchoolDetails.length, (index) => TextEditingController());
    _userSchoolAddressControllers = List.generate(_userSchoolDetails.length, (index) => TextEditingController());
    _userSchoolYearOfPassoutControllers = List.generate(_userSchoolDetails.length, (index) => TextEditingController());

    // Initialize controllers for Plus Two details
    _plusTwoStreamControllers = List.generate(_plusTwoDetails.length, (index) => TextEditingController());
    _plusTwoMarksControllers = List.generate(_plusTwoDetails.length, (index) => TextEditingController());
    _plusTwoBoardControllers = List.generate(_plusTwoDetails.length, (index) => TextEditingController());
    _plusTwoYearOfPassoutControllers = List.generate(_plusTwoDetails.length, (index) => TextEditingController());
    _plusTwoSchoolAddressControllers = List.generate(_plusTwoDetails.length, (index) => TextEditingController());

    // Initialize controllers for UG details
    _ugradDegreeControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());
    _ugradSubjectControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());
    _ugradMarkControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());
    _ugradBoardControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());
    _ugradYearOfPassoutControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());
    _ugradColNameAddressControllers = List.generate(_ugradDetails.length, (index) => TextEditingController());

    // Initialize controllers for PG details
    _pgPostDegreeControllers = List.generate(_pgDetails.length, (index) => TextEditingController());
    _pgSubjectControllers = List.generate(_pgDetails.length, (index) => TextEditingController());
    _pgMarkControllers = List.generate(_pgDetails.length, (index) => TextEditingController());
    _pgBoardControllers = List.generate(_pgDetails.length, (index) => TextEditingController());
    _pgYearOfPassoutControllers = List.generate(_pgDetails.length, (index) => TextEditingController());
    _pgColNameAddressControllers = List.generate(_pgDetails.length, (index) => TextEditingController());

    // Initialize family data controllers
    _fatherNameControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _dobFatherControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _dodFatherControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _fatherAddressControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _fatherOccupationControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _fatherParishDioceseNowControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _fatherParishDioceseBirthControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _motherNameControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _dobMotherControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _dodMotherControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _motherOccupationControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _guardianNameControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _guardianAddressPhoneControllers = List.generate(_familyData.length, (index) => TextEditingController());
    _guardianRelationControllers = List.generate(_familyData.length, (index) => TextEditingController());

    // Initialize siblings data controllers
    _siblingNameControllers = List.generate(_siblingsData.length, (index) => TextEditingController());
    _genderControllers = List.generate(_siblingsData.length, (index) => TextEditingController());
    _dobControllers = List.generate(_siblingsData.length, (index) => TextEditingController());
    _occupationControllers = List.generate(_siblingsData.length, (index) => TextEditingController());
    _addressControllers = List.generate(_siblingsData.length, (index) => TextEditingController());
    _contactNoControllers = List.generate(_siblingsData.length, (index) => TextEditingController());

    // Initialize controllers for Pris
    _prisRelativeNameControllers = List.generate(_prisDetails.length, (index) => TextEditingController(text: _prisDetails[index]['relative_name']));
    _prisAddressControllers = List.generate(_prisDetails.length, (index) => TextEditingController(text: _prisDetails[index]['address']));
    _prisOrderControllers = List.generate(_prisDetails.length, (index) => TextEditingController(text: _prisDetails[index]['order']));
    _prisRelationshipControllers = List.generate(_prisDetails.length, (index) => TextEditingController(text: _prisDetails[index]['relationship']));

    // Initialize controllers for Spers
    _spersRelNameControllers = List.generate(_spersDetails.length, (index) => TextEditingController(text: _spersDetails[index]['rel_name']));
    _spersAddressControllers = List.generate(_spersDetails.length, (index) => TextEditingController(text: _spersDetails[index]['address']));
    _spersContactNoControllers = List.generate(_spersDetails.length, (index) => TextEditingController(text: _spersDetails[index]['contact_no']));

    // Initialize controllers for prof_record
    _instiNameControllers = List.generate(_profRecords.length, (index) => TextEditingController(text: _profRecords[index]['insti_name']));
    _designationControllers = List.generate(_profRecords.length, (index) => TextEditingController(text: _profRecords[index]['designation']));
    _joinDateControllers = List.generate(_profRecords.length, (index) => TextEditingController(text: _profRecords[index]['joindate']));
    _noOfYearsControllers = List.generate(_profRecords.length, (index) => TextEditingController(text: _profRecords[index]['no_of_years']));
    _retireStatusControllers = List.generate(_profRecords.length, (index) => TextEditingController(text: _profRecords[index]['retire_status']));

    // Initialize controllers for mission
    _placeControllers = List.generate(_missions.length, (index) => TextEditingController(text: _missions[index]['place']));
    _dutiesCongreControllers = List.generate(_missions.length, (index) => TextEditingController(text: _missions[index]['duties_congre']));
    _dutiesApostControllers = List.generate(_missions.length, (index) => TextEditingController(text: _missions[index]['duties_apost']));

    fetchMemberDetails();
  }

  // Fetch Code
  Future<void> fetchMemberDetails() async {
    final response = await http.get(Uri.parse('${API.fetch}?user_id=${widget.userId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _nameController.text = data['user_details']['official_name'] ?? '';
        _baptismNameController.text = data['user_details']['baptism_name'] ?? '';
        _petNameController.text = data['user_details']['pet_name'] ?? '';
        _churchDobController.text = data['user_details']['church_dob'] ?? '';
        _schoolDobController.text = data['user_details']['school_dob'] ?? '';
        _birthPlaceController.text = data['user_details']['birth_place'] ?? '';
        _baptismPlaceController.text = data['user_details']['baptism_place'] ?? '';
        _baptismDateController.text = data['user_details']['baptism_date'] ?? '';
        _confirmationDateController.text = data['user_details']['confirmation_date'] ?? '';
        _confirmationPlaceController.text = data['user_details']['confirmation_place'] ?? '';
        _phNoController.text = data['user_details']['ph_no'] ?? '';
        _dateFirstProfessionController.text = data['user_details']['date_first_profession'] ?? '';
        _dateFinalProfessionController.text = data['user_details']['date_final_profession'] ?? '';
        _dateBeginServiceController.text = data['user_details']['date_begin_service'] ?? '';
        _dateRetireController.text = data['user_details']['date_retire'] ?? '';
        _positionController.text = data['user_details']['position'] ?? '';
        _tdateController.text = data['user_details']['tdate'] ?? '';
        _dodController.text = data['user_details']['dod'] ?? '';

        if (data['personal_data'] is List && data['personal_data'].isNotEmpty) {
          final personalData = data['personal_data'][0];
          _bloodGrpController.text = personalData['blood_grp'] ?? '';
          _illnessHistoryController.text = personalData['illness_history'] ?? '';
          _surgeryHistoryController.text = personalData['surgery_history'] ?? '';
          _longTermTreatmentController.text = personalData['long_term_treatment'] ?? '';
          _presentHealthController.text = personalData['present_health'] ?? '';
          _talentsController.text = personalData['talents'] ?? '';
          _mottoPrinciplesController.text = personalData['motto_principles'] ?? '';
        }

        if (data['accredit'] is List && data['accredit'].isNotEmpty) {
          _accreditations = List<Map<String, dynamic>>.from(data['accredit']);
          _accreditationTitleControllers = _accreditations.map((accredit) => TextEditingController(text: accredit['title'])).toList();
          _accreditationFromControllers = _accreditations.map((accredit) => TextEditingController(text: accredit['acc_from'])).toList();
          _accreditationToControllers = _accreditations.map((accredit) => TextEditingController(text: accredit['acc_to'])).toList();
          _accreditationAtControllers = _accreditations.map((accredit) => TextEditingController(text: accredit['acc_at'])).toList();
          _accreditationPlaceControllers = _accreditations.map((accredit) => TextEditingController(text: accredit['place'])).toList();
        }

        if (data['user_school'] is List && data['user_school'].isNotEmpty) {
          _userSchoolDetails = List<Map<String, dynamic>>.from(data['user_school']);
          _userSchoolClassControllers = _userSchoolDetails.map((detail) => TextEditingController(text: detail['class'])).toList();
          _userSchoolMarksPercentageControllers = _userSchoolDetails.map((detail) => TextEditingController(text: detail['marks_percentage'])).toList();
          _userSchoolUniversityControllers = _userSchoolDetails.map((detail) => TextEditingController(text: detail['university'])).toList();
          _userSchoolAddressControllers = _userSchoolDetails.map((detail) => TextEditingController(text: detail['school_address'])).toList();
          _userSchoolYearOfPassoutControllers = _userSchoolDetails.map((detail) => TextEditingController(text: detail['year_of_passout'])).toList();
        }

        if (data['plus_two'] is List && data['plus_two'].isNotEmpty) {
          _plusTwoDetails = List<Map<String, dynamic>>.from(data['plus_two']);
          _plusTwoStreamControllers = _plusTwoDetails.map((detail) => TextEditingController(text: detail['stream/subject'])).toList();
          _plusTwoMarksControllers = _plusTwoDetails.map((detail) => TextEditingController(text: detail['marks'])).toList();
          _plusTwoBoardControllers = _plusTwoDetails.map((detail) => TextEditingController(text: detail['board_university'])).toList();
          _plusTwoYearOfPassoutControllers = _plusTwoDetails.map((detail) => TextEditingController(text: detail['year_of_passout'])).toList();
          _plusTwoSchoolAddressControllers = _plusTwoDetails.map((detail) => TextEditingController(text: detail['school_address'])).toList();
        }

        if (data['ugrad'] is List && data['ugrad'].isNotEmpty) {
          _ugradDetails = List<Map<String, dynamic>>.from(data['ugrad']);
          _ugradDegreeControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['degree'])).toList();
          _ugradSubjectControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['subject'])).toList();
          _ugradMarkControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['mark'])).toList();
          _ugradBoardControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['board_university'])).toList();
          _ugradYearOfPassoutControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['year_of_passout'])).toList();
          _ugradColNameAddressControllers = _ugradDetails.map((detail) => TextEditingController(text: detail['col_name_address'])).toList();
        }

        if (data['pg'] is List && data['pg'].isNotEmpty) {
          _pgDetails = List<Map<String, dynamic>>.from(data['pg']);
          _pgPostDegreeControllers = _pgDetails.map((detail) => TextEditingController(text: detail['post_degree'])).toList();
          _pgSubjectControllers = _pgDetails.map((detail) => TextEditingController(text: detail['subject'])).toList();
          _pgMarkControllers = _pgDetails.map((detail) => TextEditingController(text: detail['mark'])).toList();
          _pgBoardControllers = _pgDetails.map((detail) => TextEditingController(text: detail['board_university'])).toList();
          _pgYearOfPassoutControllers = _pgDetails.map((detail) => TextEditingController(text: detail['year_of_passout'])).toList();
          _pgColNameAddressControllers = _pgDetails.map((detail) => TextEditingController(text: detail['col_name_address'])).toList();
        }

        if (data['family'] is List && data['family'].isNotEmpty) {
          _familyData = List<Map<String, dynamic>>.from(data['family']);
          _fatherNameControllers = _familyData.map((detail) => TextEditingController(text: detail['father_name'])).toList();
          _dobFatherControllers = _familyData.map((detail) => TextEditingController(text: detail['dob_father'])).toList();
          _dodFatherControllers = _familyData.map((detail) => TextEditingController(text: detail['dod_father'])).toList();
          _fatherAddressControllers = _familyData.map((detail) => TextEditingController(text: detail['father_address'])).toList();
          _fatherOccupationControllers = _familyData.map((detail) => TextEditingController(text: detail['father_occupation'])).toList();
          _fatherParishDioceseNowControllers = _familyData.map((detail) => TextEditingController(text: detail['father_parish_diocese_now'])).toList();
          _fatherParishDioceseBirthControllers = _familyData.map((detail) => TextEditingController(text: detail['father_parish_diocese_birth'])).toList();
          _motherNameControllers = _familyData.map((detail) => TextEditingController(text: detail['mother_name'])).toList();
          _dobMotherControllers = _familyData.map((detail) => TextEditingController(text: detail['dob_mother'])).toList();
          _dodMotherControllers = _familyData.map((detail) => TextEditingController(text: detail['dod_mother'])).toList();
          _motherOccupationControllers = _familyData.map((detail) => TextEditingController(text: detail['mother_occupation'])).toList();
          _guardianNameControllers = _familyData.map((detail) => TextEditingController(text: detail['guardian_name'])).toList();
          _guardianAddressPhoneControllers = _familyData.map((detail) => TextEditingController(text: detail['guardian_address_phone'])).toList();
          _guardianRelationControllers = _familyData.map((detail) => TextEditingController(text: detail['guardian_relation'])).toList();
        }

        if (data['siblings'] is List && data['siblings'].isNotEmpty) {
          _siblingsData = List<Map<String, dynamic>>.from(data['siblings']);
          _siblingNameControllers = _siblingsData.map((detail) => TextEditingController(text: detail['sibling_name'])).toList();
          _genderControllers = _siblingsData.map((detail) => TextEditingController(text: detail['gender'])).toList();
          _dobControllers = _siblingsData.map((detail) => TextEditingController(text: detail['dob'])).toList();
          _occupationControllers = _siblingsData.map((detail) => TextEditingController(text: detail['occupation'])).toList();
          _addressControllers = _siblingsData.map((detail) => TextEditingController(text: detail['address'])).toList();
          _contactNoControllers = _siblingsData.map((detail) => TextEditingController(text: detail['contact_no'])).toList();
        }

        if (data['pris'] is List && data['pris'].isNotEmpty) {
          _prisDetails = List<Map<String, dynamic>>.from(data['pris']);
          _prisRelativeNameControllers = _prisDetails.map((detail) => TextEditingController(text: detail['relative_name'])).toList();
          _prisAddressControllers = _prisDetails.map((detail) => TextEditingController(text: detail['address'])).toList();
          _prisOrderControllers = _prisDetails.map((detail) => TextEditingController(text: detail['order'])).toList();
          _prisRelationshipControllers = _prisDetails.map((detail) => TextEditingController(text: detail['relationship'])).toList();
        }

        if (data['spers'] is List && data['spers'].isNotEmpty) {
          _spersDetails = List<Map<String, dynamic>>.from(data['spers']);
          _spersRelNameControllers = _spersDetails.map((detail) => TextEditingController(text: detail['rel_name'])).toList();
          _spersAddressControllers = _spersDetails.map((detail) => TextEditingController(text: detail['address'])).toList();
          _spersContactNoControllers = _spersDetails.map((detail) => TextEditingController(text: detail['contact_no'])).toList();
        }

        if (data['prof_record'] is List && data['prof_record'].isNotEmpty) {
          _profRecords = List<Map<String, dynamic>>.from(data['prof_record']);
          _instiNameControllers = _profRecords.map((record) => TextEditingController(text: record['insti_name'])).toList();
          _designationControllers = _profRecords.map((record) => TextEditingController(text: record['designation'])).toList();
          _joinDateControllers = _profRecords.map((record) => TextEditingController(text: record['joindate'])).toList();
          _noOfYearsControllers = _profRecords.map((record) => TextEditingController(text: record['no_of_years'])).toList();
          _retireStatusControllers = _profRecords.map((record) => TextEditingController(text: record['retire_status'])).toList();
        }

        if (data['mission'] is List && data['mission'].isNotEmpty) {
          _missions = List<Map<String, dynamic>>.from(data['mission']);
          _placeControllers = _missions.map((mission) => TextEditingController(text: mission['place'])).toList();
          _dutiesCongreControllers = _missions.map((mission) => TextEditingController(text: mission['duties_congre'])).toList();
          _dutiesApostControllers = _missions.map((mission) => TextEditingController(text: mission['duties_apost'])).toList();
        }

      });
    } else {
      throw Exception('Failed to load member details');
    }
  }

  // Function to show alert dialog
  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Update Code
  Future<void> updateData(BuildContext context) async {

    // Personal Details
    final Map<String, dynamic> data = {
      'Official Name': _nameController.text,
      'Baptism Name': _baptismNameController.text,
      'Pet Name': _petNameController.text,
      'Church DOB': _churchDobController.text,
      'School DOB': _schoolDobController.text,
      'Birth Place': _birthPlaceController.text,
      'Baptism Place': _baptismPlaceController.text,
      'Baptism Date': _baptismDateController.text,
      'Confirmation Date': _confirmationDateController.text,
      'Confirmation Place': _confirmationPlaceController.text,
      'Phone Number': _phNoController.text,
      'Date of First Profession': _dateFirstProfessionController.text,
      'Date of Final Profession': _dateFinalProfessionController.text,
      'Date of Begin Service': _dateBeginServiceController.text,
      'Date of Retire': _dateRetireController.text,
      'Position': _positionController.text,
      'Tdate': _tdateController.text,
      'Date of Death': _dodController.text,
      'Blood Group': _bloodGrpController.text,
      'Illness History': _illnessHistoryController.text,
      'Surgery History': _surgeryHistoryController.text,
      'Long Term Treatment': _longTermTreatmentController.text,
      'Present Health': _presentHealthController.text,
      'Talents': _talentsController.text,
      'Motto Principles': _mottoPrinciplesController.text,
    };

    // Formation Details
    for (int i = 0; i < _accreditations.length; i++) {
      data['Formation $i Title'] = _accreditationTitleControllers[i].text;
      data['Formation $i From'] = _accreditationFromControllers[i].text;
      data['Formation $i To'] = _accreditationToControllers[i].text;
      data['Formation $i At'] = _accreditationAtControllers[i].text;
      data['Formation $i Place'] = _accreditationPlaceControllers[i].text;
    }

    // Education Details

    // School
    for (int i = 0; i < _userSchoolDetails.length; i++) {
      final TextEditingController classController = _userSchoolClassControllers[i];
      final TextEditingController marksPercentageController = _userSchoolMarksPercentageControllers[i];
      final TextEditingController universityController = _userSchoolUniversityControllers[i];
      final TextEditingController addressController = _userSchoolAddressControllers[i];
      final TextEditingController yearOfPassoutController = _userSchoolYearOfPassoutControllers[i];

      data['School Class $i'] = classController.text;
      data['School Marks Percentage $i'] = marksPercentageController.text;
      data['School University $i'] = universityController.text;
      data['School Address $i'] = addressController.text;
      data['School Year of Passout $i'] = yearOfPassoutController.text;
    }

    // Plus Two
    for (int i = 0; i < _plusTwoStreamControllers.length; i++) {
      final TextEditingController streamController = _plusTwoStreamControllers[i];
      final TextEditingController marksController = _plusTwoMarksControllers[i];
      final TextEditingController boardController = _plusTwoBoardControllers[i];
      final TextEditingController yearOfPassoutController = _plusTwoYearOfPassoutControllers[i];
      final TextEditingController addressController = _plusTwoSchoolAddressControllers[i];

      data['Plus Two Stream/Subject $i'] = streamController.text;
      data['Plus Two Marks $i'] = marksController.text;
      data['Plus Two Board/University $i'] = boardController.text;
      data['Plus Two Year of Passout $i'] = yearOfPassoutController.text;
      data['Plus Two School Address $i'] = addressController.text;
    }

    // UG Details
    for (int i = 0; i < _ugradDegreeControllers.length; i++) {
      final TextEditingController degreeController = _ugradDegreeControllers[i];
      final TextEditingController subjectController = _ugradSubjectControllers[i];
      final TextEditingController markController = _ugradMarkControllers[i];
      final TextEditingController boardController = _ugradBoardControllers[i];
      final TextEditingController yearOfPassoutController = _ugradYearOfPassoutControllers[i];
      final TextEditingController colNameAddressController = _ugradColNameAddressControllers[i];

      data['UG Degree $i'] = degreeController.text;
      data['UG Subject $i'] = subjectController.text;
      data['UG Mark $i'] = markController.text;
      data['UG Board/University $i'] = boardController.text;
      data['UG Year of Passout $i'] = yearOfPassoutController.text;
      data['UG College Name & Address $i'] = colNameAddressController.text;
    }

    // PG Details
    for (int i = 0; i < _pgPostDegreeControllers.length; i++) {
      final TextEditingController postDegreeController = _pgPostDegreeControllers[i];
      final TextEditingController subjectController = _pgSubjectControllers[i];
      final TextEditingController markController = _pgMarkControllers[i];
      final TextEditingController boardController = _pgBoardControllers[i];
      final TextEditingController yearOfPassoutController = _pgYearOfPassoutControllers[i];
      final TextEditingController colNameAddressController = _pgColNameAddressControllers[i];

      data['PG Post Degree $i'] = postDegreeController.text;
      data['PG Subject $i'] = subjectController.text;
      data['PG Mark $i'] = markController.text;
      data['PG Board/University $i'] = boardController.text;
      data['PG Year of Passout $i'] = yearOfPassoutController.text;
      data['PG College Name & Address $i'] = colNameAddressController.text;
    }

    // Family Details: Father
    for (int i = 0; i < _fatherNameControllers.length; i++) {
      final TextEditingController fatherNameController = _fatherNameControllers[i];
      final TextEditingController dobFatherController = _dobFatherControllers[i];
      final TextEditingController dodFatherController = _dodFatherControllers[i];
      final TextEditingController fatherAddressController = _fatherAddressControllers[i];
      final TextEditingController fatherOccupationController = _fatherOccupationControllers[i];
      final TextEditingController fatherParishDioceseNowController = _fatherParishDioceseNowControllers[i];
      final TextEditingController fatherParishDioceseBirthController = _fatherParishDioceseBirthControllers[i];

      data['Father Name $i'] = fatherNameController.text;
      data['Father DOB $i'] = dobFatherController.text;
      data['Father DOD $i'] = dodFatherController.text;
      data['Father Address $i'] = fatherAddressController.text;
      data['Father Occupation $i'] = fatherOccupationController.text;
      data['Father Parish/Diocese Now $i'] = fatherParishDioceseNowController.text;
      data['Father Parish/Diocese at Birth $i'] = fatherParishDioceseBirthController.text;
    }

    // Family Details: Mother
    for (int i = 0; i < _motherNameControllers.length; i++) {
      final TextEditingController motherNameController = _motherNameControllers[i];
      final TextEditingController dobMotherController = _dobMotherControllers[i];
      final TextEditingController dodMotherController = _dodMotherControllers[i];
      final TextEditingController motherOccupationController = _motherOccupationControllers[i];

      data['Mother Name $i'] = motherNameController.text;
      data['Mother DOB $i'] = dobMotherController.text;
      data['Mother DOD $i'] = dodMotherController.text;
      data['Mother Occupation $i'] = motherOccupationController.text;
    }

    // Family Details: Guardian
    for (int i = 0; i < _guardianNameControllers.length; i++) {
      final TextEditingController guardianNameController = _guardianNameControllers[i];
      final TextEditingController guardianAddressPhoneController = _guardianAddressPhoneControllers[i];
      final TextEditingController guardianRelationController = _guardianRelationControllers[i];

      data['Guardian Name $i'] = guardianNameController.text;
      data['Guardian Address/Phone $i'] = guardianAddressPhoneController.text;
      data['Guardian Relation $i'] = guardianRelationController.text;
    }

    // Family Details: Siblings
    for (int i = 0; i < _siblingNameControllers.length; i++) {
      final TextEditingController siblingNameController = _siblingNameControllers[i];
      final TextEditingController genderController = _genderControllers[i];
      final TextEditingController dobController = _dobControllers[i];
      final TextEditingController occupationController = _occupationControllers[i];
      final TextEditingController addressController = _addressControllers[i];
      final TextEditingController contactNoController = _contactNoControllers[i];

      data['Sibling Name $i'] = siblingNameController.text;
      data['Sibling Gender $i'] = genderController.text;
      data['Sibling DOB $i'] = dobController.text;
      data['Sibling Occupation $i'] = occupationController.text;
      data['Sibling Address $i'] = addressController.text;
      data['Sibling Contact Number $i'] = contactNoController.text;
    }

    // Sister Details
    for (int i = 0; i < _prisRelativeNameControllers.length; i++) {
      final TextEditingController relativeNameController = _prisRelativeNameControllers[i];
      final TextEditingController addressController = _prisAddressControllers[i];
      final TextEditingController orderController = _prisOrderControllers[i];
      final TextEditingController relationshipController = _prisRelationshipControllers[i];

      data['Sister Name $i'] = relativeNameController.text;
      data['Sister Address $i'] = addressController.text;
      data['Sister Order $i'] = orderController.text;
      data['Sister Relationship $i'] = relationshipController.text;
    }

    // Priest Details
    for (int i = 0; i < _spersRelNameControllers.length; i++) {
      final TextEditingController relNameController = _spersRelNameControllers[i];
      final TextEditingController addressController = _spersAddressControllers[i];
      final TextEditingController contactNoController = _spersContactNoControllers[i];

      data['Priest Name $i'] = relNameController.text;
      data['Priest Address $i'] = addressController.text;
      data['Priest Contact No $i'] = contactNoController.text;
    }

    // Prof Records
    for (int i = 0; i < _instiNameControllers.length; i++) {
      final TextEditingController instiNameController = _instiNameControllers[i];
      final TextEditingController designationController = _designationControllers[i];
      final TextEditingController joinDateController = _joinDateControllers[i];
      final TextEditingController noOfYearsController = _noOfYearsControllers[i];
      final TextEditingController retireStatusController = _retireStatusControllers[i];

      data['Institution Name $i'] = instiNameController.text;
      data['Designation $i'] = designationController.text;
      data['Join Date $i'] = joinDateController.text;
      data['Number of Years $i'] = noOfYearsController.text;
      data['Retire Status $i'] = retireStatusController.text;
    }

    // Missions
    for (int i = 0; i < _placeControllers.length; i++) {
      final TextEditingController placeController = _placeControllers[i];
      final TextEditingController dutiesCongreController = _dutiesCongreControllers[i];
      final TextEditingController dutiesApostController = _dutiesApostControllers[i];

      data['Place $i'] = placeController.text;
      data['Duties in Congregation $i'] = dutiesCongreController.text;
      data['Duties in Apostolate $i'] = dutiesApostController.text;
    }

    // Convert data to JSON
    final jsonData = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(API.edit),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Show success message
        showAlert(context, 'Data updated successfully');
      } else {
        // Show error message
        showAlert(context, 'Failed to update data: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Show network error message
      showAlert(context, 'Failed to update data. Network Error: $error');
    }
  }

  // Dispose Code
  @override
  void dispose() {
    _disposePersonalControllers();
    _disposeAccreditationControllers();
    _disposeUserSchoolControllers();
    _disposePlusTwoControllers();
    _disposeUgradControllers();
    _disposePgControllers();
    _disposeFamilyControllers();
    _disposeSiblingsControllers();
    _disposeRelatedControllers();
    _disposeRecordMissionControllers();
    super.dispose();
  }

  void _disposePersonalControllers() {
    _tabController.dispose();
    _nameController.dispose();
    _baptismNameController.dispose();
    _petNameController.dispose();
    _churchDobController.dispose();
    _schoolDobController.dispose();
    _birthPlaceController.dispose();
    _baptismPlaceController.dispose();
    _baptismDateController.dispose();
    _confirmationDateController.dispose();
    _confirmationPlaceController.dispose();
    _phNoController.dispose();
    _dateFirstProfessionController.dispose();
    _dateFinalProfessionController.dispose();
    _dateBeginServiceController.dispose();
    _dateRetireController.dispose();
    _positionController.dispose();
    _tdateController.dispose();
    _dodController.dispose();
    _bloodGrpController.dispose();
    _illnessHistoryController.dispose();
    _surgeryHistoryController.dispose();
    _longTermTreatmentController.dispose();
    _presentHealthController.dispose();
    _talentsController.dispose();
    _mottoPrinciplesController.dispose();
  }

  void _disposeAccreditationControllers() {
    for (var controller in _accreditationTitleControllers) {
      controller.dispose();
    }
    for (var controller in _accreditationFromControllers) {
      controller.dispose();
    }
    for (var controller in _accreditationToControllers) {
      controller.dispose();
    }
    for (var controller in _accreditationAtControllers) {
      controller.dispose();
    }
    for (var controller in _accreditationPlaceControllers) {
      controller.dispose();
    }
  }

  void _disposeUserSchoolControllers() {
    for (var controller in _userSchoolClassControllers) {
      controller.dispose();
    }
    for (var controller in _userSchoolMarksPercentageControllers) {
      controller.dispose();
    }
    for (var controller in _userSchoolUniversityControllers) {
      controller.dispose();
    }
    for (var controller in _userSchoolAddressControllers) {
      controller.dispose();
    }
    for (var controller in _userSchoolYearOfPassoutControllers) {
      controller.dispose();
    }
  }

  void _disposePlusTwoControllers() {
    for (var controller in _plusTwoStreamControllers) {
      controller.dispose();
    }
    for (var controller in _plusTwoMarksControllers) {
      controller.dispose();
    }
    for (var controller in _plusTwoBoardControllers) {
      controller.dispose();
    }
    for (var controller in _plusTwoYearOfPassoutControllers) {
      controller.dispose();
    }
    for (var controller in _plusTwoSchoolAddressControllers) {
      controller.dispose();
    }
  }

  void _disposeUgradControllers() {
    for (var controller in _ugradDegreeControllers) {
      controller.dispose();
    }
    for (var controller in _ugradSubjectControllers) {
      controller.dispose();
    }
    for (var controller in _ugradMarkControllers) {
      controller.dispose();
    }
    for (var controller in _ugradBoardControllers) {
      controller.dispose();
    }
    for (var controller in _ugradYearOfPassoutControllers) {
      controller.dispose();
    }
    for (var controller in _ugradColNameAddressControllers) {
      controller.dispose();
    }
  }

  void _disposePgControllers() {
    for (var controller in _pgPostDegreeControllers) {
      controller.dispose();
    }
    for (var controller in _pgSubjectControllers) {
      controller.dispose();
    }
    for (var controller in _pgMarkControllers) {
      controller.dispose();
    }
    for (var controller in _pgBoardControllers) {
      controller.dispose();
    }
    for (var controller in _pgYearOfPassoutControllers) {
      controller.dispose();
    }
    for (var controller in _pgColNameAddressControllers) {
      controller.dispose();
    }
  }

  void _disposeFamilyControllers() {
    for (var controller in _fatherNameControllers) {
      controller.dispose();
    }
    for (var controller in _dobFatherControllers) {
      controller.dispose();
    }
    for (var controller in _dodFatherControllers) {
      controller.dispose();
    }
    for (var controller in _fatherAddressControllers) {
      controller.dispose();
    }
    for (var controller in _fatherOccupationControllers) {
      controller.dispose();
    }
    for (var controller in _fatherParishDioceseNowControllers) {
      controller.dispose();
    }
    for (var controller in _fatherParishDioceseBirthControllers) {
      controller.dispose();
    }
    for (var controller in _motherNameControllers) {
      controller.dispose();
    }
    for (var controller in _dobMotherControllers) {
      controller.dispose();
    }
    for (var controller in _dodMotherControllers) {
      controller.dispose();
    }
    for (var controller in _motherOccupationControllers) {
      controller.dispose();
    }
    for (var controller in _guardianNameControllers) {
      controller.dispose();
    }
    for (var controller in _guardianAddressPhoneControllers) {
      controller.dispose();
    }
    for (var controller in _guardianRelationControllers) {
      controller.dispose();
    }
  }

  void _disposeSiblingsControllers() {
    for (var controller in _siblingNameControllers) {
      controller.dispose();
    }
    for (var controller in _genderControllers) {
      controller.dispose();
    }
    for (var controller in _dobControllers) {
      controller.dispose();
    }
    for (var controller in _occupationControllers) {
      controller.dispose();
    }
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    for (var controller in _contactNoControllers) {
      controller.dispose();
    }
  }

  void _disposeRelatedControllers() {
    for (var controller in _prisRelativeNameControllers) {
      controller.dispose();
    }
    for (var controller in _prisAddressControllers) {
      controller.dispose();
    }
    for (var controller in _prisOrderControllers) {
      controller.dispose();
    }
    for (var controller in _prisRelationshipControllers) {
      controller.dispose();
    }
    for (var controller in _spersRelNameControllers) {
      controller.dispose();
    }
    for (var controller in _spersAddressControllers) {
      controller.dispose();
    }
    for (var controller in _spersContactNoControllers) {
      controller.dispose();
    }
  }

  void _disposeRecordMissionControllers() {
    for (var controller in _instiNameControllers) {
      controller.dispose();
    }
    for (var controller in _designationControllers) {
      controller.dispose();
    }
    for (var controller in _joinDateControllers) {
      controller.dispose();
    }
    for (var controller in _noOfYearsControllers) {
      controller.dispose();
    }
    for (var controller in _retireStatusControllers) {
      controller.dispose();
    }
    for (var controller in _placeControllers) {
      controller.dispose();
    }
    for (var controller in _dutiesCongreControllers) {
      controller.dispose();
    }
    for (var controller in _dutiesApostControllers) {
      controller.dispose();
    }
  }

  void addProfRecord() {
    setState(() {
      _profRecords.add({});
      _instiNameControllers.add(TextEditingController());
      _designationControllers.add(TextEditingController());
      _joinDateControllers.add(TextEditingController());
      _noOfYearsControllers.add(TextEditingController());
      _retireStatusControllers.add(TextEditingController());
    });
  }

  void removeProfRecord(int index) {
    setState(() {
      _profRecords.removeAt(index);
      _instiNameControllers.removeAt(index);
      _designationControllers.removeAt(index);
      _joinDateControllers.removeAt(index);
      _noOfYearsControllers.removeAt(index);
      _retireStatusControllers.removeAt(index);
    });
  }

  void addMission() {
    setState(() {
      _missions.add({});
      _placeControllers.add(TextEditingController());
      _dutiesCongreControllers.add(TextEditingController());
      _dutiesApostControllers.add(TextEditingController());
    });
  }

  void removeMission(int index) {
    setState(() {
      _missions.removeAt(index);
      _placeControllers.removeAt(index);
      _dutiesCongreControllers.removeAt(index);
      _dutiesApostControllers.removeAt(index);
    });
  }

  void addPrisDetail() {
    setState(() {
      _prisDetails.add({});
      _prisRelativeNameControllers.add(TextEditingController());
      _prisAddressControllers.add(TextEditingController());
      _prisOrderControllers.add(TextEditingController());
      _prisRelationshipControllers.add(TextEditingController());
    });
  }

  void removePrisDetail(int index) {
    setState(() {
      _prisDetails.removeAt(index);
      _prisRelativeNameControllers.removeAt(index);
      _prisAddressControllers.removeAt(index);
      _prisOrderControllers.removeAt(index);
      _prisRelationshipControllers.removeAt(index);
    });
  }

  void addSpersDetail() {
    setState(() {
      _spersDetails.add({});
      _spersRelNameControllers.add(TextEditingController());
      _spersAddressControllers.add(TextEditingController());
      _spersContactNoControllers.add(TextEditingController());
    });
  }

  void removeSpersDetail(int index) {
    setState(() {
      _spersDetails.removeAt(index);
      _spersRelNameControllers.removeAt(index);
      _spersAddressControllers.removeAt(index);
      _spersContactNoControllers.removeAt(index);
    });
  }

  void addUserSchoolDetail() {
    setState(() {
      _userSchoolDetails.add({});
      _userSchoolClassControllers.add(TextEditingController());
      _userSchoolMarksPercentageControllers.add(TextEditingController());
      _userSchoolUniversityControllers.add(TextEditingController());
      _userSchoolAddressControllers.add(TextEditingController());
      _userSchoolYearOfPassoutControllers.add(TextEditingController());
    });
  }

  void removeUserSchoolDetail(int index) {
    setState(() {
      _userSchoolDetails.removeAt(index);
      _userSchoolClassControllers.removeAt(index);
      _userSchoolMarksPercentageControllers.removeAt(index);
      _userSchoolUniversityControllers.removeAt(index);
      _userSchoolAddressControllers.removeAt(index);
      _userSchoolYearOfPassoutControllers.removeAt(index);
    });
  }

  void addPlusTwoDetail() {
    setState(() {
      _plusTwoStreamControllers.add(TextEditingController());
      _plusTwoMarksControllers.add(TextEditingController());
      _plusTwoBoardControllers.add(TextEditingController());
      _plusTwoYearOfPassoutControllers.add(TextEditingController());
      _plusTwoSchoolAddressControllers.add(TextEditingController());
    });
  }

  void removePlusTwoDetail(int index) {
    setState(() {
      _plusTwoStreamControllers.removeAt(index);
      _plusTwoMarksControllers.removeAt(index);
      _plusTwoBoardControllers.removeAt(index);
      _plusTwoYearOfPassoutControllers.removeAt(index);
      _plusTwoSchoolAddressControllers.removeAt(index);
    });
  }

  void addUgDetail() {
    setState(() {
      _ugradDegreeControllers.add(TextEditingController());
      _ugradSubjectControllers.add(TextEditingController());
      _ugradMarkControllers.add(TextEditingController());
      _ugradBoardControllers.add(TextEditingController());
      _ugradYearOfPassoutControllers.add(TextEditingController());
      _ugradColNameAddressControllers.add(TextEditingController());
    });
  }

  void removeUgDetail(int index) {
    setState(() {
      _ugradDegreeControllers.removeAt(index);
      _ugradSubjectControllers.removeAt(index);
      _ugradMarkControllers.removeAt(index);
      _ugradBoardControllers.removeAt(index);
      _ugradYearOfPassoutControllers.removeAt(index);
      _ugradColNameAddressControllers.removeAt(index);
    });
  }

  void addPgDetail() {
    setState(() {
      _pgPostDegreeControllers.add(TextEditingController());
      _pgSubjectControllers.add(TextEditingController());
      _pgMarkControllers.add(TextEditingController());
      _pgBoardControllers.add(TextEditingController());
      _pgYearOfPassoutControllers.add(TextEditingController());
      _pgColNameAddressControllers.add(TextEditingController());
    });
  }

  void removePgDetail(int index) {
    setState(() {
      _pgPostDegreeControllers.removeAt(index);
      _pgSubjectControllers.removeAt(index);
      _pgMarkControllers.removeAt(index);
      _pgBoardControllers.removeAt(index);
      _pgYearOfPassoutControllers.removeAt(index);
      _pgColNameAddressControllers.removeAt(index);
    });
  }

  void addAccreditation() {
    setState(() {
      _accreditationTitleControllers.insert(0, TextEditingController());
      _accreditationFromControllers.insert(0, TextEditingController());
      _accreditationToControllers.insert(0, TextEditingController());
      _accreditationAtControllers.insert(0, TextEditingController());
      _accreditationPlaceControllers.insert(0, TextEditingController());

      _accreditations.insert(0, {
        'title': '',
        'acc_from': '',
        'acc_to': '',
        'acc_at': '',
        'place': '',
        'temp': true, // Mark as temporary
      });
    });
  }

  void cancelAccreditationAtIndex(int index) {
    setState(() {
      _accreditationTitleControllers.removeAt(index);
      _accreditationFromControllers.removeAt(index);
      _accreditationToControllers.removeAt(index);
      _accreditationAtControllers.removeAt(index);
      _accreditationPlaceControllers.removeAt(index);
      _accreditations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Member'),
            ElevatedButton(
              onPressed: () => updateData(context),
              child: const Text('Update All'),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              isScrollable: true, // This makes the tabs scrollable
              tabs: const [
                Tab(text: 'Personal Details'),
                Tab(text: 'Formation Details'),
                Tab(text: 'Education Details'),
                Tab(text: 'Family Details'),
                Tab(text: 'Related Personalities'),
                Tab(text: 'Records and Mission'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Personal Data Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Official Name Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Official Name',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(labelText: 'Official Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the official name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Baptism Information Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Baptism Information',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: _baptismNameController,
                                    decoration: const InputDecoration(labelText: 'Baptism Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the baptism name';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _baptismPlaceController,
                                    decoration: const InputDecoration(labelText: 'Baptism Place'),
                                  ),
                                  TextFormField(
                                    controller: _baptismDateController,
                                    decoration: const InputDecoration(labelText: 'Baptism Date'),
                                  ),
                                  TextFormField(
                                    controller: _confirmationDateController,
                                    decoration: const InputDecoration(labelText: 'Confirmation Date'),
                                  ),
                                  TextFormField(
                                    controller: _confirmationPlaceController,
                                    decoration: const InputDecoration(labelText: 'Confirmation Place'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Personal Information Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Personal Information',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: _petNameController,
                                    decoration: const InputDecoration(labelText: 'Pet Name'),
                                  ),
                                  TextFormField(
                                    controller: _churchDobController,
                                    decoration: const InputDecoration(labelText: 'Church DOB'),
                                  ),
                                  TextFormField(
                                    controller: _schoolDobController,
                                    decoration: const InputDecoration(labelText: 'School DOB'),
                                  ),
                                  TextFormField(
                                    controller: _birthPlaceController,
                                    decoration: const InputDecoration(labelText: 'Birth Place'),
                                  ),
                                  TextFormField(
                                    controller: _phNoController,
                                    decoration: const InputDecoration(labelText: 'Phone Number'),
                                  ),
                                  TextFormField(
                                    controller: _dateFirstProfessionController,
                                    decoration: const InputDecoration(labelText: 'Date of First Profession'),
                                  ),
                                  TextFormField(
                                    controller: _dateFinalProfessionController,
                                    decoration: const InputDecoration(labelText: 'Date of Final Profession'),
                                  ),
                                  TextFormField(
                                    controller: _dateBeginServiceController,
                                    decoration: const InputDecoration(labelText: 'Date of Begin Service'),
                                  ),
                                  TextFormField(
                                    controller: _dateRetireController,
                                    decoration: const InputDecoration(labelText: 'Date of Retire'),
                                  ),
                                  TextFormField(
                                    controller: _positionController,
                                    decoration: const InputDecoration(labelText: 'Position'),
                                  ),
                                  TextFormField(
                                    controller: _tdateController,
                                    decoration: const InputDecoration(labelText: 'Tdate'),
                                  ),
                                  TextFormField(
                                    controller: _dodController,
                                    decoration: const InputDecoration(labelText: 'Date of Death'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Health Information Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Health Information',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: _bloodGrpController,
                                    decoration: const InputDecoration(labelText: 'Blood Group'),
                                  ),
                                  TextFormField(
                                    controller: _illnessHistoryController,
                                    decoration: const InputDecoration(labelText: 'Illness History'),
                                  ),
                                  TextFormField(
                                    controller: _surgeryHistoryController,
                                    decoration: const InputDecoration(labelText: 'Surgery History'),
                                  ),
                                  TextFormField(
                                    controller: _longTermTreatmentController,
                                    decoration: const InputDecoration(labelText: 'Long Term Treatment'),
                                  ),
                                  TextFormField(
                                    controller: _presentHealthController,
                                    decoration: const InputDecoration(labelText: 'Present Health'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Talents and Principles Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Talents and Principles',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  TextFormField(
                                    controller: _talentsController,
                                    decoration: const InputDecoration(labelText: 'Talents'),
                                  ),
                                  TextFormField(
                                    controller: _mottoPrinciplesController,
                                    decoration: const InputDecoration(labelText: 'Motto Principles'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),

                  // Formation Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: addUserSchoolDetail,
                                label: const Text('Add'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ..._accreditations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final accreditation = entry.value;
                            final isTemporary = accreditation['temp'] ?? false;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _accreditationTitleControllers[index],
                                          decoration: const InputDecoration(labelText: 'Title'),
                                        ),
                                        TextFormField(
                                          controller: _accreditationFromControllers[index],
                                          decoration: const InputDecoration(labelText: 'From'),
                                        ),
                                        TextFormField(
                                          controller: _accreditationToControllers[index],
                                          decoration: const InputDecoration(labelText: 'To'),
                                        ),
                                        TextFormField(
                                          controller: _accreditationAtControllers[index],
                                          decoration: const InputDecoration(labelText: 'At'),
                                        ),
                                        TextFormField(
                                          controller: _accreditationPlaceControllers[index],
                                          decoration: const InputDecoration(labelText: 'Place'),
                                        ),
                                        const SizedBox(height: 16.0),
                                      ],
                                    ),
                                  ),
                                  if (isTemporary) // Render cancel button only for temporary accreditations
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          cancelAccreditationAtIndex(index);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Education Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        // User School Details Section
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'User School Details',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: addUserSchoolDetail,
                            label: const Text('Add'),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                        ),
                          const SizedBox(height: 16.0),
                            if (_userSchoolDetails.isEmpty)
                              const Text('NIL'),
                            ..._userSchoolDetails.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final TextEditingController classController = _userSchoolClassControllers[index];
                              final TextEditingController marksPercentageController = _userSchoolMarksPercentageControllers[index];
                              final TextEditingController universityController = _userSchoolUniversityControllers[index];
                              final TextEditingController addressController = _userSchoolAddressControllers[index];
                              final TextEditingController yearOfPassoutController = _userSchoolYearOfPassoutControllers[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: classController,
                                        decoration: const InputDecoration(labelText: 'Class'),
                                      ),
                                      TextFormField(
                                        controller: marksPercentageController,
                                        decoration: const InputDecoration(labelText: 'Marks Percentage'),
                                      ),
                                      TextFormField(
                                        controller: universityController,
                                        decoration: const InputDecoration(labelText: 'University'),
                                      ),
                                      TextFormField(
                                        controller: addressController,
                                        decoration: const InputDecoration(labelText: 'School Address'),
                                      ),
                                      TextFormField(
                                        controller: yearOfPassoutController,
                                        decoration: const InputDecoration(labelText: 'Year of Passout'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => removeUserSchoolDetail(index),
                                        icon: const Icon(Icons.remove),
                                        label: const Text('Remove'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),

                            // Plus Two Details Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Plus Two Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: addUserSchoolDetail,
                                label: const Text('Add'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                            if (_plusTwoStreamControllers.isEmpty)
                              const Text('NIL'),
                            ..._plusTwoStreamControllers.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final TextEditingController streamController = _plusTwoStreamControllers[index];
                              final TextEditingController marksController = _plusTwoMarksControllers[index];
                              final TextEditingController boardController = _plusTwoBoardControllers[index];
                              final TextEditingController yearOfPassoutController = _plusTwoYearOfPassoutControllers[index];
                              final TextEditingController addressController = _plusTwoSchoolAddressControllers[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: streamController,
                                        decoration: const InputDecoration(labelText: 'Stream/Subject'),
                                      ),
                                      TextFormField(
                                        controller: marksController,
                                        decoration: const InputDecoration(labelText: 'Marks'),
                                      ),
                                      TextFormField(
                                        controller: boardController,
                                        decoration: const InputDecoration(labelText: 'Board/University'),
                                      ),
                                      TextFormField(
                                        controller: yearOfPassoutController,
                                        decoration: const InputDecoration(labelText: 'Year of Passout'),
                                      ),
                                      TextFormField(
                                        controller: addressController,
                                        decoration: const InputDecoration(labelText: 'School Address'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => removeUserSchoolDetail(index),
                                        icon: const Icon(Icons.remove),
                                        label: const Text('Remove'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                            // UG Details Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'UG Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: addUserSchoolDetail,
                                label: const Text('Add'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          if (_ugradDegreeControllers.isEmpty)
                            const Text('NIL'),
                          ..._ugradDegreeControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController degreeController = _ugradDegreeControllers[index];
                            final TextEditingController subjectController = _ugradSubjectControllers[index];
                            final TextEditingController markController = _ugradMarkControllers[index];
                            final TextEditingController boardController = _ugradBoardControllers[index];
                            final TextEditingController yearOfPassoutController = _ugradYearOfPassoutControllers[index];
                            final TextEditingController colNameAddressController = _ugradColNameAddressControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: degreeController,
                                      decoration: const InputDecoration(labelText: 'Degree'),
                                    ),
                                    TextFormField(
                                      controller: subjectController,
                                      decoration: const InputDecoration(labelText: 'Subject'),
                                    ),
                                    TextFormField(
                                      controller: markController,
                                      decoration: const InputDecoration(labelText: 'Mark'),
                                    ),
                                    TextFormField(
                                      controller: boardController,
                                      decoration: const InputDecoration(labelText: 'Board/University'),
                                    ),
                                    TextFormField(
                                      controller: yearOfPassoutController,
                                      decoration: const InputDecoration(labelText: 'Year of Passout'),
                                    ),
                                    TextFormField(
                                      controller: colNameAddressController,
                                      decoration: const InputDecoration(labelText: 'College Name & Address'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => removeUserSchoolDetail(index),
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Remove'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                            // PG Details Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'PG Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: addUserSchoolDetail,
                                label: const Text('Add'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          if (_pgPostDegreeControllers.isEmpty)
                            const Text('NIL'),
                          ..._pgPostDegreeControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController postDegreeController = _pgPostDegreeControllers[index];
                            final TextEditingController subjectController = _pgSubjectControllers[index];
                            final TextEditingController markController = _pgMarkControllers[index];
                            final TextEditingController boardController = _pgBoardControllers[index];
                            final TextEditingController yearOfPassoutController = _pgYearOfPassoutControllers[index];
                            final TextEditingController colNameAddressController = _pgColNameAddressControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: postDegreeController,
                                      decoration: const InputDecoration(labelText: 'Post Degree'),
                                    ),
                                    TextFormField(
                                      controller: subjectController,
                                      decoration: const InputDecoration(labelText: 'Subject'),
                                    ),
                                    TextFormField(
                                      controller: markController,
                                      decoration: const InputDecoration(labelText: 'Mark'),
                                    ),
                                    TextFormField(
                                      controller: boardController,
                                      decoration: const InputDecoration(labelText: 'Board/University'),
                                    ),
                                    TextFormField(
                                      controller: yearOfPassoutController,
                                      decoration: const InputDecoration(labelText: 'Year of Passout'),
                                    ),
                                    TextFormField(
                                      controller: colNameAddressController,
                                      decoration: const InputDecoration(labelText: 'College Name & Address'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => removeUserSchoolDetail(index),
                                      icon: const Icon(Icons.remove),
                                      label: const Text('Remove'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Family Details Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Father Details
                          if (_fatherNameControllers.isEmpty || _fatherNameControllers[0].text.isEmpty)
                            Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Father Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _fatherNameControllers.isNotEmpty ? _fatherNameControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _dobFatherControllers.isNotEmpty ? _dobFatherControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: _dodFatherControllers.isNotEmpty ? _dodFatherControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Date of Death'),
                                    ),
                                    TextFormField(
                                      controller: _fatherAddressControllers.isNotEmpty ? _fatherAddressControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Address'),
                                    ),
                                    TextFormField(
                                      controller: _fatherOccupationControllers.isNotEmpty ? _fatherOccupationControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                    TextFormField(
                                      controller: _fatherParishDioceseNowControllers.isNotEmpty ? _fatherParishDioceseNowControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Parish/Diocese Now'),
                                    ),
                                    TextFormField(
                                      controller: _fatherParishDioceseBirthControllers.isNotEmpty ? _fatherParishDioceseBirthControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Parish/Diocese at Birth'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ..._fatherNameControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController fatherNameController = _fatherNameControllers[index];
                            final TextEditingController dobFatherController = _dobFatherControllers[index];
                            final TextEditingController dodFatherController = _dodFatherControllers[index];
                            final TextEditingController fatherAddressController = _fatherAddressControllers[index];
                            final TextEditingController fatherOccupationController = _fatherOccupationControllers[index];
                            final TextEditingController fatherParishDioceseNowController = _fatherParishDioceseNowControllers[index];
                            final TextEditingController fatherParishDioceseBirthController = _fatherParishDioceseBirthControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Father Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: fatherNameController,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: dobFatherController,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: dodFatherController,
                                      decoration: const InputDecoration(labelText: 'Date of Death'),
                                    ),
                                    TextFormField(
                                      controller: fatherAddressController,
                                      decoration: const InputDecoration(labelText: 'Address'),
                                    ),
                                    TextFormField(
                                      controller: fatherOccupationController,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                    TextFormField(
                                      controller: fatherParishDioceseNowController,
                                      decoration: const InputDecoration(labelText: 'Parish/Diocese Now'),
                                    ),
                                    TextFormField(
                                      controller: fatherParishDioceseBirthController,
                                      decoration: const InputDecoration(labelText: 'Parish/Diocese at Birth'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Mother Details
                          if (_motherNameControllers.isEmpty || _motherNameControllers[0].text.isEmpty)
                            Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Mother Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _motherNameControllers.isNotEmpty ? _motherNameControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _dobMotherControllers.isNotEmpty ? _dobMotherControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: _dodMotherControllers.isNotEmpty ? _dodMotherControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Date of Death'),
                                    ),
                                    TextFormField(
                                      controller: _motherOccupationControllers.isNotEmpty ? _motherOccupationControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ..._motherNameControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController motherNameController = _motherNameControllers[index];
                            final TextEditingController dobMotherController = _dobMotherControllers[index];
                            final TextEditingController dodMotherController = _dodMotherControllers[index];
                            final TextEditingController motherOccupationController = _motherOccupationControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Mother Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: motherNameController,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: dobMotherController,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: dodMotherController,
                                      decoration: const InputDecoration(labelText: 'Date of Death'),
                                    ),
                                    TextFormField(
                                      controller: motherOccupationController,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Guardian Details
                          if (_guardianNameControllers.isEmpty || _guardianNameControllers[0].text.isEmpty)
                            Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Guardian Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _guardianNameControllers.isNotEmpty ? _guardianNameControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _guardianAddressPhoneControllers.isNotEmpty ? _guardianAddressPhoneControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Address and Phone'),
                                    ),
                                    TextFormField(
                                      controller: _guardianRelationControllers.isNotEmpty ? _guardianRelationControllers[0] : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Relation',
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ..._guardianNameControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController guardianNameController = _guardianNameControllers[index];
                            final TextEditingController guardianAddressPhoneController = _guardianAddressPhoneControllers[index];
                            final TextEditingController guardianRelationController = _guardianRelationControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Guardian ${index + 1} Details',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: guardianNameController,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: guardianAddressPhoneController,
                                      decoration: const InputDecoration(labelText: 'Address and Phone'),
                                    ),
                                    TextFormField(
                                      controller: guardianRelationController,
                                      decoration: const InputDecoration(labelText: 'Relation'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Siblings Details
                          if (_siblingNameControllers.isEmpty || _siblingNameControllers[0].text.isEmpty)
                            Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Siblings Details',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _siblingNameControllers.isNotEmpty ? _siblingNameControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: _genderControllers.isNotEmpty ? _genderControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Gender'),
                                    ),
                                    TextFormField(
                                      controller: _dobControllers.isNotEmpty ? _dobControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: _occupationControllers.isNotEmpty ? _occupationControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                    TextFormField(
                                      controller: _addressControllers.isNotEmpty ? _addressControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Address'),
                                    ),
                                    TextFormField(
                                      controller: _contactNoControllers.isNotEmpty ? _contactNoControllers[0] : null,
                                      decoration: const InputDecoration(labelText: 'Contact Number'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ..._siblingNameControllers.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final TextEditingController siblingNameController = _siblingNameControllers[index];
                            final TextEditingController genderController = _genderControllers[index];
                            final TextEditingController dobController = _dobControllers[index];
                            final TextEditingController occupationController = _occupationControllers[index];
                            final TextEditingController addressController = _addressControllers[index];
                            final TextEditingController contactNoController = _contactNoControllers[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sibling ${index + 1} Details',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: siblingNameController,
                                      decoration: const InputDecoration(labelText: 'Name'),
                                    ),
                                    TextFormField(
                                      controller: genderController,
                                      decoration: const InputDecoration(labelText: 'Gender'),
                                    ),
                                    TextFormField(
                                      controller: dobController,
                                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                                    ),
                                    TextFormField(
                                      controller: occupationController,
                                      decoration: const InputDecoration(labelText: 'Occupation'),
                                    ),
                                    TextFormField(
                                      controller: addressController,
                                      decoration: const InputDecoration(labelText: 'Address'),
                                    ),
                                    TextFormField(
                                      controller: contactNoController,
                                      decoration: const InputDecoration(labelText: 'Contact Number'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Related Personalities Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Pris Details ExpansionTile
                          ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sister Details'),
                                const SizedBox(width: 16.0),
                                Text('${_prisDetails.length}'),
                                ElevatedButton.icon(
                                  onPressed: addUserSchoolDetail,
                                  label: const Text('Add'),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            children: [
                              ..._prisDetails.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final TextEditingController relativeNameController = _prisRelativeNameControllers[index];
                                final TextEditingController addressController = _prisAddressControllers[index];
                                final TextEditingController orderController = _prisOrderControllers[index];
                                final TextEditingController relationshipController = _prisRelationshipControllers[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: relativeNameController,
                                          decoration: const InputDecoration(labelText: 'Name'),
                                        ),
                                        TextFormField(
                                          controller: addressController,
                                          decoration: const InputDecoration(labelText: 'Address'),
                                        ),
                                        TextFormField(
                                          controller: orderController,
                                          decoration: const InputDecoration(labelText: 'Order'),
                                        ),
                                        TextFormField(
                                          controller: relationshipController,
                                          decoration: const InputDecoration(labelText: 'Relationship'),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () => removeUserSchoolDetail(index),
                                              icon: const Icon(Icons.remove),
                                              label: const Text('Remove'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),

                          // Spers Details ExpansionTile
                          ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Priest Details'),
                                const SizedBox(width: 16.0),
                                Text('${_spersDetails.length}'),
                                ElevatedButton.icon(
                                  onPressed: addUserSchoolDetail,
                                  label: const Text('Add'),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            children: [
                              ..._spersDetails.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final TextEditingController relNameController = _spersRelNameControllers[index];
                                final TextEditingController addressController = _spersAddressControllers[index];
                                final TextEditingController contactNoController = _spersContactNoControllers[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: relNameController,
                                          decoration: const InputDecoration(labelText: 'Rel Name'),
                                        ),
                                        TextFormField(
                                          controller: addressController,
                                          decoration: const InputDecoration(labelText: 'Address'),
                                        ),
                                        TextFormField(
                                          controller: contactNoController,
                                          decoration: const InputDecoration(labelText: 'Contact No'),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () => removeUserSchoolDetail(index),
                                              icon: const Icon(Icons.remove),
                                              label: const Text('Remove'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Records and Mission Tab Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Prof Records
                          ExpansionTile(
                            title: Row(
                              children: [
                                const Text('Prof Records'),
                                const Spacer(),
                                Text('${_profRecords.length}'),
                                const SizedBox(width: 16.0),
                                ElevatedButton.icon(
                                  onPressed: addUserSchoolDetail,
                                  label: const Text('Add'),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            children: [
                              ..._profRecords.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final TextEditingController instiNameController = _instiNameControllers[index];
                                final TextEditingController designationController = _designationControllers[index];
                                final TextEditingController joinDateController = _joinDateControllers[index];
                                final TextEditingController noOfYearsController = _noOfYearsControllers[index];
                                final TextEditingController retireStatusController = _retireStatusControllers[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Prof Record ${index + 1}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        TextFormField(
                                          controller: instiNameController,
                                          decoration: const InputDecoration(labelText: 'Institution Name'),
                                        ),
                                        TextFormField(
                                          controller: designationController,
                                          decoration: const InputDecoration(labelText: 'Designation'),
                                        ),
                                        TextFormField(
                                          controller: joinDateController,
                                          decoration: const InputDecoration(labelText: 'Join Date'),
                                        ),
                                        TextFormField(
                                          controller: noOfYearsController,
                                          decoration: const InputDecoration(labelText: 'Number of Years'),
                                        ),
                                        TextFormField(
                                          controller: retireStatusController,
                                          decoration: const InputDecoration(labelText: 'Retire Status'),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Button to remove a Prof Record entry
                                            ElevatedButton.icon(
                                              onPressed: () => removeUserSchoolDetail(index),
                                              icon: const Icon(Icons.remove),
                                              label: const Text('Remove'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),

                          // Missions
                          ExpansionTile(
                            title: Row(
                              children: [
                                const Text('Missions'),
                                const Spacer(),
                                Text('${_missions.length}'), // Count of Missions
                                const SizedBox(width: 16.0),
                                ElevatedButton.icon(
                                  onPressed: addUserSchoolDetail,
                                  label: const Text('Add'),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            children: [
                              ..._missions.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final TextEditingController placeController = _placeControllers[index];
                                final TextEditingController dutiesCongreController = _dutiesCongreControllers[index];
                                final TextEditingController dutiesApostController = _dutiesApostControllers[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mission ${index + 1}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        TextFormField(
                                          controller: placeController,
                                          decoration: const InputDecoration(labelText: 'Place'),
                                        ),
                                        TextFormField(
                                          controller: dutiesCongreController,
                                          decoration: const InputDecoration(labelText: 'Duties in Congregation'),
                                        ),
                                        TextFormField(
                                          controller: dutiesApostController,
                                          decoration: const InputDecoration(labelText: 'Duties in Apostolate'),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Button to remove a Mission entry
                                            ElevatedButton.icon(
                                              onPressed: () => removeUserSchoolDetail(index),
                                              icon: const Icon(Icons.remove),
                                              label: const Text('Remove'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}