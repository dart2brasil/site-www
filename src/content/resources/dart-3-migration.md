---
ia-translate: true
title: Guia de migração para Dart 3
description: Como migrar código Dart existente para ser compatível com Dart 3.
---

Dart 3 é uma versão principal que introduz novas capacidades centrais ao Dart:
[records][], [patterns][] e [class modifiers][].

Junto com essas novas capacidades, o Dart 3 traz uma série de mudanças
que podem quebrar código existente.

Este guia vai ajudar você a resolver os problemas de migração que possa encontrar
depois de [atualizar para o Dart 3](/get-dart).

## Introdução

### Mudanças versionadas vs não versionadas {:#unversioned-vs-versioned-changes}

As mudanças potencialmente incompatíveis listadas abaixo se enquadram em uma de duas categorias:

* **Mudanças não versionadas**: essas mudanças afetam qualquer código Dart
  depois de atualizar para um SDK Dart 3.0 ou posterior.
  Não há como "desligar" essas mudanças.

* **Mudanças versionadas**: essas mudanças se aplicam somente quando a versão da linguagem
  do pacote ou aplicativo está definida como >= Dart 3.0.
  A [versão da linguagem](/language/versioning#language-version-numbers)
  é derivada do limite inferior do `sdk` no
  [arquivo `pubspec.yaml`](/tools/pub/packages#creating-a-pubspec).
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

Para usar os novos recursos do Dart 3, você precisa
atualizar a versão da linguagem para 3.0.
Isso também aplica as mudanças versionadas do Dart 3 ao mesmo tempo.

### Compatibilidade retroativa com Dart 3

Muitos pacotes e aplicativos que usaram null safety com Dart 2.12 ou
posterior provavelmente são compatíveis com Dart 3.
Isso vale para qualquer pacote cujo limite inferior da restrição do SDK
seja 2.12.0 ou superior.

A [ferramenta pub do Dart](/tools/pub/packages) permite a resolução mesmo quando
o limite superior está restrito a versões abaixo de 3.0.0.
Por exemplo, um pacote com a seguinte restrição
poderá ser resolvido com um SDK Dart 3.x, porque o pub reinterpreta o limite superior `<3.0.0` como `<4.0.0`
quando o limite inferior é `2.12` ou superior:

```yaml
environment:
  sdk: '>=2.14.0 <3.0.0'           # This is interpreted as '>=2.14.0 <4.0.0'
```

Isso permite que desenvolvedores usem o null safety sólido do Dart 3 com pacotes
que já suportam null safety 2.12
sem precisar de uma segunda migração, a menos que
o código seja afetado por outras mudanças do Dart 3.

### Testando o impacto

Para saber se seu código-fonte é afetado por alguma mudança do Dart 3,
siga estes passos:

```console
$ dart --version    # Make sure this reports 3.0.0 or higher.
$ dart pub get      # This should resolve without issues.
$ dart analyze      # This should pass without errors.
```

Se a etapa `pub get` falhar, tente atualizar suas dependências
para ver se versões mais recentes já suportam Dart 3:

```console
$ dart pub upgrade
$ dart analyze      # This should pass without errors.
```

Ou, se necessário, inclua também atualizações de [versões principais][major versions]:

```console
$ dart pub upgrade --major-versions
$ dart analyze      # This should pass without errors.
```

[major versions]: /tools/pub/cmd/pub-upgrade#major-versions

## Mudanças na linguagem Dart 3

### Null safety 100% sólido {:#100-sound-null-safety}

O Dart 2.12 introduziu o null safety há mais de dois anos.
No Dart 2.12, os usuários precisavam habilitar o null safety [com uma configuração no pubspec][with a pubspec setting].
No Dart 3, o null safety vem embutido; você não pode desligá-lo.

[with a pubspec setting]: /null-safety#enable-null-safety

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Pacotes desenvolvidos sem suporte a null safety vão causar problemas
ao resolver dependências com `pub get`:

```console
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Bibliotecas que desativam o null safety com [comentários de versão da linguagem][language version comments]
que selecionam qualquer versão da linguagem abaixo de `2.12` vão causar
erros de análise ou de compilação:

```console
$ dart analyze .
Analyzing ....                         0.6s

  error • lib/pkg1.dart:1:1 • The language version must be >=2.12.0. 
  Try removing the language version override and migrating the code.
  • illegal_language_version_override
```

```console
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Library doesn't support null safety.
// @dart=2.9
^^^^^^^^^^^^
```

[language version comments]: /language/versioning#library-override

#### Migração

Antes de começar qualquer migração para o Dart 3,
garanta que seu aplicativo ou pacote foi 100% migrado para habilitar o null safety.
Isso exige um SDK Dart `2.19`, não um SDK Dart 3.
Para aprender como migrar seu aplicativo ou pacote para suportar null safety,
confira o [guia de migração para null safety][null safety migration guide].

[null safety migration guide]: https://github.com/dart-community/migrate-to-null-safety/blob/main/docs/migrate.md#migrate-to-null-safety

### Sintaxe com dois-pontos para valores padrão

Por razões históricas, parâmetros opcionais nomeados podiam
especificar o valor padrão usando `:` ou `=`.
No Dart 3, só a sintaxe `=` é permitida.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica somente à versão da linguagem 3.0 ou posterior.

#### Sintoma

A análise do Dart produz erros como:

```plaintext
line 2 • Using a colon as a separator before a default value is no longer supported.
```

#### Migração

Troque o uso de dois-pontos:

```dart
int someInt({int x: 0}) => x;
```

Por igual:

```dart
int someInt({int x = 0}) => x;
```

Essa migração pode ser feita manualmente ou automatizada com `dart fix`:

```console
$ dart fix --apply --code=obsolete_colon_for_default_value
```

### `mixin`

Antes do Dart 3, qualquer `class` podia ser usada como `mixin`, desde que
não tivesse construtores declarados e nenhuma superclasse além de `Object`.

No Dart 3, classes declaradas em bibliotecas na versão da linguagem 3.0 ou posterior
não podem ser usadas como mixins, a menos que sejam marcadas com `mixin`.
Essa restrição se aplica ao código de qualquer biblioteca
que tente usar a classe como mixin,
independentemente da versão da linguagem dessa última biblioteca.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica somente à versão da linguagem 3.0 ou posterior.

#### Sintoma

Um erro de análise como:

```plaintext
Mixin can only be applied to class.
```

O analisador produz esse diagnóstico quando uma classe que não é nem uma
`mixin class` nem um `mixin` é usada em uma cláusula `with`.

#### Migração

Determine se a classe foi feita para ser usada como mixin.

Se a classe define uma interface, considere usar `implements`.

### `switch`

O Dart 3.0 interpreta os casos de [switch](/language/branches#switch)
como [patterns][] em vez de expressões constantes.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica somente à versão da linguagem 3.0 ou posterior.

#### Sintoma

A maioria das expressões constantes encontradas em casos de switch são patterns válidos
com o mesmo significado (constantes nomeadas, literais, etc.).
Elas vão se comportar da mesma forma e nenhum sintoma vai aparecer.

As poucas expressões constantes que não são patterns válidos
vão acionar o [lint `invalid_case_patterns`][`invalid_case_patterns` lint].

[`invalid_case_patterns` lint]: /tools/linter-rules/invalid_case_patterns

#### Migração

Você pode voltar ao comportamento original prefixando
o pattern do caso com `const`, para que ele não seja mais interpretado como pattern:

```dart
case const [1, 2]:
case const {'k': 'v'}:
case const {1, 2}:
case const Point(1, 2):
```

Você pode aplicar uma correção rápida para essa mudança incompatível
usando `dart fix` ou pela sua IDE.

### `continue`

O Dart 3 reporta um erro de tempo de compilação se uma instrução continue aponta para um label
que não é um loop (instruções `for`, `do` e `while`) nem um membro de switch.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica somente à versão da linguagem 3.0 ou posterior.

#### Sintoma

Você vai ver um erro como:

```plaintext
The label used in a 'continue' statement must be defined on either a loop or a switch member.
```

#### Migração

Se mudar o comportamento for aceitável,
altere o `continue` para apontar para uma instrução com label válida,
que deve estar associada a uma instrução `for`, `do` ou `while`.

Se você quiser preservar o comportamento, troque a
instrução `continue` por uma instrução `break`.
Em versões anteriores do Dart, uma instrução `continue`
que não apontava para um loop nem para um membro de switch
se comportava como `break`.

## Mudanças nas bibliotecas principais do Dart 3

### APIs removidas

**Mudança incompatível [#49529][]**: as bibliotecas principais foram limpas
para remover APIs que estavam descontinuadas havia vários anos.
As seguintes APIs não existem mais nas bibliotecas principais do Dart.

[#49529]: {{site.repo.dart.sdk}}/issues/49529

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### `dart:core`

- Removido o construtor `List` descontinuado, pois não era null safe.
  Use literais de lista (por exemplo, `[]` para uma lista vazia ou `<int>[]` para uma
  lista tipada vazia) ou [`List.filled`][]. Isso afeta apenas código sem null safety,
  pois código com null safety já não podia usar esse construtor.
- Removido o argumento `onError` descontinuado em [`int.parse`][], [`double.parse`][],
  e [`num.parse`][]. Use o método [`tryParse`][] no lugar.
- Removidas as anotações [`proxy`][] e [`Provisional`][] descontinuadas.
  A anotação `proxy` original não tinha efeito no Dart 2,
  e o tipo `Provisional` e a constante [`provisional`][]
  eram usados apenas internamente durante o desenvolvimento do Dart 2.0.
- Removido o getter [`Deprecated.expires`][] descontinuado.
  Use [`Deprecated.message`][] no lugar.
- Removido o erro [`CastError`][] descontinuado.
  Use [`TypeError`][] no lugar.
- Removido o erro [`FallThroughError`][] descontinuado. O tipo de
  fall-through que antes lançava esse erro passou a ser um erro de tempo de
  compilação no Dart 2.0.
- Removido o erro [`NullThrownError`][] descontinuado. Esse erro nunca é
  lançado por código com null safety.
- Removido o erro [`AbstractClassInstantiationError`][] descontinuado. Chamar o construtor
  de uma classe abstrata virou erro de tempo de compilação no Dart 2.0.
- Removido o [`CyclicInitializationError`] descontinuado. Dependências cíclicas não são
  mais detectadas em tempo de execução em código com null safety. Esse código vai falhar de outras
  formas, possivelmente com um StackOverflowError.
- Removido o construtor padrão descontinuado de [`NoSuchMethodError`][].
  Use o construtor nomeado [`NoSuchMethodError.withInvocation`][] no lugar.
- Removida a classe [`BidirectionalIterator`][] descontinuada.
  Iteradores bidirecionais existentes ainda podem funcionar; só não têm mais
  um supertipo compartilhado que os prende a um nome específico para voltar.

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

- Removida a classe [`DeferredLibrary`][] descontinuada.
  Use a sintaxe de importação [`deferred as`][] no lugar.

[`DeferredLibrary`]: {{site.dart-api}}/stable/2.19.6/dart-async/DeferredLibrary-class.html
[`deferred as`]: /language/libraries#lazily-loading-a-library

#### `dart:developer`

- Removida a constante [`MAX_USER_TAGS`][] descontinuada.
  Use [`maxUserTags`][] no lugar.
- Removidas as classes [`Metrics`][], [`Metric`][], [`Counter`][]
  e [`Gauge`][] descontinuadas, pois estavam quebradas desde o Dart 2.0.

[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/2.19.6/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/dart-developer/UserTag/maxUserTags-constant.html
[`Metrics`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Gauge-class.html

#### `dart:html`

- Como anunciado anteriormente, os métodos descontinuados `registerElement`
  e `registerElement2` de `Document` e `HtmlDocument` foram
  removidos. Veja [#49536]({{site.repo.dart.sdk}}/issues/49536) para
  detalhes.

#### `dart:math`

- A interface `Random` só pode ser implementada, não estendida.

#### `dart:io`

- Atualizado `NetworkProfiling` para acomodar os novos ids `String`
  introduzidos no vm_service:11.0.0.

#### Sintoma

A análise do Dart (por exemplo, na sua IDE ou em `dart analyze`/`flutter analyze`)
vai falhar com erros como:

```plaintext
error line 2 • Undefined class 'CyclicInitializationError'.
```

#### Migração

Migre manualmente para deixar de usar essas APIs.

### Extends & implements

O Dart 3 suporta novos [modificadores de classe][class modifiers] que
podem restringir as capacidades de uma classe.
Eles foram aplicados a várias classes nas bibliotecas principais.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica somente à versão da linguagem 3.0 ou posterior.

#### `dart:async`

* As seguintes declarações só podem ser implementadas, não estendidas:

  - `StreamConsumer`
  - `StreamIterator`
  - `StreamTransformer`
  - `MultiStreamController`

  Nenhuma dessas declarações contém implementação para herdar.
  Elas são marcadas como `interface` para indicar que
  são destinadas apenas a interfaces.

#### `dart:core`

* O tipo `Function` não pode mais ser implementado, estendido ou usado como mixin.
  Desde o Dart 2.0, escrever `implements Function` era permitido
  por compatibilidade retroativa, mas não tinha nenhum efeito.
  No Dart 3.0, o tipo `Function` é final e não pode ser subtipado,
  o que evita que o código assuma por engano que funciona.

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

  Nenhuma dessas declarações contém implementação para herdar.
  Elas são marcadas como `interface` para indicar que
  são destinadas apenas a interfaces.

* As seguintes declarações não podem mais ser implementadas nem estendidas:

  - `MapEntry`
  - `OutOfMemoryError`
  - `StackOverflowError`
  - `Expando`
  - `WeakReference`
  - `Finalizer`

  A classe de valor `MapEntry` foi restrita para permitir otimizações futuras.
  As demais classes são fortemente acopladas à plataforma e não são
  destinadas a serem subclasseadas ou implementadas.

#### `dart:collection`

* A seguinte interface não pode mais ser estendida, só implementada:

  - `Queue`

* As seguintes classes de implementação não podem mais ser implementadas:

  - `LinkedList`
  - `LinkedListEntry`

* As seguintes classes de implementação não podem mais ser implementadas
  nem estendidas:

  - `HasNextIterator` (também descontinuada.)
  - `HashMap`
  - `LinkedHashMap`
  - `HashSet`
  - `LinkedHashSet`
  - `DoubleLinkedQueue`
  - `ListQueue`
  - `SplayTreeMap`
  - `SplayTreeSet`

## Mudanças nas ferramentas do Dart 3

### Ferramentas removidas

Historicamente, a equipe do Dart ofereceu várias ferramentas menores para
tarefas como formatar código (`dartfmt`), analisar código (`dartanalyzer`), etc.
No Dart 2.10 (outubro de 2020) introduzimos uma nova ferramenta unificada para desenvolvedores Dart, a
[ferramenta `dart`](/tools/dart-tool).

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

No Dart 3 essas ferramentas menores não existem mais e
foram substituídas pela nova ferramenta combinada `dart`.

#### Migração

Use os novos subcomandos disponíveis na ferramenta `dart`:

| Ferramenta histórica | Substituta no `dart`                         | Depreciação | Descontinuação |
|----------------------|----------------------------------------------|-------------|----------------|
| `stagehand`          | [`dart create`](/tools/dart-create)          | [2.14]({{site.repo.dart.org}}/stagehand/issues/671)        | 2.14*  |
| `dartfmt`            | [`dart format`](/tools/dart-format)          | [2.14]({{site.repo.dart.org}}/dart_style/issues/986)        | [2.15]({{site.repo.dart.org}}/dart_style/issues/986)            |
| `dart2native`        | [`dart compile exe`](/tools/dart-compile#exe)| [2.14]({{site.repo.dart.sdk}}/commit/cac00e9d956a6f7ef28628989912d971f6b908d4)        | [2.15]({{site.repo.dart.sdk}}/commit/6c5fb84716b1f257b170351efe8096fe2af2809b)            |
| `dart2js`            | [`dart compile js`](/tools/dart-compile)     | [2.17]({{site.repo.dart.sdk}}/commit/8415b70e75b1d5bbe8251fa6a9eab2d970cf9eec)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartdevc`           | [`webdev`](/tools/webdev)                    | [2.17]({{site.repo.dart.sdk}}/commit/5173fd2d224f669fd8d0a1d21adbfd6187d10f53)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartanalyzer`       | [`dart analyze`](/tools/dart-analyze)        | [2.16]({{site.repo.dart.sdk}}/commit/f7af5c5256ee6f3a167f380722b96e8af4360b46)         | [2.18]({{site.repo.dart.sdk}}/issues/48457)             |
| `dartdoc`            | [`dart doc`](/tools/dart-doc)                | [2.16]({{site.repo.dart.sdk}}/issues/44610)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/228647)             |
| `pub`                | [`dart pub`](/tools/dart-pub)                | [2.15]({{site.repo.dart.org}}/pub/issues/2736)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/234283)             |

{:.table .table-striped .nowrap}

### Ferramentas de migração de null safety

Os seguintes comandos de migração de null safety foram removidos,
pois o Dart 3 [não suporta código sem null safety](#100-sound-null-safety):

- `dart migrate`
- `dart pub upgrade --null-safety`
- `dart pub outdated --mode=null-safety`

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Esses comandos vão falhar.

#### Migração

Use o Dart 2.19 para [migrar para null safety][migrate to null safety].

[migrate to null safety]: https://github.com/dart-community/migrate-to-null-safety/blob/main/docs/migrate.md#migrate-to-null-safety

### Configuração do analisador

As [opções de configuração do analisador][analyzer configuration options] para
habilitar verificações mais rigorosas foram alteradas.

[analyzer configuration options]: /tools/analysis#enabling-additional-type-checks

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

As opções de configuração anteriores vão falhar com um aviso como:

```plaintext
The option 'implicit-casts' is no longer supported.
Try using the new 'strict-casts' option.
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

* O Observatory descontinuado foi ocultado por padrão.
  Recomendamos usar o [DevTools](/tools/dart-devtools).
* O comando `dart format fix` foi substituído por `dart fix`
  [#1153]({{site.repo.dart.org}}/dart_style/issues/1153).
* Os arquivos snapshot incluídos no SDK para o compilador web do Dart
  foram limpos [#50700]({{site.repo.dart.sdk}}/issues/50700).
* A saída de `dart format` mudou um pouco para
  [alguns casos de código]({{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#formatter).
* Fim da compatibilidade retroativa com a localização antiga do pub-cache no Windows.
  Antes do Dart 3, `%APPDATA%\Pub\Cache` era uma localização de fallback para o pub-cache.
  A partir do Dart 3, o pub-cache padrão fica em
  `%LOCALAPPDATA%\Pub\Cache`.
  Se você adicionou pacotes ativados globalmente ao seu `PATH`, considere
  atualizar o `PATH` para conter `%LOCALAPPDATA%\Pub\Cache\bin`.

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

[records]: /language/records
[patterns]: /language/patterns
[class modifiers]: /language/class-modifiers
