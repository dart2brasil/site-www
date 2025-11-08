---
title: Mudanças incompatíveis e descontinuações
description: Uma lista de mudanças incompatíveis por versão em Dart.
maxTocDepth: 2
lastVerified: 2025-08-13
ia-translate: true
---

{% assign versioned = '<span class="tag-label language-versioned-tag">Language versioned</span>' %}
{% assign deprecated = '<span class="tag-label deprecated-tag">Deprecated</span>' %}
{% assign removed = '<span class="tag-label removed-tag">Removed</span>' %}
{% assign experimental = '<span class="tag-label experimental-tag">Experimental</span>' %}

Esta página lista todas as mudanças incompatíveis e descontinuações em
atualizações do Dart SDK, organizadas por versão e área,
para ajudar desenvolvedores Dart a entender e gerenciar seu impacto.
Notas de versão completas estão disponíveis no [changelog do Dart SDK][changelog].
O documento de [política de mudanças incompatíveis][breaking change policy] descreve a política e processo
em torno de mudanças incompatíveis e descontinuações em Dart.

**Esta página inclui os seguintes tipos de mudanças incompatíveis:**

**Sem versionamento**
: O Dart SDK não mantém compatibilidade retroativa,
  e o código pode quebrar assim que você [atualizar sua versão do sdk][sdk] se
  ele depender do comportamento anterior.

  _Estas são a maioria das mudanças e não são especialmente marcadas nesta lista._

**Versionamento de linguagem**
: O Dart SDK mantém compatibilidade retroativa para código existente,
  e a mudança de comportamento só entra em vigor (potencialmente quebrando
  código que depende do comportamento anterior) quando você
  atualizar a [versão da linguagem][language version] do seu código.

  _Estas são marcadas como:_ {{versioned}}

**Descontinuações**
: O Dart SDK mantém compatibilidade para código descontinuado, com um aviso.
  Descontinuações são então completamente removidas em uma versão posterior,
  quebrando qualquer código que dependa do comportamento anterior.

  _Estas são marcadas como:_ {{deprecated}} / {{removed}}

**Experimental**
: Parte da versão mas ainda não tratado como estável no SDK e
  pode quebrar de uma versão para outra.
  Mudanças experimentais nem sempre têm uma issue de mudança incompatível correspondente,
  mas podem ter mais detalhes no [changelog do SDK][changelog].

  Estas são marcadas: {{experimental}}

Se você tiver perguntas ou preocupações sobre qualquer uma dessas mudanças incompatíveis,
por favor comente na issue de mudança incompatível vinculada à entrada relevante.
Para ser notificado sobre futuras mudanças incompatíveis, junte-se ao grupo [Dart announce][].

