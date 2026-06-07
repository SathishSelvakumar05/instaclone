abstract class sample {
  void add();
  void sub();
  void mul();
  void div();
}
class operation extends sample {
  int a = 10;
  int b = 5;
  int c = 0;
  @override
  void add() {
    c = a + b;
    print("Addition is : $c");
  }

  @override
  void div() {
    c = a % b;
    print("Addition is : $c");
  }

  @override
  void mul() {
    c = a * b;
    print("Addition is : $c");
  }

  @override
  void sub() {
    c = a - b;
    print("Addition is : $c");
  }
}
