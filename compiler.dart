enum _State {top, number, word}

Iterable<Object> compile(String eq) sync* {
  _State state = _State.top;
  List<int> buffer = [];
  for(int char in eq.runes) {
    switch(state) {
      case _State.top:
        if("-0123456789.".runes.contains(char)) {
          buffer.add(char);
          state = _State.number;
        }
        else if(String.fromCharCodes([char]).toUpperCase().runes.first != char) {
          buffer.add(char);
          state = _State.word;
        }
        else if(char != 32){
          yield String.fromCharCodes([char]);
        }
        break;
      case _State.number:
        if(!"0123456789.".runes.contains(char)) {
          //print(buffer);
          yield double.tryParse(buffer.fold("", (String old, int newe) => old + String.fromCharCodes([newe]))) ?? "-";
          if(char != 32) {
            yield String.fromCharCodes([char]);
          }
          buffer = [];
          state = _State.top;
        } else {
          buffer.add(char);
        }
        break;
      case _State.word:
        if(String.fromCharCodes([char]).toUpperCase().runes.first == char) {
          yield buffer.fold<String>("", (String old, int newe) => old + String.fromCharCodes([newe]));
          if(char != 32) {
            yield String.fromCharCodes([char]);
          }
          buffer = [];
          state = _State.top;
        } else {
          buffer.add(char);
        }
        break;
    }
  }
  switch(state) {
    case _State.top:
      break;
    case _State.number:
      yield double.parse(buffer.fold("", (String old, int newe) => old + String.fromCharCodes([newe])));
      buffer = [];
      break;
    case _State.word:
      yield buffer.fold<String>("", (String old, int newe) => old + String.fromCharCodes([newe]));
      buffer = [];
      break;
  }
  yield Object();
}