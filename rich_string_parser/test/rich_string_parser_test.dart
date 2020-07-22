import 'package:rich_string_parser/rich_string_parser.dart';
import 'package:rich_string_parser/src/rich_string_parser_base.dart';
import 'package:test/test.dart';

void main() {
  group('Should find mentions', () {
    test('find mention', () {
      var string = ' asd @(123|richard) asd ';
      var result = richStringParser(string, [
        MentionParser(),
      ]);

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<MentionMatch>(), ' asd ']));
    });

    test('find all mentions', () {
      var string = ' asd @(123|richard)@(123|richard) asd @(123|richard) hej';
      var result = richStringParser(string, [
        MentionParser(),
      ]);

      expect(result.length, equals(6));
      expect(
          result,
          equals([
            ' asd ',
            isA<MentionMatch>(),
            isA<MentionMatch>(),
            ' asd ',
            isA<MentionMatch>(),
            ' hej'
          ]));
    });
  });

  group('Should find links', () {
    test('find link', () {
      var string = ' asd https://plantr.online asd ';
      var result = richStringParser(string, [
        LinkParser(),
      ]);

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<LinkMatch>(), ' asd ']));
    });

    test('find all links', () {
      var string =
          ' asd http://richardsoderman.se asd https://plantr.online hej';
      var result = richStringParser(string, [
        LinkParser(),
      ]);

      expect(result.length, equals(5));
      expect(
          result,
          equals(
              [' asd ', isA<LinkMatch>(), ' asd ', isA<LinkMatch>(), ' hej']));
    });
  });

  group('Should find emails', () {
    test('Should find email', () {
      var string = ' asd asd@asd.com hej';
      var result = richStringParser(string, [
        EmailParser(),
      ]);

      expect(result.length, equals(3));
      expect(result, equals([' asd ', isA<EmailMatch>(), ' hej']));
    });

    test('Should find all emails', () {
      var string = ' asd asd@asd.com asd asd joans@jonas.com asd';
      var result = richStringParser(string, [
        EmailParser(),
      ]);

      expect(result.length, equals(5));
      expect(
          result,
          equals([
            ' asd ',
            isA<EmailMatch>(),
            ' asd asd ',
            isA<EmailMatch>(),
            ' asd'
          ]));
    });
  });

  group('should find email and mention', () {
    test('Should find email and mention', () {
      var string = ' asd asd@asd.com asd @(123|richard)asd';
      var result = richStringParser(string, [
        EmailParser(),
        MentionParser(),
      ]);

      expect(result.length, equals(5));
      expect(
          result,
          equals([
            ' asd ',
            isA<EmailMatch>(),
            ' asd ',
            isA<MentionMatch>(),
            'asd'
          ]));
    });

    test('Should find all emails and mentions', () {
      var string =
          ' asd asd@asd.com asd @(123|richard)asd @(123|richard) asd@asd.com';
      var result = richStringParser(string, [
        EmailParser(),
        MentionParser(),
      ]);

      expect(result.length, equals(8));
      expect(
          result,
          equals([
            ' asd ',
            isA<EmailMatch>(),
            ' asd ',
            isA<MentionMatch>(),
            'asd ',
            isA<MentionMatch>(),
            ' ',
            isA<EmailMatch>()
          ]));
    });
  });

  group('Should not find any matches', () {
    test('Should not find email', () {
      var string = ' asd asd hello hej';
      var result = richStringParser(string, [
        EmailParser(),
      ]);

      expect(result.length, equals(1));
      expect(result, equals([' asd asd hello hej']));
    });

    test('Should find all email or mention', () {
      var string = ' asd eric asd asd example asd';
      var result = richStringParser(string, [
        EmailParser(),
        MentionParser(),
      ]);

      expect(result.length, equals(1));
      expect(result, equals([' asd eric asd asd example asd']));
    });
  });

  group('performance', () {
    test('faster than 12 milliseconds', () {
      var string =
          'Lorem http://example.com ipsum dolor example@example.com sit amet http://example.com consectetur adipiscing elit mi @(1235|asdf) habitasse enim, quam pharetra tempor ligula example@example.com venenatis nec dis http://example.com vulputate morbi example@example.com , neque dictum nisl lacinia curae cras example@example2.com @(1235|asdf) orci natoque feugiat. Sociosqu bibendum augue potenti sapien integer http://example.com http://example.com http://example.com http://example.com http://example.com dui hendrerit non ac magnis gravida, cubilia example@example3.com turpis mattis ut eleifend facilisis @(1235|asdf) auctor urna http://example.com ante inceptos dignissim, torquent nulla consequat example@example5.com sed hac tellus http://example.com magna malesuada praesent interdum. Ridiculus @(1235|asdf) vel nunc elementum http://example.com ullamcorper varius accumsan fusce, rhoncus nostra pulvinar http://example.com eros molestie tortor, vestibulum convallis libero commodo faucibus mus. Est http://example.com nisi per scelerisque leo a vivamus http://example.com ultrices conubia example@example.com ornare @(1235|asdf) example@example.com montes curabitur facilisi, pretium sociis odio et posuere imperdiet penatibus condimentum nam senectus arcu aliquam, http://example.com quisque risus @(1235|asdf) diam class nascetur mauris suspendisse lacus porta metus semper. Ad aptent cursus ultricies aenean volutpat netus, dictumst etiam duis @(1235|asdf) in massa eu tristique, euismod http://example.com fames example@example.com primis egestas maecenas. Erat sem himenaeos porttitor proin pellentesque viverra dapibus lectus @(1235|asdf) congue sollicitudin, litora eget placerat id quis phasellus nullam sodales tincidunt, fermentum http://example.com iaculis felis @(1235|asdf) taciti donec vitae suscipit cum lobortis. example@example.com At parturient aliquet vehicula nibh example@example.com laoreet velit tempus sagittis justo, example@example.com luctus fringilla purus @(1235|asdf) platea rutrum mollis example@example.com blandit. Habitant phasellus dictum dui iaculis sed example@example.com integer netus litora, elementum @(1235|asdf) @(1235|asdf) purus fringilla example@example.com eget venenatis quisque eu, mauris suscipit viverra pharetra a sagittis http://example.com eleifend. Arcu nisi nunc non cursus condimentum nec hendrerit mattis velit, @(1235|asdf) ante auctor turpis massa platea http://example.com consequat taciti neque vehicula tempor, egestas maecenas odio @(1235|asdf) felis etiam http://example.com proin nascetur imperdiet @(1235|asdf). Lorem http://example.com ipsum dolor example@example.com sit amet http://example.com consectetur adipiscing elit mi @(1235|asdf) habitasse enim, quam pharetra tempor ligula example@example.com venenatis nec dis http://example.com vulputate morbi example@example.com , neque dictum nisl lacinia curae cras example@example2.com @(1235|asdf) orci natoque feugiat. Sociosqu bibendum augue potenti sapien integer http://example.com http://example.com http://example.com http://example.com http://example.com dui hendrerit non ac magnis gravida, cubilia example@example3.com turpis mattis ut eleifend facilisis @(1235|asdf) auctor urna http://example.com ante inceptos dignissim, torquent nulla consequat example@example5.com sed hac tellus http://example.com magna malesuada praesent interdum. Ridiculus @(1235|asdf) vel nunc elementum http://example.com ullamcorper varius accumsan fusce, rhoncus nostra pulvinar http://example.com eros molestie tortor, vestibulum convallis libero commodo faucibus mus. Est http://example.com nisi per scelerisque leo a vivamus http://example.com ultrices conubia example@example.com ornare @(1235|asdf) example@example.com montes curabitur facilisi, pretium sociis odio et posuere imperdiet penatibus condimentum nam senectus arcu aliquam, http://example.com quisque risus @(1235|asdf) diam class nascetur mauris suspendisse lacus porta metus semper. Ad aptent cursus ultricies aenean volutpat netus, dictumst etiam duis @(1235|asdf) in massa eu tristique, euismod http://example.com fames example@example.com primis egestas maecenas. Erat sem himenaeos porttitor proin pellentesque viverra dapibus lectus @(1235|asdf) congue sollicitudin, litora eget placerat id quis phasellus nullam sodales tincidunt, fermentum http://example.com iaculis felis @(1235|asdf) taciti donec vitae suscipit cum lobortis. example@example.com At parturient aliquet vehicula nibh example@example.com laoreet velit tempus sagittis justo, example@example.com luctus fringilla purus @(1235|asdf) platea rutrum mollis example@example.com blandit. Habitant phasellus dictum dui iaculis sed example@example.com integer netus litora, elementum @(1235|asdf) @(1235|asdf) purus fringilla example@example.com eget venenatis quisque eu, mauris suscipit viverra pharetra a sagittis http://example.com eleifend. Arcu nisi nunc non cursus condimentum nec hendrerit mattis velit, @(1235|asdf) ante auctor turpis massa platea http://example.com consequat taciti neque vehicula tempor, egestas maecenas odio @(1235|asdf) felis etiam http://example.com proin nascetur imperdiet @(1235|asdf). Lorem http://example.com ipsum dolor example@example.com sit amet http://example.com consectetur adipiscing elit mi @(1235|asdf) habitasse enim, quam pharetra tempor ligula example@example.com venenatis nec dis http://example.com vulputate morbi example@example.com , neque dictum nisl lacinia curae cras example@example2.com @(1235|asdf) orci natoque feugiat. Sociosqu bibendum augue potenti sapien integer http://example.com http://example.com http://example.com http://example.com http://example.com dui hendrerit non ac magnis gravida, cubilia example@example3.com turpis mattis ut eleifend facilisis @(1235|asdf) auctor urna http://example.com ante inceptos dignissim, torquent nulla consequat example@example5.com sed hac tellus http://example.com magna malesuada praesent interdum. Ridiculus @(1235|asdf) vel nunc elementum http://example.com ullamcorper varius accumsan fusce, rhoncus nostra pulvinar http://example.com eros molestie tortor, vestibulum convallis libero commodo faucibus mus. Est http://example.com nisi per scelerisque leo a vivamus http://example.com ultrices conubia example@example.com ornare @(1235|asdf) example@example.com montes curabitur facilisi, pretium sociis odio et posuere imperdiet penatibus condimentum nam senectus arcu aliquam, http://example.com quisque risus @(1235|asdf) diam class nascetur mauris suspendisse lacus porta metus semper. Ad aptent cursus ultricies aenean volutpat netus, dictumst etiam duis @(1235|asdf) in massa eu tristique, euismod http://example.com fames example@example.com primis egestas maecenas. Erat sem himenaeos porttitor proin pellentesque viverra dapibus lectus @(1235|asdf) congue sollicitudin, litora eget placerat id quis phasellus nullam sodales tincidunt, fermentum http://example.com iaculis felis @(1235|asdf) taciti donec vitae suscipit cum lobortis. example@example.com At parturient aliquet vehicula nibh example@example.com laoreet velit tempus sagittis justo, example@example.com luctus fringilla purus @(1235|asdf) platea rutrum mollis example@example.com blandit. Habitant phasellus dictum dui iaculis sed example@example.com integer netus litora, elementum @(1235|asdf) @(1235|asdf) purus fringilla example@example.com eget venenatis quisque eu, mauris suscipit viverra pharetra a sagittis http://example.com eleifend. Arcu nisi nunc non cursus condimentum nec hendrerit mattis velit, @(1235|asdf) ante auctor turpis massa platea http://example.com consequat taciti neque vehicula tempor, egestas maecenas odio @(1235|asdf) felis etiam http://example.com proin nascetur imperdiet @(1235|asdf). Lorem http://example.com ipsum dolor example@example.com sit amet http://example.com consectetur adipiscing elit mi @(1235|asdf) habitasse enim, quam pharetra tempor ligula example@example.com venenatis nec dis http://example.com vulputate morbi example@example.com , neque dictum nisl lacinia curae cras example@example2.com @(1235|asdf) orci natoque feugiat. Sociosqu bibendum augue potenti sapien integer http://example.com http://example.com http://example.com http://example.com http://example.com dui hendrerit non ac magnis gravida, cubilia example@example3.com turpis mattis ut eleifend facilisis @(1235|asdf) auctor urna http://example.com ante inceptos dignissim, torquent nulla consequat example@example5.com sed hac tellus http://example.com magna malesuada praesent interdum. Ridiculus @(1235|asdf) vel nunc elementum http://example.com ullamcorper varius accumsan fusce, rhoncus nostra pulvinar http://example.com eros molestie tortor, vestibulum convallis libero commodo faucibus mus. Est http://example.com nisi per scelerisque leo a vivamus http://example.com ultrices conubia example@example.com ornare @(1235|asdf) example@example.com montes curabitur facilisi, pretium sociis odio et posuere imperdiet penatibus condimentum nam senectus arcu aliquam, http://example.com quisque risus @(1235|asdf) diam class nascetur mauris suspendisse lacus porta metus semper. Ad aptent cursus ultricies aenean volutpat netus, dictumst etiam duis @(1235|asdf) in massa eu tristique, euismod http://example.com fames example@example.com primis egestas maecenas. Erat sem himenaeos porttitor proin pellentesque viverra dapibus lectus @(1235|asdf) congue sollicitudin, litora eget placerat id quis phasellus nullam sodales tincidunt, fermentum http://example.com iaculis felis @(1235|asdf) taciti donec vitae suscipit cum lobortis. example@example.com At parturient aliquet vehicula nibh example@example.com laoreet velit tempus sagittis justo, example@example.com luctus fringilla purus @(1235|asdf) platea rutrum mollis example@example.com blandit. Habitant phasellus dictum dui iaculis sed example@example.com integer netus litora, elementum @(1235|asdf) @(1235|asdf) purus fringilla example@example.com eget venenatis quisque eu, mauris suscipit viverra pharetra a sagittis http://example.com eleifend. Arcu nisi nunc non cursus condimentum nec hendrerit mattis velit, @(1235|asdf) ante auctor turpis massa platea http://example.com consequat taciti neque vehicula tempor, egestas maecenas odio @(1235|asdf) felis etiam http://example.com proin nascetur imperdiet @(1235|asdf). Lorem http://example.com ipsum dolor example@example.com sit amet http://example.com consectetur adipiscing elit mi @(1235|asdf) habitasse enim, quam pharetra tempor ligula example@example.com venenatis nec dis http://example.com vulputate morbi example@example.com , neque dictum nisl lacinia curae cras example@example2.com @(1235|asdf) orci natoque feugiat. Sociosqu bibendum augue potenti sapien integer http://example.com http://example.com http://example.com http://example.com http://example.com dui hendrerit non ac magnis gravida, cubilia example@example3.com turpis mattis ut eleifend facilisis @(1235|asdf) auctor urna http://example.com ante inceptos dignissim, torquent nulla consequat example@example5.com sed hac tellus http://example.com magna malesuada praesent interdum. Ridiculus @(1235|asdf) vel nunc elementum http://example.com ullamcorper varius accumsan fusce, rhoncus nostra pulvinar http://example.com eros molestie tortor, vestibulum convallis libero commodo faucibus mus. Est http://example.com nisi per scelerisque leo a vivamus http://example.com ultrices conubia example@example.com ornare @(1235|asdf) example@example.com montes curabitur facilisi, pretium sociis odio et posuere imperdiet penatibus condimentum nam senectus arcu aliquam, http://example.com quisque risus @(1235|asdf) diam class nascetur mauris suspendisse lacus porta metus semper. Ad aptent cursus ultricies aenean volutpat netus, dictumst etiam duis @(1235|asdf) in massa eu tristique, euismod http://example.com fames example@example.com primis egestas maecenas. Erat sem himenaeos porttitor proin pellentesque viverra dapibus lectus @(1235|asdf) congue sollicitudin, litora eget placerat id quis phasellus nullam sodales tincidunt, fermentum http://example.com iaculis felis @(1235|asdf) taciti donec vitae suscipit cum lobortis. example@example.com At parturient aliquet vehicula nibh example@example.com laoreet velit tempus sagittis justo, example@example.com luctus fringilla purus @(1235|asdf) platea rutrum mollis example@example.com blandit. Habitant phasellus dictum dui iaculis sed example@example.com integer netus litora, elementum @(1235|asdf) @(1235|asdf) purus fringilla example@example.com eget venenatis quisque eu, mauris suscipit viverra pharetra a sagittis http://example.com eleifend. Arcu nisi nunc non cursus condimentum nec hendrerit mattis velit, @(1235|asdf) ante auctor turpis massa platea http://example.com consequat taciti neque vehicula tempor, egestas maecenas odio @(1235|asdf) felis etiam http://example.com proin nascetur imperdiet @(1235|asdf).';

      var start = DateTime.now();
      richStringParser(string, [
        EmailParser(),
        LinkParser(),
        MentionParser(),
      ]);
      var end = DateTime.now();

      var diff = end.difference(start).inMilliseconds;

      expect(diff, lessThanOrEqualTo(12));
    });
  });
}
