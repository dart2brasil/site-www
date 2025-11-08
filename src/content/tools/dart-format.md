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

Provide the path to one file or directory.
If you pass a directory path,
`dart format` recurses into its subdirectories as well.

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

## What changes?

`dart format` makes the following formatting changes:

* Removes whitespace.
* Wraps every line to 80 characters long or shorter.
* Adds trailing commas to any argument or parameter list
that splits across multiple lines, and removes them from ones that don't.
* Might move comments before or after a comma.

To learn more about best practices for writing and styling Dart code,
check out the [Dart style guide][].

### Configuring formatter page width

When you run `dart format`, the formatter defaults to
80 character line length or shorter. 
If you'd like to configure the line length for your project,
you can add a top-level `formatter` section to the
[`analysis_options.yaml`][] file, like so:

```yaml title="analysis_options.yaml"
formatter:
  page_width: 123
```

With the analysis options file typically at the root,
the configured line length will apply to everything in the package.

You can also configure individual files' line length,
overriding the analysis options file,
with a marker comment at the top of the file before any other code:

```dart
// dart format width=123
```

:::version-note
Configurable page width requires
a [language version][] of at least 3.7.
:::

## Learn more

Para saber mais sobre opções adicionais de linha de comando,
use o comando `dart help` ou consulte a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

Check out the [formatter FAQ][] for more context behind formatting decisions.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