---
ia-translate: true
title: dart format
description: Ferramenta de linha de comando para formatar código-fonte Dart.
---

Para atualizar seu código para seguir as
[diretrizes de formatação do Dart][dart-guidelines],
use o comando `dart format`.
Essa formatação segue o mesmo padrão que você obtém
ao usar um IDE ou editor com suporte a Dart.

{% render 'tools/dart-tool-note.md' %}

## Especifique os arquivos a formatar {:#specify-files-to-format}

Para reformatar um ou mais arquivos Dart,
forneça uma lista de caminhos para os arquivos ou diretórios desejados.

### Especifique um caminho {:#specify-one-path}

Forneça o caminho de um arquivo ou diretório.
Se você passar um caminho de diretório,
o `dart format` também percorre os subdiretórios.

**Exemplo:** para formatar todos os arquivos Dart no diretório atual ou abaixo dele:

```console
$ dart format .
```

### Especifique múltiplos caminhos {:#specify-multiple-paths}

Para especificar vários arquivos ou diretórios, use uma lista separada por espaços.

**Exemplo:** para formatar todos os arquivos Dart no diretório `lib`,
mais um arquivo Dart no diretório `bin`:

```console
$ dart format lib bin/updater.dart 
```

### Evite sobrescrever arquivos Dart {:#prevent-overwriting-dart-files}

Por padrão, o `dart format` **sobrescreve** os arquivos Dart.

* Para não sobrescrever os arquivos, adicione a flag `--output` ou `-o`.
* Para obter o conteúdo dos arquivos formatados, adicione `-o show` ou `-o json`.
* Para ver apenas quais arquivos _seriam_ alterados, adicione `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Seja notificado quando houver alterações {:#notify-when-changes-occur}

Para fazer o `dart format` retornar um código de saída quando houver alterações de formatação,
adicione a flag `--set-exit-if-changed`.

* Se houver alterações, o comando `dart format` retorna o código de saída `1`.
* Se não houver alterações, o comando `dart format` retorna o código de saída `0`.

Use os códigos de saída com sistemas de integração contínua (CI)
para que eles possam disparar outra ação em resposta ao código de saída.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## Formatar ao salvar {:#format-on-save}

Muitos editores com suporte a Dart podem formatar
seu código automaticamente ao salvar um arquivo.

### VS Code {:#vs-code}

Para ativar a formatação ao salvar no [VS Code](/tools/vs-code),
adicione a seguinte entrada ao seu arquivo `settings.json`:

```json
{
  "[dart]": {
    "editor.formatOnSave": true
  }
}
```

### IntelliJ e Android Studio {:#intellij-and-android-studio}

Para ativar a formatação ao salvar nas [IDEs da JetBrains](/tools/jetbrains-plugin),
incluindo o IntelliJ IDEA e o Android Studio,
siga as instruções deles sobre como
[reformatar o código automaticamente ao salvar][ij-on-save].

[ij-on-save]: https://www.jetbrains.com/help/idea/reformat-and-rearrange-code.html#reformat-on-save

## O que muda? {:#what-changes}

O `dart format` faz as seguintes alterações de formatação:

* Remove espaços em branco.
* Quebra cada linha para ter 80 caracteres ou menos.
* Adiciona vírgulas finais a qualquer lista de argumentos ou parâmetros
que se divida em várias linhas, e as remove das que não se dividem.
* Pode mover comentários para antes ou depois de uma vírgula.

Para saber mais sobre as melhores práticas para escrever e estilizar código Dart,
consulte o [Dart style guide][].

### Configure o formatador {:#configure-the-formatter}

Ao executar o `dart format`, o formatador usa por padrão
um comprimento de linha de 80 caracteres ou menos.
Configure o comportamento do formatador adicionando uma seção
`formatter` de nível superior ao arquivo [`analysis_options.yaml`][].

#### Largura da página {:#page-width}

Configure o comprimento de linha do seu projeto:

```yaml title="analysis_options.yaml"
formatter:
  page_width: 123
```

Como o arquivo de opções de análise geralmente fica na raiz,
o comprimento de linha configurado se aplica a tudo no pacote.

#### Preservar vírgulas finais {:#preserve-trailing-commas}

Por padrão, o `dart format` adiciona ou remove vírgulas finais
conforme a construção seja dividida em várias linhas ou não.
Para forçar uma construção a se dividir mesmo quando couber em uma linha,
configure o formatador para preservar as vírgulas finais:

```yaml title="analysis_options.yaml"
formatter:
  trailing_commas: preserve
```

Quando essa opção está ativada, adicionar uma vírgula final a uma lista de argumentos,
a uma lista de parâmetros ou a outras construções força o formatador a dividi-las
em várias linhas, mesmo que caibam em uma só. Isso dá controle manual
sobre as quebras de linha em construções específicas.
Isso lhe dá controle manual sobre as quebras de linha em construções específicas.

Para configurar o comprimento de linha de um arquivo individual,
sobrescrevendo as opções de análise, adicione
um comentário marcador no topo do arquivo, antes de qualquer outro código:

```dart
// dart format width=123
```

:::version-note
As opções configuráveis do formatador exigem
uma [versão da linguagem][language version] de pelo menos 3.7.
A opção `trailing_commas` exige pelo menos 3.8.
:::

## Saiba mais {:#learn-more}

Para conhecer opções adicionais de linha de comando,
use o comando `dart help` ou consulte a documentação do
[pacote dart_style][dart_style]

```console
$ dart help format
```

Confira o [FAQ do formatador][formatter FAQ] para entender melhor o contexto das decisões de formatação.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /language/versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ
