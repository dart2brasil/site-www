---
ia-translate: true
title: dart format
description: Ferramenta de linha de comando para formatar código-fonte Dart.
---

Para atualizar seu código para seguir as
[diretrizes de formatação do Dart][dart-guidelines],
use o comando `dart format`.
Esta formatação segue o que você obtém
ao usar um IDE ou editor com suporte para Dart.

{% render 'tools/dart-tool-note.md' %}

## Especificar arquivos para formatar

Para reformatar um ou mais arquivos Dart,
forneça uma lista de caminhos para os arquivos ou diretórios desejados.

### Especificar um caminho

Forneça o caminho para um arquivo ou diretório.
Se você passar um caminho de diretório,
`dart format` percorre seus subdiretórios também.

**Exemplo:** Para formatar todos os arquivos Dart no diretório atual ou abaixo dele:

```console
$ dart format .
```

### Especificar múltiplos caminhos

Para especificar múltiplos arquivos ou diretórios, use uma lista delimitada por espaços.

**Exemplo:** Para formatar todos os arquivos Dart no diretório `lib`,
mais um arquivo Dart no diretório `bin`:

```console
$ dart format lib bin/updater.dart
```

### Prevenir sobrescrita de arquivos Dart

Por padrão, `dart format` **sobrescreve** os arquivos Dart.

* Para não sobrescrever os arquivos, adicione a flag `--output` ou `-o`.
* Para obter o conteúdo dos arquivos formatados, adicione `-o show` ou `-o json`.
* Para ver apenas quais arquivos _iriam_ mudar, adicione `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Notificar quando ocorrerem mudanças

Para fazer o `dart format` retornar um código de saída quando mudanças de formatação ocorrerem,
adicione a flag `--set-exit-if-changed`.

* Se mudanças ocorrerem, o comando `dart format` retorna um código de saída `1`.
* Se mudanças não ocorrerem, o comando `dart format` retorna um código de saída `0`.

Use códigos de saída com sistemas de integração contínua (CI)
para que eles possam acionar outra ação em resposta ao código de saída.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## O que muda?

`dart format` faz as seguintes mudanças de formatação:

* Remove espaços em branco.
* Quebra cada linha para 80 caracteres de comprimento ou menos.
* Adiciona vírgulas finais a qualquer lista de argumentos ou parâmetros
que se divide em múltiplas linhas, e as remove das que não se dividem.
* Pode mover comentários antes ou depois de uma vírgula.

Para saber mais sobre as melhores práticas para escrever e estilizar código Dart,
confira o [Dart style guide][].

### Configurando largura de página do formatador

Quando você executa `dart format`, o formatador assume como padrão
comprimento de linha de 80 caracteres ou menos.
Se você quiser configurar o comprimento de linha para seu projeto,
pode adicionar uma seção `formatter` de nível superior ao
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
uma [language version][] de pelo menos 3.7.
:::

## Saiba mais

Para aprender sobre opções adicionais de linha de comando,
use o comando `dart help` ou veja a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

Confira o [FAQ do formatador][formatter FAQ] para mais contexto por trás das decisões de formatação.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ
