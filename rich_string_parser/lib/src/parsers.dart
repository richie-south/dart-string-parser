abstract class Parser {
  dynamic converter(String v);
}

class MentionMatch {
  int id;
  String name;
  MentionMatch(
    this.id,
    this.name,
  );
}

class MentionParser extends Parser {
  RegExp regex = RegExp('@\\(\\d+\\|(.+?)\\)', multiLine: true, unicode: true);

  @override
  MentionMatch converter(String mention) {
    return MentionMatch(int.parse(mention.substring(2, mention.indexOf('|'))),
        mention.substring(mention.indexOf('|') + 1, mention.length - 1));
  }
}

class EmailMatch {
  String value;
  EmailMatch(this.value);
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

class LinkMatch {
  String value;
  LinkMatch(this.value);
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
