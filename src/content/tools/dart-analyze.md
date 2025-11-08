---
ia-translate: true
title: dart analyze
description: Ferramenta de linha de comando para análise estática
showToc: false
---

O comando `dart analyze`
executa a mesma [análise estática][static analysis]
que você obtém quando usa uma IDE ou editor que tem suporte ao Dart.

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de execução de análise estática sobre todos os arquivos Dart
no diretório atual:

```console
$ dart analyze
```

Você pode personalizar como o analyzer trata avisos e problemas de nível info.
Normalmente o analyzer reporta falha quando encontra quaisquer erros ou avisos,
mas não quando encontra problemas de nível info.
Você pode personalizar este comportamento usando as
flags `--fatal-infos` e `--no-fatal-warnings`.
Por exemplo, para fazer o analyzer falhar quando qualquer problema é encontrado,
use a flag `--fatal-infos`:

```console
$ dart analyze --fatal-infos
```

Você pode adicionar um argumento de diretório ou arquivo único:

```console
$ dart analyze [<DIRECTORY> | <DART_FILE>]
```

Por exemplo, aqui está o comando para analisar o diretório `bin`:

```console
$ dart analyze bin
```

:::version-note
Antes do Dart 2.13, `dart analyze` suportava apenas argumentos de diretório.
:::

Para personalizar a análise, use um arquivo de opções de análise
ou comentários especiais no código fonte Dart,
conforme descrito em [Personalizando a análise estática][static analysis].

Para informações sobre opções de linha de comando, use a flag `--help`:

```console
$ dart analyze --help
```

[static analysis]: /tools/analysis

{% comment %}
```
Usage: dart analyze [arguments] [<directory>]
-h, --help                   Print this usage information.
    --fatal-infos            Treat info level issues as fatal.
    --[no-]fatal-warnings    Treat warning level issues as fatal.
                             (defaults to on)
```
{% endcomment %}
