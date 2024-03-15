class CollegeData {
  static Map<String, List<String>> collegeData = {
    // 'Andhra Pradesh': ['College A', 'College B', 'College C', 'College D', 'College E', 'College F', 'College G', 'College H', 'College I', 'College J'],
    // 'Arunachal Pradesh': ['College X', 'College Y', 'College Z', 'College P', 'College Q', 'College R', 'College S', 'College T', 'College U', 'College V'],
    // 'Assam': ['College M', 'College N', 'College O', 'College K', 'College L', 'College W', 'College AA', 'College BB', 'College CC', 'College DD'],
    // 'Bihar': ['College DD', 'College EE', 'College FF', 'College GG', 'College HH', 'College II', 'College JJ', 'College KK', 'College LL', 'College MM'],
    // 'Chhattisgarh': ['College NN', 'College OO', 'College PP', 'College QQ', 'College RR', 'College SS', 'College TT', 'College UU', 'College VV', 'College WW'],
    'Karnataka': [
      'Presideny University, Bangalore',
      // 'Indian Institute of Science (IISc), Bangalore',
      // 'National Institute of Fashion Technology (NIFT), Bangalore',
      // 'National Institute of Technology Karnataka (NITK), Surathkal',
      // 'Bangalore Medical College and Research Institute (BMCRI), Bangalore',
      // 'Manipal Institute of Technology (MIT), Manipal',
      // 'RV College of Engineering (RVCE), Bangalore',
      // 'BMS College of Engineering, Bangalore',
      // 'Christ University, Bangalore',
      // 'Jawaharlal Nehru Centre for Advanced Scientific Research (JNCASR), Bangalore',
      // 'PES University, Bangalore'
    ],
    // Add more states and colleges as needed
  };

  static List<String> getCollegesByState(String selectedState) {
    return collegeData[selectedState] ?? [];
  }
}
