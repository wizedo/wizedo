import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UserController extends GetxController {
  var userDetails = <String, dynamic>{}.obs; // Using a Map to store user details

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    var box = await Hive.openBox('userdetails');
    Map<String, dynamic> storedDetails = Map<String, dynamic>.from(box.get('userDetails', defaultValue: {}));

    userDetails.value = storedDetails;
  }

  void setUserDetails(Map<String, dynamic> details) {
    userDetails.value = details;
    updateUserDetails();
  }

  // Getter methods to access individual user details
  String get avatar => userDetails['avatar'] ?? '';
  String get id => userDetails['id'] ?? '';
  String get firstname => userDetails['firstname'] ?? '';
  String get lastname => userDetails['lastname'] ?? '';
  String get country => userDetails['country'] ?? '';
  String get college => userDetails['college'] ?? '';
  String get course => userDetails['course'] ?? '';
  String get courseStartYear => userDetails['courseStartYear'] ?? '';
  bool get userDetailsfilled => userDetails['userDetailsfilled'] ?? false;
  DateTime get lastUpdated => userDetails['lastUpdated'] ?? DateTime.now();
  String get emailVerified => userDetails['emailVerified'] ?? 'no';

  // Setter methods to update individual user details
  void setAvatar(String value) {
    userDetails['avatar'] = value;
    updateUserDetails();
  }

  void setId(String value) {
    userDetails['id'] = value;
    updateUserDetails();
  }

  void setFirstname(String value) {
    userDetails['firstname'] = value;
    updateUserDetails();
  }

  void setLastname(String value) {
    userDetails['lastname'] = value;
    updateUserDetails();
  }

  void setCountry(String value) {
    userDetails['country'] = value;
    updateUserDetails();
  }

  void setCollege(String value) {
    userDetails['college'] = value;
    updateUserDetails();
  }

  void setCourse(String value) {
    userDetails['course'] = value;
    updateUserDetails();
  }

  void setCourseStartYear(String value) {
    userDetails['courseStartYear'] = value;
    updateUserDetails();
  }

  void setUserDetailsfilled(bool value) {
    userDetails['userDetailsfilled'] = value;
    updateUserDetails();
  }

  void setLastUpdated(DateTime value) {
    userDetails['lastUpdated'] = value;
    updateUserDetails();
  }

  void setEmailVerified(String value) {
    userDetails['emailVerified'] = value;
    updateUserDetails();
  }

  // Method to update user details in Hive
  void updateUserDetails() async {
    var box = await Hive.openBox('userdetails');
    await box.put('userDetails', userDetails.value);
  }
}
