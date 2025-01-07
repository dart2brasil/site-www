---
ia-translate: true
title: Customizando a análise estática
description: >-
  Use um arquivo de opções de análise e comentários de código para personalizar a análise estática.
body_class: highlight-diagnostics
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

A análise estática permite que você encontre problemas antes
de executar uma única linha de código. É uma ferramenta poderosa
usada para prevenir bugs e garantir que o código esteja em conformidade com as
diretrizes de estilo.

Com a ajuda do analisador, você pode encontrar
erros de digitação simples. Por exemplo, talvez um ponto e vírgula acidental
tenha entrado em uma instrução `if`:


<blockquote class="ml-3">

<?code-excerpt "analysis/lib/lint.dart (empty_statements)" replace="/(if .*?)(;)/$1[!$2!]/g"?>
```dart showLineNumbers=8
void increment() {
  if (count < 10) [!;!]
  count++;
}
```

Se configurado corretamente, o analisador aponta para o ponto e vírgula e
produz o seguinte aviso:

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="empty_statements" replace="/lib\/lint.dart/example.dart/g"?>
```plaintext
info - example.dart:9:19 - Declaração vazia desnecessária. Tente remover a declaração vazia ou reestruturar o código. - empty_statements
```

</blockquote>

O analisador também pode ajudá-lo a encontrar problemas mais sutis.
Por exemplo, talvez você tenha se esquecido de fechar um método sink (esgotar/dreno):

<blockquote class="ml-3">

<?code-excerpt "analysis/lib/lint.dart (close_sinks)" replace="/(contr.*?)(;)/[!$1!]$2/g"?>
```dart
var [!controller = StreamController<String>()!];
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="close_sinks" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
info - Instância não fechada de 'Sink'. Tente invocar 'close' na função em que o 'Sink' foi criado. - close_sinks
```

</blockquote>

No ecossistema Dart,
o Dart Analysis Server e outras ferramentas usam o
[pacote analyzer]({{site.pub-pkg}}/analyzer)
para realizar análise estática.

