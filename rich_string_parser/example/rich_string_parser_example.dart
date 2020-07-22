import 'package:rich_string_parser/rich_string_parser.dart';

class OwnMatch extends ParserMatch {
  @override
  String match;
  OwnMatch(
    this.match,
  ) : super(match);
}

class OwnParser extends Parser {
  @override
  RegExp regex = RegExp('(hello)', multiLine: true, unicode: true);

  @override
  OwnMatch converter(String own) {
    return OwnMatch(own);
  }
}

void main() {
  // single parser
  var singleParser = 'hello world example@example.com asd';
  var singleParserResult = richStringParser(singleParser, [EmailParser()]);

  // => ['hello world ', Instance of 'EmailMatch', ' asd']
  print(singleParserResult);

  // single parser
  var multibleParsers = 'hello @(123|example) world example@example.com asd';
  var multibleParsersResult =
      richStringParser(multibleParsers, [EmailParser(), MentionParser()]);

  // => ['hello ', Instance of 'MentionMatch', ' world ',  Instance of 'EmailMatch', ' asd']
  print(multibleParsersResult);

  // createParser: see OwnParser
  var own = 'hello world';
  var ownResult = richStringParser(own, [OwnParser()]);

  // => [Instance of 'OwnMatch', ' world']
  print(ownResult);
}
