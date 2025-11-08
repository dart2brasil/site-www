---
ia-translate: true
title: dart test
description: Command-line tool for testing Dart projects.
showToc: false
---

O comando `dart test` executa testes que
dependem do [`test` package][] (pacote `test`) e
estão no diretório `test` do projeto Dart atual.
Para obter informações sobre como escrever testes, consulte a
[documentação de testes][].
Se você estiver trabalhando com código Flutter, use o comando `flutter test` em vez disso,
como descrito em [Testando aplicativos Flutter][].

[documentação de testes]: /tools/testing
[`test` package]: {{site.pub-pkg}}/test
[Testando aplicativos Flutter]: {{site.flutter-docs}}/testing

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de como usar `dart test` para executar todos os testes
que estão no diretório `test` do projeto atual:

```console
$ cd my_app
$ dart test
```

Para controlar quais testes são executados, você pode adicionar os caminhos para
diretórios ou arquivos no diretório `test`:

{% comment %}
  Eu executei esses comandos em site-www/misc
{% endcomment %}

```console
$ dart test test/library_tour/io_test.dart
00:00 +0: readAsString, readAsLines
00:00 +1: readAsBytes
...
```

Outra forma de executar um subconjunto de testes é usar a flag `--name` (`-n`),
`--tags` (`-t`), ou `--exclude-tags` (`-x`),
adicionando parte ou toda a string para corresponder:

```console
$ dart test --name String
00:00 +0: test/library_tour/io_test.dart: readAsString, readAsLines
00:00 +1: test/library_tour/core_test.dart: print: print(nonString)
00:00 +2: test/library_tour/core_test.dart: print: print(String)
00:00 +3: test/library_tour/core_test.dart: numbers: toString()
...
```

Quando você usa essas flags mais de uma vez na mesma linha de comando,
apenas os testes que correspondem a _todas_ as condições são executados:

```console
$ dart test --name String --name print
00:00 +0: test/library_tour/core_test.dart: print: print(nonString)
00:00 +1: test/library_tour/core_test.dart: print: print(String)
00:00 +2: All tests passed!
```

O comando `dart test` possui muitas outras flags para controlar
quais testes são executados,
como eles são executados (por exemplo, concorrência e timeout), e
onde e como a saída aparece.
Para mais informações sobre opções de linha de comando,
consulte o [`test` package][] (pacote `test`) ou
use a flag `--help`:

```console
$ dart test --help
