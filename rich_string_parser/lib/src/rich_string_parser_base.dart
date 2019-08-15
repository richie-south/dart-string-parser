import './parsers.dart';

List<dynamic> _runTextParser(
  dynamic parser,
  String text
) {
  final List<dynamic> contentList = [];

  if (text == null || text.isEmpty) {
    return contentList;
  }

  final match = parser.regex.firstMatch(text);

  if (match == null) {
    contentList.add(text);
    return contentList;
  }

  String asd = match.group(0);
  var values = text.split(asd);
  text = text.substring(match.end, text.length);

  if (values[0].isNotEmpty) {
    contentList.add(values[0]);
  }

  contentList.add(parser.converter(match.group(0)));

  contentList.addAll(
    _runTextParser(
      parser,
      text
    )
  );

  return contentList;
}


List<dynamic> runParser(
  dynamic parser,
  {
    String text,
    List<dynamic> list,
  }
) {
  final List<dynamic> contentList = [];

  if (list != null && list.isNotEmpty) {
    final List<dynamic> _contentList = list;

    int index = 0;
    list.forEach((dynamic item) {
      if (item is String) {
        var subList = _runTextParser(parser, item);

        _contentList.removeAt(index);
        _contentList.insert(index, subList);
      }

      index += 1;
    });

    return _contentList.expand((f) => f is List ? f : [f]).toList();

  } else if (text != null && text.isNotEmpty) {

    contentList.addAll(
      _runTextParser(parser, text)
    );
  }

  return contentList;
}

List<dynamic> richStringParser(
  String text,
  List<Parser> parsers,
) {
  List<dynamic> contentList = [];

  if (text == null || text.isEmpty) {
    return contentList;
  }

  parsers.forEach((parser) {
    contentList =
      runParser(
        parser,
        text: contentList.isEmpty
          ? text
          : null,
        list: contentList.isNotEmpty
          ? contentList
          : null,
    );
  });

  return contentList;
}
