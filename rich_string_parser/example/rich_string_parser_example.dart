import 'package:rich_string_parser/rich_string_parser.dart';

class OwnMatch {
  String value;
  OwnMatch(
    this.value,
  );
}

class OwnParser extends Parser {
  RegExp regex = RegExp(
    '(hello)',
    multiLine: true,
    unicode: true
  );

  @override
  OwnMatch converter(String own) {
    return OwnMatch(
      own
    );
  }
}

void main() {
  // single parser
  var singleParser = 'hello world example@example.com asd';
  List<dynamic> singleParserResult = richStringParser(
    singleParser,
    [ EmailParser() ]
  );

  // => ['hello world ', Instance of 'EmailMatch', ' asd']
  print(singleParserResult);

  // single parser
  var multibleParsers = 'hello @(123|example) world example@example.com asd';
  List<dynamic> multibleParsersResult = richStringParser(
    multibleParsers,
    [ EmailParser(), MentionParser() ]
  );

  // => ['hello ', Instance of 'MentionMatch', ' world ',  Instance of 'EmailMatch', ' asd']
  print(multibleParsersResult);

  // createParser: see OwnParser
  var own = 'hello world';
  List<dynamic> ownResult = richStringParser(
    own,
    [ OwnParser() ]
  );

  // => [Instance of 'OwnMatch', ' world']
  print(ownResult);
}
