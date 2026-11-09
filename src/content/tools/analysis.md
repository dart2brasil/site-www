---
ia-translate: true
title: Personalizando a análise estática
shortTitle: Análise estática
description: >-
  Use um arquivo de opções de análise e comentários no código para personalizar a análise estática.
bodyClass: highlight-diagnostics
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

A análise estática permite encontrar problemas antes
de executar uma única linha de código. É uma ferramenta poderosa
usada para prevenir bugs e garantir que o código esteja em conformidade com as
diretrizes de estilo.

Com a ajuda do analyzer, você pode encontrar
erros de digitação simples. Por exemplo, talvez um ponto e vírgula acidental
tenha se infiltrado em uma instrução `if`:


:::secondary
<?code-excerpt "analysis/lib/lint.dart (empty_statements)" replace="/(if .*?)(;)/$1[!$2!]/g"?>
```dart showLineNumbers=8
void increment() {
  if (count < 10) [!;!]
  count++;
}
```

Se estiver configurado corretamente, o analyzer aponta para o ponto e vírgula e
produz o seguinte aviso:

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="empty_statements" replace="/lib\/lint.dart/example.dart/g"?>
```plaintext
info - example.dart:9:19 - Unnecessary empty statement. Try removing the empty statement or restructuring the code. - empty_statements
```
:::

O analyzer também pode ajudar você a encontrar problemas mais sutis.
Por exemplo, talvez você tenha esquecido de fechar um sink:

:::secondary
<?code-excerpt "analysis/lib/lint.dart (close_sinks)" replace="/(contr.*?)(;)/[!$1!]$2/g"?>
```dart
var [!controller = StreamController<String>()!];
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="close_sinks" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
info - Unclosed instance of 'Sink'. Try invoking 'close' in the function in which the 'Sink' was created. - close_sinks
```
:::

No ecossistema Dart,
o Dart Analysis Server e outras ferramentas usam o
[pacote analyzer]({{site.pub-pkg}}/analyzer)
para realizar a análise estática.

