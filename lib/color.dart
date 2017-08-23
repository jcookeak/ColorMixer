class Color {
  String name;
  String hex;
  String brand;
  String id;

  //name, brand, id are all optional (will be null if not defined
  Color(this.hex, [this.name, this.brand, this.id]);


  setName(String name) {
    this.name = name;
  }

  setColor(String hex) {
    this.hex = hex;
  }

  setBrand(String brand) {
    this.brand = brand;
  }

  setId(String id) {
    this.id = id;
  }

  String textColor() {
    List<num> numVals = hexToInt(); // r,g,b
    if((numVals[0] * 0.299 + numVals[1] * 0.587 + numVals[2] * 0.144) > 186) {
      return "#000000";
    }
    else {
      return "#FFFFFF";
    }
  }

  List<num> hexToInt() {
    num r = int.parse(this.hex.substring(1,3), radix: 16);
    num g = int.parse(this.hex.substring(3,5), radix: 16);
    num b = int.parse(this.hex.substring(5,7), radix: 16);
    return [r,g,b];
  }

  List<num> colorPercentRatio() { //percent of max color
    List<num> vals = hexToInt();
    return [vals[0]/255, vals[1]/255, vals[2]/255];
  }

  List<num> colorRelativeRatio() { //ratio compared to other colors
    List<num> vals = hexToInt();
    num sum = vals[0] + vals[1] + vals[2];
    List<num> c = [vals[0]/sum, vals[1]/sum, vals[2]/sum];
    return c;
  }
}