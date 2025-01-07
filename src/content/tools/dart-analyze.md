---
ia-translate: true
title: dart analyze
description: Ferramenta de linha de comando para análise estática
toc: false
---

O comando `dart analyze`
executa a mesma [análise estática][static analysis]
que você obtém quando usa um IDE ou editor que tem suporte a Dart.

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de como realizar a análise estática em todos os arquivos
Dart no diretório atual:

```console
$ dart analyze
```

Você pode customizar como o analisador trata avisos e problemas em nível de informação.
Normalmente o analisador reporta falha quando encontra quaisquer erros ou avisos,
mas não quando encontra problemas em nível de informação.
Você pode customizar este comportamento usando as
flags `--fatal-infos` e `--no-fatal-warnings`.
Por exemplo, para fazer o analisador falhar quando encontrar qualquer problema use
a flag `--fatal-infos`:

```console
$ dart analyze --fatal-infos
```

Você pode adicionar um diretório ou um argumento de arquivo único:

```console
$ dart analyze [<DIRETÓRIO> | <ARQUIVO_DART>]
```

Por exemplo, aqui está o comando para analisar o diretório `bin`:

```console
$ dart analyze bin
```

:::version-note
Antes do Dart 2.13, `dart analyze` suportava apenas argumentos de diretório.
:::

Para customizar a análise, use um arquivo de opções de análise
ou comentários especiais no código-fonte Dart,
como descrito em [Customizando análise estática][static analysis].

Para informações sobre as opções de linha de comando, use a flag `--help`:

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
