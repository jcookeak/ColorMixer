import 'color.dart';
import 'dart:math';
import 'color_operations.dart';

class Mixer {

  Color target;
  List<Color> myColors;

  Mixer([this.myColors, this.target]);

  List<Color> findColor([target]) {
    if (target != null) {
      this.target = target;
    }

    if (this.target == null) {
      print("error: no target color set");
    }
  }

  Color closestColor(Color color) {
    List<num> ratio = color.colorPercentRatio();
    Color closest = null;
    //List<num> temp_ratio = closest.colorRatio();
    for (Color x in myColors) {
      //safeguard
      if (closest == null) {print("setting color: " + x.hex); closest = x; }
      else {
        print("x: " + x.hex);
        num d1 = pythagoras(color.colorPercentRatio(), closest.colorPercentRatio());
        num d2 = pythagoras(color.colorPercentRatio(), x.colorPercentRatio());
        print([d1, d2, (d2 < d1)]);
        if (d2 < d1) {
          closest = x;
          print(closest.hex);
        }
      }
    }
    return closest;
  }

  Color closestTint(Color color) {
    List<num> ratio = color.colorRelativeRatio();
  }


  num pythagoras(List<num> r1, List<num> r2) {
    return sqrt(pow((r2[0] - r1[0]),2) + pow((r2[1] - r1[1]),2) + pow((r2[2] - r1[2]),2));
  }

  Color colorDiff(Color base, Color c) {
    List<num> base_vals = base.colorPercentRatio();
    List<num> c_vals = c.colorPercentRatio();

    List<num> temp = [];
    for (num x in c_vals) {
      temp.add(x/2);
    }

    List<num> diff_vals = [
      (base_vals[0] - temp[0]),
    (base_vals[1] - temp[1]),
    (base_vals[2] - temp[2])];

    print("diff values " + diff_vals.toString());
    List<int> out = [];
    for (num x in diff_vals) {
      num t = ((x*2) * 255).round();
      //guards
      if (t < 0) {t = 0;}
      if (t > 255) {t = 255;}
      out.add(int.parse(t.toString()));
    }

    print("out: " + out.toString());

    String color_hex = toHex(out);
    print("color_hex: " + color_hex);

    return new Color(color_hex);
  }

//  Color colorDiff_1(Color c1, Color c2) {
//    List<num> c1_vals = c1.hexToInt();
//    List<num> c2_vals = c2.hexToInt();
//
//    List<int> diff_vals = [(c1_vals[0] - c2_vals[0]).abs(),
//                            (c1_vals[1] - c2_vals[1]).abs(),
//                            (c1_vals[2] - c2_vals[2]).abs()];
//
//    String color_hex = toHex(diff_vals);
//
//    return new Color(color_hex);
//  }

  Color mixColors(colors, weights) {
    return mixColors(colors, weights);
  }

//  Color mixColors(Color c1, Color c2, [num weight=0.5]) {
//    List<num> c1_vals = c1.hexToInt();
//    List<num> c2_vals = c2.hexToInt();
//
//    List<int> mixed_vals = [
//      (c1_vals[0] * weight).floor() + (c2_vals[0] * (1 - weight)).floor(),
//      (c1_vals[1] * weight).floor() + (c2_vals[1] * (1 - weight)).floor(),
//      (c1_vals[2] * weight).floor() + (c2_vals[2] * (1 - weight)).floor()];
//    String hex = toHex(mixed_vals);
//    return new Color(hex);
//  }

  String toHex(List<int> v) {
    String r = v[0].toRadixString(16);
    String g = v[1].toRadixString(16);
    String b = v[2].toRadixString(16);

    String output = "#";
    for (String x in [r,g,b]) {
      if (x.length == 1) {
        x = "0" + x;
      }
      output = output + x;
    }
    return output;
  }

  bool isEqual(List<num> c1, List<num> c2, [num margin = 30]) {
    List<num> bound = new List<num>();

    //populate lower and upper bounds
    //margin of error default of adding/subbing 30 from each color
    for (num x in c1) {
      num temp = x + margin;
      if (temp > 255) {temp = 255;} //guard
      if (temp < 0) {temp = 0;} //guard
      bound.add(temp);
    }

    num bound_val = pythagoras(c1, bound);
    num c2_val = pythagoras(c1, c2);

    print("bound: " + bound_val.toString());
    print("c2 val:" + c2_val.toString());

    if (c2_val <= bound_val) {
      return true;
    }
    return false;
  }
}