Você pode personalizar a análise estática para procurar uma variedade de problemas potenciais,
incluindo erros e avisos especificados na
[especificação da linguagem Dart](/resources/language/spec).
Você também pode configurar regras do linter (analisador de código),
para garantir que seu código esteja em conformidade com o
[Guia de Estilo Dart](/effective-dart/style)
e outras diretrizes sugeridas em [Effective Dart][Effective Dart].
Ferramentas como [`dart analyze`](/tools/dart-analyze),
[`flutter analyze`]({{site.flutter-docs}}/testing/debugging#the-dart-analyzer),
e [IDEs e editores](/tools#editors)
usam o pacote analyzer para avaliar seu código.

Este documento explica como personalizar o comportamento do analisador
usando um arquivo de opções de análise ou comentários no código-fonte Dart. Se você deseja
adicionar análise estática à sua ferramenta, consulte a
documentação do [pacote analyzer]({{site.pub-pkg}}/analyzer) e a
[Especificação da API do Analysis Server](https://htmlpreview.github.io/?{{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/doc/api.html).

:::note
Para visualizar vários diagnósticos do analisador com explicações e correções comuns,
consulte [Mensagens de diagnóstico][diagnostics].
:::

## O arquivo de opções de análise {:#the-analysis-options-file}

Coloque o arquivo de opções de análise, `analysis_options.yaml`,
na raiz do pacote, no mesmo diretório do arquivo pubspec.

Aqui está um exemplo de arquivo de opções de análise:

<?code-excerpt "analysis_options.yaml" from="include" remove="implicit-dynamic" retain="/^$|\w+:|- cancel/" remove="https:"?>
```yaml title="analysis_options.yaml"
include: package:lints/recommended.yaml

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

- Use <code>include: <em>url</em></code> para
  trazer opções da URL especificada—neste caso,
  de um arquivo no pacote `lints`.
  Como o YAML não permite chaves duplicadas,
  você pode incluir no máximo um arquivo.
- Use a entrada `analyzer:` para personalizar a análise estática:
  [habilitar verificações de tipo mais restritas](#enabling-additional-type-checks),
  [excluir arquivos](#excluding-files),
  [ignorar regras específicas](#ignoring-rules),
  [alterar a severidade das regras](#changing-the-severity-of-rules) ou
  [habilitar experimentos](/tools/experiment-flags#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide).
- Use a entrada `linter:` para configurar [regras do linter](#enabling-linter-rules).

:::warning
**YAML é sensível a espaços em branco.**
Não use tabs em um arquivo YAML,
e use 2 espaços para denotar cada nível de indentação.
:::

Se o analisador não conseguir encontrar um arquivo de opções de análise na raiz do pacote,
ele percorre a árvore de diretórios, procurando um.
Se nenhum arquivo estiver disponível, o analisador assume as verificações padrão.

Considere a seguinte estrutura de diretórios para um grande projeto:

<img
  src="/assets/img/guides/analysis-options-directory-structure.png"
  alt="raiz do projeto contém analysis_options.yaml (#1) e 3 pacotes, um dos quais (my_package) contém um arquivo analysis_options.yaml (#2).">

O analisador usa o arquivo #1 para analisar o código em `my_other_package`
e `my_other_other_package`, e o arquivo #2 para analisar o código em
`my_package`.


## Habilitando verificações de tipo mais restritas {:#enabling-additional-type-checks}

Se você deseja verificações estáticas mais restritas do que
o [sistema de tipos Dart][type-system] exige,
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

Você pode usar os modos juntos ou separadamente; todos assumem o padrão `false`.

`strict-casts: <bool>`
: Um valor de `true` garante que o mecanismo de inferência de tipo nunca
  faça casts (conversões) implícitos de `dynamic` para um tipo mais específico.
  O código Dart válido a seguir inclui um downcast (conversão para um subtipo) implícito do
  valor `dynamic` retornado por `jsonDecode` para `List<String>`
  que poderia falhar em tempo de execução.
  Este modo relata o erro potencial,
  exigindo que você adicione um cast explícito ou ajuste seu código de outra forma.

<?code-excerpt "analysis/lib/strict_modes.dart (strict-casts)" replace="/jsonDecode\(jsonText\)/[!$&!]/g"?>
```dart tag=fails-sa
void foo(List<String> lines) {
  ...
}

void bar(String jsonText) {
  foo([!jsonDecode(jsonText)!]); // Cast implícito
}
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The argument type 'dynamic' can't be assigned"  replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - O tipo de argumento 'dynamic' não pode ser atribuído ao tipo de parâmetro 'List<String>'. - argument_type_not_assignable
```

:::version-note
O modo `strict-casts` foi introduzido no Dart 2.16.
Para habilitar verificações semelhantes com versões anteriores do SDK,
considere usar a opção `implicit-casts` agora obsoleta:

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
```
:::

`strict-inference: <bool>`
: Um valor de `true` garante que o mecanismo de inferência de tipo nunca escolha
  o tipo `dynamic` quando não consegue determinar um tipo estático.
  O seguinte código Dart válido cria um `Map`
  cujo argumento de tipo não pode ser inferido,
  resultando em uma dica de falha de inferência por este modo:

<?code-excerpt "analysis/lib/strict_modes.dart (strict-inference)" replace="/{}/[!$&!]/g"?>
```dart tag=fails-sa
final lines = [!{}!]; // Falha de inferência
lines['Dart'] = 10000;
lines['C++'] = 'one thousand';
lines['Go'] = 2000;
print('Lines: ${lines.values.reduce((a, b) => a + b)}'); // Erro em tempo de execução
```
{:analyzer}

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The type argument(s) of 'Map'"  replace="/. Use.*'Map'. / /g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
warning - Os argumentos de tipo de 'Map' não podem ser inferidos - inference_failure_on_collection_literal
```

:::tip
O modo `strict-inference` pode identificar muitas situações
que resultam em uma falha de inferência.

Consulte [Condições para falha de inferência estrita][Condições para falha de inferência estrita]
para obter uma lista exaustiva de condições de falha de inferência.
:::

[Condições para falha de inferência estrita]: {{site.repo.dart.lang}}/blob/main/resources/type-system/strict-inference.md#conditions-for-strict-inference-failure

`strict-raw-types: <bool>`
: Um valor de `true` garante que o mecanismo de inferência de tipo nunca escolha
  o tipo `dynamic` quando não consegue determinar um tipo estático
  devido a argumentos de tipo omitidos.
  O seguinte código Dart válido tem uma variável `List` com um tipo bruto (raw type),
  resultando em uma dica de tipo bruto por este modo:

<?code-excerpt "analysis/lib/strict_modes.dart (strict-raw-types)" replace="/List n/[!List!] n/g"?>
```dart tag=fails-sa
[!List!] numbers = [1, 2, 3]; // List com tipo bruto
for (final n in numbers) {
  print(n.length); // Erro em tempo de execução
}
```

<?code-excerpt "analysis/analyzer-results-stable.txt" retain="The generic type" replace="/. Use explicit.*\. / /g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
warning - O tipo genérico 'List<dynamic>' deve ter argumentos de tipo explícitos, mas não tem - strict_raw_type
```

## Habilitando e desabilitando regras do linter {:#enabling-linter-rules}

O pacote analyzer também fornece um linter de código. Uma grande variedade de
[regras do linter][linter rules] estão disponíveis. Os linters tendem a ser
não denominacionais—as regras não precisam concordar umas com as outras.
Por exemplo, algumas regras são mais apropriadas para pacotes Dart regulares
e outras são projetadas para aplicativos Flutter.
Observe que as regras do linter podem ter falsos positivos, ao contrário da análise estática.

### Habilitando as regras do linter recomendadas pela equipe Dart {:#lints}

A equipe Dart fornece dois conjuntos de regras do linter recomendadas
no [pacote lints][pacote lints]:

Regras principais
: Ajudam a identificar problemas críticos que provavelmente levarão a problemas
  ao executar ou consumir código Dart.
  Todo o código deve passar nessas regras do linter.
  Pacotes que são enviados para [pub.dev]({{site.pub}})
  têm uma [pontuação de pacote]({{site.pub}}/help/scoring)
  que é baseada em parte na aprovação nessas regras.

Regras recomendadas
: Ajudam a identificar problemas adicionais
  que podem levar a problemas ao executar ou consumir código Dart,
  e impõem um estilo e formato únicos e idiomáticos.
  Recomendamos que todo o código Dart use essas regras,
  que são um superconjunto das regras principais.

:::tip
Se você estiver trabalhando em código Flutter, então, em vez de usar o pacote `lints`,
use [`flutter_lints`]({{site.pub-pkg}}/flutter_lints),
que fornece um superconjunto das regras recomendadas.
:::

Para habilitar qualquer um dos conjuntos de lints,
adicione o [pacote lints][pacote lints] como uma dependência de desenvolvimento:

```console
$ dart pub add --dev lints
```

Em seguida, edite seu arquivo `analysis_options.yaml` para incluir
seu conjunto de regras preferido:

```yaml
include: package:lints/<CONJUNTO_DE_REGRAS>.yaml
```

Por exemplo, você pode incluir o conjunto de regras recomendado assim:

```yaml
include: package:lints/recommended.yaml
```

:::important
Quando uma **nova versão de `lints`** é publicada,
o código que antes passava na análise pode **começar a falhar na análise.**
Recomendamos atualizar seu código para funcionar com as novas regras.
Outras opções são habilitar explicitamente regras do linter individuais
ou [desabilitar regras individuais][desabilitar regras individuais].
:::

[pacote lints]: {{site.pub-pkg}}/lints

### Habilitando regras individuais {:#individual-rules}

Para habilitar uma única regra do linter, adicione `linter:` ao arquivo de opções de análise
como uma chave de nível superior,
seguida por `rules:` como uma chave de segundo nível.
Nas linhas subsequentes, especifique as regras que você deseja aplicar,
prefixadas com traços (a sintaxe para uma lista YAML).
Por exemplo:

<?code-excerpt "analysis_options.yaml" from="linter:" take="12" remove="https:"?>
```yaml
linter:
  rules:
    - always_declare_return_types
    - cancel_subscriptions
    - close_sinks
    - combinators_ordering
    - comment_references
    - invalid_case_patterns
    - one_member_abstracts
    - only_throw_errors
    - prefer_single_quotes
```


### Desabilitando regras individuais {:#disabling-individual-rules}

Se você incluir um arquivo de opções de análise como o do `lints`,
você pode querer desabilitar algumas das regras incluídas.
Desabilitar regras individuais é semelhante a habilitá-las,
mas requer o uso de um mapa em vez de uma lista
como o valor para a entrada `rules:`,
portanto, cada linha deve conter o nome de uma regra seguida por
`: false` ou `: true`.

Aqui está um exemplo de um arquivo de opções de análise
que usa todas as regras recomendadas de `lints`
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
Devido às restrições do YAML,
**você não pode misturar a sintaxe de lista e chave-valor na mesma entrada `rules`.**
Você pode usar a outra sintaxe para regras em um arquivo incluído.
:::

## Habilitando plugins do analisador (experimental) {:#plugins}

O analisador tem suporte experimental para plugins.
Esses plugins se integram ao analisador para adicionar funcionalidades
como novos diagnósticos, correções rápidas e conclusão de código personalizada.
Você pode habilitar apenas um plugin por arquivo `analysis_options.yaml`.
Habilitar um plugin do analisador aumenta a quantidade de memória que o analisador usa.

Não use plugins do analisador se sua situação atender
a qualquer uma das seguintes condições:

* Você usa uma máquina de desenvolvimento com menos de 16 GB de memória.
* Você usa um mono-repo com mais de 10 arquivos `pubspec.yaml` e
  `analysis_options.yaml`.

Você pode encontrar alguns plugins do analisador em
[pub.dev]({{site.pub-pkg}}?q=dependency%3Aanalyzer_plugin).

Para habilitar um plugin:

 1. Adicione o pacote que contém o plugin como uma dependência de desenvolvimento.

    ```console
    $ dart pub add --dev <seu_pacote_de_plugin_do_analisador_favorito>
    ```

 2. Edite seu arquivo `analysis_options.yaml` para habilitar o plugin.

    ```yaml
    analyzer:
      plugins:
        - seu_pacote_de_plugin_do_analisador_favorito
    ```

    Para indicar a funcionalidade específica do plugin a ser habilitada,
    como novos diagnósticos, uma configuração adicional pode ser necessária.

## Excluindo código da análise {:#excluding-code-from-analysis}

Às vezes, não há problema em que algum código falhe na análise.
Por exemplo, você pode depender de código gerado por um pacote que
você não possui—o código gerado funciona,
mas produz avisos durante a análise estática.
Ou uma regra do linter pode causar um falso positivo
que você deseja suprimir.

Você tem algumas maneiras de excluir código da análise:

* Excluir arquivos inteiros da análise.
* Impedir que regras específicas que não sejam de erro sejam aplicadas a arquivos individuais.
* Impedir que regras específicas que não sejam de erro sejam aplicadas a linhas de código individuais.

Você também pode [desabilitar regras específicas][desabilitar regras individuais]
para todos os arquivos ou
[alterar a severidade das regras][alterar a severidade das regras].


### Excluindo arquivos {:#excluding-files}

Para excluir arquivos da análise estática, use a opção `exclude:` do analisador.
Você pode listar arquivos individuais ou
usar a sintaxe de padrão [glob]({{site.pub-pkg}}/glob).
Todos os usos de padrões glob devem ser relativos ao
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
### Suprimindo diagnósticos para um arquivo {:#suppressing-diagnostics-for-a-file}

Para ignorar um diagnóstico específico que não seja de erro para um arquivo específico,
adicione um comentário `ignore_for_file` ao arquivo:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)" replace="/, \w+//g"?>
```dart
// ignore_for_file: unused_local_variable
```

Isso atua para todo o arquivo, antes ou depois do comentário, e é
particularmente útil para código gerado.

Para suprimir mais de um diagnóstico, use uma lista separada por vírgulas:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)"?>
```dart
// ignore_for_file: unused_local_variable, duplicate_ignore, dead_code
```

Para suprimir todas as regras do linter, adicione um especificador `type=lint`:

<?code-excerpt "analysis/lib/ignore_lints.dart (ignore_type_for_file)"?>
```dart
// ignore_for_file: type=lint
```

:::version-note
O suporte para o especificador `type=lint` foi adicionado no Dart 2.15.
:::

<a id="suppressing-rules-for-a-line-of-code"></a>
### Suprimindo diagnósticos para uma linha de código {:#suppressing-diagnostics-for-a-line-of-code}

Para suprimir um diagnóstico específico que não seja de erro em uma linha específica de código Dart,
coloque um comentário `ignore` acima da linha de código.
Aqui está um exemplo de como ignorar código que causa um erro em tempo de execução,
como você pode fazer em um teste de idioma:

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

Alternativamente, anexe o comentário ignore à linha à qual ele se aplica:

<?code-excerpt "analysis/lib/assignment.dart (single-line)"?>
```dart
int x = ''; // ignore: invalid_assignment
```

### Suprimindo diagnósticos em um arquivo pubspec {:#suppressing-diagnostics-in-a-pubspec-file}

Se você precisar suprimir um diagnóstico que não seja de erro do analisador
em um arquivo `pubspec.yaml`, adicione um comentário `ignore` acima da linha afetada.

O exemplo a seguir ignora o lint [`sort_pub_dependencies`][`sort_pub_dependencies`]
pois ele quer colocar a dependência `flutter` primeiro:

```yaml title="pubspec.yaml".
dependencies:
  flutter:
    sdk: flutter

  # ignore: sort_pub_dependencies
  collection: ^1.19.0
```

:::version-note
O suporte para comentários ignore em arquivos `pubspec.yaml` foi adicionado no Dart 3.3.
Se você estiver usando o Dart 3.2 ou anterior,
o diagnóstico ignorado ainda será acionado.
:::

[`sort_pub_dependencies`]: /tools/linter-rules/sort_pub_dependencies

## Customizando regras de análise {:#customizing-analysis-rules}

Cada [diagnóstico do analisador][analyzer diagnostics] e
[regra do linter][linter rules] tem uma severidade padrão.
Você pode usar o arquivo de opções de análise para alterar
a severidade de regras individuais, ou para sempre ignorar algumas regras.

O analisador oferece suporte a três níveis de severidade:

`info`
: Uma mensagem informativa que não faz com que a análise falhe.
  Exemplo: [`dead_code`][dead_code]

`warning`
: Um aviso que não faz com que a análise falhe, a menos que
  o analisador esteja configurado para tratar avisos como erros.
  Exemplo: [`invalid_null_aware_operator`][invalid_null_aware_operator]

`error`
: Um erro que faz com que a análise falhe.
  Exemplo: [`invalid_assignment`][invalid_assignment


### Ignorando regras {:#ignoring-rules}

Você pode ignorar [diagnósticos do analisador][analyzer diagnostics] e [regras do linter][linter rules] específicos
usando o campo `errors:`.
Liste a regra, seguida por <code>:&nbsp;ignore</code>. Por exemplo, o seguinte
arquivo de opções de análise instrui as ferramentas de análise a ignorar a regra TODO:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" to="ignore"?>
```yaml
analyzer:
  errors:
    todo: ignore
```


### Alterando a severidade das regras {:#changing-the-severity-of-rules}

Você pode alterar globalmente a severidade de uma regra específica.
Esta técnica funciona para problemas de análise regulares, bem como para lints.
Por exemplo, o seguinte arquivo de opções de análise instrui as ferramentas de análise a
tratar atribuições inválidas como avisos e retornos ausentes como erros,
e fornecer informações (mas não um aviso ou erro) sobre código morto:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" remove="ignore"?>
```yaml
analyzer:
  errors:
    invalid_assignment: warning
    missing_return: error
    dead_code: info
```


## Recursos {:#resources}

Use os seguintes recursos para saber mais sobre análise estática em Dart:

* [Sistema de tipos do Dart][type-system]
* [Regras do linter do Dart][linter rules]
* [Pacote analyzer]({{site.pub-pkg}}/analyzer)

[invalid_null_aware_operator]: /tools/diagnostic-messages#invalid_null_aware_operator
[analyzer diagnostics]: /tools/diagnostic-messages
[alterar a severidade das regras]: #changing-the-severity-of-rules
[diagnostics]: /tools/diagnostic-messages
[invalid_assignment]: /tools/diagnostic-messages#invalid_assignment
[versão da linguagem]: /resources/language/evolution#language-versioning
[linter rules]: /tools/linter-rules
[type-system]: /language/type-system
[dead_code]: /tools/diagnostic-messages#dead_code
[desabilitar regras individuais]: #disabling-individual-rules
[Effective Dart]: /effective-dart
