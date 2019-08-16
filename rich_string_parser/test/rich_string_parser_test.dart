import 'package:rich_string_parser/rich_string_parser.dart';
import 'package:rich_string_parser/src/rich_string_parser_base.dart';
import "package:test/test.dart";


void main() {
  group('Should find mentions', () {
    test("find mention", () {
      var string = ' asd @(123|richard) asd ';
      List<dynamic> result = richStringParser(
        string,
        [
          MentionParser(),
        ]
      );

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<MentionMatch>(), ' asd ']));
    });

    test("find all mentions", () {
      var string = ' asd @(123|richard)@(123|richard) asd @(123|richard) hej';
      List<dynamic> result = richStringParser(
        string,
        [
          MentionParser(),
        ]
      );

      expect(result.length, equals(6));
      expect(result, equals([' asd ', isA<MentionMatch>(), isA<MentionMatch>(), ' asd ', isA<MentionMatch>(), ' hej']));
    });
  });

  group('Should find links', () {
    test("find link", () {
      var string = ' asd https://plantr.online asd ';
      List<dynamic> result = richStringParser(
        string,
        [
          LinkParser(),
        ]
      );

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<LinkMatch>(), ' asd ']));
    });

    test("find all links", () {
      var string = ' asd http://richardsoderman.se asd https://plantr.online hej';
      List<dynamic> result = richStringParser(
        string,
        [
          LinkParser(),
        ]
      );

      expect(result.length, equals(5));
      expect(result, equals([' asd ', isA<LinkMatch>(), ' asd ', isA<LinkMatch>(), ' hej']));
    });
  });

  group('Should find emails', () {
    test("Should find email", () {
      var string = ' asd asd@asd.com hej';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
        ]
      );

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<EmailMatch>(), ' hej']));
    });

    test("Should find all emails", () {
      var string = ' asd asd@asd.com asd asd joans@jonas.com asd';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
        ]
      );

      expect(result.length, equals(5));
      expect(result, equals([' asd ', isA<EmailMatch>(), ' asd asd ', isA<EmailMatch>(), ' asd']));
    });
  });

  group('should find email and mention', () {
    test("Should find email and mention", () {
      var string = ' asd asd@asd.com asd @(123|richard)asd';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
          MentionParser(),
        ]
      );

      expect(result.length, equals(5));
      expect(result, equals([' asd ', isA<EmailMatch>(), ' asd ', isA<MentionMatch>(), 'asd']));
    });

    test("Should find all emails and mentions", () {
      var string = ' asd asd@asd.com asd @(123|richard)asd @(123|richard) asd@asd.com';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
          MentionParser(),
        ]
      );

      expect(result.length, equals(8));
      expect(result, equals([' asd ', isA<EmailMatch>(), ' asd ', isA<MentionMatch>(), 'asd ', isA<MentionMatch>(), ' ', isA<EmailMatch>()]));
    });
  });

  group('Should not find any matches', () {
    test("Should not find email", () {
      var string = ' asd asd hello hej';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
        ]
      );

      expect(result.length, equals(1));
      expect(result, equals([' asd asd hello hej']));
    });

    test("Should find all email or mention", () {
      var string = ' asd eric asd asd example asd';
      List<dynamic> result = richStringParser(
        string,
        [
          EmailParser(),
          MentionParser(),
        ]
      );

      expect(result.length, equals(1));
      expect(result, equals([' asd eric asd asd example asd']));
    });
  });

}

