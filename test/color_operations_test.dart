import 'package:test/test.dart';
import 'package:color_mixer/matrix.dart';
import 'package:color_mixer/data/matrix_b.dart';
import 'package:color_mixer/data/b11.dart';
import 'package:color_mixer/data/b12.dart';
import 'package:color_mixer/LLSS.dart';
import 'package:color_mixer/color_operations.dart';
import 'package:color_mixer/data/T.dart';
import 'package:color_mixer/color.dart';

void main() {
  group('ILLS', () {
    Matrix T = new Matrix(3, 36, 0);
    T.setAll(t_data);

    //
    //    print("T: " + T.getSize().toString());
    //
    //    Matrix D = new Matrix(36,36,0);
    //    D.setDiagonal(4);
    //    D.setDiagonal(-2, 1);
    //    D.setDiagonal(-2,-1);
    //
    //    D.set(0, 0, 2);
    //    D.set(35,35,2);
    //    print(D);
    //
    //    Matrix temp_a = (mHorizontalCat(D, mTranspose(T)));
    //    print("temp_a " + temp_a.getSize().toString());
    //
    //    Matrix zero = new Matrix(3, 3, 0);
    //
    //    Matrix temp_b = mHorizontalCat(T, zero);
    //    print("temp_b " + temp_b.getSize().toString());

    Matrix B = new Matrix(39, 39);
    B.setAll(MATRIX_B_DATA);

    //    Matrix B =
    //    mInverse(mVerticalCat(temp_a, temp_b));
    //    print("B:");
    //    print(B.getSize().toString());
    //

    //upper-left portion of Matrix B
    Matrix B_11 = new Matrix(36, 36); //B.getBlock(36, 36, 0, 0);
    B_11.setAll(B11_DATA);

    //upper-right 36x3 portion of Matrix B
    Matrix B_12 = new Matrix(36, 3); //B.getBlock(36, 3, 0, 36);
    B_12.setAll(B12_DATA);
    print("got blocks");

    //    test('reflectance', () {
    //
    //      Matrix rgb = new Matrix(22,147,165);
    //      rgb.set(0,0, 255);
    //      Matrix out = ILLS(B_11, B_12, rgb);
    //      print(out);
    //
    //      print('rgb conversion from reflectance graph');
    //      print(mmult(T, out));
    //      expect(1, 10);
    //    });

    test("LLSS", () {
      Matrix rgb = new Matrix(3, 1);
      rgb.setAll([22, 147, 165]);
      //rgb.set(0,0, 255);

      Matrix out = LLSS(T, rgb);

      expect(convertFromReflectance(out).toString(), rgb.toString());
    });

    test("LLSS - black", () {
      Matrix rgb = new Matrix(3, 1);
      rgb.setAll([0, 0, 0]);
      //rgb.set(0,0, 255);

      Matrix out = LLSS(T, rgb);

      expect(convertFromReflectance(out).toString(), rgb.toString());
    });

    test("mix blue & red - 1:1", () {
      Matrix red = new Matrix(3, 1);
      red.setAll([255, 0, 0]);

      Matrix blue = new Matrix(3, 1);
      blue.setAll([0, 0, 255]);

      Matrix red_graph = LLSS(T, red);
      Matrix blue_graph = LLSS(T, blue);

      Matrix result_graph = multiplyColorGraphs([red_graph, blue_graph]);
      Matrix ans = new Matrix(3, 1);
      ans.setAll([77, 53, 101]);

      expect(convertFromReflectance(result_graph).toString(), ans.toString());
    });

    test("mix red & blue from Color object", () {
      Color red = new Color('#FF0000');
      Color blue = new Color('#0000FF');

      Color result = mixColors([red, blue], [1, 1]);
      expect(result.hexToInt(), [77, 53, 101]);
    });

    test("Radix color string", () {
      Color red = new Color('#00FF00');
      Color blue = new Color('#0000FF');

      Color result = mixColors([red, blue], [1, 1]);
      expect(result.hex, "#007B8D");
    });
  });
}