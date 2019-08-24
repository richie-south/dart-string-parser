import './parsers.dart';

List<dynamic> _runTextParser(dynamic parser, String text) {
  if (text.isEmpty) {
    return [];
  }

  final match = parser.regex.firstMatch(text);

  if (match == null) {
    return [text];
  }

  String groupZero = match.group(0);
  List<String> values = text.split(groupZero);
  text = text.substring(match.end, text.length);

  final List<dynamic> contentList = [];

  if (values[0].isNotEmpty) {
    contentList.add(values[0]);
  }

  contentList.add(parser.converter(match.group(0)));
  contentList.addAll(_runTextParser(parser, text));

  return contentList;
}

List<dynamic> _runParser(
  dynamic parser, {
  String text,
  List<dynamic> list,
}) {

  if (list != null && list.isNotEmpty) {
    final List<dynamic> _contentList = list;

    int index = 0;
    list.forEach((dynamic item) {
      if (item is String) {
        List<dynamic> subList = _runTextParser(parser, item);

        _contentList.removeAt(index);
        _contentList.insert(index, subList);
      }

      index += 1;
    });

    return _contentList.expand((f) => f is List ? f : [f]).toList();
  }

  return _runTextParser(parser, text);
}

List<dynamic> richStringParser(
  String text,
  List<Parser> parsers,
) {
  List<dynamic> contentList = [];

  if (text == null || text.isEmpty) {
    return contentList;
  }

  parsers = parsers
    .where(
      (parser) => parser.regex.hasMatch(text)
    ).toList();

  parsers.forEach((parser) {
    contentList = _runParser(
      parser,
      text: contentList.isEmpty ? text : '',
      list: contentList.isNotEmpty ? contentList : [],
    );
  });

  return contentList;
}
