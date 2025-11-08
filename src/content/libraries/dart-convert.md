---
ia-translate: true
title: "dart:convert"
description: "Saiba mais sobre os principais recursos na biblioteca dart:convert do Dart."
prevpage:
  url: /libraries/dart-math
  title: dart:math
nextpage:
  url: /libraries/dart-io
  title: dart:io
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

A biblioteca `dart:convert` ([referência da API][dart:convert])
possui conversores para JSON e UTF-8, bem como suporte para criar
conversores adicionais. [JSON][] é um formato de texto simples para representar
objetos e coleções estruturadas. [UTF-8][] é uma codificação comum de largura variável
que pode representar todos os caracteres no conjunto de
caracteres Unicode.

Para usar esta biblioteca, importe `dart:convert`.

<?code-excerpt "misc/test/library_tour/convert_test.dart (import)"?>
```dart
import 'dart:convert';
```


## Decodificando e codificando JSON {:#decoding-and-encoding-json}

Decodifique uma string codificada em JSON para um objeto Dart com `jsonDecode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-decode)"?>
```dart
// NOTE: Be sure to use double quotes ("),
// not single quotes ('), inside the JSON string.
// This string is JSON, not Dart.
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
```

Codifique um objeto Dart suportado em uma string formatada em JSON com
`jsonEncode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-encode)"?>
```dart
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null},
];

var jsonText = jsonEncode(scores);
assert(
  jsonText ==
      '[{"score":40},{"score":80},'
          '{"score":100,"overtime":true,'
          '"special_guest":null}]',
);
```

Apenas objetos do tipo `int`, `double`, `String`, `bool`, `null`, `List`, ou `Map` (com
chaves de string) são diretamente codificáveis em JSON. Objetos `List` e `Map` são
codificados recursivamente.

Você tem duas opções para codificar objetos que não são diretamente
codificáveis. A primeira é invocar `jsonEncode()` com um segundo argumento: uma
função que retorna um objeto que é diretamente codificável. Sua segunda
opção é omitir o segundo argumento, caso em que o codificador chama
o método `toJson()` do objeto.

Para mais exemplos e links para pacotes relacionados a JSON, consulte
[Usando JSON](/libraries/serialization/json).


## Decodificando e codificando caracteres UTF-8 {:#decoding-and-encoding-utf-8-characters}

Use `utf8.decode()` para decodificar bytes codificados em UTF8 para uma string Dart:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-decode)" replace="/ \/\/line-br.*//g"?>
```dart
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1,
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
```

Para converter um stream de caracteres UTF-8 em uma string Dart, especifique
`utf8.decoder` para o método `transform()` do Stream:

<?code-excerpt "misc/test/library_tour/io_test.dart (utf8-decoder)" replace="/utf8.decoder/[!$&!]/g"?>
```dart
var lines = [!utf8.decoder!].bind(inputStream).transform(const LineSplitter());
try {
  await for (final line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
```

Use `utf8.encode()` para codificar uma string Dart como uma lista de bytes
codificados em UTF8:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-encode)" replace="/ \/\/line-br.*//g"?>
```dart
Uint8List encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
```


## Outras funcionalidades {:#other-functionality}

A biblioteca `dart:convert` também possui conversores para ASCII e ISO-8859-1
(Latin1). Para mais detalhes, consulte a [referência da API para a biblioteca `dart:convert`][dart:convert].

[JSON]: https://www.json.org/
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[dart:convert]: {{site.dart-api}}/dart-convert/dart-convert-library.html
