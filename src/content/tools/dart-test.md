---
ia-translate: true
title: dart test
description: Ferramenta de linha de comando para testar projetos Dart.
showToc: false
---

O comando `dart test` executa testes que
dependem do [pacote `test`][`test` package] e
estão no diretório `test` do projeto Dart atual.
Para informações sobre como escrever testes, consulte a
[documentação de testes][testing documentation].
Se você estiver trabalhando em código Flutter, use o comando `flutter test`,
conforme descrito em [Testing Flutter apps][].

[testing documentation]: /tools/testing
[`test` package]: {{site.pub-pkg}}/test
[Testing Flutter apps]: {{site.flutter-docs}}/testing

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de uso do `dart test` para executar todos os testes
que estão no diretório `test` do projeto atual:

```console
$ cd my_app
$ dart test
```

Para controlar quais testes executam, você pode adicionar os caminhos para
diretórios ou arquivos no diretório `test`:

{% comment %}
  I ran these commands in site-www/misc
{% endcomment %}

```console
$ dart test test/library_tour/io_test.dart
00:00 +0: readAsString, readAsLines
00:00 +1: readAsBytes
...
```

Outra maneira de executar um subconjunto de testes é usar a flag `--name` (`-n`),
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
apenas os testes que correspondem a _todas_ as condições executam:

```console
$ dart test --name String --name print
00:00 +0: test/library_tour/core_test.dart: print: print(nonString)
00:00 +1: test/library_tour/core_test.dart: print: print(String)
00:00 +2: All tests passed!
```

O comando `dart test` tem muito mais flags para controlar
quais testes executam,
como eles executam (por exemplo, concorrência e timeout), e
onde e como a saída aparece.
Para mais informações sobre opções de linha de comando,
consulte o [pacote `test`][`test` package] ou
use a flag `--help`:

```console
$ dart test --help
```
