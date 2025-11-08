---
title: Guia de migração para Dart 3
description: Como migrar código Dart existente para ser compatível com Dart 3.
ia-translate: true
---

Dart 3 é uma versão principal que introduz novas capacidades centrais ao Dart:
[records][], [patterns][] e [class modifiers][].

Junto com essas novas capacidades, Dart 3 contém uma série de mudanças
que podem quebrar código existente.

Este guia ajudará você a resolver quaisquer problemas de migração que possa encontrar
após [atualizar para Dart 3](/get-dart).

## Introdução

### Mudanças versionadas vs não versionadas

As mudanças potencialmente incompatíveis listadas abaixo se enquadram em uma de duas categorias:

* **Mudanças não versionadas**: Essas mudanças afetam qualquer código Dart
  após atualizar para um SDK Dart 3.0 ou posterior.
  Não há maneira de "desativar" essas mudanças.

* **Mudanças versionadas**: Essas mudanças se aplicam apenas quando a versão da linguagem
  do pacote ou aplicativo está definida como >= Dart 3.0.
  A [versão da linguagem](/resources/language/evolution#language-version-numbers)
  é derivada da restrição inferior do `sdk` no
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
Isso também aplicará as mudanças versionadas do Dart 3 ao mesmo tempo.

### Compatibilidade retroativa do Dart 3

Muitos pacotes e aplicativos que usaram null safety com Dart 2.12 ou
posterior provavelmente são compatíveis retroativamente com Dart 3.
Isso é possível para qualquer pacote em que
o limite inferior da restrição do SDK seja 2.12.0 ou superior.

A [ferramenta pub do Dart](/tools/pub/packages) permite resolução mesmo quando
o limite superior está limitado a versões abaixo de 3.0.0.
Por exemplo, um pacote com a seguinte restrição
será permitido resolver com um SDK Dart 3.x,
pois pub reinterpretará a restrição superior `<3.0.0` como `<4.0.0`
quando a restrição inferior for `2.12` ou superior:

```yaml
environment:
  sdk: '>=2.14.0 <3.0.0'           # Isso é interpretado como '>=2.14.0 <4.0.0'
```

Isso permite que desenvolvedores usem o null safety sólido do Dart 3 com pacotes
que já suportam null safety 2.12
sem precisar de uma segunda migração, a menos que
o código seja afetado por outras mudanças do Dart 3.

### Testando o impacto

Para entender se seu código-fonte é impactado por quaisquer mudanças do Dart 3,
use estas etapas:

```console
$ dart --version    # Certifique-se de que isso reporta 3.0.0 ou superior.
$ dart pub get      # Isso deve resolver sem problemas.
$ dart analyze      # Isso deve passar sem erros.
```

Se a etapa `pub get` falhar, tente atualizar suas dependências
para ver se versões mais recentes podem suportar Dart 3:

```console
$ dart pub upgrade
$ dart analyze      # Isso deve passar sem erros.
```

Ou, se necessário, inclua também atualizações de [versões principais][major versions]:

```console
$ dart pub upgrade --major-versions
$ dart analyze      # Isso deve passar sem erros.
```

[major versions]: /tools/pub/cmd/pub-upgrade#major-versions

## Mudanças na linguagem Dart 3

### Null safety 100% sólido

Dart 2.12 introduziu null safety há mais de dois anos.
No Dart 2.12, os usuários precisavam habilitar null safety [com uma configuração no pubspec][with a pubspec setting].
No Dart 3, null safety está incorporado; você não pode desativá-lo.

[with a pubspec setting]: /null-safety#enable-null-safety

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Pacotes desenvolvidos sem suporte a null safety causarão problemas
ao resolver dependências com `pub get`:

```console
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Bibliotecas que optam por não usar null safety com [comentários de versão da linguagem][language version comments]
que selecionam qualquer versão da linguagem abaixo de `2.12` causarão
erros de análise ou compilação:

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

[language version comments]: /resources/language/evolution#per-library-language-version-selection

#### Migração

Antes de iniciar qualquer migração para Dart 3,
certifique-se de que seu aplicativo ou pacote foi 100% migrado para habilitar null safety.
Isso requer um SDK Dart `2.19`, não um SDK Dart 3.
Para aprender como migrar primeiro seu aplicativo ou pacote para suportar null safety,
confira o [guia de migração de null safety][null safety migration guide].

[null safety migration guide]: /null-safety/migration-guide

### Sintaxe de dois pontos para valores padrão

Por razões históricas, parâmetros opcionais nomeados podiam
especificar seu valor padrão usando `:` ou `=`.
No Dart 3, apenas a sintaxe `=` é permitida.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica apenas à versão da linguagem 3.0 ou posterior.

#### Sintoma

A análise Dart produz erros como:

```plaintext
line 2 • Using a colon as a separator before a default value is no longer supported.
```

#### Migração

Mude de usar dois pontos:

```dart
int someInt({int x: 0}) => x;
```

Para usar igual:

```dart
int someInt({int x = 0}) => x;
```

Esta migração pode ser feita manualmente ou automatizada com `dart fix`:

```console
$ dart fix --apply --code=obsolete_colon_for_default_value
```

### `mixin`

Antes do Dart 3, qualquer `class` podia ser usada como um `mixin`, desde que
não tivesse construtores declarados e nenhuma superclasse além de `Object`.

No Dart 3, classes declaradas em bibliotecas na versão da linguagem 3.0 ou posterior
não podem ser usadas como mixins a menos que sejam marcadas como `mixin`.
Esta restrição se aplica ao código em qualquer biblioteca
tentando usar a classe como um mixin,
independentemente da versão da linguagem desta última biblioteca.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica apenas à versão da linguagem 3.0 ou posterior.

#### Sintoma

Um erro de análise como:

```plaintext
Mixin can only be applied to class.
```

O analisador produz este diagnóstico quando uma classe que não é nem uma
`mixin class` nem um `mixin` é usada em uma cláusula `with`.

#### Migração

Determine se a classe é destinada a ser usada como um mixin.

Se a classe define uma interface, considere usar `implements`.

### `switch`

Dart 3.0 interpreta casos de [switch](/language/branches#switch)
como [patterns][] em vez de expressões constantes.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica apenas à versão da linguagem 3.0 ou posterior.

#### Sintoma

A maioria das expressões constantes encontradas em casos switch são patterns válidos
com o mesmo significado (constantes nomeadas, literais, etc.).
Estes se comportarão da mesma forma e nenhum sintoma surgirá.

As poucas expressões constantes que não são patterns válidos
acionarão o [lint `invalid_case_patterns`][`invalid_case_patterns` lint].

[`invalid_case_patterns` lint]: /tools/linter-rules/invalid_case_patterns

#### Migração

Você pode reverter para o comportamento original prefixando
o pattern do caso com `const`, para que não seja mais interpretado como um pattern:

```dart
case const [1, 2]:
case const {'k': 'v'}:
case const {1, 2}:
case const Point(1, 2):
```

Você pode executar uma correção rápida para esta mudança incompatível,
usando `dart fix` ou a partir de sua IDE.

### `continue`

Dart 3 reporta um erro de tempo de compilação se uma instrução continue tem como alvo um rótulo
que não é um loop (instruções `for`, `do` e `while`) ou um membro switch.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica apenas à versão da linguagem 3.0 ou posterior.

#### Sintoma

Você verá um erro como:

```plaintext
The label used in a 'continue' statement must be defined on either a loop or a switch member.
```

#### Migração

Se mudar o comportamento é aceitável,
altere o `continue` para ter como alvo uma instrução rotulada válida,
que deve estar anexada a uma instrução `for`, `do` ou `while`.

Se você quiser preservar o comportamento, altere a
instrução `continue` para uma instrução `break`.
Em versões anteriores do Dart, uma instrução `continue`
que não tinha como alvo um loop ou um membro switch
se comportava como `break`.

## Mudanças nas bibliotecas principais do Dart 3

### APIs removidas

**Mudança incompatível [#49529][]**: As bibliotecas principais foram limpas
para remover APIs que foram descontinuadas por vários anos.
As seguintes APIs não existem mais nas bibliotecas principais do Dart.

[#49529]: {{site.repo.dart.sdk}}/issues/49529

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### `dart:core`

- Removido o construtor `List` descontinuado, pois não era null safe.
  Use literais de lista (por exemplo, `[]` para uma lista vazia ou `<int>[]` para uma
  lista tipada vazia) ou [`List.filled`][]. Isso afeta apenas código não null safe,
  pois código null safe já não podia usar este construtor.
- Removido o argumento `onError` descontinuado em [`int.parse`][], [`double.parse`][],
  e [`num.parse`][]. Use o método [`tryParse`][] em vez disso.
- Removidas as anotações [`proxy`][] e [`Provisional`][] descontinuadas.
  A anotação original `proxy` não tem efeito no Dart 2,
  e o tipo `Provisional` e a constante [`provisional`][]
  foram usados apenas internamente durante o processo de desenvolvimento do Dart 2.0.
- Removido o getter [`Deprecated.expires`][] descontinuado.
  Use [`Deprecated.message`][] em vez disso.
- Removido o erro [`CastError`][] descontinuado.
  Use [`TypeError`][] em vez disso.
- Removido o erro [`FallThroughError`][] descontinuado. O tipo de
  fall-through que anteriormente lançava este erro foi tornado um erro de tempo
  de compilação no Dart 2.0.
- Removido o erro [`NullThrownError`][] descontinuado. Este erro nunca é
  lançado a partir de código null safe.
- Removido o erro [`AbstractClassInstantiationError`][] descontinuado. Foi tornado
  um erro de tempo de compilação chamar o construtor de uma classe abstrata no Dart 2.0.
- Removido o [`CyclicInitializationError`] descontinuado. Dependências cíclicas não são
  mais detectadas em tempo de execução em código null safe. Tal código falhará de outras
  formas, possivelmente com um StackOverflowError.
- Removido o construtor padrão [`NoSuchMethodError`][] descontinuado.
  Use o construtor nomeado [`NoSuchMethodError.withInvocation`][] em vez disso.
- Removida a classe [`BidirectionalIterator`][] descontinuada.
  Iteradores bidirecionais existentes ainda podem funcionar, apenas não têm
  um supertipo compartilhado bloqueando-os a um nome específico para mover para trás.

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
  Use a sintaxe de importação [`deferred as`][] em vez disso.

[`DeferredLibrary`]: {{site.dart-api}}/stable/2.19.6/dart-async/DeferredLibrary-class.html
[`deferred as`]: /language/libraries#lazily-loading-a-library

#### `dart:developer`

- Removida a constante [`MAX_USER_TAGS`][] descontinuada.
  Use [`maxUserTags`][] em vez disso.
- Removidas as classes [`Metrics`][], [`Metric`][], [`Counter`][],
  e [`Gauge`][] descontinuadas, pois estão quebradas desde o Dart 2.0.

[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/2.19.6/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/dart-developer/UserTag/maxUserTags-constant.html
[`Metrics`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Gauge-class.html

#### `dart:html`

- Como anunciado anteriormente, os métodos `registerElement`
  e `registerElement2` descontinuados em `Document` e `HtmlDocument` foram
  removidos. Veja [#49536]({{site.repo.dart.sdk}}/issues/49536) para
  detalhes.

#### `dart:math`

- A interface `Random` só pode ser implementada, não estendida.

#### `dart:io`

- Atualizado `NetworkProfiling` para acomodar novos ids `String`
  que são introduzidos em vm_service:11.0.0

#### Sintoma

A análise Dart (por exemplo, em sua IDE ou em `dart analyze`/`flutter analyze`)
falhará com erros como:

```plaintext
error line 2 • Undefined class 'CyclicInitializationError'.
```

#### Migração

Migre manualmente para não usar essas APIs.

### Extends & implements

Dart 3 suporta novos [modificadores de classe][class modifiers] que
podem restringir as capacidades de uma classe.
Eles foram aplicados a várias classes nas bibliotecas principais.

#### Escopo

Esta é uma [mudança *versionada*](#unversioned-vs-versioned-changes),
que se aplica apenas à versão da linguagem 3.0 ou posterior.

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
  Desde o Dart 2.0, escrever `implements Function` foi permitido
  por compatibilidade retroativa, mas não teve nenhum efeito.
  No Dart 3.0, o tipo `Function` é final e não pode ser subtipado,
  impedindo que o código assuma erroneamente que funciona.

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
  As classes restantes são fortemente acopladas à plataforma e não são
  destinadas a serem subclasseadas ou implementadas.

#### `dart:collection`

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

## Mudanças nas ferramentas do Dart 3

### Ferramentas removidas

Historicamente, a equipe Dart ofereceu várias ferramentas menores de desenvolvedor para
tarefas como formatar código (`dartfmt`), analisar código (`dartanalyzer`), etc.
No Dart 2.10 (Outubro de 2020) introduzimos uma nova ferramenta unificada de desenvolvedor Dart, a
[ferramenta `dart`](/tools/dart-tool).

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

No Dart 3, essas ferramentas menores não existem e
foram substituídas pela nova ferramenta combinada `dart`.

#### Migração

Use novos sub-comandos disponíveis na ferramenta `dart`:

| Ferramenta histórica | Substituição `dart`                          | Descontinuação | Descontinuação |
|---------------------|----------------------------------------------|----------------|-----------------|
| `stagehand`         | [`dart create`](/tools/dart-create)          | [2.14]({{site.repo.dart.org}}/stagehand/issues/671)        | 2.14*  |
| `dartfmt`           | [`dart format`](/tools/dart-format)          | [2.14]({{site.repo.dart.org}}/dart_style/issues/986)        | [2.15]({{site.repo.dart.org}}/dart_style/issues/986)            |
| `dart2native`       | [`dart compile exe`](/tools/dart-compile#exe)| [2.14]({{site.repo.dart.sdk}}/commit/cac00e9d956a6f7ef28628989912d971f6b908d4)        | [2.15]({{site.repo.dart.sdk}}/commit/6c5fb84716b1f257b170351efe8096fe2af2809b)            |
| `dart2js`           | [`dart compile js`](/tools/dart-compile)     | [2.17]({{site.repo.dart.sdk}}/commit/8415b70e75b1d5bbe8251fa6a9eab2d970cf9eec)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartdevc`          | [`webdev`](/tools/webdev)                    | [2.17]({{site.repo.dart.sdk}}/commit/5173fd2d224f669fd8d0a1d21adbfd6187d10f53)         | [2.18]({{site.repo.dart.sdk}}/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartanalyzer`      | [`dart analyze`](/tools/dart-analyze)        | [2.16]({{site.repo.dart.sdk}}/commit/f7af5c5256ee6f3a167f380722b96e8af4360b46)         | [2.18]({{site.repo.dart.sdk}}/issues/48457)             |
| `dartdoc`           | [`dart doc`](/tools/dart-doc)                | [2.16]({{site.repo.dart.sdk}}/issues/44610)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/228647)             |
| `pub`               | [`dart pub`](/tools/dart-pub)                | [2.15]({{site.repo.dart.org}}/pub/issues/2736)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/234283)             |

{:.table .table-striped .nowrap}

### Ferramentas de migração de null safety

Os seguintes comandos de migração de null safety foram removidos,
pois Dart 3 [não suporta código sem null safety](#100-sound-null-safety):

- `dart migrate`
- `dart pub upgrade --null-safety`
- `dart pub outdated --mode=null-safety`

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

Esses comandos falharão.

#### Migração

Use Dart 2.19 para [migrar para null safety](/null-safety/migration-guide).

### Configuração do analisador

As [opções de configuração do analisador][analyzer configuration options] para
habilitar verificação mais rigorosa foram alteradas.

[analyzer configuration options]: /tools/analysis#enabling-additional-type-checks

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

#### Sintoma

As opções de configuração anteriores falharão com um aviso como:

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

### Outras mudanças de ferramentas

* O Observatory descontinuado foi ocultado por padrão.
  Recomendamos usar [DevTools](/tools/dart-devtools).
* O comando `dart format fix` foi substituído por `dart fix`
  [#1153]({{site.repo.dart.org}}/dart_style/issues/1153).
* Os arquivos snapshot incluídos no SDK para o compilador web Dart
  foram limpos [#50700]({{site.repo.dart.sdk}}/issues/50700).
* A saída de `dart format` mudou um pouco para
  [algum código]({{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#formatter).
* Finalizando compatibilidade retroativa para a localização antiga do pub-cache no Windows.
  Antes do Dart 3, `%APPDATA%\Pub\Cache` era uma localização de fallback para pub-cache.
  A partir do Dart 3, o pub-cache padrão está localizado em
  `%LOCALAPPDATA%\Pub\Cache`.
  Se você adicionou pacotes ativados globalmente ao seu `PATH`, considere
  atualizar `PATH` para conter `%LOCALAPPDATA%\Pub\Cache\bin`.

#### Escopo

Esta é uma [mudança *não versionada*](#unversioned-vs-versioned-changes),
que se aplica a todo código Dart 3.

[records]: /language/records
[patterns]: /language/patterns
[class modifiers]: /language/class-modifiers
