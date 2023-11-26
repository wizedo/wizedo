class CollegeData {
  static Map<String, List<String>> collegeData = {
    'Andhra Pradesh': ['College A', 'College B', 'College C', 'College D', 'College E', 'College F', 'College G', 'College H', 'College I', 'College J'],
    'Arunachal Pradesh': ['College X', 'College Y', 'College Z', 'College P', 'College Q', 'College R', 'College S', 'College T', 'College U', 'College V'],
    // Add other states and their respective colleges here
    'Assam': ['College M', 'College N', 'College O', 'College K', 'College L', 'College W', 'College AA', 'College BB', 'College CC', 'College DD'],
    'Bihar': ['College DD', 'College EE', 'College FF', 'College GG', 'College HH', 'College II', 'College JJ', 'College KK', 'College LL', 'College MM'],
    'Chhattisgarh': ['College NN', 'College OO', 'College PP', 'College QQ', 'College RR', 'College SS', 'College TT', 'College UU', 'College VV', 'College WW'],
    // Add more states and colleges as needed
  };

  static List<String> getCollegesByState(String selectedState) {
    return collegeData[selectedState] ?? [];
  }
}