[breaking change policy]: {{site.repo.dart.sdk}}/blob/main/docs/process/breaking-changes.md
[changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[sdk]: /get-dart
[language version]: /resources/language/evolution#language-versioning
[Dart announce]: {{site.announce}}

{% comment %}
Create new section from these headers for each release.
If no changes exist in a section (e.g. Language, `dart:async`, etc.),
don't include the section header.

## x.x.x

### Language

### Libraries

#### (`dart:core`, `package:js`, etc)

### Tools

#### (Dart VM, Pub, Linter, `dart2js`, etc)
{% endcomment %}

## 3.11.0

:::note Tentativa
As seguintes mudanças são esperadas para serem incluídas na versão estável 3.11,
mas a lista final pode mudar antes disso.
Para reduzir o impacto potencial dessas mudanças, considere
contabilizá-las antes da versão 3.11.
:::

### Tools

#### Compilação Wasm (`dart compile wasm`)

- {{removed}}
  Código que importa `dart:js_util` ou `package:js` agora
  [resulta em um erro de compilação][61550] ao compilar para WebAssembly.

  Invocar qualquer API dessas bibliotecas resultará em um erro de runtime.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.

[61550]: {{site.repo.dart.sdk}}/issues/61550

## 3.10.0

:::note Tentativa
As seguintes mudanças são esperadas para serem incluídas na versão estável 3.10,
mas a lista final pode mudar antes disso.
Para reduzir o impacto potencial dessas mudanças, considere
contabilizá-las antes da versão 3.10.
:::

### Language

- Funções geradoras `sync*` e `async*` sem um retorno especificado agora
  inferem corretamente tipos de retorno como não-anuláveis quando nenhum valor `null` é produzido.
  Isso pode acionar novos diagnósticos relacionados a elementos de código desnecessários,
  como um operador de acesso null-aware desnecessário (`?.`).

### Libraries

#### `dart:core`

- As funções `Uri.parseIPv4Address` e `Uri.parseIPv6Address`
  [não permitem mais incorretamente][61392] zeros à esquerda em endereços IPv4.

- {{deprecated}}
  A capacidade de implementar `RegExp` e `RegExpMatch` está descontinuada
  e será removida em uma versão futura.

[61392]: {{site.repo.dart.sdk}}/issues/61392

#### `dart:io`

- `IOOverrides` [não pode mais ser implementado][56468],
  mas ainda pode ser estendido.

[56468]: {{site.repo.dart.sdk}}/issues/56468

#### `dart:js_interop`

- A extensão `Uint16ListToJSInt16Array` foi
  renomeada para `Uint16ListToJSUint16Array`.

- A extensão `JSUint16ArrayToInt16List` foi
  renomeada para `JSUint16ArrayToUint16List`.

- A função `Function.toJSCaptureThis` agora resulta em verificações
  adicionais em tempo de compilação para corresponder a `Function.toJS`.
  Se a função não tiver um tipo estaticamente conhecido,
  tiver tipos não suportados em sua assinatura, incluir parâmetros de tipo,
  ou tiver quaisquer parâmetros nomeados, a chamada resultará em um erro de compilação.

### Tools

#### SDK

- A CLI `dart` e a Dart VM agora são executáveis separados,
  com o executável e processo puro da Dart VM chamado `dartvm`.
  Programas Dart ainda devem ser executados com [`dart run`][].

- Subcomandos da ferramenta `dart`, como `dart format` e `dart compile`
  agora executam snapshots compilados AOT das ferramentas subjacentes.
  Não deve haver diferença funcional fora de melhorias de desempenho,
  mas se você encontrar incompatibilidades, por favor [relate-as][sdk report].

- {{removed}}
  A ferramenta `dart` não está mais disponível para plataformas IA32
  pois o Dart SDK não suporta mais IA32.

[`dart run`]: /tools/dart-run
[sdk report]: {{site.repo.dart.sdk}}/issues/new/choose

#### Analyzer

- Usar membros marcados como `@experimental` fora
  do pacote em que são declarados
  agora resulta em um aviso.

- Regras de lint habilitadas em arquivos de opções de análise incluídos
  agora resultam em diagnósticos de lint incompatíveis quando apropriado.

- {{removed}}
  A anotação `@required` descontinuada de
  `package:meta` não é mais suportada.
  Para marcar um parâmetro como obrigatório, use a palavra-chave `required`.

#### Compilação Wasm (`dart compile wasm`)

- `dart:js_util` e `package:js` [não são mais suportados][61550] ao
  compilar para WebAssembly.
  Invocar qualquer API dessas bibliotecas resultará em um erro de runtime.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.

- Para corresponder aos compiladores JS, `dartify` quando compilado para Wasm,
  [agora converte][54573] objetos JS `Promise` para objetos Dart `Future`
  em vez de objetos Dart `JSValue`.

[61550]: {{site.repo.dart.sdk}}/issues/61550
[54573]: {{site.repo.dart.sdk}}/issues/54573

## 3.9.0

### Language

- {{versioned}}
  Null safety agora é assumido ao computar
  promoção de tipo, alcançabilidade e atribuição definitiva.
  Como resultado, análise de código morto melhorada pode
  fazer com que novos diagnósticos do analisador sejam acionados em
  código existente que anteriormente passou na análise.

### Tools

- Alguns subcomandos da ferramenta `dart`, como `dart analyze` e `dart fix`
  agora executam snapshots compilados AOT das ferramentas subjacentes.
  Não deve haver diferença funcional fora de melhorias de desempenho,
  mas se você encontrar incompatibilidades, por favor [relate-as][sdk report].

[sdk report]: {{site.repo.dart.sdk}}/issues/new/choose

#### Pub

- {{versioned}}
  O limite superior da restrição do SDK `flutter`
  no pacote raiz do seu workspace agora é respeitado.
  Se seu SDK atual não atender ao limite especificado,
  `dart pub get` e outras ações que recuperam dependências falharão.

#### Dart build

- {{experimental}}
  Construir um bundle de aplicativo CLI com suporte experimental a native asset agora
  requer usar o subcomando `dart build cli` e
  especificar o ponto de entrada do aplicativo com uma nova opção `--target`.

## 3.8.0

### Libraries

#### `dart:html`

- {{removed}}
  O construtor `Element.created` foi removido.
- Classes nativas em `dart:html`, como `HtmlElement`,
  [não podem mais ser estendidas][53264].

[53264]: {{site.repo.dart.sdk}}/issues/53264

### Tools

#### Analyzer

- {{deprecated}}
  A regra de lint [`avoid_null_checks_in_equality_operators`][] está
  descontinuada e deve ser removida dos arquivos `analysis_options.yaml`.

[`avoid_null_checks_in_equality_operators`]: /tools/linter-rules/avoid_null_checks_in_equality_operators

#### Development JavaScript compiler (DDC)

- Agora lança um erro de runtime quando um
  construtor factory redirecionador é [torn off][tear-offs] e
  um de seus parâmetros opcionais não-anuláveis não recebe valor.
  No futuro isso provavelmente será um erro de compilação.

[tear-offs]: /language/functions#tear-offs

#### Production JavaScript compiler (dart2js)

- {{experimental}} {{removed}}
  As flags `--experiment-new-rti` e `--use-old-rti` não são mais suportadas.

#### Formatter (`dart format`)

- {{versioned}}
  O formatter fez mudanças e correções que resultam em nova saída ao
  formatar código com uma [versão da linguagem][language version] de 3.8 ou superior.

[language version]: /resources/language/evolution#language-versioning

## 3.7.0

### Language

- {{versioned}} [Variáveis locais e parâmetros nomeados `_`][wildcards] agora
  não são vinculados e não podem mais ser usados ou acessados.
- [Análise de alcançabilidade agora contabiliza se um campo é
  promovido de tipo para `Null` usando `is` ou `as`][56893].
  Isso torna o sistema de tipos mais auto-consistente, porque
  espelha o comportamento de variáveis locais promovidas.
  Esta mudança não é esperada fazer qualquer diferença na prática.

[wildcards]: /language/variables#wildcard-variables
[56893]: {{site.repo.dart.sdk}}/issues/56893

### Libraries

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audo`, `dart:web_gl`, `dart:js`

- {{deprecated}} Estas bibliotecas web legadas estão oficialmente descontinuadas.
  Espera-se que sejam removidas em uma versão futura.
  Projetos devem migrar para usar [`package:web`][] e `dart:js_interop`.
  Para saber mais, confira [Migrar para package:web][Migrate to package:web].

[`package:web`]: {{site.pub-pkg}}/web
[Migrate to package:web]: /interop/js-interop/package-web

#### `dart:js`, `dart:js_util`, `package:js`

- {{deprecated}} Estas bibliotecas JS-interop legadas estão oficialmente descontinuadas.
  Espera-se que sejam removidas em uma versão futura.
  Projetos devem migrar para usar `dart:js_interop`.
  Para saber mais, confira [Uso de JS interop][JS interop usage].

[JS interop usage]: /interop/js-interop/usage

### Tools

#### Analyzer

- {{removed}} As regras de lint [`package_api_docs`][] e [`unsafe_html`][]
  foram removidas e devem ser removidas dos arquivos `analysis_options.yaml`.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Formatter (`dart format`)

- {{versioned}} O formatter implementa um [novo estilo][new style] que resulta em
  nova saída ao formatar código com uma [versão da linguagem][language version] de 3.7 ou superior.
- {{removed}} A flag `--fix` para `dart format` não é mais suportada.
  Para aplicar correções similares e mais,
  [configure suas opções de análise][configure your analysis options] e execute [`dart fix`][].
- {{deprecated}} A opção `--line-length` para `dart format` foi
  descontinuada e está programada para ser removida.
  Todos os usos devem ser migrados para a nova opção `--page-width`.

[new style]: {{site.repo.dart.org}}/dart_style/issues/1253
[language version]: /resources/language/evolution#language-versioning
[configure your analysis options]: /tools/analysis
[`dart fix`]: /tools/dart-fix

## 3.6.0

### Language

- [O contexto usado pelo Dart para realizar inferência de tipo no
  operando de uma expressão throw foi alterado de
  "tipo desconhecido" para `Object`][56065].
  Isso torna o sistema de tipos mais auto-consistente, porque
  reflete o fato de que não é legal lançar `null`.
  Esta mudança não é esperada fazer qualquer diferença na prática.

[56065]: {{site.repo.dart.sdk}}/issues/56065

### Libraries

#### `dart:io`

- {{removed}} [O construtor `Platform()` foi removido][52444].
  Todas as instanciações de `Platform` devem ser removidas.
- `HttpClient` agora responde a um redirect que está faltando um cabeçalho "Location"
  [lançando uma `RedirectException` em vez de uma `StateError`][53618].

[52444]: {{site.repo.dart.sdk}}/issues/52444
[53618]: {{site.repo.dart.sdk}}/issues/53618

### Tools

#### Analyzer

- {{deprecated}} As regras de lint [`package_api_docs`][] e [`unsafe_html`][]
  foram descontinuadas e estão programadas para serem removidas no Dart 3.7.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Compiler front end (cfe)

- O compilador Dart agora [computa os fechamentos superior e inferior de esquemas de tipo
  logo antes de serem passados para o procedimento de teste de subtipo][56466].
  Antes do Dart 3.6, o compilador os computava no início
  dos cálculos de limite superior e inferior.
  O analisador já seguia este comportamento, então aplicativos que
  já passam na análise provavelmente não serão afetados por esta mudança.

[56466]: {{site.repo.dart.sdk}}/issues/56466

#### Wasm compiler (dart2wasm)

- A condição `dart.library.js` agora é `false` em importações condicionais
  ao compilar para WebAssembly.
  A condição `dart.library.js_interop` deve ser usada no lugar.

#### Formatter (`dart format`)

As seguintes mudanças podem resultar em pequenas alterações de formatação
ao executar `dart format` com um SDK Dart 3.6 ou posterior:

- Preservar parâmetros de tipo em formais de tipo função de estilo antigo que
  também usam `this.` ou `super.`.
- Formatar corretamente importações com cláusulas `as` e `if`.

#### Pub

- `dart pub publish` agora avisa se arquivos que são
  rastreados no git têm mudanças não commitadas.

## 3.5.0

### Language

- [O contexto usado pelo compilador para realizar inferência de tipo no
  operando de uma expressão `await` foi alterado para
  corresponder ao comportamento do analisador.][55418]
- [O contexto usado pelo compilador para realizar inferência de tipo no
  lado direito de uma expressão "if-null" (`e1 ?? e2`) foi
  alterado para corresponder ao comportamento do analisador.][55436]
  O comportamento antigo pode ser restaurado fornecendo tipos explícitos.

[55418]: {{site.repo.dart.sdk}}/issues/55418
[55436]: {{site.repo.dart.sdk}}/issues/55436

### Libraries

#### `dart:core`

- [`DateTime` agora armazena microssegundos na plataforma web][44876],
  correspondendo mais de perto ao comportamento em plataformas nativas.

[44876]: {{site.repo.dart.sdk}}/issues/44876

#### `dart:io`

- [`SecurityContext` agora é final e não pode mais ser subclassificado][55786].

[55786]: {{site.repo.dart.sdk}}/issues/55786

#### `dart:js_interop`

- [`importModule` agora aceita um `JSAny` em vez de uma `String`][55508] para
  suportar outros valores JS também, como objetos `TrustedScriptURL`.
- [`isTruthy` e `not` agora retornam `JSBoolean` em vez de `bool`][55267] para
  serem consistentes com outros métodos de operador JS.
- [`ExternalDartReference` não implementa mais `Object`][56015].
  Em vez disso, agora aceita um parâmetro de tipo (`T`) com um limite de
  `Object?` para capturar o tipo do objeto Dart que é externalizado.

[55508]: {{site.repo.dart.sdk}}/issues/55508
[55267]: {{site.repo.dart.sdk}}/issues/55267
[56015]: {{site.repo.dart.sdk}}/issues/56015

#### `dart:typed_data`

- {{removed}}
  [As classes de visualização não modificável para typed data foram removidas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de typed data.

### Runtime

- {{removed}} A Dart VM não suporta mais null safety não sonoro.
  - A opção CLI `--no-sound-null-safety` foi removida.
  - As funções `Dart_NewListOf` e `Dart_IsLegacyType` foram
    removidas da API C.
- {{removed}} A função `Dart_DefaultCanonicalizeUrl` foi
  removida da API C.

## 3.4.0

### Language

- [O esquema de tipo de contexto de pattern para cast patterns
  agora é `_` (o tipo desconhecido) em vez de `Object?`][54640].
- [O esquema de tipo usado pelos compiladores Dart para
  realizar inferência de tipo no operando de um operador spread null-aware (`...?`)
  em literais de map e set foi tornado anulável][54828],
  para corresponder ao que atualmente acontece em literais de list.

[54640]: {{site.repo.dart.sdk}}/issues/54640
[54828]: {{site.repo.dart.sdk}}/issues/54828

### Libraries

#### `dart:cli`

- {{experimental}} {{removed}} [A função `waitFor`][52121]
  foi removida.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audo`, `dart:web_gl`

- {{deprecated}} Estas bibliotecas agora são marcadas como legado e
  terão menos suporte no futuro.
  Novos projetos devem preferir usar [`package:web`][] e `dart:js_interop`.
  Para saber mais, confira [Migrar para package:web][Migrate to package:web].

[`package:web`]: {{site.pub-pkg}}/web
[Migrate to package:web]: /interop/js-interop/package-web

#### `dart:js`

- {{deprecated}}
  Esta biblioteca agora é marcada como legado e terá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, confira [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:js_util`

- {{deprecated}}
  Esta biblioteca agora é marcada como legado e terá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, confira [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:io`

- [`Stdout` tem um novo campo `lineTerminator`, que permite
  desenvolvedores controlarem o final de linha usado por `stdout` e `stderr`.][53863]
  Classes que implementam `Stdout` devem definir o campo `lineTerminator`.
  A semântica padrão de `stdout` e `stderr` não foi alterada.
- {{deprecated}} A propriedade `FileSystemDeleteEvent.isDirectory`.
  Sempre retorna `false`.

[53863]: {{site.repo.dart.sdk}}/issues/53863

#### `dart:typed_data`

- {{deprecated}}
  [As classes de visualização não modificável para typed data estão descontinuadas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de typed data.

[53128]: {{site.repo.dart.sdk}}/issues/53218

### Tools

#### Production JavaScript compiler (dart2js)

- {{experimental}} {{deprecated}} Você agora deve especificar um formato para
  a opção CLI `--dump-info` de `binary` ou `json`.
  O formato `json` está descontinuado e pode ser removido em uma versão futura do Dart.

#### Wasm compiler (dart2wasm)

- {{experimental}} Vários argumentos CLI de `dart compile wasm` foram
  atualizados, removidos ou substituídos.
  Para saber mais, execute `dart compile wasm --verbose --help`.

### Runtime

- {{removed}} A Dart VM não suporta mais strings externas.
  Como resultado, as funções `Dart_IsExternalString`, `Dart_NewExternalLatin1String` e
  `Dart_NewExternalUTF16String` foram removidas da API C do Dart.

## 3.3.0

### SDK

* {{experimental}} {{removed}} Os seguintes experimentos agora estão aposentados pois
  foram lançados no Dart 3 e não são mais necessários com
  uma versão de linguagem de 3.0 ou superior.
  A configuração deles deve ser removida de
  opções de análise, comandos CLI e configurações de IDE.

  * `patterns`
  * `records`
  * `class-modifers`
  * `sealed-class`

### Language

* [Um getter abstrato agora é considerado promovível se
  não houver declarações conflitantes][54056].

[54056]: {{site.repo.dart.sdk}}/issues/54056

### Libraries

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`][52121]
  permanece descontinuada por mais uma versão e está programada para remoção no Dart 3.4.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:ffi`

* {{deprecated}} [Os métodos de aritmética de ponteiro `elementAt`
  em tipos `Pointer` estão descontinuados][54250].
  Migre para os operadores `-` e `+` no lugar.
* {{experimental}} {{removed}} A anotação `@FfiNative` previamente descontinuada
  foi removida. Os usos devem ser
  atualizados para usar a anotação `@Native`.

[54250]: {{site.repo.dart.sdk}}/issues/54250

#### `dart:html`

* Em vez de usar `HttpRequest` diretamente,
  agora é recomendado usar [`package:http`][].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:io`

* Em vez de usar `HttpClient` diretamente,
  agora é recomendado usar [`package:http`][].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:js_interop`

* {{experimental}} Tipos JS como `JSAny` têm
  [novos tipos de representação específicos do compilador][52687].
* {{experimental}} Classes `@staticInterop` definidas pelo usuário
  [não podem mais implementar `JSAny` ou `JSObject`][52687].
  Os usos devem ser migrados para `JSObject.fromInteropObject` ou
  serem definidos como extension types.
* {{experimental}} `JSArray` e `JSPromise` agora têm parâmetros genéricos.
* {{experimental}} Vários membros de extensão foram movidos ou renomeados.
  Para saber sobre as extensões atualizadas, consulte
  `JSAnyUtilityExtension` e `JSAnyOperatorExtension`.

[52687]: {{site.repo.dart.sdk}}/issues/52687

#### `dart:typed_data`

* [As classes de visualização não modificável para typed data serão
  descontinuadas no Dart 3.4][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de typed data.

[53128]: {{site.repo.dart.sdk}}/issues/53218

#### `dart:nativewrappers`

* {{experimental}} [Todas as classes wrapper nativas agora são marcadas como `base`][51896]
  para que nenhum de seus subtipos possa ser implementado.

[51896]: {{site.repo.dart.sdk}}/issues/51896

### Tools

#### Production JavaScript compiler (dart2js)

* [O `Invocation` que é passado para `noSuchMethod` não tem mais
  um `memberName` minificado][54201], mesmo quando compilado com `--minify`.

[54201]: {{site.repo.dart.sdk}}/issues/54201

#### Wasm compiler (dart2wasm)

* {{experimental}} [Não permite importar bibliotecas JS interop legadas][54004].
  Prefira usar `dart:js_interop` e `dart:js_interop_unsafe` no lugar.

[54004]: {{site.repo.dart.sdk}}/issues/54004

#### Analyzer

* {{experimental}} Diretivas de comentário `dart doc` inválidas agora são
  relatadas pelo analisador.
* Devido a [melhorias na promoção de tipo][54056], os seguintes
  diagnósticos do analisador podem ser acionados em código existente que anteriormente passou na análise:

  * `unnecessary_non_null_assertion`
  * `unnecessary_cast`
  * `invalid_null_aware_operator`

[54056]: {{site.repo.dart.sdk}}/issues/54056

#### Linter

* Os lints `iterable_contains_unrelated_type` e
  `list_remove_unrelated_type` foram removidos.
  Considere migrar para o lint expandido
  [`collection_methods_unrelated_type`][].
* Os seguintes lints foram removidos por não serem mais
  necessários com null safety sonoro. Você deve remover a configuração deles
  dos seus arquivos `analysis_options.yaml` e quaisquer comentários ignore.

  * `always_require_non_null_named_parameters`
  * `avoid_returning_null`
  * `avoid_returning_null_for_future`

[`collection_methods_unrelated_type`]: /tools/linter-rules/collection_methods_unrelated_type

## 3.2.0

### Language

* {{versioned}} [Alterou o ponto de divisão para patterns refutáveis][53167]
  para o pattern de nível superior, de modo que a promoção de tipo em declarações if-case seja consistente
  independentemente de o scrutinee poder lançar uma exceção.

### Libraries

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`.][52121]

#### `dart:convert`

* [Alterou os tipos de retorno de `utf8.encode()` e `Utf8Codec.encode()`][52801]
 de `List<int>` para `Uint8List`.

#### `dart:developer`

* {{deprecated}} O método `Service.getIsolateID`.

#### `dart:ffi`

* [Alterou `NativeCallable.nativeFunction` para que as chamadas agora lancem um erro se
  o receptor já estiver fechado][53311], em vez de retornar `nullptr`.

#### `dart:io`

* [Eliminou espaços em branco no final de cabeçalhos HTTP][53005].
* [Inseriu um espaço no ponto de dobra de valores de cabeçalho dobrados][53227]
  que `HttpClientResponse.headers` e `HttpRequest.headers` retornam.

#### `dart:js_interop`

* {{experimental}} {{removed}} `JSNumber.toDart` em favor de `toDartDouble` e
  `toDartInt`.
* {{experimental}} {{removed}} `Object.toJS` em favor de `Object.toJSBox.`
* {{experimental}} Restringiu APIs JS interop externas usando `dart:js_interop`
  a um conjunto de tipos permitidos.
* {{experimental}} Proibiu o uso de `isNull` e `isUndefined` no dart2wasm.
* {{experimental}} Alterou as APIs `typeofEquals` e `instanceof` para retornarem
  bool em vez de `JSBoolean`.
  Além disso, `typeofEquals` agora aceita `String` em vez de `JSString`.
* {{experimental}} Alterou os tipos `JSAny` e `JSObject` para serem apenas implementáveis,
  não estendíveis, por tipos `@staticInterop` do usuário.
* {{experimental}} Alterou `JSArray.withLength` para aceitar `int` em vez de `JSNumber`.

### Tools

#### Development JavaScript compiler (DDC)

* [Adicionou interceptadores para tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Production JavaScript compiler (dart2js)

* [Adicionou interceptadores para tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Analyzer

* {{versioned}} [Promoção de campo final privado][2020] pode fazer com que os seguintes
  avisos do analisador sejam acionados em código existente que anteriormente passou na análise:

  * [`unnecessary_non_null_assertion`](/tools/diagnostic-messages#unnecessary_non_null_assertion)
  * [`invalid_null_aware_operator`](/tools/diagnostic-messages#invalid_null_aware_operator)
  * [`unnecessary_cast`](/tools/diagnostic-messages#unnecessary_cast)

  ```dart
  class C {
    final num? _x = null;

    void test() {
      if (_x != null) {
        print(_x! * 2); // unnecessary_non_null_assertion
        print(_x?.abs()); // invalid_null_aware_operator
      }
      if (_x is int) {
        print((_x as int).bitLength); // unnecessary_cast
      }
    }
  }
  ```

[53167]: {{site.repo.dart.sdk}}/issues/53167
[52121]: {{site.repo.dart.sdk}}/issues/52121
[52801]: {{site.repo.dart.sdk}}/issues/52801
[53311]: {{site.repo.dart.sdk}}/issues/53311
[53005]: {{site.repo.dart.sdk}}/issues/53005
[53227]: {{site.repo.dart.sdk}}/issues/53227
[53106]: {{site.repo.dart.sdk}}/issues/53106
[2020]: {{site.repo.dart.lang}}/issues/2020


## 3.1.0

### Libraries

#### `dart:async`

* [Adicionou modificador `interface` a classes puramente abstratas:][52334]
 `MultiStreamController`, `StreamConsumer`, `StreamIterator` e `StreamTransformer`.

#### `dart:io`

* [Adicionou `sameSite` à classe `Cookie`, e adicionou a classe `SameSite`][51486].
* [`FileSystemEvent` é `sealed`][52027]. Isso significa que `FileSystemEvent` não pode ser
  estendido ou implementado.

#### `dart:js_interop`

* {{experimental}} {{removed}} `ObjectLiteral`; crie um literal de objeto sem
  membros nomeados usando `{}.jsify()`.

#### `package:js`

* Membros `external` `@staticInterop` e membros de extensão `external` não podem mais
  ser usados como tear-offs. Declare um closure ou um método não-`external` que
  chama esses membros, e use isso no lugar.
* Membros `external` `@staticInterop` e membros de extensão `external` irão
  gerar código JS ligeiramente diferente para métodos que têm parâmetros opcionais.

[52334]: {{site.repo.dart.sdk}}/issues/52334
[51486]: {{site.repo.dart.sdk}}/issues/51486
[52027]: {{site.repo.dart.sdk}}/issues/52027

## 3.0.0

:::tip
O [guia de migração do Dart 3.0][dart3] cobre os detalhes completos
de todas as mudanças nesta seção.
:::

### Language

* {{versioned}} Alterou a interpretação de [switch cases] de expressões
  constantes para patterns.

* {{versioned}} Declarações de classe de bibliotecas que foram atualizadas
  para Dart 3.0 [não podem mais ser usadas como mixins por padrão][mixin class].

* [Dart relata um erro de compilação][50902] se uma declaração `continue` tem como alvo
  um [label] que não é um loop (declarações `for`, `do` e `while`) ou um membro de `switch`.

### Libraries

* As seguintes classes existentes foram transformadas em mixin classes:
  `Iterable`, `IterableMixin`, `IterableBase`, `ListMixin`, `SetMixin`, `MapMixin`,
  `LinkedListEntry`, `StringConversionSink`.

#### `dart:core`

* {{deprecated}} [APIs descontinuadas][49529].

#### `dart:async`

* {{removed}} [Removida a classe descontinuada][49529] [`DeferredLibrary`][].

#### `dart:collection`

* {{versioned}} [Mudanças nas bibliotecas de plataforma][collection].

#### `dart:developer`

* {{removed}} [Removida a constante descontinuada][49529] [`MAX_USER_TAGS`][].
  Use [`maxUserTags`][] no lugar.
* {{removed}} [Removidas as classes descontinuadas][50231] [`Metrics`][], [`Metric`][], [`Counter`][],
  e [`Gauge`][] pois estão quebradas desde o Dart 2.0.

#### `dart:ffi`

* {{experimental}} {{deprecated}} A anotação `@FfiNative` está
  agora descontinuada. Os usos devem ser atualizados para usar a anotação `@Native`.

#### `dart:html`

* {{removed}} [Removidos os métodos descontinuados `registerElement` e `registerElement2`][49536]
  em `Document` e `HtmlDocument`.

#### `dart:math`

* {{versioned}} A interface `Random` só pode ser implementada,
  não estendida.

#### `dart:io`

* [Atualizado `NetworkProfiling`][51035] para acomodar novos ids `String` que são
  introduzidos em vm_service:11.0.0

[dart3]: /resources/dart-3-migration/
[switch cases]: /language/branches#switch
[mixin class]: /language/mixins#class-mixin-or-mixin-class
[label]: /language/branches#switch
[50902]: {{site.repo.dart.sdk}}/issues/50902
[collection]: /resources/dart-3-migration#dart-collection
[49529]: {{site.repo.dart.sdk}}/issues/49529
[`DeferredLibrary`]: {{site.dart-api}}/stable/2.18.4/dart-async/DeferredLibrary-class.html
[`deferred as`]: /language/libraries#lazily-loading-a-library
[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/beta/2.19.0-255.2.beta/dart-developer/UserTag/maxUserTags-constant.html
[50231]: {{site.repo.dart.sdk}}/issues/50231
[`Metrics`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Gauge-class.html
[49536]: {{site.repo.dart.sdk}}/issues/49536
[51035]: {{site.repo.dart.sdk}}/issues/51035


## 2.19.0

### Language

* [Marcou código adicional como inalcançável][49635] devido aos tipos `Null` e `Never`.
* [Não delegar nomes privados inacessíveis para `noSuchMethod`][49687].
* [Relatar um erro de compilação][50383] para todas as dependências cíclicas durante
  inferência de tipo de nível superior.

### Libraries

#### `dart:convert`

* {{removed}} [A API previamente descontinuada][34233] [`DEFAULT_BUFFER_SIZE`] em `JsonUtf8Encoder`
  foi removida.

#### `dart:developer`

* {{removed}} [Removidas APIs previamente descontinuadas][34233] `kInvalidParams`,
  `kExtensionError`, `kExtensionErrorMax` e `kExtensionErrorMin` em
  [`ServiceExtensionResponse`].

#### `dart:ffi`

* [Alterado o argumento de tipo de runtime de `Pointer` para `Never`][49935] em
  preparação para remover completamente o argumento de tipo de runtime.
  Alterado `Pointer.toString` para não relatar nenhum argumento de tipo.

#### `dart:io`

* [Não permite cabeçalhos content-length negativos ou hexadecimais][49305].
* [`File.create` agora aceita um novo parâmetro `bool` opcional `exclusive`][49647],
  e quando é `true` a operação falhará se o arquivo de destino já existir.
* Chamar `ResourceHandle.toFile()`, `ResourceHandle.toSocket()`,
  `ResourceHandle.toRawSocket()` ou `ResourceHandle.toRawDatagramSocket()`,
  mais de uma vez [agora lança um `StateError`][49878].

#### `dart:isolate`

* Revertido [`SendPort.send`] de volta para verificações estritas no conteúdo de mensagens ao
  enviar mensagens entre isolates que não são conhecidos por compartilhar o mesmo código.

#### `dart:mirrors`

* {{removed}} [Removidas APIs][34233] `MirrorsUsed` e `Comment`.

#### `package:js`

* Mudanças incompatíveis no recurso de prévia `@staticInterop`:
  * Não permitido que classes com esta anotação usem construtores
    generativos `external`. Veja [48730] e [49941] para mais detalhes.
  * [Não permitido que classes com membros de extensão externos desta anotação
    usem parâmetros de tipo][49350].
  * Classes com esta anotação também devem ter a anotação `@JS`.
  * Classes com esta anotação não podem ser implementadas por classes sem esta
    anotação.

#### `dart2js`

* [`dart2js` não suporta mais URIs HTTP como entradas][49473].

[49635]: {{site.repo.dart.sdk}}/issues/49635
[49687]: {{site.repo.dart.sdk}}/issues/49687
[50383]: {{site.repo.dart.sdk}}/issues/50383
[34233]: {{site.repo.dart.sdk}}/issues/34233
[`ServiceExtensionResponse`]: {{site.dart-api}}/stable/2.17.6/dart-developer/ServiceExtensionResponse-class.html#constants
[49935]: {{site.repo.dart.sdk}}/issues/49935
[49305]: {{site.repo.dart.sdk}}/issues/49305
[49647]: {{site.repo.dart.sdk}}/issues/49647
[49878]: {{site.repo.dart.sdk}}/issues/49878
[`SendPort.send`]: {{site.dart-api}}/stable/dart-isolate/SendPort/send.html
[34233]: {{site.repo.dart.sdk}}/issues/34233
[49473]: {{site.repo.dart.sdk}}/issues/49473
[48730]: {{site.repo.dart.sdk}}/issues/48730
[49941]: {{site.repo.dart.sdk}}/issues/49941
[49350]: {{site.repo.dart.sdk}}/issues/49350


## 2.18.0

### Language

* [Removido suporte para mixin de classes que não estendem `Object`][48167].

### Libraries

#### `dart:io`

* [Alterada a propriedade `uri` de `RedirectException` em `dart:io` para ser anulável][49045].
* [Removidas constantes em APIs de rede `dart:io` seguindo a convenção
  `SCREAMING_CAPS`][34218].
* [A Dart VM não restaura mais automaticamente as configurações iniciais do terminal][45630]
  na saída.

### Tools

* [Completamente descontinuado o arquivo `.packages`][48272].

#### Dart command line

* [Removidas as ferramentas standalone `dart2js` e `dartdevc`][46100].
* [Removida a ferramenta standalone `dartanalyzer`][46100].

[48167]: {{site.repo.dart.sdk}}/issues/48167
[49045]: {{site.repo.dart.sdk}}/issues/49045
[34218]: {{site.repo.dart.sdk}}/issues/34218
[45630]: {{site.repo.dart.sdk}}/issues/45630
[48272]: {{site.repo.dart.sdk}}/issues/48272
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.17.0

### Libraries

#### `dart:io`

* [Adicionada nova propriedade `connectionFactory` a `HttpClient`][47887].
* [Adicionada nova propriedade `keyLog` a `HttpClient`][48093], que permite que chaves TLS sejam
  registradas para fins de depuração.
* [Removidas constantes em `dart:io` seguindo `SCREAMING_CAPS`][34218]
* [Adicionada uma nova propriedade `allowLegacyUnsafeRenegotiation` a `SecurityContext`][48513],
  que permite renegociação TLS para sockets seguros de cliente.

### Tools

#### Dart command line

* {{deprecated}} [Descontinuada a ferramenta standalone `dart2js`][46100].
* {{deprecated}} [Descontinuada a ferramenta standalone `dartdevc`][46100].
* {{removed}} [Removida a ferramenta standalone `dartdoc`][46100].

[47887]: {{site.repo.dart.sdk}}/issues/47887
[48093]: {{site.repo.dart.sdk}}/issues/48093
[34218]: {{site.repo.dart.sdk}}/issues/34218
[48513]: {{site.repo.dart.sdk}}/issues/48513
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.16.0

### Libraries

#### `dart:io`

* No Windows, [`Directory.rename` não deletará mais um diretório][47653] se
  `newPath` especificar um. Em vez disso, uma `FileSystemException` será lançada.
* {{removed}} [Removida a API `Platform.packageRoot`][47769].

#### `dart:isolate`

* {{removed}} [Removida a API `Isolate.packageRoot`][47769].

### Tools

#### Dart command line

* {{deprecated}} [Descontinuada a ferramenta standalone `dartanalyzer`][46100].
* {{deprecated}} [Descontinuada a ferramenta standalone `dartdoc`][46100].
* {{removed}} [Removida a ferramenta standalone `pub` descontinuada][46100].

[47653]: {{site.repo.dart.sdk}}/issues/47653
[47769]: {{site.repo.dart.sdk}}/issues/47769
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.15.0

### Libraries

#### `dart:io`

* [Atualizada a classe `SecurityContext`][46875] para definir a versão mínima
  do protocolo TLS para TLS1_2_VERSION (1.2) em vez de TLS1_VERSION.

#### `dart:web_sql`

* [Completamente deletada a biblioteca `dart:web_sql`][46316].

#### `dart:html`

* [Removido `window.openDatabase`][46316] (relacionado à exclusão de `dart:web_sql` acima).

### Tools

#### Dart command line

* [Removida a ferramenta standalone `dart2native`][46100].
* Removida a ferramenta standalone `dartfmt`.

#### Dart VM

* [Removido suporte para extensões nativas estilo `dart-ext:`][45451]
* [Agrupados isolates gerados via API `Isolate.spawn()`][46754] para operar no
  mesmo heap gerenciado e, portanto, compartilhar várias estruturas de dados internas da VM.

[46875]: {{site.repo.dart.sdk}}/issues/46875
[46316]: {{site.repo.dart.sdk}}/issues/46316
[45451]: {{site.repo.dart.sdk}}/issues/45451
[46754]: {{site.repo.dart.sdk}}/issues/46754

## 2.14.0

### Libraries

#### `dart:io`

* Os callbacks setter `.authenticate` e `.authenticateProxy` em `HttpClient`
  agora devem aceitar um argumento `realm` anulável (para código null safe pré-migrado).

#### `dart:typed_data`

* A maioria dos tipos expostos por esta biblioteca [não podem mais ser estendidos, implementados ou
  misturados][45115].

### Tools

#### Dart VM

* Expandos, e os parâmetros `object` de `Dart_NewWeakPersistentHandle` e
  `Dart_NewFinalizableHandle`, [não aceitam mais `Pointer` e subtipos de `Struct`][45071]

#### Dart command line

* [Descontinuada a ferramenta standalone `dart2native`][46100]
* Descontinuada a ferramenta standalone `dartfmt`.

#### `dart2js`

* [`dart2js` não suporta mais navegadores legados][46545], porque emite ES6+
  JavaScript por padrão.

#### Dart Dev Compiler (DDC)

* [Alteradas relações de subtipagem de classes `package:js`][44154] para serem mais corretas e
  consistentes com Dart2JS.

[45115]: {{site.repo.dart.sdk}}/issues/45115
[45071]: {{site.repo.dart.sdk}}/issues/45071
[46545]: {{site.repo.dart.sdk}}/issues/46545
[44154]: {{site.repo.dart.sdk}}/issues/44154


## 2.13.0

### Libraries

#### `package:js`

* [Não é mais válido][44211] usar uma `String` que corresponda a uma anotação `@Native`
  em uma anotação `@JS()` para uma classe JS interop não-anônima.

[44211]: {{site.repo.dart.sdk}}/issues/44211

## 2.12.0

### Language

* [Null safety] agora está habilitado por padrão em todo o código que
  não optou por sair.
* [Corrigido um bug de implementação][44660] onde `this` às vezes sofreria
  promoção de tipo em extensões.

### Libraries

#### `dart:ffi`

* [Descontinuadas invocações com um `T` genérico][44621] de `sizeOf<T>`,
  `Pointer<T>.elementAt()`, `Pointer<T extends Struct>.ref`, e
  `Pointer<T extends Struct>[]`
* [Descontinuado `allocate` em `package:ffi`][44621], pois não será mais capaz de
  invocar `sizeOf<T>` genericamente.
* [Descontinuados subtipos de `Struct` sem nenhum membro nativo][44622].

### Tools

#### Dart VM

* [`Dart_WeakPersistentHandle` não se auto-deleta mais][42312] quando o
  objeto referenciado é coletado pelo garbage collector para evitar condições de corrida.
* [Renomeado `Dart_WeakPersistentHandleFinalizer` para `Dart_HandleFinalizer`][42312]
  e removido seu argumento `handle`.

#### Pub

* [A restrição do Dart SDK agora é **obrigatória** em `pubspec.yaml`][44072].

[Null safety]: /null-safety/understanding-null-safety
[44660]: {{site.repo.dart.sdk}}/issues/44660
[44621]: {{site.repo.dart.sdk}}/issues/44621
[42312]: {{site.repo.dart.sdk}}/issues/42312
[44622]: {{site.repo.dart.sdk}}/issues/44622
[44072]: {{site.repo.dart.sdk}}/issues/44072

## 2.10.0

### Tools

#### Dart VM

* [Renomeado `dart_api_dl.cc` para `dart_api_dl.c`][42982] e alterado para um arquivo C puro.

[42982]: {{site.repo.dart.sdk}}/issues/42982

## 2.9.0

### Libraries

#### `dart:convert`

* Ao codificar uma string contendo surrogates não pareados como UTF-8, [os surrogates não pareados
  serão codificados como caracteres de substituição][41100] (`U+FFFD`).
* Ao decodificar UTF-8, [surrogates codificados serão tratados como entrada malformada][41100].
* [Alterado o número de caracteres de substituição emitidos][41100] para sequências de
  entrada malformadas para corresponder ao [padrão de codificação WHATWG][WHATWG encoding standard] ao decodificar UTF-8
  com `allowMalformed: true`.

#### `dart:html`

* `CssClassSet.add()` e `CssClassSet.toggle` agora retornam `false` em vez de
   `null` se o `CssClassSet` corresponder a vários elementos.

#### `dart:mirrors`

* [Compiladores web (dart2js e DDC) agora produzem um erro de compilação][42714] se
  `dart:mirrors` for importado.

### Tools

#### Dart VM

* Ao imprimir uma string usando a função `print`, [a implementação padrão
  imprimirá quaisquer surrogates não pareados na string como caracteres de substituição][41100]
  (`U+FFFD`).
* A função `Dart_StringToUTF8` na API Dart [converterá surrogates não pareados
  em caracteres de substituição][41100].


[41100]: {{site.repo.dart.sdk}}/issues/41100
[WHATWG encoding standard]: https://encoding.spec.whatwg.org/#utf-8-decoder
[42714]: {{site.repo.dart.sdk}}/issues/42714

## 2.8.1

### Language

* [Corrigido um bug de implementação][40675] onde a inferência de variável local
  usaria incorretamente o tipo promovido de uma variável de tipo.
* [Corrigido um bug de implementação][41362] em torno das cláusulas
  `implements Function`, `extends Function`, ou `with Function` não tendo mais
  efeito desde o Dart 2.0.0.

### Libraries

#### `dart:async`

* [Alterado o tipo de retorno de `StreamSubscription.cancel()` para `Future<void>`][40676].
* [Dividida a função `runZoned()` em duas funções][40681]:
  `runZoned()` e `runZonedGuarded()`, onde a última tem um
  parâmetro `onError` obrigatório, e a primeira não tem nenhum.
* Erros passados para `Completer.completeError()`, `Stream.addError()`,
  `Future.error()`, etc. [não podem mais ser `null`][40683].
* [Tornado stack traces não-nulos][40130].

#### `dart:core`

* Três membros em `RuneIterator` [não retornam mais `null`][40674] quando acessados
  antes da primeira chamada para `moveNext()`.
* O valor padrão de `String.fromEnvironment()` para `defaultValue`
  [agora é uma string vazia em vez de `null`][40678].
* O valor padrão para o parâmetro `defaultValue` de `int.fromEnvironment()`
  [agora é zero][40678].

#### `dart:ffi`

* Alterados `Pointer.asFunction()` e `DynamicLibrary.lookupFunction()` para
  métodos de extensão.

#### `dart:io`

* [Alterada a assinatura dos métodos `HttpHeaders`][33501] `add()` e `set`.
* [A classe `Socket` agora lança uma `SocketException`][40702] se o socket foi
  explicitamente destruído ou atualizado para um socket seguro ao definir ou obter opções de socket.
* [A classe `Process` agora lança um `StateError`][40483]
  se o processo está desanexado (`ProcessStartMode.detached` e
  `ProcessStartMode.detachedWithStdio`) ao acessar o getter `exitCode`.
* [A classe `Process` agora também lança][40483] quando não conectado ao
  stdio do processo filho (`ProcessStartMode.detached` e `ProcessStartMode.inheritStdio`) ao acessar os getters `stdin`, `stdout` e `stderr`.
* O objeto fictício retornado se `FileStat.stat()` ou `FileStat.statSync()` falhar
  [agora contém timestamps de época Unix][40706] em vez de `null` para os getters `accessed`,
  `changed` e `modified`.
* [A classe `HeaderValue` agora analisa mais estritamente][40709] em dois casos extremos inválidos.

### Tools

#### Dart Dev Compiler (DDC)

Corrigimos várias inconsistências entre DDC e Dart2JS para que os usuários menos
frequentemente encontrem código que é aceito por um compilador mas falha no
outro.

* Deletada a versão legada (baseada em analisador) do [DDC][ddc].
* Funções passadas para JavaScript usando a especificação de interop `package:js` recomendada
  agora devem ser envolvidas com uma chamada para `allowInterop`.
* Construtores em classes `@JS()` devem ser marcados com `external`.

#### `dart2js`

* Limites de parâmetro de tipo correspondentes agora só precisam ser
  subtipos mútuos em vez de estruturalmente iguais até a renomeação de variáveis de tipo limitadas
  e equiparação de todos os tipos top.
* Tipos agora são [normalizados][normalized].
* Construtores em classes `@JS()` devem ser marcados com `external`.
* Completamente removida a flag `--package-root`, que estava oculta e desabilitada
  no Dart 2.0.0.

[40675]: {{site.repo.dart.sdk}}/issues/40675
[41362]: {{site.repo.dart.sdk}}/issues/41362
[40676]: {{site.repo.dart.sdk}}/issues/40676
[40681]: {{site.repo.dart.sdk}}/issues/40681
[40683]: {{site.repo.dart.sdk}}/issues/40683
[40130]: {{site.repo.dart.sdk}}/issues/40130
[40674]: {{site.repo.dart.sdk}}/issues/40674
[40678]: {{site.repo.dart.sdk}}/issues/40678
[33501]: {{site.repo.dart.sdk}}/issues/33501
[40702]: {{site.repo.dart.sdk}}/issues/40702
[40483]: {{site.repo.dart.sdk}}/issues/40483
[40706]: {{site.repo.dart.sdk}}/issues/40706
[40709]: {{site.repo.dart.sdk}}/issues/40709
[ddc]: {{site.repo.dart.sdk}}/issues/38994
[normalized]: {{site.repo.dart.lang}}/blob/main/resources/type-system/normalization.md

## 2.7.1

* [O Dart SDK para macOS agora está disponível apenas para x64][39810].

[39810]: {{site.repo.dart.sdk}}/issues/39810

## 2.7.0

### Language

* [Membros de extensão estáticos são acessíveis quando importados com um prefixo][671].

### Libraries

#### `dart:io`

* Adicionado `IOOverrides.serverSocketBind` para auxiliar na escrita de testes que desejam fazer mock de
  `ServerSocket.bind`.

## 2.6.0

### Language

* [Alterada a inferência ao usar valores `Null` em um contexto `FutureOr`][37985].
  Nomeadamente, restrições de formas similares a `Null` <: `FutureOr<T>` agora produzem
  `Null` como a solução para `T`.

### Libraries

#### `dart:ffi`

* A API agora faz uso de membros de extensão estáticos.
* Removido gerenciamento de memória `Pointer.allocate` e `Pointer.free`.
* `Pointer.offsetBy` foi removido, use `cast` e `elementAt` no lugar.

[671]: {{site.repo.dart.lang}}/issues/671
[37985]: {{site.repo.dart.sdk}}/issues/37985

## 2.5.0

### Libraries

* Vários métodos e propriedades em várias bibliotecas principais, que costumavam
  declarar um tipo de retorno de `List<int>`, foram [atualizados para declarar um tipo de retorno
  de `Uint8List`][36900].

#### `dart:io`

* Os parâmetros posicionais opcionais `name` e `value` do construtor da classe `Cookie`
  [agora são obrigatórios][37192].
* [Os setters `name` e `value` da classe `Cookie` agora validam][37192]
  que as strings são feitas do conjunto de caracteres permitido e não são null.

### Tools

#### Pub

* Pacotes publicados em [pub.dev]({{site.pub}}) [não podem mais conter
  dependências git][36765].

[36900]: {{site.repo.dart.sdk}}/issues/36900
[37192]: {{site.repo.dart.sdk}}/issues/37192
[37192]: {{site.repo.dart.sdk}}/issues/37192
[36765]: {{site.repo.dart.sdk}}/issues/36765

## 2.4.0

### Language

* [Covariância de variáveis de tipo usadas em super-interfaces agora é aplicada][35097].

### Libraries

#### `dart:isolate`

* `Isolate.resolvePackageUri` sempre lançará um `UnsupportedError` quando
  compilado com dart2js ou DDC.

#### `dart:async`

* [Corrigido um bug na classe `StreamIterator`][36382] onde `await for` permitia
  `null` como uma stream.

[35097]: {{site.repo.dart.sdk}}/issues/35097
[36382]: {{site.repo.dart.sdk}}/issues/36382

## 2.2.0

### Libraries

#### `package:kernel`

* O getter `klass` na classe `InstanceConstant` na
  API AST Kernel foi renomeado para `classNode` para consistência.
* [Atualizada a implementação de `Link`][33966] para utilizar links simbólicos
  verdadeiros em vez de junctions no Windows.

[33966]: {{site.repo.dart.sdk}}/issues/33966

## 2.1.1

### Libraries

#### `dart:io`

* [Adicionado a um `IOSink` fechado agora lança um `StateError`][29554].

[29554]: {{site.repo.dart.sdk}}/issues/29554

### Tools

#### Dart VM

* [Corrigido um buraco de soundness ao usar `dart:mirrors`][35611] para
  invocar reflexivamente um método de uma maneira incorreta que viola seus tipos estáticos.

[29554]: {{site.repo.dart.sdk}}/issues/29554
[35611]: {{site.repo.dart.sdk}}/issues/35611

## 2.1.0

### Language

* Vários erros estáticos que deveriam ter sido detectados
  e relatados não eram suportados no 2.0.0. Estes são relatados agora, o que significa que
  código incorreto existente pode mostrar novos erros:
  * [Mixins devem sobrescrever corretamente suas superclasses][34235].
  * [Argumentos de tipo implícitos em cláusulas extends devem satisfazer os limites de classe][34532].
  * [Membros de instância devem sombrear prefixos][34498].
  * [Invocações de construtor devem usar sintaxe válida, mesmo com `new` opcional][34403].
  * [Argumentos de tipo para typedefs genéricos devem satisfazer seus limites][33308].
  * [Classes não podem implementar FutureOr][33744].
  * [Métodos abstratos não podem sobrescrever de forma não sonora um método concreto][32014].
  * [Construtores constantes não podem redirecionar para construtores não-constantes][34161].
  * [Setters com o mesmo nome que a classe envolvente não são permitidos][34225].

### Tools

#### `dart2js`

* Chaves duplicadas em um map const não são permitidas e produzem um erro de compilação.

[32014]: {{site.repo.dart.sdk}}/issues/32014
[33308]: {{site.repo.dart.sdk}}/issues/33308
[33744]: {{site.repo.dart.sdk}}/issues/33744
[34161]: {{site.repo.dart.sdk}}/issues/34161
[34225]: {{site.repo.dart.sdk}}/issues/34225
[34235]: {{site.repo.dart.sdk}}/issues/34235
[34403]: {{site.repo.dart.sdk}}/issues/34403
[34498]: {{site.repo.dart.sdk}}/issues/34498
[34532]: {{site.repo.dart.sdk}}/issues/34532

## 2.0.0

### Language

* Substituído o sistema de tipos estático opcional não sonoro por um sistema de tipos estático sonoro
  usando inferência de tipo e verificações de runtime, anteriormente chamado [strong mode].
* [Funções marcadas como `async` agora executam sincronicamente][30345] até a primeira
  declaração `await`.

### Libraries

* Renomeadas constantes nas bibliotecas principais de `SCREAMING_CAPS` para `lowerCamelCase`.
* Adicionados muitos novos métodos a classes de bibliotecas principais que precisarão ser implementados
  se você implementar as interfaces dessas classes.
* `dart:isolate` e `dart:mirrors` não são mais suportados ao
  usar Dart para a web.

### Tools

#### Pub

* Substituído o sistema de build baseado em transformer do pub por um [novo sistema de build][build system].

[30345]: {{site.repo.dart.sdk}}/issues/30345
[strong mode]: /language/type-system
[build system]: {{site.repo.dart.org}}/build