Você pode personalizar a análise estática para procurar uma variedade de possíveis
problemas, incluindo erros e avisos especificados na
[especificação da linguagem Dart](/resources/language/spec).
Você também pode configurar regras do linter
para garantir que seu código esteja em conformidade com o
[Guia de Estilo do Dart](/effective-dart/style)
e com outras diretrizes sugeridas no [Effective Dart][].
Ferramentas como o [`dart analyze`](/tools/dart-analyze),
o [`flutter analyze`]({{site.flutter-docs}}/testing/debugging#the-dart-analyzer)
e as [IDEs e editores](/tools#editors)
usam o pacote analyzer para avaliar seu código.

Este documento explica como personalizar o comportamento do analyzer
usando um arquivo de opções de análise ou comentários no código-fonte Dart. Se você quiser
adicionar análise estática à sua ferramenta, consulte a
documentação do [pacote analyzer]({{site.pub-pkg}}/analyzer) e a
[Especificação da API do Analysis Server.](https://htmlpreview.github.io/?{{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/doc/api.html)

:::note
Para visualizar diversos diagnósticos do analyzer com explicações e correções comuns,
consulte [Mensagens de diagnóstico][diagnostics].
:::

## O arquivo de opções de análise {:#the-analysis-options-file}

Coloque o arquivo de opções de análise, `analysis_options.yaml`,
na raiz do pacote, no mesmo diretório do arquivo pubspec.

Aqui está um exemplo de arquivo de opções de análise:

<?code-excerpt "analysis_options.yaml" from="include" remove="implicit-dynamic" retain="/^$|\w+:|- cancel/" remove="https:"?>
```yaml title="analysis_options.yaml"
include:
  - package:lints/recommended.yaml

analyzer:
  exclude: [build/**]
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - cancel_subscriptions
```

O exemplo ilustra as entradas de nível superior mais comuns:

- Use `include:` para importar
  [opções de análise compartilhadas](#including-shared-options)
  de outros arquivos ou pacotes,
  como `package:lints/recommended.yaml`
  ou `package:flutter_lints/flutter.yaml`.
  Especifique um único URI ou uma lista de URIs para incluir vários arquivos.
  O analyzer mescla as opções incluídas em ordem,
  com as opções locais tendo precedência.
- Use `analyzer:` para personalizar as verificações da análise estática, como
  [habilitar verificações de tipo mais rigorosas](#enabling-additional-type-checks),
  [excluir arquivos da análise](#excluding-files),
  [ignorar regras específicas](#ignoring-rules),
  [alterar a severidade das regras](#changing-the-severity-of-rules) ou
  [habilitar experimentos][analyzer-experiments].
- Use `linter:` para configurar as [regras do linter](#enabling-linter-rules)
  para impor padrões de codificação, detectar possíveis bugs
  e manter as melhores práticas.

:::warning
**YAML é sensível a espaços em branco.**
Não use tabs em um arquivo YAML,
e use 2 espaços para indicar cada nível de indentação.
:::

Se o analyzer não encontrar um arquivo de opções de análise na raiz do pacote,
ele percorre a árvore de diretórios procurando por um.
Se nenhum arquivo estiver disponível, o analyzer usa as verificações padrão.

Considere a seguinte estrutura de diretórios para um projeto grande:

<img
  src="/assets/img/guides/analysis-options-directory-structure.png"
  class="diagram-wrap"
  alt="project root contains analysis_options.yaml (#1) and 3 packages, one of which (my_package) contains an analysis_options.yaml file (#2).">

O analyzer usa o arquivo #1 para analisar o código em `my_other_package`
e `my_other_other_package`, e o arquivo #2 para analisar o código em
`my_package`.


## Habilitando verificações de tipo mais rigorosas {:#enabling-additional-type-checks}

Se você quiser verificações estáticas mais rigorosas do que
o [sistema de tipos do Dart][type-system] exige,
considere habilitar os modos de linguagem
`strict-casts`, `strict-inference` e `strict-raw-types`:

<?code-excerpt "analysis/analysis_options.yaml" from="analyzer" to="strict-raw-types" remove="exclude"?>
```yaml title="analysis_options.yaml"
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

Você pode usar os modos juntos ou separadamente; todos têm `false` como padrão.

`strict-casts: <bool>`
: Um valor `true` garante que o mecanismo de inferência de tipos nunca
  faça um cast implícito de `dynamic` para um tipo mais específico.
  O código Dart válido a seguir inclui um downcast implícito do
  valor `dynamic` retornado por `jsonDecode` para `List<String>`,
  que pode falhar em tempo de execução.
  Este modo reporta o possível erro,
  exigindo que você adicione um cast explícito ou ajuste o seu código de outra forma.

<?code-excerpt "analysis/lib/strict_modes.dart (strict-casts)" replace="/jsonDecode\(jsonText\)/[!$&!]/g"?>
```dart tag=fails-sa
void foo(List<String> lines) {
  ...
}

void bar(String jsonText) {
  foo([!jsonDecode(jsonText)!]); // Implicit cast
}
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The argument type 'dynamic' can't be assigned"  replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - The argument type 'dynamic' can't be assigned to the parameter type 'List<String>'. - argument_type_not_assignable
```

:::version-note
O modo `strict-casts` foi introduzido no Dart 2.16.
Para habilitar verificações semelhantes em versões anteriores do SDK,
considere usar a opção `implicit-casts`, agora obsoleta:

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
```
:::

`strict-inference: <bool>`
: Um valor `true` garante que o mecanismo de inferência de tipos nunca escolha
  o tipo `dynamic` quando não conseguir determinar um tipo estático.
  O código Dart válido a seguir cria um `Map`
  cujo argumento de tipo não pode ser inferido,
  o que resulta em uma dica de falha de inferência deste modo:

<?code-excerpt "analysis/lib/strict_modes.dart (strict-inference)" replace="/{}/[!$&!]/g"?>
```dart tag=fails-sa
final lines = [!{}!]; // Inference failure
lines['Dart'] = 10000;
lines['C++'] = 'one thousand';
lines['Go'] = 2000;
print('Lines: ${lines.values.reduce((a, b) => a + b)}'); // Runtime error
```
{:analyzer}

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The type argument(s) of 'Map'"  replace="/. Use.*'Map'. / /g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
warning - The type argument(s) of 'Map' can't be inferred - inference_failure_on_collection_literal
```

:::tip
O modo `strict-inference` consegue identificar várias situações
que resultam em falha de inferência.

Consulte [Condições para falha de inferência estrita][Conditions for strict inference failure]
para uma lista completa das condições de falha de inferência.
:::

[Conditions for strict inference failure]: {{site.repo.dart.lang}}/blob/main/resources/type-system/strict-inference.md#conditions-for-strict-inference-failure

`strict-raw-types: <bool>`
: Um valor `true` garante que o mecanismo de inferência de tipos nunca escolha
  o tipo `dynamic` quando não conseguir determinar um tipo estático
  por causa de argumentos de tipo omitidos.
  O código Dart válido a seguir tem uma variável `List` com tipo bruto (raw),
  o que resulta em uma dica de tipo bruto deste modo:

<?code-excerpt "analysis/lib/strict_modes.dart (strict-raw-types)" replace="/List n/[!List!] n/g"?>
```dart tag=fails-sa
[!List!] numbers = [1, 2, 3]; // List with raw type
for (final n in numbers) {
  print(n.length); // Runtime error
}
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The generic type" replace="/. Use explicit.*\. / /g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
warning - The generic type 'List<dynamic>' should have explicit type arguments but doesn't - strict_raw_type
```

## Habilitando e desabilitando regras do linter {:#enabling-linter-rules}

O pacote analyzer também fornece um linter de código. Há uma grande variedade de
[regras do linter][linter rules] disponíveis. Os linters tendem a ser
não denominacionais: as regras não precisam concordar entre si.
Por exemplo, algumas regras são mais adequadas para pacotes Dart comuns,
e outras são projetadas para aplicativos Flutter.
Observe que as regras do linter podem gerar falsos positivos, ao contrário da análise estática.

### Habilitando as regras de lint recomendadas pela equipe do Dart {:#lints}

A equipe do Dart oferece dois conjuntos de regras de lint recomendadas
no [pacote lints][lints package]:

Regras essenciais (core)
: Ajudam a identificar problemas críticos que provavelmente causam falhas
  ao executar ou consumir código Dart.
  Todo código deve passar por essas regras do linter.
  Os pacotes publicados no [pub.dev]({{site.pub}})
  têm uma [pontuação do pacote]({{site.pub}}/help/scoring)
  que se baseia, em parte, na aprovação nessas regras.

Regras recomendadas
: Ajudam a identificar problemas adicionais
  que podem causar falhas ao executar ou consumir código Dart,
  e impõem um estilo e formato únicos e idiomáticos.
  Recomendamos que todo código Dart use essas regras,
  que são um superconjunto das regras essenciais.

:::tip
Se você estiver trabalhando com código Flutter, use o
[`flutter_lints`]({{site.pub-pkg}}/flutter_lints)
em vez do pacote `lints`, pois ele oferece um superconjunto das regras recomendadas.
:::

Para habilitar qualquer um dos conjuntos de lints,
adicione o [pacote lints][lints package] como dev dependency:

```console
$ dart pub add --dev lints
```

Em seguida, edite o arquivo `analysis_options.yaml` para incluir
o conjunto de regras de sua preferência:

```yaml
include: package:lints/<RULE_SET>.yaml
```

Por exemplo, você pode incluir o conjunto de regras recomendadas assim:

```yaml
include: package:lints/recommended.yaml
```

:::important
Quando uma **nova versão do `lints`** é publicada,
um código que antes passava na análise pode **começar a falhar na análise.**
Recomendamos atualizar seu código para funcionar com as novas regras.
Outras opções são habilitar explicitamente regras individuais do linter
ou [desabilitar regras individuais][disable individual rules].
:::

:::note
Para mais informações sobre a inclusão de arquivos de opções, consulte a seção
[Incluindo opções compartilhadas](#including-shared-options).
:::

[lints package]: {{site.pub-pkg}}/lints

### Habilitando regras individuais {:#individual-rules}

Para habilitar uma única regra do linter, adicione `linter:` ao arquivo de opções de análise
como uma chave de nível superior,
seguida de `rules:` como chave de segundo nível.
Nas linhas seguintes, especifique as regras que deseja aplicar,
precedidas de hífens (a sintaxe de uma lista YAML).
Por exemplo:

<?code-excerpt "analysis_options.yaml" from="linter:" take="12" remove="https:"?>
```yaml
linter:
  rules:
    - always_declare_return_types
    - annotate_redeclares
    - cancel_subscriptions
    - close_sinks
    - combinators_ordering
    - comment_references
    - invalid_case_patterns
    - only_throw_errors
    - prefer_single_quotes
```


### Desabilitando regras individuais {:#disabling-individual-rules}

Se você incluir um arquivo de opções de análise como o do `lints`,
pode querer desabilitar algumas das regras incluídas.
Desabilitar regras individuais é semelhante a habilitá-las,
mas exige o uso de um mapa em vez de uma lista
como valor da entrada `rules:`,
então cada linha deve conter o nome de uma regra seguido de
`: false` ou `: true`.

Aqui está um exemplo de arquivo de opções de análise
que usa todas as regras recomendadas do `lints`
exceto `avoid_shadowing_type_parameters`.
Ele também habilita o lint `await_only_futures`:

<?code-excerpt "analysis_alt/analysis_options_linter.yaml"?>
```yaml title="analysis_options.yaml"
include: package:lints/recommended.yaml

linter:
  rules:
    avoid_shadowing_type_parameters: false
    await_only_futures: true
```

:::note
Por restrições do YAML,
**você não pode misturar a sintaxe de lista e de chave-valor na mesma entrada `rules`.**
Você pode usar a outra sintaxe para regras em um arquivo incluído.
:::

## Incluindo opções compartilhadas {:#including-shared-options}

Um arquivo de opções de análise pode incluir opções especificadas em
outro arquivo de opções, ou até em uma lista de outros arquivos de opções.
Você pode especificar esses arquivos usando o campo de nível superior `include:`:

```yaml title="analysis_options.yaml"
include: package:flutter_lints/recommended.yaml
```

Um arquivo de opções incluído pode ser especificado com um
URI `package:` ou com um caminho relativo.
Para incluir vários arquivos de opções de análise, use uma lista:

```yaml title="analysis_options.yaml"
include:
  - package:flutter_lints/recommended.yaml
  - ../team_options.yaml
```

Ao incluir vários arquivos,
o analyzer mescla as opções na ordem da lista:

1. O primeiro arquivo incluído é avaliado,
   incluindo quaisquer arquivos que ele inclua recursivamente.
1. Cada arquivo incluído subsequente é aplicado em ordem,
   adicionando novas opções ou sobrescrevendo as conflitantes.
1. Por fim, as opções definidas diretamente no
   arquivo `analysis_options.yaml` atual sobrescrevem quaisquer opções incluídas.

Ao mesclar as opções,
o analyzer combina configurações compatíveis em vez de
substituir seções inteiras.
Por exemplo, habilitar uma regra individual do linter em um arquivo posterior
acrescenta ou sobrescreve regras de arquivos anteriores
sem descartar o restante do conjunto de regras incluído.

Por exemplo, dados os seguintes arquivos de opções:

```yaml title="three.yaml"
include: two.yaml
# ...
```

E um arquivo de opções final que os inclui:

```yaml title="analysis_options.yaml"
include:
  - one.yaml
  - three.yaml
# ...
```

Então o analyzer aplica as opções de `one.yaml`, depois as de `two.yaml`,
depois as de `three.yaml` e, por fim, as de `analysis_options.yaml`.


## Habilitando plugins do analyzer (experimental) {:#plugins}

:::note
Isto é para o sistema legado de plugins, que será
descontinuado em uma versão futura. Para novos
desenvolvimentos, use o novo sistema de [plugins do analyzer][analyzer plugin].
:::

O analyzer tem suporte experimental a plugins legados.
Esses plugins se integram ao analyzer para adicionar funcionalidades
como novos diagnósticos, correções rápidas e autocompletar personalizado.
Você pode habilitar apenas um plugin por arquivo `analysis_options.yaml`.
Habilitar um plugin legado do analyzer aumenta a quantidade de memória
que o analyzer usa.

Não use plugins legados do analyzer se a sua situação atender
a qualquer uma das condições a seguir:

* Você usa uma máquina de desenvolvimento com menos de 16 GB de memória.
* Você usa um mono-repo com mais de 10 arquivos `pubspec.yaml` e
  `analysis_options.yaml`.
  
Você pode encontrar alguns plugins legados do analyzer em
[pub.dev]({{site.pub-pkg}}?q=dependency%3Aanalyzer_plugin).

Para habilitar um plugin legado:

 1. Adicione o pacote que contém o plugin como dev dependency.

    ```console
    $ dart pub add --dev <your_favorite_analyzer_plugin_package>
    ```

 2. Edit your `analysis_options.yaml` file to enable the plugin.

    ```yaml
    analyzer:
      plugins:
        - your_favorite_analyzer_plugin_package
    ```

    Para indicar funcionalidades específicas do plugin a serem habilitadas,
    como novos diagnósticos, pode ser necessária uma configuração adicional.

[analyzer plugin]: /tools/analyzer-plugins

## Excluindo código da análise {:#excluding-code-from-analysis}

Às vezes é aceitável que algum código falhe na análise.
Por exemplo, você pode depender de código gerado por um pacote que
não é seu: o código gerado funciona,
mas produz avisos durante a análise estática.
Ou uma regra do linter pode causar um falso positivo
que você quer suprimir.

Você tem algumas formas de excluir código da análise:

* Excluir arquivos inteiros da análise.
* Impedir que regras específicas que não são de erro sejam aplicadas a arquivos individuais.
* Impedir que regras específicas que não são de erro sejam aplicadas a linhas de código individuais.

Você também pode [desabilitar regras específicas][disable individual rules]
para todos os arquivos ou
[alterar a severidade das regras][change the severity of rules].


### Excluindo arquivos {:#excluding-files}

Para excluir arquivos da análise estática, use a opção `exclude:` do analyzer.
Você pode listar arquivos individuais ou
usar a sintaxe de padrões [glob]({{site.pub-pkg}}/glob).
Todos os padrões glob devem ser relativos ao
diretório que contém o arquivo `analysis_options.yaml`.

<?code-excerpt "analysis_alt/analysis_options.yaml (exclude)" plaster="none"?>
```yaml
analyzer:
  exclude:
    - lib/client.dart
    - lib/server/*.g.dart
    - test/_data/**
```

<a id="suppressing-rules-for-a-file"></a>
### Suprimindo diagnósticos de um arquivo {:#suppressing-diagnostics-for-a-file}

Para ignorar um diagnóstico específico que não seja de erro em um arquivo específico,
adicione um comentário `ignore_for_file` ao arquivo:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)" replace="/, \w+//g"?>
```dart
// ignore_for_file: unused_local_variable
```

Isso vale para o arquivo inteiro, antes ou depois do comentário, e é
especialmente útil para código gerado.

Para suprimir mais de um diagnóstico, use uma lista separada por vírgulas:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)"?>
```dart
// ignore_for_file: unused_local_variable, duplicate_ignore, dead_code
```

Para suprimir todas as regras do linter, adicione o especificador `type=lint`:

<?code-excerpt "analysis/lib/ignore_lints.dart (ignore_type_for_file)"?>
```dart
// ignore_for_file: type=lint
```

:::version-note
O suporte ao especificador `type=lint` foi adicionado no Dart 2.15.
:::

<a id="suppressing-rules-for-a-line-of-code"></a>
### Suprimindo diagnósticos de uma linha de código {:#suppressing-diagnostics-for-a-line-of-code}

Para suprimir um diagnóstico específico que não seja de erro em uma linha específica de código Dart,
coloque um comentário `ignore` acima da linha de código.
Aqui está um exemplo de como ignorar código que causa um erro em tempo de execução,
como você poderia fazer em um teste de linguagem:

<?code-excerpt "analysis/lib/assignment.dart (invalid_assignment)"?>
```dart
// ignore: invalid_assignment
int x = '';
```

Para suprimir mais de um diagnóstico, forneça uma lista separada por vírgulas:

<?code-excerpt "analysis/lib/assignment.dart (ignore-more)"?>
```dart
// ignore: invalid_assignment, const_initialized_with_non_constant_value
const x = y;
```

Como alternativa, acrescente o comentário ignore à linha à qual ele se aplica:

<?code-excerpt "analysis/lib/assignment.dart (single-line)"?>
```dart
int x = ''; // ignore: invalid_assignment
```

### Suprimindo diagnósticos em um arquivo pubspec {:#suppressing-diagnostics-in-a-pubspec-file}

Se você precisar suprimir um diagnóstico que não seja de erro do analyzer
em um arquivo `pubspec.yaml`, adicione um comentário `ignore` acima da linha afetada.

O exemplo a seguir ignora o lint [`sort_pub_dependencies`][] porque
a dependência `flutter` deve vir primeiro:

```yaml title="pubspec.yaml".
dependencies:
  flutter:
    sdk: flutter

  # ignore: sort_pub_dependencies
  collection: ^1.19.0
```

:::version-note
O suporte a comentários ignore em arquivos `pubspec.yaml` foi adicionado no Dart 3.3.
Se você estiver usando o Dart 3.2 ou anterior,
o diagnóstico ignorado ainda será disparado.
:::

[`sort_pub_dependencies`]: /tools/linter-rules/sort_pub_dependencies

## Personalizando as regras de análise {:#customizing-analysis-rules}

Cada [diagnóstico do analyzer][analyzer diagnostics] e
[regra do linter][linter rules] tem uma severidade padrão.
Você pode usar o arquivo de opções de análise para alterar
a severidade de regras individuais ou para sempre ignorar algumas regras.

O analyzer oferece suporte a três níveis de severidade:

`info`
: Uma mensagem informativa que não faz a análise falhar.
  Exemplo: [`dead_code`][dead_code]

`warning`
: Um aviso que não faz a análise falhar, a menos que
  o analyzer esteja configurado para tratar avisos como erros.
  Exemplo: [`invalid_null_aware_operator`][invalid_null_aware_operator]

`error`
: Um erro que faz a análise falhar.
  Exemplo: [`invalid_assignment`][invalid_assignment]


### Ignorando regras {:#ignoring-rules}

Você pode ignorar [diagnósticos do analyzer][analyzer diagnostics] e
[regras do linter][linter rules] específicos
usando o campo `errors:`.
Liste a regra, seguida de <code>:&nbsp;ignore</code>. Por exemplo, o arquivo
de opções de análise a seguir instrui as ferramentas de análise a ignorar a regra TODO:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" to="ignore"?>
```yaml
analyzer:
  errors:
    todo: ignore
```


### Alterando a severidade das regras {:#changing-the-severity-of-rules}

Você pode alterar globalmente a severidade de uma regra específica.
Essa técnica funciona tanto para problemas comuns de análise quanto para lints.
Por exemplo, o arquivo de opções de análise a seguir instrui as ferramentas de análise a
tratar atribuições inválidas como avisos e retornos ausentes como erros,
e a fornecer informações (mas não um aviso ou erro) sobre código morto:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" remove="ignore"?>
```yaml
analyzer:
  errors:
    invalid_assignment: warning
    missing_return: error
    dead_code: info
```

## Configurando o `dart format` {:#configuring-dart-format}

Você pode configurar o comportamento do [`dart format`][`dart format`] adicionando uma
seção `formatter` ao arquivo de opções de análise.

### Opções configuráveis {:#configurable-options}

#### `page_width` {:#page_width}

Você pode especificar o `page_width` (comprimento de linha) desejado.
O padrão é 80 caracteres.

Para mais informações, leia [Configurando a largura de página do formatador][Configuring formatter page width].

#### `trailing_commas` {:#trailing_commas}

Você pode configurar como o formatador trata as vírgulas finais
nas listas de argumentos e de parâmetros
usando a opção `trailing_commas`.
Ela aceita um de dois valores:

`automate` (padrão)
: O formatador adiciona e remove vírgulas finais com base na
  sua decisão de dividir a construção ao redor.

`preserve`
: Uma vírgula final força a construção ao redor a ser dividida.
  O formatador adiciona uma vírgula final quando divide uma construção, mas não remove uma.

```yaml title="analysis_options.yaml"
formatter:
  page_width: 120
  trailing_commas: preserve
```

## Recursos {:#resources}

Use os recursos a seguir para saber mais sobre análise estática no Dart:

* [Sistema de tipos do Dart][type-system]
* [Regras do linter do Dart][linter rules]
* [pacote analyzer]({{site.pub-pkg}}/analyzer)
* [Solucionar problemas de desempenho do analyzer][Troubleshoot analyzer performance]

[invalid_null_aware_operator]: /tools/diagnostic-messages#invalid_null_aware_operator
[analyzer diagnostics]: /tools/diagnostic-messages
[change the severity of rules]: #changing-the-severity-of-rules
[diagnostics]: /tools/diagnostic-messages
[invalid_assignment]: /tools/diagnostic-messages#invalid_assignment
[language version]: /language/versioning
[linter rules]: /tools/linter-rules
[type-system]: /language/type-system
[dead_code]: /tools/diagnostic-messages#dead_code
[disable individual rules]: #disabling-individual-rules
[Effective Dart]: /effective-dart
[`dart format`]: /tools/dart-format
[Configuring formatter page width]: /tools/dart-format#page-width
[Troubleshoot analyzer performance]: /tools/analyzer-performance
[analyzer-experiments]: /tools/experiment-flags#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide
