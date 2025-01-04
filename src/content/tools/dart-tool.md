---
ia-translate: true
title: "dart: A ferramenta de linha de comando do Dart"
description: "A página de referência para usar 'dart' em uma janela de terminal."
toc: false
---

A ferramenta `dart` (`bin/dart`)
é uma interface de linha de comando para o [Dart SDK](/tools/sdk).
A ferramenta está disponível independentemente de como você obtém o Dart SDK —
seja baixando o Dart SDK explicitamente
ou baixando apenas o [Flutter SDK.]({{site.flutter}})

Veja como você pode usar a ferramenta `dart`
para criar, analisar, testar e executar um app:

```console
$ dart create -t console my_app
$ cd my_app
$ dart analyze
$ dart test
$ dart run bin/my_app.dart
```

Você também pode executar comandos [`pub`][pub] usando a ferramenta `dart`:

```console
$ dart pub get
$ dart pub outdated
$ dart pub upgrade
```

A tabela a seguir mostra quais comandos você pode usar com a ferramenta `dart`.
Se você está desenvolvendo para o Flutter,
pode usar a ferramenta [`flutter`][] em vez disso.

[`flutter` tool]: {{site.flutter-docs}}/reference/flutter-cli

<code>&#124;</code>

| Comando   | Exemplo de uso                                          | Mais informações                                                                                             |
|-----------|---------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `analyze` | <code>dart analyze [<DIRECTORY&#124;DART_FILE>]</code> | Analisa o código-fonte Dart do projeto.<br>[Saiba mais.][analyze]                                             |
| `compile` | `dart compile exe <DART_FILE>`                          | Compila o Dart para vários formatos.<br>Substitui `dart2js` e `dart2native`.<br>[Saiba mais.][compile]         |
| `create`  | `dart create <DIRECTORY>`                               | Cria um novo projeto.<br>[Saiba mais.][create]                                                                |
| `doc`     | `dart doc <DIRECTORY>`                                  | Gera documentação de referência da API.<br>Substitui [`dartdoc`][].<br>[Saiba mais.][doc]                     |
| `fix`     | <code>dart fix <DIRECTORY&#124;DART_FILE></code>       | Aplica correções automatizadas ao código-fonte Dart.<br>[Saiba mais.][fix]                                     |
| `format`  | <code>dart format <DIRECTORY&#124;DART_FILE></code>    | Formata o código-fonte Dart.<br>[Saiba mais.][format]                                                             |
| `info`    | `dart info`                                            | Exibe informações de diagnóstico de ferramentas Dart.<br>[Saiba mais.][info]                                  |
| `pub`     | `dart pub <PUB_COMMAND>`                                | Trabalha com packages (pacotes).<br>Substitui `pub`.<br>[Saiba mais.][pub]                                   |
| `run`     | `dart run <DART_FILE>`                                  | Executa um programa Dart.<br>Substitui o comando pré-existente da VM Dart (`dart` sem comando).<br>[Saiba mais.][run] |
| `test`    | <code>dart test <DIRECTORY&#124;DART_FILE></code>      | Executa testes neste package.<br>Substitui `pub run test`.<br>[Saiba mais.][test]                               |
| _(none)_  | `dart <DART_FILE>`                                      | Executa um programa Dart; idêntico ao comando pré-existente da VM Dart.<br>Prefira [`dart run`][run].         |

{:.table .table-striped .nowrap}

[analyze]: /tools/dart-analyze
[compile]: /tools/dart-compile
[create]: /tools/dart-create
[doc]: /tools/dart-doc
[fix]: /tools/dart-fix
[format]: /tools/dart-format
[info]: /tools/dart-info
[pub]: /tools/pub/cmd
[run]: /tools/dart-run
[test]: /tools/dart-test

Para obter ajuda com qualquer um dos comandos, digite `dart help <command>`.
Você também pode obter detalhes sobre os comandos `pub`.

```console
$ dart help pub outdated
```

[`dartdoc`]: {{site.pub-pkg}}/dartdoc
