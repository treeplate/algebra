import "dart:io";
String solve(String equation) {
  List<Object> things = equation.split(" ").cast<Object>().toList();
  for (int i = 0; i < things.length; i++) {
    int parsed = int.parse(things[i], onError: (String value) => null);
    if (parsed != null) {
      things[i] = parsed;
    }
  }
  if(things.length == 5 && things[0] is int && things[2] is int && things[3] == "=" && things[4] is String){
    //int _ int = var
    if(things[1] == "+"){
      int result = (things[0] as int) + (things[2] as int);
      return "${things[4]} = $result";
    }
    else if(things[1] == "-"){
      int result = (things[0] as int) - (things[2] as int);
      return "${things[4]} = $result";
    }
    else if(things[1] == "*"){
      int result = (things[0] as int) * (things[2] as int);
      return "${things[4]} = $result";
    }
    else if(things[1] == "/"){
      double result = (things[0] as int) / (things[2] as int);
      return "${things[4]} = $result";
    }

  }
  else if(things.length == 5 && things[2] is int && things[4] is int && things[1] == "=" && things[0] is String){
    //var = int _ int
    if(things[3] == "+"){
      int result = (things[4] as int) + (things[2] as int);
      return "${things[0]} = $result";
    }
    else if(things[3] == "-"){
      int result = (things[2] as int) - (things[4] as int);
      return "${things[0]} = $result";
    }
    else if(things[3] == "*"){
      int result = (things[4] as int) * (things[2] as int);
      return "${things[0]} = $result";
    }
    else if(things[3] == "/"){
      double result = (things[2] as int) / (things[4] as int);
      return "${things[0]} = $result";
    }

  }
  else if(things.length == 5 && things[2] is int && things[4] is int && things[3] == "=" && things[0] is String){
    //var _ int = int
    if(things[1] == "+"){
      int result = (things[4] as int) - (things[2] as int);
      return "${things[0]} = $result";
    }
    else if(things[1] == "-"){
      int result = (things[2] as int) + (things[4] as int);
      return "${things[0]} = $result";
    }
    else if(things[1] == "*"){
      double result = (things[4] as int) / (things[2] as int);
      return "${things[0]} = $result";
    }
    else if(things[1] == "/"){
      int result = (things[2] as int) * (things[4] as int);
      return "${things[0]} = $result";
    }

  }

   
  
}

void printQuoted(List<Object> printer) {
  StringBuffer str = StringBuffer();
  for (Object obj in printer) {
    if(obj is String){
    str.write("\"" + obj.toString() + "\"");
    }else{
    str.write(obj.toString());
    }
  }
  print(str);
}

void main() {
  String solver = stdin.readLineSync();
  print(solve(solver));
  //printQuoted(["5", "o", 5]);
}
