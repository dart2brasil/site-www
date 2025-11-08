---
ia-translate: true
title: dart format
description: Ferramenta de linha de comando para formatar código fonte Dart.
---

Para atualizar seu código para seguir as
[diretrizes de formatação do Dart][dart-guidelines],
use o comando `dart format`.
Esta formatação segue o que você obtém
ao usar uma IDE ou editor com suporte ao Dart.

{% render 'tools/dart-tool-note.md' %}

## Especificar arquivos para formatar

Para reformatar um ou mais arquivos Dart,
forneça uma lista de caminhos para os arquivos ou diretórios desejados.

### Especificar um caminho

Forneça o caminho para um arquivo ou diretório.
Se você passar um caminho de diretório,
`dart format` percorre recursivamente seus subdiretórios também.

**Exemplo:** Para formatar todos os arquivos Dart em ou sob o diretório atual:

```console
$ dart format .
```

### Especificar vários caminhos

Para especificar vários arquivos ou diretórios, use uma lista delimitada por espaços.

**Exemplo:** Para formatar todos os arquivos Dart sob o diretório `lib`,
mais um arquivo Dart sob o diretório `bin`:

```console
$ dart format lib bin/updater.dart
```

### Prevenir sobrescrita de arquivos Dart

Por padrão, `dart format` **sobrescreve** os arquivos Dart.

* Para não sobrescrever os arquivos, adicione a flag `--output` ou `-o`.
* Para obter o conteúdo dos arquivos formatados, adicione `-o show` ou `-o json`.
* Para ver apenas quais arquivos _mudariam_, adicione `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Notificar quando mudanças ocorrerem

Para fazer o `dart format` retornar um código de saída quando mudanças de formatação ocorrerem,
adicione a flag `--set-exit-if-changed`.

* Se mudanças ocorrerem, o comando `dart format` retorna um código de saída de `1`.
* Se mudanças não ocorrerem, o comando `dart format` retorna um código de saída de `0`.

Use códigos de saída com sistemas de integração contínua (CI)
para que eles possam acionar outra ação em resposta ao código de saída.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## O que muda?

`dart format` faz as seguintes mudanças de formatação:

* Remove espaços em branco.
* Quebra cada linha em 80 caracteres ou menos.
* Adiciona vírgulas finais a qualquer lista de argumentos ou parâmetros
que se divide em várias linhas, e as remove das que não dividem.
* Pode mover comentários antes ou depois de uma vírgula.

Para aprender mais sobre melhores práticas para escrever e estilizar código Dart,
confira o [guia de estilo Dart][Dart style guide].

### Configurando largura de página do formatador

Quando você executa `dart format`, o formatador usa por padrão
comprimento de linha de 80 caracteres ou menos.
Se você gostaria de configurar o comprimento de linha para seu projeto,
você pode adicionar uma seção de nível superior `formatter` ao
arquivo [`analysis_options.yaml`][], assim:

```yaml title="analysis_options.yaml"
formatter:
  page_width: 123
```

Com o arquivo de opções de análise tipicamente na raiz,
o comprimento de linha configurado se aplicará a tudo no pacote.

Você também pode configurar o comprimento de linha de arquivos individuais,
sobrescrevendo o arquivo de opções de análise,
com um comentário marcador no topo do arquivo antes de qualquer outro código:

```dart
// dart format width=123
```

:::version-note
Largura de página configurável requer
uma [versão de linguagem][language version] de pelo menos 3.7.
:::

## Saiba mais

Para aprender sobre opções adicionais de linha de comando,
use o comando `dart help` ou consulte a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

Confira o [FAQ do formatador][formatter FAQ] para mais contexto sobre decisões de formatação.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ
