import 'package:test/test.dart';
import 'package:color_mixer/matrix_operations.dart';
import 'package:color_mixer/matrix.dart';

void main() {

  group("Basics", () {
    test("check size of matrix", () {
      Matrix temp = new Matrix(3, 3, 0);
      expect(temp.getSize(), [3,3]);
    });

    test("Set", () {
      Matrix temp = new Matrix(3, 3, 0);
      temp.set(0, 0, 1);
      expect(temp.getRow(0), [1,0,0]);
      expect(temp.getColumn(0), [1,0,0]);
      expect(temp.getRow(1), [0,0,0]);
      expect(temp.getColumn(1), [0,0,0]);
    });

    test("abs", () {
      Matrix a = new Matrix(2, 2);
      a.setAll([1,-2,-3,4]);

      Matrix ans = new Matrix(2, 2);
      ans.setAll([1,2,3,4]);

      expect(a.abs().toString(), ans.toString());
    });
  });

  group("operations", () {
    test("Basic Multiplication of two Matrices", (){
      Matrix a = new Matrix(2, 2);
      a.set(0, 0, 1);
      a.set(1, 0, 2);
      a.set(0, 1, 3);
      a.set(1, 1, 4);
      Matrix b = new Matrix(2, 2);
      b.set(0, 0, 1);
      b.set(1, 0, 2);
      b.set(0, 1, 3);
      b.set(1, 1, 4);

      Matrix e = new Matrix(2, 2);
      e.set(0, 0, 7);
      e.set(1, 0, 10);
      e.set(0, 1, 15);
      e.set(1, 1, 22);
      expect(multiplyMatrices(a, b).toString(), e.toString());
    });

    test("Divide matrix by 2", () {
      Matrix a = new Matrix(2, 2);
      a.set(0, 0, 1);
      a.set(1, 0, 2);
      a.set(0, 1, 3);
      a.set(1, 1, 4);

      Matrix e = new Matrix(2, 2);
      e.set(0, 0, 0.5);
      e.set(1, 0, 1.0);
      e.set(0, 1, 1.5);
      e.set(1, 1, 2.0);

      expect(divideMatrixBy(a, 2).toString(), e.toString());
    });

    test("multBy", () {
      Matrix a = new Matrix(2, 2);
      a.setAll([1,2,3,4]);

      Matrix ans = new Matrix(2, 2);
      ans.setAll([-1,-2,-3,-4]);

      expect(multiplyMatrixBy(a, -1).toString(), ans.toString());
    });

    test("mldivide", () {
      Matrix a = new Matrix(3, 3); //magic 3
      a.setAll([8,1,6,3,5,7,4,9,2]);

      Matrix b = new Matrix(1, 3);
      b.setAll([15,15,15]);

      Matrix t = leftMatrixDivide(a, b);
      t.round();

      Matrix ans = new Matrix(1,3);
      ans.setAll([1,1,1]);

      expect(t.toString(), ans.toString());
    });

    test("madd", () {
      Matrix a = new Matrix(2, 2);
      a.setAll([1,2,3,4]);

      Matrix b = new Matrix(2, 2);
      b.setAll([-1,-2,-3,-4]);

      Matrix ans = new Matrix(2, 2);

      expect(addMatrices(a, b).toString(), ans.toString());
    });

  });

  group("Matrix Comparisons", () {
    Matrix a = new Matrix(3, 1);
    a.setAll([1,2,3]);

    Matrix b = new Matrix(4, 4);
    b.setAll([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);

    test("mAnyGreater Single Column", () {
      bool ans = true;

      expect(greaterForAny(a, 2), ans);
    });

    test("mAnyGreater Square", () {
      bool ans = true;

      expect(greaterForAny(b, 15), ans);
    });

    test("mAllLess flat - true", () {
      expect(trueForAllLess(a, 4), true);
    });

    test("mAllLess square - true", () {
      expect(trueForAllLess(b, 17), true);
    });

    test("mAllLess square - false", () {
      expect(trueForAllLess(b, 4), false);
    });
  });

  group("Matrix Operations", () {
    Matrix a = new Matrix(3, 3);
    a.setAll([1,2,3,4,5,6,7,8,9]);

    test("Get Row", () {
      List b = a.getRow(1);

      List c = [4,5,6];

      expect(b, c);
    });

    test("Get Col", () {
      List b = a.getColumn(1);

      List c = [2,5,8];

      expect(b, c);
    });
    
    test("round", () {
      Matrix a = new Matrix(3,3);
      a.setAll([1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9]);
      
      Matrix ans = new Matrix(3, 3);
      ans.setAll([1,2,3,4,6,7,8,9,10]);

      a.round();
      expect(a.toString(), ans.toString());
    });
  });
  
  group("Concationation", () {
    Matrix a = new Matrix(2, 2);
    a.setAll([1,2,3,4]);
    Matrix b = new Matrix(2, 2);
    b.setAll([5,6,7,8]);

    test("Vertical Concationation", () {

      Matrix c = verticalConcatenateMatrices(a, b);

      Matrix d  = new Matrix(4, 2, 0);
      d.setAll([1,2,3,4,5,6,7,8]);

      expect(c.toString(), d.toString());
    });

    test("Horizontal Concationation", () {
      Matrix c = horizontalConcatenateMatrices(a, b);

      Matrix d  = new Matrix(2, 4, 0);
      d.setAll([1,2,5,6,3,4,7,8]);

      expect(c.toString(), d.toString());
    });
  });

  group("Get Block of Matrix", () {
    Matrix a = new Matrix(4, 4);
    a.setAll([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);

    test("get upper left 2x2",() {
      Matrix b = a.getBlock(2, 2);

      Matrix c = new Matrix(2, 2);
      c.setAll([1,2,5,6]);

      expect(b.toString(), c.toString());
    });

    test("get upper right 2x2", () {
      Matrix b = a.getBlock(2, 2, 2, 2);

      Matrix c  = new Matrix(2, 2);
      c.setAll([11,12,15,16]);

      expect(b.toString(), c.toString());
    });
  });

  group("Search", () {
    test("mFind with boolean", () {
      Matrix a = new Matrix(4, 4);
      a.setAll([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);

      Matrix test = setMatrixIfGreaterEqual(a, 5);
      List find = findMatrixIndices(test);
      List ans = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

      expect(find, ans);
    });
  });

  group("Logic Operations", () {
    Matrix a = new Matrix(3, 3);
    a.setAll([1,2,3,4,5,6,7,8,9]);

    test("", () {
      Matrix logic = new Matrix(3, 3);
      logic.setAll([true, 0, true, 0,0,0,0,0,0]);

      Matrix ans = new Matrix(3, 3);
      ans.setAll([-1,2,-1,4,5,6,7,8,9]);

      expect(setWhereTrue(a, logic, -1).toString(), ans.toString());
    });
  });



  group("Inverse", () {
    test("Inverse Matrix", () {
      Matrix a = new Matrix(3,3);
      a.set(0, 0, 3);
      a.set(0, 1, 5);
      a.set(0, 2, 2);
      a.set(1, 0, 1);
      a.set(1, 1, 5);
      a.set(1, 2, 8);
      a.set(2, 0, 3);
      a.set(2, 1, 9);
      a.set(2, 2, 2);

      Matrix b = new Matrix(3,3);
      b.set(0, 0, 0.7045454545454546);
      b.set(0, 1, -0.09090909090909091);
      b.set(0, 2, -0.3409090909090909);
      b.set(1, 0, -0.25);
      b.set(1, 1, -0.0);
      b.set(1, 2, 0.25);
      b.set(2, 0, 0.06818181818181818);
      b.set(2, 1, 0.13636363636363635);
      b.set(2, 2, -0.11363636363636363);

      //print(mInverse(a).toString());
      expect(baseInvertMatrix(a).toString(), b.toString());
    });

    test("Inverse Large Matrix", () {
      Matrix a = new Matrix(3, 3);
      a.setAll([1,2,3,0,1,4,5,6,0]);

      Matrix ans = new Matrix(3,3);
      ans.setAll([-24.0,18.0,5.0,20.0,-15.0,-4.0,-5.0,4.0,1.0]);

      expect(baseInvertMatrix(a).toString(),ans.toString());
    });

    test("Inverse 6x6", () {
      Matrix a = new Matrix(6,6);
      a.setAll([1,1,1,1,1,1,
      (1/2), (1/3), (1/4), (1/5), (1/6),(1/7),
      (1/3), (1/4), (1/5), (1/6),(1/7), (1/8),
      (1/4), (1/5), (1/6),(1/7), (1/8), (1/9),
      (1/5), (1/6),(1/7), (1/8), (1/9), (1/10),
      (1/6),(1/7), (1/8), (1/9), (1/10), (1/11)]);

      expect(baseInvertMatrix(a).round(), invertMatrix(a).round());
    });


//    http://www.ams.org/journals/mcom/1955-09-052/S0025-5718-1955-0074919-9/S0025-5718-1955-0074919-9.pdf
//    test("16 x 16", () {
//      List matrix_data(n) {
//        List ans = [];
//
//        for (var x = 1; x <= n; x++) {
//          List temp = [];
//          for (var i = 0; i < n; i++) {
//            if (x == 1) {
//              temp.add(1);
//            }
//            else {
//              temp.add(1 / (x + i));
//            }
//          }
//          ans.addAll(temp);
//        }
//        return ans;
//      }
//
//      Matrix a = new Matrix(16, 16);
//      a.setAll(matrix_data(16));
//
//      print(blockwiseInvert(a).toString());
//
//    });
  });

  group("Diagonal Matrix Operations", () {
    test("makeDiag", () {
      Matrix a = new Matrix(3, 1);
      a.setAll([1,2,3]);

      Matrix ans = new Matrix(3, 3);
      ans.set(0, 0, 1);
      ans.set(1, 1, 2);
      ans.set(2, 2, 3);

      expect(createDiagonalMatrix(a).toString(), ans.toString());
    });
  });



  print("All Tests Run");
}