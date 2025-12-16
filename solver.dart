import "compiler.dart";

///Algebra solver
String solve(String equation) {
  List<Object> things = compile(equation).toList();
  Iterator tokens = things.iterator;
  tokens.moveNext();
  return Equation(parse(tokens), () {tokens..moveNext();}(), parse(tokens)).solve();
}

abstract class Expression {
  Expression simplify();
}

class NumberExpression extends Expression {
  NumberExpression(this.n);
  final double n;

  Expression simplify() => this;

  String toString() => n.toStringAsFixed(n.truncateToDouble() == n ? 0 : n.toString().split(".").last.length);
}

class UnknownExpression extends Expression {
  UnknownExpression(this.n);
  final String n;

  Expression simplify() => this;

  String toString() => n.toString();
}

class PlusExpression extends Expression {
  PlusExpression(this.a, this.b);
  final Expression a;
  final Expression b;

  Expression simplify() {
    Expression a = this.a.simplify();
    Expression b = this.b.simplify();
    if(a is NumberExpression && b is NumberExpression) {
      NumberExpression n = NumberExpression(a.n + b.n);
      print("Simplify $a + $b into $n");
      return n; 
    } else {
      if(a != this.a || b != this.b) {
        return PlusExpression(a, b);
      } else {
        return this;
      }
    }
  }

  String toString() => "($a + $b)";

  static Expression parse(Iterator tokens, [String i = ""]) {
    //print(i + tokens.current.toString());
    Expression a = MinusExpression.parse(tokens);
    //print("$i${tokens.current} (2)");
    if(tokens.current != "+") return a;
    tokens.moveNext();
    //print("$i${tokens.current} (3)");
    Expression b = PlusExpression.parse(tokens, i+"  ");
    //print("$i${tokens.current} (4)");
    return PlusExpression(a, b);
  }
}

class MinusExpression extends Expression {
  MinusExpression(this.a, this.b);
  final Expression a;
  final Expression b;

  String toString() => "($a - $b)";

  static Expression parse(Iterator tokens) {
    Expression a = DivExpression.parse(tokens);
    if(tokens.current != "-") return a;
    tokens.moveNext();
    Expression b = MinusExpression.parse(tokens);
    return MinusExpression(a, b);
  }

  Expression simplify() {
    Expression a = this.a.simplify();
    Expression b = this.b.simplify();
    if(a is NumberExpression && b is NumberExpression) {
      NumberExpression n = NumberExpression(a.n - b.n);
      print("Simplify $a - $b into $n");
      return n; 
    } else {
      if(a != this.a || b != this.b) {
        return MinusExpression(a, b);
      } else {
        return this;
      }
    }
  }
}

class DivExpression extends Expression {
  DivExpression(this.a, this.b);
  final Expression a;
  final Expression b;

  String toString() => "($a / $b)";

  static Expression parse(Iterator tokens) {
    //print("got ${tokens.current}-DivExpression");
    Expression a = TimesExpression.parse(tokens);
    //print("got ${tokens.current}-afterX");
    if(tokens.current != "/") return a;
    tokens.moveNext();
    //print("got ${tokens.current}-after/");
    Expression b = DivExpression.parse(tokens);
    return DivExpression(a, b);
  }

  Expression simplify() {
    Expression a = this.a.simplify();
    Expression b = this.b.simplify();
    if(a is NumberExpression && b is NumberExpression) {
      NumberExpression n = NumberExpression(a.n / b.n);
      print("Simplify $a / $b into $n");
      return n; 
    } else {
      if(a != this.a || b != this.b) {
        return DivExpression(a, b);
      } else {
        return this;
      }
    }
  }
}

class TimesExpression extends Expression {
  TimesExpression(this.a, this.b);
  final Expression a;
  final Expression b;

  String toString() => "($a * $b)";

  static Expression parse(Iterator tokens) {
    Expression a = parseLiteral(tokens);
    tokens.moveNext();
    if(tokens.current != "*") return a;
    tokens.moveNext();
    Expression b = TimesExpression.parse(tokens);
    return TimesExpression(a, b);
  }

  Expression simplify() {
    Expression a = this.a.simplify();
    Expression b = this.b.simplify();
    if(a is NumberExpression && b is NumberExpression) {
      NumberExpression n = NumberExpression(a.n * b.n);
      print("Simplify $a * $b into $n");
      return n; 
    } else {
      if(a is NumberExpression && a.n == 0) {
        print("Simplify 0 * $b into 0");
        return NumberExpression(0);
      }
      if(b is NumberExpression && b.n == 0) {
        print("Simplify $a * 0 into 0");
        return NumberExpression(0);
      }
      if(a is NumberExpression && a.n == 1) {
        print("Simplify 1 * $b into $b");
        return b;
      }
      if(b is NumberExpression && b.n == 1) {
        print("Simplify $a * 1 into $a");
        return a;
      }
      return TimesExpression(a, b);
    }
  }
}

Expression parseLiteral(Iterator tokens) {
  //print("got ${tokens.current}");
  if(tokens.current == "(") {
    tokens.moveNext();
    Expression expr = parse(tokens);
    return expr;
  }
  if(tokens.current is String) return UnknownExpression(tokens.current);
  //print("carpet-" + tokens.current.toString());
  return NumberExpression(tokens.current);
}

Expression parse(Iterator tokens) {
  Expression cat = PlusExpression.parse(tokens);
  //print("MEOWING $cat");
  return cat;
}

class Equation {
  Equation(this.a, dynamic _, this.b);
  final Expression a;
  final Expression b;
  String solve() {
    //print(this.a);
    //print((this.b as NumberExpression).n);
    Expression a = this.a.simplify();
    Expression b = this.b.simplify();
    if(a != this.a || b != this.b) {
      print("Summarizing, simplify ${this.a} = ${this.b} into $a = $b");
    }
    if(a.toString() == b.toString()) {
      return "True equation; no variables to solve for";
    }
    if(a is NumberExpression && b is UnknownExpression) { 
      return "$b = $a";
    }
    if(b is NumberExpression && a is UnknownExpression) { 
      return "$a = $b";
    }
    if(a is NumberExpression && b is NumberExpression) {
      return "Invalid equation due to paradox $a = $b";
    }
    return "Not yet solvable";
  }
}