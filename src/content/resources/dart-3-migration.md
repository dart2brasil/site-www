---
ia-translate: true
title: Guia de migração do Dart 3
description: Como migrar código Dart existente para ser compatível com o Dart 3.
---

Dart 3 é um lançamento principal que introduz novos recursos essenciais ao Dart:
[records][], [patterns][] e [modificadores de classe][].

Juntamente com esses novos recursos, o Dart 3 contém várias mudanças que
podem quebrar código existente.

Este guia ajudará você a resolver quaisquer problemas de migração que você possa
encontrar após [atualizar para o Dart 3](/get-dart).

## Introdução {:#introduction}

### Mudanças não versionadas vs. versionadas {:#unversioned-vs-versioned-changes}

As mudanças potencialmente quebra-código listadas abaixo se enquadram em uma de duas categorias:

*   **Mudanças não versionadas**: Essas mudanças afetam qualquer código Dart
    após a atualização para um SDK Dart 3.0 ou posterior.
    Não há como "desativar" essas mudanças.

*   **Mudanças versionadas**: Essas mudanças só se aplicam quando a versão
    da linguagem do pacote ou aplicativo é definida como >= Dart 3.0.
    A [versão da linguagem](/resources/language/evolution#language-version-numbers)
    é derivada da restrição inferior `sdk` no
    arquivo [`pubspec.yaml`](/tools/pub/packages#creating-a-pubspec).
    Uma restrição de SDK como esta *não* aplica as mudanças versionadas do Dart 3:

    ```yaml
    environment:
      sdk: '>=2.14.0 <3.0.0'
    ```

    Mas uma restrição de SDK como esta aplica:

    ```yaml
    environment:
      sdk: '>=3.0.0 <4.0.0'
    ```

Para usar os novos recursos do Dart 3, você deve
atualizar a versão da linguagem para 3.0.
Isso traz as mudanças versionadas do Dart 3 ao mesmo tempo.

### Compatibilidade retroativa do Dart 3 {:#dart-3-backwards-compatibility}

Muitos pacotes e aplicativos que usaram segurança nula com o Dart 2.12 ou
posterior provavelmente são compatíveis com o Dart 3.
Isso é possível para qualquer pacote onde
o limite inferior da restrição do SDK seja 2.12.0 ou superior.

A [ferramenta pub do Dart](/tools/pub/packages) permite a resolução mesmo quando
o limite superior é limitado a versões abaixo de 3.0.0.
Por exemplo, um pacote com a seguinte restrição
terá permissão para resolver com um SDK Dart 3.x,
já que o pub irá reinterpretar a restrição superior `<3.0.0` como `<4.0.0`
quando a restrição inferior for `2.12` ou superior:

```yaml
environment:
  sdk: '>=2.14.0 <3.0.0'           # Isto é interpretado como '>=2.14.0 <4.0.0'
```

Isso permite que desenvolvedores usem a segurança nula completa do Dart 3 com pacotes
que já suportam a segurança nula 2.12
sem a necessidade de uma segunda migração, a menos que
o código seja afetado por quaisquer outras mudanças do Dart 3.

### Testando o impacto {:#testing-for-impact}

Para entender se seu código fonte é afetado por quaisquer mudanças do Dart 3,
siga estes passos:

```console
$ dart --version    # Certifique-se de que isto reporte 3.0.0 ou superior.
$ dart pub get      # Isto deve resolver sem problemas.
$ dart analyze      # Isto deve passar sem erros.
```

Se o passo `pub get` falhar, tente atualizar suas dependências
para ver se versões mais recentes podem suportar o Dart 3:

```console
$ dart pub upgrade
$ dart analyze      # Isto deve passar sem erros.
```

Ou, se necessário, inclua também atualizações de [versões principais][]:

```console
$ dart pub upgrade --major-versions
$ dart analyze      # Isto deve passar sem erros.
```

[major versions]: /tools/pub/cmd/pub-upgrade#major-versions

## Mudanças na linguagem Dart 3 {:#dart-3-language-changes}

### Segurança nula 100% completa {:#100-sound-null-safety}

O Dart 2.12 introduziu a segurança nula há mais de dois anos.
No Dart 2.12, os usuários precisavam habilitar a segurança nula [com uma configuração no pubspec][].
No Dart 3, a segurança nula é integrada; você não pode desativá-la.

[with a pubspec setting]: /null-safety#enable-null-safety

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Pacotes desenvolvidos sem suporte à segurança nula causarão problemas
ao resolver dependências com `pub get`:

```console
$ dart pub get

Porque pkg1 não suporta segurança nula, a resolução de versão falhou.
O limite inferior de "sdk: '>=2.9.0 <3.0.0'" deve ser 2.12.0 ou superior para habilitar a segurança nula.
```

Bibliotecas que desabilitam a segurança nula com [comentários de versão da linguagem][]
que selecionam qualquer versão da linguagem abaixo de `2.12` causarão
erros de análise ou compilação:

```console
$ dart analyze .
Analisando ....                         0.6s

  error • lib/pkg1.dart:1:1 • A versão da linguagem deve ser >=2.12.0.
  Tente remover a sobrescrita da versão da linguagem e migrar o código.
  • illegal_language_version_override (sobrescrita_ilegal_de_versao_da_linguagem)
```

```console
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Biblioteca não suporta segurança nula.
// @dart=2.9
^^^^^^^^^^^^
```

[language version comments]: /resources/language/evolution#per-library-language-version-selection

#### Migração

Antes de iniciar qualquer migração para o Dart 3,
certifique-se de que seu aplicativo ou pacote foi 100% migrado para habilitar a segurança nula.
Isso requer um SDK Dart `2.19`, não um SDK Dart 3.
Para aprender como migrar primeiro seu aplicativo ou pacote para suportar a segurança nula,
confira o [guia de migração de segurança nula][].

[null safety migration guide]: /null-safety/migration-guide

### Sintaxe de dois pontos para valores padrão {:#colon-syntax-for-default-values}

Por razões históricas, parâmetros opcionais nomeados podiam
especificar seu valor padrão usando `:` ou `=`.
No Dart 3, apenas a sintaxe `=` é permitida.

#### Escopo

Esta é uma mudança [*versionada*](#unversioned-vs-versioned-changes),
que só se aplica à versão da linguagem 3.0 ou posterior.

#### Sintoma

A análise do Dart produz erros como:

```plaintext
line 2 • Usar dois pontos como um separador antes de um valor padrão não é mais suportado.
```

#### Migração

Mude de usar dois pontos:

```dart
int someInt({int x: 0}) => x;
```

Para usar iguais:

```dart
int someInt({int x = 0}) => x;
```

Esta migração pode ser feita manualmente, ou automatizada com `dart fix`:

```console
$ dart fix --apply --code=obsolete_colon_for_default_value
```

### `mixin` {:#mixin}

Pré-Dart 3, qualquer `class` poderia ser usada como um `mixin` (mistura), desde que
não tivesse construtores declarados e nenhuma superclasse além de `Object`.

No Dart 3, classes declaradas em bibliotecas na versão da linguagem 3.0 ou posterior
não podem ser usadas como mixins, a menos que marcadas como `mixin`.
Esta restrição se aplica ao código em qualquer biblioteca
que tente usar a classe como um mixin,
independentemente da versão da linguagem da última biblioteca.

#### Escopo

Esta é uma mudança [*versionada*](#unversioned-vs-versioned-changes),
que só se aplica à versão da linguagem 3.0 ou posterior.

#### Sintoma

Um erro de análise como:

```plaintext
Mixin só pode ser aplicado à classe.
```

O analisador produz este diagnóstico quando uma classe que não é um
`mixin class` nem um `mixin` é usada em uma cláusula `with`.

#### Migração

Determine se a classe se destina a ser usada como um mixin.

Se a classe definir uma interface, considere usar `implements`.

### `switch` {:#switch}

O Dart 3.0 interpreta os casos de [switch](/language/branches#switch)
como [patterns (padrões)][] em vez de expressões constantes.

#### Escopo

Esta é uma mudança [*versionada*](#unversioned-vs-versioned-changes),
que só se aplica à versão da linguagem 3.0 ou posterior.

#### Sintoma

A maioria das expressões constantes encontradas em casos de switch são padrões válidos
com o mesmo significado (constantes nomeadas, literais, etc.).
Estes se comportarão da mesma forma e nenhum sintoma surgirá.

As poucas expressões constantes que não são padrões válidos
acionarão o [`invalid_case_patterns` lint][].

[`invalid_case_patterns` lint]: /tools/linter-rules/invalid_case_patterns

#### Migração

Você pode reverter para o comportamento original prefixando
o padrão do caso com `const`, para que não seja mais interpretado como um padrão:

```dart
case const [1, 2]:
case const {'k': 'v'}:
case const {1, 2}:
case const Point(1, 2):
```

Você pode executar uma correção rápida para esta mudança que quebra o código,
usando `dart fix` ou em seu IDE.

### `continue` {:#continue}

O Dart 3 relata um erro em tempo de compilação se uma declaração continue tiver como alvo um rótulo
que não é um loop (declarações `for`, `do` e `while`) ou um membro switch.

#### Escopo

Esta é uma mudança [*versionada*](#unversioned-vs-versioned-changes),
que só se aplica à versão da linguagem 3.0 ou posterior.

#### Sintoma

Você verá um erro como:

```plaintext
O rótulo usado em uma declaração 'continue' deve ser definido em um loop ou em um membro switch.
```

#### Migração

Se a mudança de comportamento for aceitável,
mude o `continue` para ter como alvo uma declaração rotulada válida,
que deve estar anexada a uma declaração `for`, `do` ou `while`.

Se você quiser preservar o comportamento, mude a
declaração `continue` para uma declaração `break`.
Em versões anteriores do Dart, uma declaração `continue`
que não tinha como alvo um loop ou um membro switch
se comportava como `break`.

## Mudanças na biblioteca principal do Dart 3 {:#dart-3-core-library-changes}

### APIs removidas {:#apis-removed}

**Mudança que quebra o código [#49529][]**: As bibliotecas principais foram limpas
para remover APIs que foram descontinuadas por vários anos.
As seguintes APIs não existem mais nas bibliotecas principais do Dart.

[#49529]: {{site.repo.dart.sdk}}/issues/49529

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### `dart:core`

- Removido o construtor `List` descontinuado, pois não era nulo seguro.
  Use literais de lista (por exemplo, `[]` para uma lista vazia ou `<int>[]` para uma lista
  tipada vazia) ou [`List.filled`][]. Isso só afeta o código não seguro nulo,
  já que o código seguro nulo já não podia usar este construtor.
- Removido o argumento `onError` descontinuado em [`int.parse`][], [`double.parse`][] e
  [`num.parse`][]. Use o método [`tryParse`][] em vez disso.
- Removidas as anotações descontinuadas [`proxy`][] e [`Provisional`][].
  A anotação original `proxy` não tem efeito no Dart 2,
  e o tipo `Provisional` e a constante [`provisional`][]
  foram usados apenas internamente durante o processo de desenvolvimento do Dart 2.0.
- Removido o getter descontinuado [`Deprecated.expires`][].
  Use [`Deprecated.message`][] em vez disso.
- Removido o erro descontinuado [`CastError`][].
  Use [`TypeError`][] em vez disso.
- Removido o erro descontinuado [`FallThroughError`][]. O tipo de
  fall-through que anteriormente lançava este erro foi transformado em um erro
  em tempo de compilação no Dart 2.0.
- Removido o erro descontinuado [`NullThrownError`][]. Este erro nunca é
  lançado de código seguro nulo.
- Removido o erro descontinuado [`AbstractClassInstantiationError`][].
  Tornou-se um erro em tempo de compilação chamar o construtor de uma classe abstrata no Dart 2.0.
- Removido o descontinuado [`CyclicInitializationError`]. Dependências cíclicas
  não são mais detectadas em tempo de execução em código seguro nulo. Esse código falhará de outras
  maneiras, possivelmente com um StackOverflowError.
- Removido o construtor padrão descontinuado [`NoSuchMethodError`][].
  Use o construtor nomeado [`NoSuchMethodError.withInvocation`][] em vez disso.
- Removida a classe descontinuada [`BidirectionalIterator`][].
  Iteradores bidirecionais existentes ainda podem funcionar, eles apenas não têm
  um supertipo compartilhado que os prenda a um nome específico para se mover para trás.

[`List.filled`]: {{site.dart-api}}/dart-core/List/List.filled.html
[`int.parse`]: {{site.dart-api}}/dart-core/int/parse.html
[`double.parse`]: {{site.dart-api}}/dart-core/double/parse.html
[`num.parse`]: {{site.dart-api}}/dart-core/num/parse.html
[`tryParse`]: {{site.dart-api}}/dart-core/num/tryParse.html
[`Deprecated.expires`]: {{site.dart-api}}/stable/2.19.6/dart-core/Deprecated/expires.html
[`Deprecated.message`]: {{site.dart-api}}/dart-core/Deprecated/message.html
[`AbstractClassInstantiationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/AbstractClassInstantiationError-class.html
[`CastError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CastError-class.html
[`FallThroughError`]: {{site.dart-api}}/stable/2.19.6/dart-core/FallThroughError-class.html
[`NoSuchMethodError`]: {{site.dart-api}}/stable/2.19.6/dart-core/NoSuchMethodError/NoSuchMethodError.html
[`NoSuchMethodError.withInvocation`]: {{site.dart-api}}/dart-core/NoSuchMethodError/NoSuchMethodError.withInvocation.html
[`CyclicInitializationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CyclicInitializationError-class.html
[`Provisional`]: {{site.dart-api}}/stable/2.19.6/dart-core/Provisional-class.html
[`provisional`]: {{site.dart-api}}/stable/2.19.6/dart-core/provisional-constant.html
[`proxy`]: {{site.dart-api}}/stable/2.19.6/dart-core/proxy-constant.html
[`CastError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CastError-class.html
[`TypeError`]: {{site.dart-api}}/dart-core/TypeError-class.html
[`FallThroughError`]: {{site.dart-api}}/stable/2.19.6/dart-core/FallThroughError-class.html
[`NullThrownError`]: {{site.dart-api}}/stable/2.19.6/dart-core/NullThrownError-class.html
[`AbstractClassInstantiationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/AbstractClassInstantiationError-class.html
[`CyclicInitializationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CyclicInitializationError-class.html
[`BidirectionalIterator`]: {{site.dart-api}}/stable/2.19.6/dart-core/BidirectionalIterator-class.html

#### `dart:async`

- Removida a classe descontinuada [`DeferredLibrary`][].
  Use a sintaxe de importação [`deferred as`][] em vez disso.

[`DeferredLibrary`]: {{site.dart-api}}/stable/2.19.6/dart-async/DeferredLibrary-class.html
[`deferred as`]: /language/libraries#lazily-loading-a-library

#### `dart:developer` {:#dart-developer}

- Removida a constante descontinuada [`MAX_USER_TAGS`][].
  Use [`maxUserTags`][] em vez disso.
- Removidas as classes descontinuadas [`Metrics`][], [`Metric`][], [`Counter`][]
  e [`Gauge`][], pois estão quebradas desde o Dart 2.0.

[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/2.19.6/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/dart-developer/UserTag/maxUserTags-constant.html
[`Metrics`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Gauge-class.html

#### `dart:html` {:#dart-html}

- Como anunciado anteriormente, os métodos descontinuados `registerElement`
  e `registerElement2` em `Document` e `HtmlDocument` foram
  removidos. Consulte [#49536]({{site.repo.dart.sdk}}/issues/49536) para
  detalhes.

#### `dart:math` {:#dart-math}

- A interface `Random` só pode ser implementada, não estendida.

#### `dart:io` {:#dart-io}

- Atualize `NetworkProfiling` para acomodar novos ids `String`
  que são introduzidos no vm_service:11.0.0

#### Sintoma

A análise do Dart (por exemplo, em seu IDE, ou em `dart analyze`/`flutter analyze`)
falhará com erros como:

```plaintext
erro linha 2 • Classe indefinida 'CyclicInitializationError'.
```

#### Migração

Migre manualmente para longe do uso dessas APIs.

### Extends & implements {:#extends-implements}

O Dart 3 suporta novos [modificadores de classe][] que
podem restringir os recursos de uma classe.
Eles foram aplicados a várias classes nas bibliotecas principais.

#### Escopo

Esta é uma mudança [*versionada*](#unversioned-vs-versioned-changes),
que só se aplica à versão da linguagem 3.0 ou posterior.

#### `dart:async`

* As seguintes declarações só podem ser implementadas, não estendidas:

  - `StreamConsumer`
  - `StreamIterator`
  - `StreamTransformer`
  - `MultiStreamController`

  Nenhuma dessas declarações continha qualquer implementação para herdar.
  Elas são marcadas como `interface` para indicar que
  são destinadas apenas como interfaces.

#### `dart:core`

* O tipo `Function` não pode mais ser implementado, estendido ou misturado.
  Desde o Dart 2.0, escrever `implements Function` tem sido permitido
  por compatibilidade retroativa, mas não teve qualquer efeito.
  No Dart 3.0, o tipo `Function` é final e não pode ser subtipado,
  impedindo que o código erroneamente assuma que funciona.

* As seguintes declarações só podem ser implementadas, não estendidas:

  - `Comparable`
  - `Exception`
  - `Iterator`
  - `Pattern`
  - `Match`
  - `RegExp`
  - `RegExpMatch`
  - `StackTrace`
  - `StringSink`

  Nenhuma dessas declarações continha qualquer implementação para herdar.
  Elas são marcadas como `interface` para indicar que
  são destinadas apenas como interfaces.

* As seguintes declarações não podem mais ser implementadas ou estendidas:

  - `MapEntry`
  - `OutOfMemoryError`
  - `StackOverflowError`
  - `Expando`
  - `WeakReference`
  - `Finalizer`

  A classe de valor `MapEntry` é restrita para permitir otimizações posteriores.
  As classes restantes estão intimamente ligadas à plataforma e não
  se destinam a ser subclasses ou implementadas.

#### `dart:collection` {:#dart-collection}

* A seguinte interface não pode mais ser estendida, apenas implementada:

  - `Queue`

* As seguintes classes de implementação não podem mais ser implementadas:

  - `LinkedList`
  - `LinkedListEntry`

* As seguintes classes de implementação não podem mais ser implementadas
  ou estendidas:

  - `HasNextIterator` (Também descontinuado.)
  - `HashMap`
  - `LinkedHashMap`
  - `HashSet`
  - `LinkedHashSet`
  - `DoubleLinkedQueue`
  - `ListQueue`
  - `SplayTreeMap`
  - `SplayTreeSet`

## Mudanças nas ferramentas do Dart 3 {:#dart-3-tools-changes}

### Ferramentas removidas {:#removed-tools}

Historicamente, a equipe do Dart ofereceu uma série de ferramentas de desenvolvedor menores para
coisas como formatar código (`dartfmt`), analisar código (`dartanalyzer`), etc.
No Dart 2.10 (outubro de 2020), introduzimos uma nova ferramenta de desenvolvedor Dart unificada, a
ferramenta [`dart`](/tools/dart-tool).

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

No Dart 3, essas ferramentas menores não existem, e
foram substituídas pela nova ferramenta `dart` combinada.

#### Migração

Use novos subcomandos disponíveis na ferramenta `dart`:

| Ferramenta histórica | Substituição `dart`                              | Descontinuação | Interrupção |
|-----------------|-----------------------------------------------|-------------|-----------------|
| `stagehand`     | [`dart create`](/tools/dart-create)           | [2.14]({{site.repo.dart.org}}/stagehand/issues/671)        | 2.14*  |
| `dartfmt`       | [`dart format`](/tools/dart-format)           | [2.14]({{site.repo.dart.org}}/dart_style/issues/986)        | [2.15]({{site.repo.dart.org}}/dart_style/issues/986)            |
| `dart2native`   | [`dart compile exe`](/tools/dart-compile#exe) | [2.14]({{site.repo.dart.sdk}}/commit/cac00e9d956a6f7ef28628989912d971f6b908d4)        | [2.15]({{site.repo.dart.sdk}}/commit/6c5fb84716b1f257b170351efe8096fe2af2809b)            |
| `dart2js`       | [`dart compile js`](/tools/dart-compile)      | [2.17]({{site.repo.dart.sdk}}/commit/8415b70e75b1d5bbe8251fa6a9eab2d970cf9eec)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartdevc`      | [`webdev`](/tools/webdev)                     | [2.17]({{site.repo.dart.sdk}}/commit/5173fd2d224f669fd8d0a1d21adbfd6187d10f53)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartanalyzer`  | [`dart analyze`](/tools/dart-analyze)         | [2.16]({{site.repo.dart.sdk}}/commit/f7af5c5256ee6f3a167f380722b96e8af4360b46)         | [2.18]({{site.repo.dart.sdk}}/issues/48457)             |
| `dartdoc`       | [`dart doc`](/tools/dart-doc)                 | [2.16]({{site.repo.dart.sdk}}/issues/44610)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/228647)             |
| `pub`           | [`dart pub`](/tools/dart-pub)                 | [2.15]({{site.repo.dart.org}}/pub/issues/2736)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/234283)             |

{:.table .table-striped .nowrap}

### Ferramentas de migração de segurança nula {:#null-safety-migration-tools}

Os seguintes comandos de migração de segurança nula foram removidos,
já que o Dart 3 [não suporta código sem segurança nula](#100-sound-null-safety):

- `dart migrate`
- `dart pub upgrade --null-safety`
- `dart pub outdated --mode=null-safety`

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Esses comandos falharão.

#### Migração

Use o Dart 2.19 para [migrar para a segurança nula](/null-safety/migration-guide).

### Configuração do analisador {:#analyzer-config}

As [opções de configuração do analisador][] para
habilitar verificações mais rigorosas foram alteradas.

[analyzer configuration options]: /tools/analysis#enabling-additional-type-checks

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

As opções de configuração anteriores falharão com um aviso como:

```plaintext
A opção 'implicit-casts' não é mais suportada.
Tente usar a nova opção 'strict-casts'.
```

#### Migração

Substitua esta parte da configuração do analisador:

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```

por:

```yaml
analyzer:
  language:
    strict-casts: true
    strict-raw-types: true
```

### Outras mudanças nas ferramentas {:#other-tools-changes}

* O Observatório descontinuado foi ocultado por padrão.
  Recomendamos o uso do [DevTools](/tools/dart-devtools).
* O comando `dart format fix` foi substituído por `dart fix`
  [#1153]({{site.repo.dart.org}}/dart_style/issues/1153).
* Os arquivos de snapshot incluídos no SDK para o compilador web do Dart
  foram limpos [#50700]({{site.repo.dart.sdk}}/issues/50700).
* A saída de `dart format` mudou um pouco para
  [algum código]({{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#formatter).
* Fim da compatibilidade retroativa para a localização antiga do pub-cache no Windows.
  Antes do Dart 3, `%APPDATA%\Pub\Cache` era um local de fallback para o pub-cache.
  A partir do Dart 3, o pub-cache padrão está localizado em
  `%LOCALAPPDATA%\Pub\Cache`.
  Se você adicionou pacotes ativados globalmente ao seu `PATH`, considere
  atualizar o `PATH` para conter `%LOCALAPPDATA%\Pub\Cache\bin`.

#### Escopo

Esta é uma mudança [*não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

[records]: /language/records
[patterns]: /language/patterns
[class modifiers]: /language/class-modifiers
