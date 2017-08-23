import 'dart:math';

import 'matrix.dart';
import 'matrix_operations.dart';
import 'package:color_mixer/data/T.dart';
import 'color.dart';
import 'LLSS.dart';
import 'dart:core';

Color mixColors(List<Color> colors, List<num> ratios) {
  Matrix T = new Matrix(3, 36, 0);
  T.setAll(t_data);

  List convertedColors = [];
  Matrix temp = new Matrix(3, 1);
  for (var x = 0; x < colors.length; x++) {
    temp.setAll(colors[x].hexToInt());
    convertedColors.add(LLSS(T, temp));
  }

  Matrix result = multiplyColorGraphs(convertedColors, ratios);

  var numRepresentation = convertFromReflectance(result);
  String ans = '#';
  ans += toRadixString(numRepresentation.mat[0][0]);
  ans += toRadixString(numRepresentation.mat[1][0]);
  ans += toRadixString(numRepresentation.mat[2][0]);

  return new Color(ans);
}

String toRadixString(num n) {

  List conversionChart = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D', 'E', 'F', 'x'];

  String ans = '';

  num x = n;
  //todo figure out if neg numbers are fine, or if a deeper issue exists.
  if (x < 0) {
    ans = '00';
  }
  while (x > 0) {
    ans = conversionChart[(x % 16).round().toInt()] + ans;
    x = (x / 16).floor();
  }

  return ans;
}

Matrix convertToRGBIntValues(Matrix rgb) {

//      =ROUND(255 * IF(D1<0.0031308, 12.92*D1, 1.055*D1^(1/2.4)-0.055), 0)

  Matrix out = new Matrix(rgb.getSize()[0], rgb.getSize()[1]);

  for (var x = 0; x < 3; x++) {
    if (rgb.mat[x][0] < 0.0031308) {
      out.mat[x][0] = rgb.mat[x][0] * 12.92;
    }
    else {
      out.mat[x][0] = 1.055 * pow(rgb.mat[x][0], (1/2.4)) - 0.055;
    }

    out.mat[x][0] = (255 * out.mat[x][0]).round();
  }

  return out;
}

Matrix convertFromReflectance(Matrix m) {
  Matrix T = new Matrix(3,36);
  T.setAll(t_data);

  return convertToRGBIntValues(multiplyMatrices(T, m));
}

/// Takes a list of [Matrix] that contain color reflectance graphs,
/// then computes the geometric mean of these graphs
Matrix multiplyColorGraphs(List<Matrix> colors, [List<num> weights = null]) {//Matrix a, Matrix b) {
  try {
    if (weights != null && colors.length != weights.length) {
      throw new Exception("weights and colors lengths do not match");
    }
    if (colors.length < 2) {
      throw new Exception("Not enough reflectance graphs provided");
    }
  }
  catch(Exception, stackTrace) {
    print(Exception);
    print(stackTrace);
  }

  if (weights == null) {
    weights = new List<num>();
    for (var x = 0; x < colors.length; x++) {
      weights.add(1);
    }
  }

  Matrix result = new Matrix(36,1);


  for (var i = 0; i < colors[0].getSize()[0]; i++) {
    num t = 1;
    for (var x = 0; x < colors.length; x++) {
      t *= pow(colors[x].mat[i][0], weights[x]);
    }
    result.mat[i][0] = pow(t, (1/colors.length));
  }

  return result;
}