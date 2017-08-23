import 'dart:math';

class Matrix {

  var mat = null;
  num row;
  num col;

  //initialize matrix in x,y pair
  Matrix(int row, int col, [fill=0]) {
    this.row = row;
    this.col = col;
    this.mat = new List(row);//new List.filled(row, new List(col));//.filled(col, 0));

    //initialize the cols of the matrix with fill value
    num i = 0;
    while (i < row) {
      this.mat[i] = new List.filled(col, fill);
      i++;
    }
  }

  void round() {
    for (var i = 0; i < this.row; i++) {
      for (var j = 0; j < this.col; j++) {
        this.mat[i][j] = this.mat[i][j].round();
      }
    }
  }

  void set(row, column, value) {
    try {
      if (row >= this.row) {
        throw new Exception('set: row is out of bounds');
      }
      if (column >= this.col) {
        throw new Exception('set: col is out of bounds');
      }
    } catch(exception, stackTrace) {
      print(exception);
      print(stackTrace);
    }
    this.mat[row][column] = value;
  }

  void setAll(List data) {
    try{
      if (data.length != this.row * this.col) {
        throw new Exception("list is of insuffcient length");
      }
    }
    catch(exception, stackTrace) {
      print(exception);
      print(stackTrace);
    }

    var  i = 0;
    for (var r = 0; r < this.row; r++) {
      for (var c = 0; c < this.col; c++) {
        this.mat[r][c] = data[i];
        i++;
      }
    }
  }

  void setDiagonal(var n, [offset = 0]) {
    for (var i = 0; i < this.row; i++) {
      if (i + offset >= 0 && i + offset < this.col) {
        this.mat[i][i + offset] = n;
      }
    }
  }

  //[rows, columns]
  List<num> getSize() {
    return [this.row, this.col];
  }

  List<num> getRow(num row) {
    List<num> result = new List<num>();


    for (var i = 0; i < this.col; i++) {
      result.add(this.mat[row][i]);
    }

//    num i = 0;
//
//    while (i < this.row) {
//      result.add(this.mat[row][i]);
//      i++;
//    }
    return result;
  }

  List<num> getColumn(num col) {
    List<num> result = new List<num>();

    num i = 0;

    while (i < this.row) {
      result.add(this.mat[i][col]);
      i++;
    }
    return result;
  }

  String toString() {
    num i = 0;
    String result = "";
    /* while (i < this.row) {
      result += getRow(i).toString();
      result += '\n';
      i++;
    }
    */

    for (var r = 0; r < this.row; r++) {
      result += "[";
      for (var c = 0; c < this.col; c++) {
        result += " " + this.mat[r][c].toString();
      }
      result += "] \n";
    }

    return result;
  }

  Matrix getBlock(num r, num c, [r_offset = 0, c_offset = 0]) {
    Matrix out = new Matrix(r, c);

    for (var i = 0; i < out.row; i++) {
      for (var j = 0; j < out.col; j++) {
        out.set(i, j, this.mat[i + r_offset][j + c_offset]);
      }
    }
    return out;
  }

  void setBlock(Matrix a, [r_offset = 0, c_offset = 0]) {

    for (var i = 0; i < a.row; i++) {
      for (var j = 0; j < a.col; j++) {
        this.set(i+r_offset, j+c_offset, a.mat[i][j]);
      }
    }
  }

  Matrix abs() {
    Matrix ans = new Matrix(this.row,this.col);
    for (var i = 0; i < ans.row; i++) {
      for (var j = 0; j < ans.col; j++) {
        ans.mat[i][j] = this.mat[i][j].abs();
      }
    }

    return ans;
  }

}