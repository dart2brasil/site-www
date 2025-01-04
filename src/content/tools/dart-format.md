---
ia-translate: true
title: dart format
description: Ferramenta de linha de comando para formatar código-fonte Dart.
---

Para atualizar seu código para seguir as
[diretrizes de formatação Dart][dart-guidelines],
use o comando `dart format`.
Essa formatação segue o que você obtém
ao usar um IDE ou editor com suporte a Dart.

{% render 'tools/dart-tool-note.md' %}

## Especificar arquivos para formatar {:#specify-files-to-format}

Para reformatar um ou mais arquivos Dart,
forneça uma lista de caminhos para os arquivos ou diretórios desejados.

### Especificar um caminho {:#specify-one-path}

Forneça o caminho para um arquivo ou diretório.
Se você especificar um diretório, `dart format` afetará apenas os arquivos no
diretório imediato; ele não percorre recursivamente os subdiretórios.

**Exemplo:** Para formatar todos os arquivos Dart no diretório atual ou abaixo dele:

```console
$ dart format .
```

### Especificar múltiplos caminhos {:#specify-multiple-paths}

Para especificar vários arquivos ou diretórios, use uma lista delimitada por espaços.

**Exemplo:** Para formatar todos os arquivos Dart no diretório `lib`,
mais um arquivo Dart no diretório `bin`:

```console
$ dart format lib bin/updater.dart
```

### Impedir a sobrescrita de arquivos Dart {:#prevent-overwriting-dart-files}

Por padrão, `dart format` **sobrescreve** os arquivos Dart.

* Para não sobrescrever os arquivos, adicione a flag `--output` ou `-o`.
* Para obter o conteúdo dos arquivos formatados, adicione `-o show` ou `-o json`.
* Para ver apenas quais arquivos _seriam_ alterados, adicione `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Notificar quando ocorrem alterações {:#notify-when-changes-occur}

Para fazer o `dart format` retornar um código de saída quando ocorrerem alterações de formatação,
adicione a flag `--set-exit-if-changed`.

* Se ocorrerem alterações, o comando `dart format` retorna um código de saída `1`.
* Se não ocorrerem alterações, o comando `dart format` retorna um código de saída `0`.

Use códigos de saída com sistemas de integração contínua (CI)
para que eles possam acionar outra ação em resposta ao código de saída.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## Usar vírgulas à direita {:#use-trailing-commas}

Use vírgulas opcionais à direita para uma melhor formatação automática.
Adicione uma vírgula à direita no final das listas de parâmetros em funções, métodos
e construtores.
Isso ajuda o formatador a inserir a quantidade apropriada de quebras de linha para
código no estilo Dart.

## Afeta apenas espaços em branco {:#affects-whitespace-only}

Para evitar fazer alterações que possam ser inseguras,
`dart format` afeta apenas espaços em branco.

Há muito mais para escrever código legível e
consistente do que apenas espaços em branco, no entanto.
Para saber mais sobre as melhores práticas para escrever e estilizar código Dart,
consulte o [guia de estilo Dart][].

## Saiba mais {:#learn-more}

Para saber mais sobre opções adicionais de linha de comando,
use o comando `dart help` ou consulte a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
