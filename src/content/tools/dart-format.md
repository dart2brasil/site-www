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
Se você passar o caminho de um diretório,
o `dart format` percorre recursivamente seus subdiretórios também.

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

## Quais alterações são feitas? {:#what-changes}

O `dart format` faz as seguintes alterações de formatação:

* Remove whitespace.
* Quebra cada linha em 80 caracteres ou menos.
* Adiciona trailing commas a qualquer lista de argumentos ou parâmetros
que se divide em várias linhas, e os remove daquelas que não se dividem.
* Pode mover comentários antes ou depois de uma vírgula.

Para saber mais sobre as melhores práticas para escrever e estilizar código Dart,
confira o [guia de estilo Dart][Dart style guide].

### Configurando a largura de página do formatter {:#configuring-formatter-page-width}

Quando você executa o `dart format`, o formatter usa por padrão
o comprimento de linha de 80 caracteres ou menos.
Se você quiser configurar o comprimento de linha para seu projeto,
pode adicionar uma seção `formatter` no nível superior do
arquivo [`analysis_options.yaml`][], assim:

```yaml title="analysis_options.yaml"
formatter:
  page_width: 123
```

Com o arquivo de opções de análise normalmente na raiz,
o comprimento de linha configurado se aplicará a tudo no pacote.

Você também pode configurar o comprimento de linha de arquivos individuais,
sobrescrevendo o arquivo de opções de análise,
com um comentário marcador no topo do arquivo antes de qualquer outro código:

```dart
// dart format width=123
```

:::version-note
A largura de página configurável requer
uma [versão da linguagem][language version] de pelo menos 3.7.
:::

## Saiba mais {:#learn-more}

Para saber mais sobre opções adicionais de linha de comando,
use o comando `dart help` ou consulte a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

Confira o [FAQ do formatter][formatter FAQ] para mais contexto sobre as decisões de formatação.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