class CollegeData {
  static Map<String, List<String>> collegeData = {
    'Andhra Pradesh': ['College A', 'College B', 'College C'],
    'Arunachal Pradesh': ['College X', 'College Y', 'College Z'],
    // Add other states and their respective colleges here
  };

  static List<String> getCollegesByState(String selectedState) {
    return collegeData[selectedState] ?? [];
  }
}
