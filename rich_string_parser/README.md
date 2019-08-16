# rich_string_parser
Parse multible different values in one string.

## install

```yaml
dependencies:
  rich_string_parser: ^1.0.0
```

## Usage

A simple usage example:

```dart
import 'package:rich_string_parser/rich_string_parser.dart';

main() {
  List<dynamic> result = richStringParser(
    'text to be parsed example@example.com @(123|example)',
    [
      EmailParser(),
      LinkParser(),
      MentionParser(),
    ]
  );

  print(result); // >> ['text to be parsed ' Instance of 'EmailMatch', ' ', Instance of 'MentionMatch']
}
```

## Create own parser


```dart
import 'package:rich_string_parser/rich_string_parser.dart';

class OwnMatch extends ParserMatch {
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

main() {
  List<dynamic> result = richStringParser(
    'text to be parsed (hello)',
    [
      EmailParser(),
      LinkParser(),
      OwnParser(),
    ]
  );

  print(result); // >> ['text to be parsed ', Instance of 'OwnMatch']
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
