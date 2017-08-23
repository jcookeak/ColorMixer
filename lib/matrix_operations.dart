import 'dart:math';

import 'matrix.dart';

//multiply two matrices together
Matrix multiplyMatrices(Matrix a, Matrix b) {
  try {
    if (a.getSize()[1] != b.getSize()[0]) {
      throw new Exception('matricies of wrong size');
    }
  } catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }

  Matrix result = new Matrix(a.getSize()[0], b.getSize()[1]);

  //matrices iterators for row and column of matrices A, B, and result
  num ar = 0;
  num rr = 0;

  //multiple each row of A by the columns of B

  for (var row = 0; row < result.getSize()[0]; row++) {
    for (var col = 0; col < result.getSize()[1]; col++) {
//      print("row: " + row.toString() + " col: " + col.toString());
      result.set(row, col, dotProduct(a.getRow(row), b.getColumn(col)));
    }
  }

  return result;
}

//multiply first matrix by inverse of second matrix
Matrix divideMatrices(Matrix a, Matrix b) {
  return multiplyMatrices(a, invertMatrix(b));
}

Matrix msub(Matrix a, Matrix b) {
  try {
    if (a.getSize()[0] != b.getSize()[0]) {
      throw new Exception('matricies of different sizes');
    }
    if (a.getSize()[1] != b.getSize()[1]) {
      throw new Exception('matricies of different sizes');
    }
  } catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }
  Matrix c = new Matrix(a.getSize()[0], a.getSize()[1]);
  for (var i = 0; i < a.getSize()[0]; i++) {
    for (var j = 0; j < a.getSize()[1]; j++) {
      c.mat[i][j] = a.mat[i][j] - b.mat[i][j];
    }
  }

  return c;
}

Matrix addMatrices(Matrix a, Matrix b) {
  try {
    if (a.getSize()[0] != b.getSize()[0]) {
      throw new Exception('madd: matricies of different sizes');
    }
    if (a.getSize()[1] != b.getSize()[1]) {
      throw new Exception('madd: matricies of different sizes');
    }
  } catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }
  Matrix c = new Matrix(a.getSize()[0], a.getSize()[1]);
  for (var i = 0; i < a.getSize()[0]; i++) {
    for (var j = 0; j < a.getSize()[1]; j++) {
      c.mat[i][j] = a.mat[i][j] + b.mat[i][j];
    }
  }

  return c;
}

num dotProduct(List a, List b) {

  try {
    if (a.length != b.length) {
      throw new Exception("dotProduct: lengths of two lists don't match");
    }

    if (a[0] is !num) {
      throw new Exception("dotProduct: first element in List a is not a num");
    }

    if (b[0] is !num) {
      throw new Exception("dotProduct: first element in List b is not a num");
    }
  } catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }

  num ans = 0;
  num i = 0;

  while (i < a.length) {
    ans += a[i] * b[i];
    i++;
  }

  return ans;
}

//scale a matrix using division
Matrix divideMatrixBy(Matrix m, num n) {

  Matrix ans = new Matrix(m.getSize()[0], m.getSize()[1]);

  for (var x = 0; x < m.row; x++) {
    for (var y = 0; y < m.col; y++) {
      ans.mat[x][y] = m.mat[x][y] / n;
    }
  }

  return ans;
}

/// scale a [Matrix] using division by a number.
Matrix multiplyMatrixBy(Matrix m, num) {

  Matrix ans = new Matrix(m.getSize()[0], m.getSize()[1]);

  int x = 0;
  while (x < m.row) {
    int y = 0;
    while (y < m.col) {
      ans.mat[x][y] = m.mat[x][y] * num;
      y++;
    }
    x++;
  }
  return ans;
}

//transpose a matrix
Matrix transposeMatrix(Matrix m) {
  Matrix out = new Matrix(m.col, m.row);

  for (var i = 0; i < m.row; i++) {
    for (var j = 0; j < m.col; j++) {
      out.mat[j][i] = m.mat[i][j];
    }
  }
  return out;
}


//todo look at block inversion https://en.wikipedia.org/wiki/Invertible_matrix#Inversion_of_4_.C3.97_4_matrices


//invert matrix
//based on C code found at http://www.sanfoundry.com/c-program-find-inverse-matrix/

