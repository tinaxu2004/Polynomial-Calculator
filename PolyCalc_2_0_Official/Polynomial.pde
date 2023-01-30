class Polynomial {
  String polyString;
  int[][] polyArray;

  Polynomial(String s) {
    this.polyString = s;
    int count = 0;
    int lastTermStart = 0;
    for (int i = 0; i < this.polyString.length(); i++) { //Creates the array based on the number of terms
      if (this.polyString.substring(i, i+1).equals("x"))
        count ++;
      if(this.polyString.substring(i, i+1).equals("+") || (this.polyString.substring(i, i+1).equals("+") && !this.polyString.substring(i-1, i).equals("^")))
        lastTermStart = i;
    }
    
    if(this.polyString.indexOf("x", lastTermStart) == -1 && lastTermStart!=0)
      count++;
      
    if(count == 0 && lastTermStart == 0)
      count++;
    
    this.polyArray = new int[count][2];
    this.createArray();
  }

  Polynomial(int[][] p) {
    this.polyArray = p;
  }

  void createArray() {
    cStart = 0;
    cEnd = this.polyString.indexOf("x");
    if(cEnd == -1)
      cEnd = this.polyString.length();
    int i = 0;
    while (i < this.polyArray.length) {
      if (cStart == cEnd - 1 && cEnd != this.polyString.length() && cStart != 0) {
        if (this.polyString.substring(cStart, cEnd).equals("-"))
          this.polyArray[i][0] = -1;
        else
          this.polyArray[i][0] = 1;
      } else {
        if (cStart == cEnd)
          this.polyArray[i][0] = 1;
        else
          this.polyArray[i][0] = int(this.polyString.substring(cStart, cEnd));
      };
      try {
        if (this.polyString.substring(cEnd+1, cEnd+2).equals("^")) {
          eStart = cEnd + 2;
          p = this.polyString.indexOf("+", eStart); //location of + sign
          n = this.polyString.indexOf("-", eStart); //location of - sign
          if (n == cEnd + 2) //checks if - sign is for exp, not coef
            n = this.polyString.indexOf("-", cEnd+3);
          if(p == -1 && n == -1){
            eEnd = this.polyString.length();
          } else if (p < 0 && n > 0) { //if no more + signs but still - signs
            eEnd = n;
          } else if (n < 0 && p > 0) { //if no more - signs but still + signs
            eEnd = p;
          } else if (p < n) { //checks if + sign or - sign comes first
            eEnd = p;
          } else {
            eEnd = n;
          }
          this.polyArray[i][1] = int(this.polyString.substring(eStart, eEnd));
        } else if (this.polyString.substring(cEnd+1, cEnd+2).equals("-") || this.polyString.substring(cEnd+1, cEnd+2).equals("+")) {
          this.polyArray[i][1] = 1;
          eEnd += 3;
        }
      } 
      catch(StringIndexOutOfBoundsException e) {
      }
      cStart = eEnd;
      cEnd = this.polyString.indexOf("x", cStart);
      if (cEnd < 0)
        cEnd = this.polyString.length();
      i++;
    }
  }

  void printPoly() {
    println();
    polyPrint = "";
    for (int j = 0; j < this.polyArray.length; j++) {
      if (j != 0) {
        if (this.polyArray[j][0] == 1)
          polyPrint += " + ";
        else if (this.polyArray[j][0] == -1)
          polyPrint += " - ";
        else if (this.polyArray[j][0] > 0)
          polyPrint += (" + " + str(this.polyArray[j][0]));
        else if (this.polyArray[j][0] < 0)
          polyPrint += (" - " + str(this.polyArray[j][0]*-1));
      } else {
        if (this.polyArray[j][0] == 1)
          polyPrint += "";
        else if (this.polyArray[j][0] == -1)
          polyPrint += "-";
        else if (this.polyArray[j][0] != 0)
          polyPrint += str(this.polyArray[j][0]);
      }
      if (j == this.polyArray.length-1 && (this.polyArray[j][0] == 1 || this.polyArray[j][0] == -1))
        polyPrint += "1";

      if (this.polyArray[j][1] == 0)
        polyPrint += "";
      else if (this.polyArray[j][1] == 1)
        polyPrint += "x";
      else
        polyPrint += ("x^" + str(this.polyArray[j][1]));
    }
    println(polyPrint);
  }
  
  Polynomial add(Polynomial other) {
    IntList exp = new IntList();    
    for (int i = 0; i < this.polyArray.length; i++) {
      if (!exp.hasValue(this.polyArray[i][1]))
        exp.append(this.polyArray[i][1]);
    }
    for (int i = 0; i < other.polyArray.length; i++) {
      if (!exp.hasValue(other.polyArray[i][1]))
        exp.append(other.polyArray[i][1]);
    }
    exp.sortReverse();
    if (exp.hasValue(0)) {
      for (int i = 0; i < exp.size(); i++) {
        if (exp.get(i) == 0) {
          exp.remove(i);
          exp.append(0);
          break;
        }
      }
    }
    int[][] a = new int[exp.size()][2];
    for (int i = 0; i < a.length; i++) {
      a[i][1] = exp.get(i);
    }
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < this.polyArray.length; j++) {
        if (this.polyArray[j][1] == a[i][1])
          a[i][0] += this.polyArray[j][0];
      }
      for (int j = 0; j < other.polyArray.length; j++) {
        if (other.polyArray[j][1] == a[i][1])
          a[i][0] += other.polyArray[j][0];
      }
    }

    return(new Polynomial(a));
  }

  Polynomial sub(Polynomial other) {
    IntList exp = new IntList();    
    for (int i = 0; i < this.polyArray.length; i++) {
      if (!exp.hasValue(this.polyArray[i][1]))
        exp.append(this.polyArray[i][1]);
    }
    for (int i = 0; i < other.polyArray.length; i++) {
      if (!exp.hasValue(other.polyArray[i][1]))
        exp.append(other.polyArray[i][1]);
    }
    exp.sortReverse();
    if (exp.hasValue(0)) {
      for (int i = 0; i < exp.size(); i++) {
        if (exp.get(i) == 0) {
          exp.remove(i);
          exp.append(0);
          break;
        }
      }
    }
    int[][] a = new int[exp.size()][2];
    for (int i = 0; i < a.length; i++) {
      a[i][1] = exp.get(i);
    }
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < this.polyArray.length; j++) {
        if (this.polyArray[j][1] == a[i][1])
          a[i][0] += this.polyArray[j][0];
      }
      for (int j = 0; j < other.polyArray.length; j++) {
        if (other.polyArray[j][1] == a[i][1])
          a[i][0] -= other.polyArray[j][0];
      }
    }

    return(new Polynomial(a));
  }

  Polynomial mult(Polynomial other) {
    int size = this.polyArray.length * other.polyArray.length;
    int[][] a = new int[size][2];
    int g = 0;
    for (int i = 0; i < this.polyArray.length; i++) {
      for (int j = 0; j < other.polyArray.length; j++) {
        a[g][0] = this.polyArray[i][0] * other.polyArray[j][0];
        a[g][1] = this.polyArray[i][1] + other.polyArray[j][1];
        g++;
      }
    }
    IntList exp = new IntList();    
    for (int i = 0; i < a.length; i++) {
      if (!exp.hasValue(a[i][1]))
        exp.append(a[i][1]);
    }
    exp.sortReverse();
    if (exp.hasValue(0)) {
      for (int i = 0; i < exp.size(); i++) {
        if (exp.get(i) == 0) {
          exp.remove(i);
          exp.append(0);
          break;
        }
      }
    }
    int[][] b = new int[exp.size()][2];
    for (int i = 0; i < b.length; i++) {
      b[i][1] = exp.get(i);
    }
    for (int i = 0; i < b.length; i++) {
      for (int j = 0; j < a.length; j++) {
        if (a[j][1] == b[i][1])
          b[i][0] += a[j][0];
      }
    }
    return(new Polynomial(b));
  }
  
  void graph(Polynomial p){
    graphing = true;
    
  }
  
  void roots() {
    roots = "";
    int c = abs(this.polyArray[this.polyArray.length-1][0]); // last coefficient
    int q = abs(this.polyArray[0][0]); // leading coefficient
    boolean hasContant = this.polyArray[this.polyArray.length-1][1] == 0;
    IntList factors_c = new IntList();
    IntList factors_q = new IntList();
    FloatList factors = new FloatList();
    FloatList zeroes = new FloatList();

    if (!hasContant) {
      zeroes.append(0);

      while (this.polyArray[this.polyArray.length-1][1] != 0) {
        for (int i = 0; i < this.polyArray.length; i++) {
          this.polyArray[i][1]--;
        }
      }
    }

    //println("[");
    //for (int[] arr : this.polyArray) {
    //    println("  [", arr[0], ",", arr[1], "]");
    //}
    //println("]");
    //println("C", c);
    //println("Q", q);

    for (int i = 1; i <= c; i++) { //FIND FACTORS
      if (c % i == 0) {
        factors_c.append(i);
      }
    }
    for (int i = 1; i <= q; i++) {
      if (q % i == 0) {
        factors_q.append(i);
      }
    }
    for (int i = 0; i < factors_c.size(); i++) {
      for (int j = 0; j < factors_q.size(); j++) {
        factors.append(factors_c.get(i)/factors_q.get(j));
        factors.append(-factors_c.get(i)/factors_q.get(j));
      }
    }
    //test if number equals to 0
    for (int i = 0; i < factors.size(); i++) {
      float f = factors.get(i);
      float v = 0;
      //println(f);
      for (int j = 0; j < this.polyArray.length; j++) {
        v += this.polyArray[j][0] * pow(f, this.polyArray[j][1]);
      }
      //println("v is " + str(v));
      if (v == 0) {
        zeroes.append(f);
      }
    }

    println(zeroes);

    if (zeroes.size() == 0) {
      println("No rational roots.");
      roots = "No rational roots.";
    } else if (zeroes.size() == 1) {
        println("Rational root: ", zeroes.get(0) + ".");
        roots = ("Rational root: " + str(zeroes.get(0)) + ".");
    } else {
        print("Rational roots: ");
        roots = "Rational roots: ";
        
        for (int i = 0; i < zeroes.size() - 1; i++) {
            print(Float.toString(zeroes.get(i)) + ", ");
            roots += (str(zeroes.get(i)) + ", ");
        }

        println(zeroes.get(zeroes.size() - 1));
        roots += str(zeroes.get(zeroes.size() - 1));
    }

  }
  
  Polynomial derive(){
    int[][] newArray = this.polyArray;
    for (int i=0; i<this.polyArray.length; i++) {
      newArray[i][0] = this.polyArray[i][0] * this.polyArray[i][1];
      newArray[i][1] = this.polyArray[i][1] - 1;
      
      
    }
    if (newArray[newArray.length-1][1] < 0) {
      newArray[newArray.length-1][1] = 0;    
    }

    return(new Polynomial(newArray));
  }
  
}
