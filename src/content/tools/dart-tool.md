---
ia-translate: true
title: "dart: A ferramenta de linha de comando do Dart"
shortTitle: Dart CLI
description: >-
  Aprenda sobre o CLI 'dart' e seus subcomandos disponíveis.
---

A ferramenta `dart` é a interface de linha de comando para o [Dart SDK][].
A ferramenta está disponível independentemente de como você obtém o Dart SDK—seja
fazendo download do Dart SDK explicitamente
ou fazendo download apenas do [Flutter SDK][].

[Dart SDK]: /tools/sdk
[Flutter SDK]: {{site.flutter}}

## Exemplo de uso

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

## Comandos disponíveis

A tabela a seguir mostra quais comandos você pode usar com a ferramenta `dart`.

| Comando    | Formato do comando                                      | Mais informações                                                                                         |
|------------|--------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `analyze`  | <code>dart analyze [<DIRECTORY&#124;DART_FILE>]</code> | Analisa o código-fonte Dart do projeto.<br>[Saiba mais.][analyze]                                       |
| `build`    | `dart build <APP_TYPE>`                                | Compila um aplicativo Dart incluindo [code assets][].<br>[Saiba mais.][build]               |
| `compile`  | `dart compile <FORMAT>`                                | Compila Dart para vários formatos (executável nativo, JavaScript, WebAssembly).<br>[Saiba mais.][compile] |
| `create`   | `dart create <DIRECTORY>`                              | Cria um novo projeto.<br>[Saiba mais.][create]                                                          |
| `devtools` | `dart devtools`                                        | Abre o Dart DevTools, um conjunto de ferramentas de debugging e performance para Dart.<br>[Saiba mais.][devtools]     |
| `doc`      | `dart doc <DIRECTORY>`                                 | Gera documentação de referência da API.<br>[Saiba mais.][doc]                                             |
| `fix`      | <code>dart fix <DIRECTORY&#124;DART_FILE></code>       | Aplica correções automatizadas ao código-fonte Dart.<br>[Saiba mais.][fix]                                       |
| `format`   | <code>dart format <DIRECTORY&#124;DART_FILE></code>    | Formata o código-fonte Dart.<br>[Saiba mais.][format]                                                       |
| `info`     | `dart info`                                            | Exibe informações de diagnóstico das ferramentas Dart.<br>[Saiba mais.][info]                                      |
| `pub`      | `dart pub <PUB_COMMAND>`                               | Trabalha com pacotes.<br>Substitui `pub`.<br>[Saiba mais.][pub]                                            |
| `run`      | `dart run <DART_FILE>`                                 | Executa um programa Dart.<br>[Saiba mais.][run]                                                               |
| `test`     | <code>dart test <DIRECTORY&#124;DART_FILE></code>      | Executa testes neste pacote.<br>[Saiba mais.][test]                                                       |
| _(none)_   | `dart <DART_FILE>`                                     | Executa um programa Dart.<br>Prefira [`dart run`][run].                                                        |

{:.table .table-striped .nowrap}

[code assets]: /tools/hooks#assets

[analyze]: /tools/dart-analyze
[build]: /tools/dart-build
[compile]: /tools/dart-compile
[create]: /tools/dart-create
[devtools]: /tools/dart-devtools
[doc]: /tools/dart-doc
[fix]: /tools/dart-fix
[format]: /tools/dart-format
[info]: /tools/dart-info
[pub]: /tools/pub/cmd
[run]: /tools/dart-run
[test]: /tools/dart-test

## Saiba mais

Para obter ajuda com qualquer um dos comandos, execute `dart help <command>`.
Você também pode obter detalhes sobre os comandos `pub`.

```console
$ dart help pub outdated
```