/// Breaks down [Matrix] into smaller chunks using blockwise inversion method.
Matrix invertMatrix(Matrix m) {

  num LEAF_SIZE = 8;

  //check if partition needed

  if (m.getSize()[0] > LEAF_SIZE) {
    //break into blocks

    num base_block_size = (m.getSize()[0]/2).floor().toInt();
    num leftover_block_size = (m.getSize()[0] - base_block_size).toInt();


    Matrix E = m.getBlock(base_block_size, base_block_size);
    Matrix G = m.getBlock(leftover_block_size, base_block_size, base_block_size, 0);
    Matrix F = m.getBlock(base_block_size, leftover_block_size, 0, base_block_size);
    Matrix H = m.getBlock(leftover_block_size, leftover_block_size, base_block_size, base_block_size);

    //Invert block E
    /*
  * [ E^-1 F]
  * [ G    H]
  * */

    Matrix E_i = invertMatrix(E);

    //mult F by inverse of E, negate result
    /*
  * [ E^-1 -E^-1F]
  * [ G    H     ]
  * */

    Matrix temp = multiplyMatrices(E_i, F);
    F = multiplyMatrixBy(temp, -1);

    // take G and mult by the previous step (add to H the result)
    //this is now S
    /*
  * [ E^-1 -E^-1F  ]
  * [ G    H-GE^1F ]
  * */

    temp = multiplyMatrices(G, F);
    H = addMatrices(H, temp);

    /*
  * [ E^-1   -E^-1F ]
  * [ GE^-1  S^-1   ]
  * */

    Matrix S = invertMatrix(H);
    G = multiplyMatrices(G, E_i);

    /*
  * [ E^-1         -E^-1F ]
  * [ -S^-1GE^-1    S^-1 ]
  * */

    temp = multiplyMatrices(S, G); //mult s and g
    G = multiplyMatrixBy(temp, -1); //negate


    /*
  * [ E^-1+E^-1FS^-1GE^-1   -E^-1F ]
  * [ -S^-1GE^-1            S^-1   ]
  * */

    temp = multiplyMatrices(F, G);
    E_i = addMatrices(E_i, temp);


    //finally multiply -E^-1F by S^-1
    /*
  * [ E^-1+E^-1FS^-1GE^-1   -E^-1FS^-1 ]
  * [ -S^-1GE^-1            S^-1   ]
  * */

    F = multiplyMatrices(F, S);

    //combine into result
    Matrix ans = new Matrix(m.getSize()[0], m.getSize()[1]);

    ans.setBlock(E_i);
    ans.setBlock(G, base_block_size, 0);
    ans.setBlock(F, 0, base_block_size);
    ans.setBlock(S, base_block_size, base_block_size);

    return ans;
  }
  else { //block is of sufficiently small size
    return baseInvertMatrix(m);
  }
}

/// Base operation to invert small [Matrix].
Matrix baseInvertMatrix(Matrix m) {
  var k = m.getSize()[0];
  num d = calculateDeterminate(m, k);

  try{
    if (d == 0) {
      throw new Exception("mInverse: Inverse of Matrix not possible");
    }
    if( m.getSize()[0] != m.getSize()[1]) {
      throw new Exception("mInverse: Matrix is not square");
    }
  }
  catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }

//  print("Determinate: " + d.toString());
  return Cofactor(m, k);

}

calculateDeterminate(Matrix a, var k) {
  var s = 1;
  var det = 0;
  Matrix b = new Matrix(k, k);

  if (k == 1) {
    return a.mat[0][0];
  }
  else {
    det = 0;
    for (var c = 0; c < k; c++) {
      var m = 0;
      var n = 0;
      for(var i = 0; i < k; i++) {
        for(var j = 0; j < k; j++) {
          b.set(i, j, 0);
          if (i != 0 && j != c) {
            b.mat[m][n] = a.mat[i][j];
            if (n < (k - 2)) {
              n++;
            }
            else {
              n = 0;
              m++;
            }
          }
        }
      }
      det = det + s * (a.mat[0][c] * calculateDeterminate(b, k - 1));
      s = -1 * s;
    }
  }
  return det;
}

Matrix Cofactor(Matrix a, f) {
  Matrix b = new Matrix(f, f);
  Matrix fac = new Matrix(f, f);

  for (var q = 0; q < f; q++) {
    for (var p = 0; p < f; p++) {
      var m = 0;
      var n = 0;

      for (var i = 0; i < f; i++) {
        for (var j = 0; j < f; j++) {
          if ( i != q && j != p) {
            b.mat[m][n] = a.mat[i][j];

            if (n < (f - 2)) {
              n++;
            }
            else {
              n = 0;
              m++;
            }
          }
        }
      }
      fac.mat[q][p] = pow(-1, q + p) * calculateDeterminate(b, f-1);
    }
  }
  return Transpose(a, fac, f);
}

//todo figure out if needed
///Transpose a Matrix
Matrix Transpose(Matrix num, Matrix fac, r) {
  Matrix b = new Matrix(r, r);
  Matrix inverse = new Matrix(r, r);

  for (var i = 0; i < r; i++) {
    for (var j = 0; j < r; j++) {
      b.mat[i][j] = fac.mat[j][i];
    }
  }
  var d = calculateDeterminate(num, r);
  for (var i = 0; i < r; i++) {
    for (var j = 0; j < r; j++) {
      inverse.mat[i][j] = b.mat[i][j] / d;
    }
  }
  return inverse;
}

///checks if
bool trueForAll(Matrix m, var z) {
  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] != z) {
        return false;
      }
    }
  }
  return true;
}

bool trueForAny(Matrix m, var z) {
  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] == z) {
        return true;
      }
    }
  }
  return false;
}

bool greaterForAny(Matrix m, z) {
  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] > z) {
        return true;
      }
    }
  }
  return false;
}
//todo check when needed
/// If true for case, sets [Matrix] element to true, else sets to zero.
Matrix setMatrixIfGreaterEqual(Matrix m, z) {

  Matrix ans = new Matrix(m.getSize()[0], m.getSize()[1]);

  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] >= z) {
        ans.mat[x][y] = true;
      }
      else {
        ans.mat[x][y] = 0;
      }
    }
  }
  return ans;
}

Matrix setMatrixIfLessEqual(Matrix m, z) {

  Matrix ans = new Matrix(m.getSize()[0], m.getSize()[1]);

  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] <= z) {
        ans.mat[x][y] = true;
      }
      else {
        ans.mat[x][y] = 0;
      }
    }
  }

  return ans;
}

bool trueForAnyLess(Matrix m, z) {
  var i = m.getSize()[0];
  var j = m.getSize()[1];

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] < z) {
        return true;
      }
    }
  }
  return false;
}

bool trueForAllLess(Matrix m, z) {
  for (var i = 0; i < m.getSize()[0]; i++) {
    for (var j = 0; j < m.getSize()[1]; j++) {
      if (m.mat[i][j] >= z) {
        return false;
      }
    }
  }
  return true;
}

Matrix setWhereTrue(Matrix a, Matrix b, var val) {

  try{
    if (a.getSize()[0] != b.getSize()[0]) {
      throw new Exception("setWhereTrue: Matrices not of same size");
    }
    if (a.getSize()[1] != b.getSize()[1]) {
      throw new Exception("setWhereTrue: Matrices not of same size");
    }
  }
  catch(exception, stackTrace) {
    print(exception);
    print(stackTrace);
  }


  Matrix ans = new Matrix(a.getSize()[0], a.getSize()[1]);

  for (var i = 0; i < ans.getSize()[0]; i++) {
    for (var j = 0; j < ans.getSize()[1]; j++) {
      if (b.mat[i][j] is bool && b.mat[i][j]) {
        ans.mat[i][j] = val;
      }
      else {
        ans.mat[i][j] = a.mat[i][j];
      }

    }
  }

  return ans;
}

/// Returns list of flattened indices where value is not equal to zero.
List findMatrixIndices(Matrix m) {
  List output = [];
  var i = m.getSize()[0];
  var j = m.getSize()[1];
  var count = 0;

  for (var x = 0; x < i; x++) {
    for (var y = 0; y < j; y++) {
      if (m.mat[x][y] != 0) {
        output.add(count);
      }
      count++;
    }
  }

  return output;
}

Matrix verticalConcatenateMatrices(Matrix a, Matrix b) {
//  try {
//    if (a.getSize()[0] != b.getSize()[0]) {
//      throw new Exception('mVerticalCat: matrices of wrong size');
//    }
//  } catch(exception, stackTrace) {
//    print(exception);
//    print(stackTrace);
//  }

  Matrix c = new Matrix(a.getSize()[0] + b.getSize()[0],
      max(a.getSize()[1], b.getSize()[1]), 0);

  //todo optimize with for(j...) first
  //go through first matrix
  for (var i = 0; i < a.getSize()[0]; i++) {
    for (var j = 0; j < a.getSize()[1]; j++) {
      c.mat[i][j] = a.mat[i][j];
    }
  }
  for (var i = 0; i < b.getSize()[0]; i++) {
    for (var j = 0; j < b.getSize()[1]; j++) {
      c.mat[i + a.getSize()[0]][j] = b.mat[i][j];
    }
  }

  return c;
}

Matrix horizontalConcatenateMatrices(Matrix a, Matrix b) {
//  print(a.getSize().toString());
//  print(b.getSize().toString());

//  try {
//    if (a.getSize()[1] != b.getSize()[1]) {
//      throw new Exception('mHorizontalCat: matricies of wrong size');
//    }
//  } catch(exception, stackTrace) {
//    print(exception);
//    print(stackTrace);
//  }

  num row = max(a.getSize()[0], b.getSize()[0]);

  Matrix c = new Matrix(row,
      a.getSize()[1] + b.getSize()[1], 0);

//  print("c: " + c.getSize().toString());

  for (var i = 0; i < row; i++) {
    for (var j = 0; i < a.getSize()[0] && j < a.getSize()[1]; j++) {
      //print("i: " + i.toString() + " j: " + j.toString());
      c.mat[i][j] = a.mat[i][j];
    }
    for (var y = 0; i < b.getSize()[0] && y < b.getSize()[1]; y++) {
      //print("i: " + i.toString() + " y: " + y.toString());
      c.mat[i][y + a.getSize()[1]] = b.mat[i][y];
    }
  }
  return c;
}

//todo write function
/// Returns the diagonal of a [Matrix]
Matrix getMatixDiagonal(Matrix m) {

}

/// Creates a [Matrix] with the diagonal filled with the values of a flat Matrix.
/// The rest of the [Matrix] is set to zeros.
Matrix createDiagonalMatrix(Matrix m) {
  Matrix ans = new Matrix(m.getSize()[0], m.getSize()[0]);

  for (var x = 0; x < m.getSize()[0]; x++) {
    ans.mat[x][x] = m.mat[x][0];
  }

  return ans;
}

Matrix leftMatrixDivide(Matrix a, Matrix b) {
  return multiplyMatrices(b, invertMatrix(a));
}

