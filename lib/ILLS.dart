import 'matrix.dart';
import 'matrix_operations.dart';
import 'dart:math';


Matrix ILLS(Matrix B11, Matrix B12, Matrix sRGB) {

  print('B11:');
  print(B11);
  print('B12');
  print(B12);

  Matrix ones = new Matrix(36, 1, 1);
  Matrix rho = divideMatrixBy(ones, 2);
  var rhomin = 0.00001;

  //handle special case for white
  if (trueForAll(sRGB, 255)) {
    rho = ones;
    return rho;
  }

  //handle special case for black
  if (trueForAll(sRGB, 0)) {
    rho = multiplyMatrixBy(ones, rhomin);
    return rho;
  }

  print("preparing to convert sRGB to rgb");

  //target linear rgb values
  sRGB = divideMatrixBy(sRGB, 255);
  Matrix rgb = new Matrix(3, 1, 0);

  for (var i = 1; i < 3; i++) {
    if (sRGB.mat[i][0] < 0.04045) {
      rgb.mat[i][0] = rgb.mat[i][0] / 12.92;
    }
    else {
      rgb.mat[i][0] = pow(((sRGB.mat[i][0] + 0.055) / 1.055), 2.4);
    }
  }

  print("B12: " + B12.getSize().toString() + " rgb: " + rgb.getSize().toString());

  Matrix R = multiplyMatrices(B12, rgb);
  print('R');
  print(R);
  
  //get all refl to range 0-1

  print("working:");

  var MAXIT = 10;
  var count = 0;
  while(((greaterForAny(rho, 1) || trueForAnyLess(rho, rhomin)) && (count <= MAXIT)) || count == 0) {

    print(count);

    print("Create K1");
    //create K1 matrix for fixed refl at 1
    Matrix fixed_upper_logical = setMatrixIfGreaterEqual(rho, 1);
    List fixed_upper = findMatrixIndices(fixed_upper_logical);
    print("fixed upper \n" + fixed_upper.toString());
    var num_upper = fixed_upper.length;
    Matrix K1 = new Matrix(num_upper, 36, 0);
    for (var i = 0; i < num_upper; i++) {
      K1.mat[i][fixed_upper[i]] = 1;
    }

    print("Create K0");
    //create K0 matrix for fixed refl at rhomin
    Matrix fixed_lower_logical = setMatrixIfLessEqual(rho, rhomin);
    List fixed_lower = findMatrixIndices(fixed_lower_logical);
    print("fixed lower \n" + fixed_lower.toString());
    var num_lower = fixed_lower.length;
    Matrix K0 = new Matrix(num_lower, 36);
    for (var i = 0; i < num_lower; i++) {
      K0.mat[i][fixed_lower[i]] = 1;
    }

    print("lower logical");
    print(fixed_lower_logical.toString());
    print("upper logical");
    print(fixed_upper_logical.toString());

    print("setup linear system");
    //setup linear system
    print("create K");
    Matrix K = verticalConcatenateMatrices(K1, K0);

    Matrix C = divideMatrices(multiplyMatrices(B11, transposeMatrix(K)),
        multiplyMatrices(multiplyMatrices(K, B11), transposeMatrix(K)));

//
//        print("matrix 1");
//        Matrix B11_KT = mmult(B11, mTranspose(K));
//        print("matrix 2");
//        Matrix B11_K = mmult(K, B11);
//        print("matrix 3");
//        Matrix B11_K_multKT = mmult(B11_K, mTranspose(K));
//    print("matrix 4");
//    Matrix Inv = blockwiseInvert(B11_K_multKT);
//    //        Matrix Inv = mInverse(B11_K_multKT);
//    print("matrix 5");
//        Matrix C = mmult(B11_KT, Inv);
//    // mmult(B11, mTranspose(K));
    print("create rho");
    rho = msub(R, multiplyMatrices(C,
        msub(multiplyMatrices(K, R),
            verticalConcatenateMatrices(new Matrix(num_upper, 1, 1),
                new Matrix(num_lower, 1, rhomin)))));

    print(rho.toString());
    rho = setWhereTrue(rho, fixed_upper_logical, 1);
    print("rho after fixed upper");
    print(rho.toString());
    rho = setWhereTrue(rho, fixed_lower_logical, rhomin);
    print("rho after fixed lower");
    print(rho.toString());


    print("iterate");
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