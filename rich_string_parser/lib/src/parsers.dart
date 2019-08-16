abstract class Parser {
  dynamic converter(String v);
}

abstract class ParserMatch {
  String match;

  ParserMatch(this.match);
}

class MentionMatch extends ParserMatch {
  String match;
  int id;
  String name;

  MentionMatch(
    this.match,
    this.id,
    this.name,
  ): super(match);
}

class MentionParser extends Parser {
  RegExp regex = RegExp('@\\(\\d+\\|(.+?)\\)', multiLine: true, unicode: true);

  @override
  MentionMatch converter(String mention) {
    return MentionMatch(
      mention,
      int.parse(mention.substring(2, mention.indexOf('|'))),
      mention.substring(mention.indexOf('|') + 1, mention.length - 1)
    );
  }
}

class EmailMatch extends ParserMatch {
  String match;
  EmailMatch(this.match): super(match);
}

class EmailParser extends Parser {
  RegExp regex = RegExp(
    r"([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})",
    caseSensitive: false,
  );

  @override
  EmailMatch converter(match) {
    return EmailMatch(match);
  }
}

class LinkMatch  extends ParserMatch {
  String match;
  LinkMatch(this.match): super(match);
}

class LinkParser extends Parser {
  RegExp regex = RegExp(
    r"((?:https?):\/\/[^\s/$.?#].[^\s]*)",
    caseSensitive: false,
  );

  @override
  LinkMatch converter(match) {
    return LinkMatch(match);
  }
}
