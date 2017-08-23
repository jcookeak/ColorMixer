import 'matrix.dart';
import 'matrix_operations.dart';
import 'dart:math';
import 'package:color_mixer/data/D.dart';
import 'dart:core';


Matrix LLSS(Matrix T, Matrix sRGB) {


  Matrix ones = new Matrix(36, 1, 1);
  Matrix rho = divideMatrixBy(ones, 2);
  var rhomin = 0.00001;

  //handle special case for black
  if (trueForAll(sRGB, 0)) {
    rho = multiplyMatrixBy(ones, rhomin);
    return rho;
  }

  // preparing to convert sRGB to rgb

  //target linear rgb values

  sRGB = divideMatrixBy(sRGB, 255);
  Matrix rgb = new Matrix(3, 1, 0);

  for (var i = 0; i < 3; i++) {
    if (sRGB.mat[i][0] < 0.04045) {
      rgb.mat[i][0] = sRGB.mat[i][0] / 12.92;
    }
    else {
      rgb.mat[i][0] = pow(((sRGB.mat[i][0] + 0.055) / 1.055), 2.4);
    }
  }

  Matrix D = new Matrix(36, 36);
  D.setAll(D_DATA);

  //initialize
  Matrix z = new Matrix(36, 1, 0);
  Matrix lambda = new Matrix(3,1,0);
  num MAXIT = 30; //100
  num ftol = 1.0e-8;//1.0e-8; //solution tolerance
  num deltatol = 1.0e-8;//1.0e-8; //change in opereration point tolerance

  var count = 0;
  while(count <= MAXIT) {

    Matrix r = new Matrix(36, 1);
    for (var x = 0; x < z.getSize()[0]; x++) {
      r.mat[x][0] = pow(E, z.mat[x][0]);
    }

    // creates 36x1 matrix
    Matrix v = multiplyMatrices(multiplyMatrices(multiplyMatrixBy(createDiagonalMatrix(r),-1), transposeMatrix(T)),lambda);
    Matrix m1 = multiplyMatrices(multiplyMatrixBy(T, -1), r);
    Matrix m2 = multiplyMatrices(multiplyMatrixBy(T, -1), createDiagonalMatrix(r));

    Matrix F = verticalConcatenateMatrices(addMatrices(multiplyMatrices(D, z),v), addMatrices(m1, rgb));
    Matrix J = verticalConcatenateMatrices(
        horizontalConcatenateMatrices(addMatrices(D, createDiagonalMatrix(v)), transposeMatrix(m2)),
        horizontalConcatenateMatrices(m2, new Matrix(3, 1))
    );

    Matrix delta = transposeMatrix(leftMatrixDivide(J, transposeMatrix(multiplyMatrixBy(F, -1))));

    Matrix delta_a = new Matrix(36, 1);
    for (var x = 0; x < 36; x++) {
      delta_a.mat[x][0] = delta.mat[x][0];
    }
    z = addMatrices(z, delta_a);
    Matrix delta_b = new Matrix(3, 1);
    for (var x = 0; x < 3; x++) {
      delta_b.mat[x][0] = delta.mat[x+36][0];
    }

    lambda = addMatrices(lambda, delta_b);
    if (trueForAllLess(F.abs(), ftol)) {
      if (trueForAllLess(delta.abs(), deltatol)) {
//        print("Solution found " + count.toString() + " iterations");
        for (var x = 0; x < z.getSize()[0]; x++) {
          rho.mat[x][0] = pow(E, z.mat[x][0]);
        }
        return rho;
      }
    }
    count++;
  }

  try {
    if (count >= MAXIT) {
      throw new Exception('No Solution Found');
    }
  } catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }

  return rho;
}