---
ia-translate: true
title: Mudanças e descontinuações (Breaking Changes and Deprecations)
description: Uma lista de mudanças interruptivas por lançamento no Dart.
lastVerified: 2024-08-04
---

{% assign versioned = '<span class="tag-label language-versioned-tag">Com versão de linguagem</span>' %}
{% assign deprecated = '<span class="tag-label deprecated-tag">Descontinuado</span>' %}
{% assign removed = '<span class="tag-label removed-tag">Removido</span>' %}
{% assign experimental = '<span class="tag-label experimental-tag">Experimental</span>' %}

Esta página lista todas as mudanças interruptivas e descontinuações na linguagem e nas bibliotecas do Dart,
organizadas por lançamento e área, para ajudar os usuários do Dart a entender e gerenciar seu
impacto. Notas de lançamento completas estão disponíveis no [changelog do SDK do Dart][changelog].
O documento [política de mudanças interruptivas (breaking change policy)][breaking change policy] descreve a política e o processo
em torno de mudanças interruptivas e descontinuações no Dart.

**Esta página inclui os seguintes tipos de mudanças interruptivas**:

* **Sem versão**: O SDK do Dart não mantém compatibilidade com versões anteriores, e
  o código pode quebrar assim que você [atualizar sua versão do SDK][sdk] se ele depender
  do comportamento anterior.
  
  _Estas são a maioria das mudanças e não estão especialmente marcadas nesta lista._
* **Com versão de linguagem**: O SDK do Dart mantém compatibilidade com versões anteriores
  para o código existente, e a mudança de comportamento só entra em vigor (potencialmente quebrando
  o código que depende do comportamento anterior) quando você atualiza a
  [versão da linguagem][language version] do seu código.

  _Estas são marcadas como:_ {{versioned}}
* **Descontinuações**: O SDK do Dart mantém a compatibilidade com o código descontinuado,
  com um aviso. As descontinuações são então completamente removidas em um lançamento subsequente,
  quebrando qualquer código que dependa do comportamento anterior.

  _Estas são marcadas como:_ {{deprecated}} / {{removed}}
* **Experimental**: Parte do lançamento, mas ainda não tratada como estável no SDK,
  e pode quebrar de uma versão para outra. Mudanças experimentais nem sempre
  têm um problema de mudança interruptiva correspondente, mas podem ter mais detalhes no
  [changelog do SDK][changelog].

  Estas são marcadas: {{experimental}}

Se você tiver dúvidas ou preocupações sobre alguma dessas mudanças interruptivas, por favor,
comente sobre o problema da mudança interruptiva (breaking change issue)  linkado a partir da entrada relevante.
Para ser notificado sobre futuras mudanças interruptivas, junte-se ao grupo [Dart announce][Dart announce].

[breaking change policy]: {{site.repo.dart.sdk}}/blob/main/docs/process/breaking-changes.md
[changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[sdk]: /get-dart
[language version]: /resources/language/evolution#language-versioning
[Dart announce]: {{site.announce}}

{% comment %}
Crie uma nova seção a partir desses cabeçalhos para cada lançamento.
Se não existirem mudanças em uma seção (por exemplo, Linguagem, `dart:async`, etc.),
não inclua o cabeçalho da seção.

## x.x.x {:#x-x-x}

### Linguagem {:.no_toc}

### Bibliotecas {:.no_toc}

#### (`dart:core`, `package:js`, etc) {:#dart-core-package-js-etc}

### Ferramentas {:.no_toc}

#### (Dart VM, Pub, Linter, `dart2js`, etc) {:#dart-vm-pub-linter-dart2js-etc}
{% endcomment %}

## 3.7.0 {:#3-7-0}

**Provisório**<br>
Espera-se que as seguintes mudanças sejam incluídas no lançamento estável 3.7,
mas a lista final pode mudar antes disso.
Para reduzir o impacto potencial dessas mudanças, considere
levá-las em conta antes do lançamento do 3.7.

### Linguagem {:.no_toc}

- {{versioned}} [Variáveis locais e parâmetros nomeados `_`][wildcards] agora são
  não vinculativos e não podem mais ser usados ou acessados.
- [A análise de alcançabilidade agora leva em conta se um campo é
  promovido por tipo para `Null` usando `is` ou `as`][56893].
  Isso torna o sistema de tipos mais autoconsistente, porque
  espelha o comportamento de variáveis locais promovidas.
  Não se espera que esta mudança faça qualquer diferença na prática.

[wildcards]: {{site.repo.dart.lang}}/blob/main/accepted/future-releases/wildcard-variables/feature-specification.md
[56893]: {{site.repo.dart.sdk}}/issues/56893

### Ferramentas {:.no_toc}

#### Analisador (Analyzer)

- {{removed}} As regras de lint [`package_api_docs`][`package_api_docs`] e [`unsafe_html`][`unsafe_html`]
  foram removidas e devem ser removidas dos arquivos `analysis_options.yaml`.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Formatador (`dart format`)

- {{versioned}} O formatador implementa um [novo estilo][new style] que resulta em
  nova saída ao formatar o código com uma [versão de linguagem][language version] de 3.7 ou superior.
- {{removed}} A flag `--fix` para `dart format` não é mais suportada.
  Para aplicar correções similares e mais,
  [configure suas opções de análise][configure your analysis options] e execute [`dart fix`][`dart fix`].
- {{deprecated}} A opção `--line-length` para `dart format` foi
  descontinuada e definida para ser removida.
  Todos os usos devem ser migrados para a nova opção `--page-width`.

[new style]: {{site.repo.dart.org}}/dart_style/issues/1253
[language version]: /resources/language/evolution#language-versioning
[configure your analysis options]: /tools/analysis
[`dart fix`]: /tools/dart-fix

## 3.6.0 {:#3-6-0}

### Linguagem {:.no_toc}

- [O contexto usado pelo Dart para realizar a inferência de tipo no
  operando de uma expressão throw foi alterado do
  "tipo desconhecido" para `Object`][56065].
  Isso torna o sistema de tipos mais autoconsistente, porque
  reflete o fato de que não é legal lançar `null`.
  Não se espera que esta mudança faça qualquer diferença na prática.

[56065]: {{site.repo.dart.sdk}}/issues/56065

### Bibliotecas {:.no_toc}

#### `dart:io`

- {{removed}} [O construtor `Platform()` foi removido][52444].
  Todas as instanciações de `Platform` devem ser removidas.
- `HttpClient` agora responde a um redirecionamento que está faltando um cabeçalho "Location"
  [lançando uma `RedirectException` em vez de um `StateError`][53618].

[52444]: {{site.repo.dart.sdk}}/issues/52444
[53618]: {{site.repo.dart.sdk}}/issues/53618

### Ferramentas {:.no_toc}

#### Analisador (Analyzer)

- {{deprecated}} As regras de lint [`package_api_docs`][`package_api_docs`] e [`unsafe_html`][`unsafe_html`]
  foram descontinuadas e estão definidas para serem removidas no Dart 3.7.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Front end do compilador (cfe) {:#compiler-front-end-cfe}

- O compilador Dart agora [computa os closures superiores e inferiores de esquemas de tipo
  pouco antes de serem passados para o procedimento de teste de subtipo][56466].
  Antes do Dart 3.6, o compilador computava no início do
  cálculo do limite superior e inferior.
  O analisador já seguia este comportamento, então é improvável que os aplicativos que
  já passam na análise sejam afetados por esta mudança.

[56466]: {{site.repo.dart.sdk}}/issues/56466

#### Compilador Wasm (dart2wasm)

- A condição `dart.library.js` agora é `false` em imports condicionais
  ao compilar para WebAssembly.
  A condição `dart.library.js_interop` deve ser usada em vez disso.

#### Formatador (`dart format`)

As seguintes mudanças podem resultar em pequenas mudanças de formatação
ao executar `dart format` com um SDK Dart 3.6 ou posterior:

- Preserve os parâmetros de tipo em formais de tipo de função de estilo antigo que
  também usam `this.` ou `super.`.
- Formate corretamente os imports com as cláusulas `as` e `if`.

#### Pub

- `dart pub publish` agora avisa se os arquivos que são
  rastreados no git têm alterações não commitadas.

## 3.5.0 {:#3-5-0}

### Linguagem {:.no_toc}

- [O contexto usado pelo compilador para realizar a inferência de tipo no
  operando de uma expressão `await` foi alterado para
  corresponder ao comportamento do analisador.][55418]
- [O contexto usado pelo compilador para realizar a inferência de tipo no
  lado direito de uma expressão "if-null" (`e1 ?? e2`) foi
  alterado para corresponder ao comportamento do analisador.][55436]
  O comportamento antigo pode ser restaurado fornecendo tipos explícitos.

[55418]: {{site.repo.dart.sdk}}/issues/55418
[55436]: {{site.repo.dart.sdk}}/issues/55436

### Bibliotecas {:.no_toc}

#### `dart:core`

- [`DateTime` agora armazena microssegundos na plataforma web][44876],
  correspondendo mais de perto ao comportamento em plataformas nativas.

[44876]: {{site.repo.dart.sdk}}/issues/44876

#### `dart:io`

- [`SecurityContext` agora é final e não pode mais ser subclassificado][55786].

[55786]: {{site.repo.dart.sdk}}/issues/55786

#### `dart:js_interop`

- [`importModule` agora aceita um `JSAny` em vez de um `String`][55508] para
  também dar suporte a outros valores JS, como objetos `TrustedScriptURL`.
- [`isTruthy` e `not` agora retornam `JSBoolean` em vez de `bool`][55267] para
  serem consistentes com outros métodos de operadores JS.
- [`ExternalDartReference` não implementa mais `Object`][56015].
  Em vez disso, agora aceita um parâmetro de tipo (`T`) com um limite de
  `Object?` para capturar o tipo do objeto Dart que está sendo externalizado.

[55508]: {{site.repo.dart.sdk}}/issues/55508
[55267]: {{site.repo.dart.sdk}}/issues/55267
[56015]: {{site.repo.dart.sdk}}/issues/56015

#### `dart:typed_data`

- {{removed}}
  [As classes de visualização não modificáveis para dados tipados foram removidas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de dados tipados.

### Runtime {:.no_toc}

- {{removed}} A VM do Dart não suporta mais segurança nula não-sound.
  - A opção `--no-sound-null-safety` da CLI foi removida.
  - As funções `Dart_NewListOf` e `Dart_IsLegacyType` foram
    removidas da API C.
- {{removed}} A função `Dart_DefaultCanonicalizeUrl` foi
  removida da API C.

## 3.4.0 {:#3-4-0}

### Linguagem {:.no_toc}

- [O esquema de tipo de contexto de padrão para padrões de cast (cast patterns)
  agora é `_` (o tipo desconhecido) em vez de `Object?`][54640].
- [O esquema de tipo usado pelos compiladores Dart para
  realizar a inferência de tipo no operando de um operador spread com reconhecimento nulo (`...?`)
  em literais de mapa e conjunto foi tornado anulável][54828],
  para corresponder ao que acontece atualmente em literais de lista.

[54640]: {{site.repo.dart.sdk}}/issues/54640
[54828]: {{site.repo.dart.sdk}}/issues/54828

### Bibliotecas {:.no_toc}

#### `dart:cli`

- {{experimental}} {{removed}} [A função `waitFor`][52121]
  foi removida.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audo`, `dart:web_gl` {:#dart-html-dart-indexed-db-dart-svg-dart-web-audo-dart-web-gl}

- {{deprecated}} Estas bibliotecas agora estão marcadas como legado e
  verão menos suporte no futuro.
  Novos projetos devem preferir usar [`package:web`][`package:web`] e `dart:js_interop`.
  Para saber mais, confira [Migrar para package:web][Migrate to package:web].

[`package:web`]: {{site.pub-pkg}}/web
[Migrate to package:web]: /interop/js-interop/package-web

#### `dart:js` {:#dart-js}

- {{deprecated}}
  Esta biblioteca agora está marcada como legado e verá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, confira [`/go/next-gen-js-interop`][`/go/next-gen-js-interop`].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:js_util` {:#dart-js-util}

- {{deprecated}}
  Esta biblioteca agora está marcada como legado e verá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, confira [`/go/next-gen-js-interop`][`/go/next-gen-js-interop`].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:io`

- [`Stdout` tem um novo campo `lineTerminator`, que permite
  que os desenvolvedores controlem o final de linha usado por `stdout` e `stderr`.][53863]
  Classes que implementam `Stdout` devem definir o campo `lineTerminator`.
  A semântica padrão de `stdout` e `stderr` não é alterada.
- {{deprecated}} A propriedade `FileSystemDeleteEvent.isDirectory`.
  Ela sempre retorna `false`.

[53863]: {{site.repo.dart.sdk}}/issues/53863

#### `dart:typed_data`

- {{deprecated}}
  [As classes de visualização não modificáveis para dados tipados estão descontinuadas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de dados tipados.

[53128]: {{site.repo.dart.sdk}}/issues/53218

### Ferramentas {:.no_toc}

#### Compilador JavaScript de Produção (dart2js)

- {{experimental}} {{deprecated}} Você deve agora especificar um formato para
  a opção `--dump-info` da CLI de `binary` ou `json`.
  O formato `json` está descontinuado e pode ser removido em um futuro lançamento do Dart.

#### Compilador Wasm (dart2wasm)

- {{experimental}} Vários argumentos da CLI `dart compile wasm` foram
  atualizados, removidos ou substituídos.
  Para saber mais, execute `dart compile wasm --verbose --help`.

### Runtime {:.no_toc}

- {{removed}} A VM do Dart não suporta mais strings externas.
  Como resultado, as funções `Dart_IsExternalString`, `Dart_NewExternalLatin1String` e
  `Dart_NewExternalUTF16String` foram removidas da API C do Dart.

## 3.3.0 {:#3-3-0}

### SDK {:.no_toc} {:#sdk}

* {{experimental}} {{removed}} Os seguintes experimentos agora estão aposentados, pois
  foram lançados no Dart 3 e não são mais necessários com
  uma versão da linguagem de 3.0 ou superior.
  A configuração deles deve ser removida de
  opções de análise, comandos da CLI e configurações de IDE.

  * `patterns` (padrões)
  * `records` (registros)
  * `class-modifers` (modificadores de classe)
  * `sealed-class` (classe selada)

### Linguagem {:.no_toc}

* [Um getter abstrato agora é considerado promovível se
  não houver declarações conflitantes][54056].

[54056]: {{site.repo.dart.sdk}}/issues/54056

### Bibliotecas {:.no_toc}

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`][52121]
  permanece descontinuada para outro lançamento e está definida para remoção no Dart 3.4.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:ffi`

* {{deprecated}} [Os métodos de aritmética de ponteiro `elementAt`
  em tipos `Pointer` estão descontinuados][54250].
  Migre para os operadores `-` e `+` em vez disso.
* {{experimental}} {{removed}} A anotação `@FfiNative` previamente descontinuada
  foi removida. Os usos devem ser
  atualizados para usar a anotação `@Native`.

[54250]: {{site.repo.dart.sdk}}/issues/54250

#### `dart:html`

* Em vez de usar `HttpRequest` diretamente,
  agora é recomendado usar [`package:http`][`package:http`].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:io`

* Em vez de usar `HttpClient` diretamente,
  agora é recomendado usar [`package:http`][`package:http`].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:js_interop`

* {{experimental}} Tipos JS como `JSAny` têm
  [novos tipos de representação específicos do compilador][52687].
* {{experimental}} Classes `@staticInterop` definidas pelo usuário podem
  [não implementar mais `JSAny` ou `JSObject`][52687].
  Os usos devem ser migrados para `JSObject.fromInteropObject` ou
  serem definidos como tipos de extensão.
* {{experimental}} `JSArray` e `JSPromise` agora têm parâmetros genéricos.
* {{experimental}} Vários membros de extensão foram movidos ou renomeados.
  Para saber mais sobre as extensões atualizadas, consulte
  `JSAnyUtilityExtension` e `JSAnyOperatorExtension`.

[52687]: {{site.repo.dart.sdk}}/issues/52687

#### `dart:typed_data`

* [As classes de visualização não modificáveis para dados tipados serão
  descontinuadas no Dart 3.4][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` em listas de dados tipados.

[53128]: {{site.repo.dart.sdk}}/issues/53218

#### `dart:nativewrappers` {:#dart-nativewrappers}

* {{experimental}} [Todas as classes wrapper nativas agora são marcadas como `base`][51896]
  para que nenhum de seus subtipos possa ser implementado.

[51896]: {{site.repo.dart.sdk}}/issues/51896

### Ferramentas {:.no_toc}

#### Compilador JavaScript de Produção (dart2js)

* [A `Invocation` que é passada para `noSuchMethod` não tem mais
  um `memberName` minificado][54201], mesmo quando compilado com `--minify`.

[54201]: {{site.repo.dart.sdk}}/issues/54201

#### Compilador Wasm (dart2wasm)

* {{experimental}} [Impedir a importação de bibliotecas legadas de interoperação JS][54004].
  Prefira usar `dart:js_interop` e `dart:js_interop_unsafe` em vez disso.

[54004]: {{site.repo.dart.sdk}}/issues/54004

#### Analisador (Analyzer)

* {{experimental}} Diretivas de comentários `dart doc` inválidas agora são
  reportadas pelo analisador.
* Devido a [melhorias na promoção de tipo][54056], os seguintes diagnósticos
  do analisador podem ser acionados em códigos existentes que anteriormente passavam na análise:

  * `unnecessary_non_null_assertion` (asserção não nula desnecessária)
  * `unnecessary_cast` (cast desnecessário)
  * `invalid_null_aware_operator` (operador null-aware inválido)

[54056]: {{site.repo.dart.sdk}}/issues/54056

#### Linter {:#linter}

* Os lints `iterable_contains_unrelated_type` e
  `list_remove_unrelated_type` foram removidos.
  Considere migrar para o lint expandido
  [`collection_methods_unrelated_type`][`collection_methods_unrelated_type`].
* Os seguintes lints são removidos por não serem mais
  necessários com segurança nula sound. Você deve remover a configuração deles
  de seus arquivos `analysis_options.yaml` e quaisquer comentários ignore.
  
  * `always_require_non_null_named_parameters`
  * `avoid_returning_null`
  * `avoid_returning_null_for_future`

[`collection_methods_unrelated_type`]: /tools/linter-rules/collection_methods_unrelated_type

## 3.2.0 {:#3-2-0}

### Linguagem {:.no_toc}

* {{versioned}} [Alterado o ponto de divisão para padrões refutáveis][53167]
  para o padrão de nível superior, de modo que a promoção de tipo em declarações if-case seja consistente
  independentemente de a scrutinee poder lançar uma exceção.

### Bibliotecas {:.no_toc}

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`.][52121]

#### `dart:convert`

* [Tipos de retorno alterados de `utf8.encode()` e `Utf8Codec.encode()`][52801]
  de `List<int>` para `Uint8List`.

#### `dart:developer`

* {{deprecated}} O método `Service.getIsolateID`.

#### `dart:ffi`

* [Alterado `NativeCallable.nativeFunction` para que as chamadas agora lancem um erro se
  o receptor já estiver fechado][53311], em vez de retornar `nullptr`.

#### `dart:io`

* [Eliminado espaço em branco à direita dos cabeçalhos HTTP][53005].
* [Inserido um espaço no ponto de dobra dos valores de cabeçalho dobrados][53227]
  que `HttpClientResponse.headers` e `HttpRequest.headers` retornam.

#### `dart:js_interop`

* {{experimental}} {{removed}} `JSNumber.toDart` em favor de `toDartDouble` e
  `toDartInt`.
* {{experimental}} {{removed}} `Object.toJS` em favor de `Object.toJSBox.`
* {{experimental}} Restringido as APIs externas de interoperação JS usando `dart:js_interop`
  para um conjunto de tipos permitidos.
* {{experimental}} Proibido o uso de `isNull` e `isUndefined` em dart2wasm.
* {{experimental}} Alterado as APIs `typeofEquals` e `instanceof` para retornarem
  `bool` em vez de `JSBoolean`.
  Além disso, `typeofEquals` agora aceita `String` em vez de `JSString`.
* {{experimental}} Alterado os tipos `JSAny` e `JSObject` para serem apenas implementáveis,
  não extensíveis, por tipos `@staticInterop` do usuário.
* {{experimental}} Alterado `JSArray.withLength` para aceitar `int` em vez de `JSNumber`.

### Ferramentas {:.no_toc}

#### Compilador JavaScript de Desenvolvimento (DDC) {:#development-javascript-compiler-ddc}

* [Adicionado interceptadores para tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Compilador JavaScript de Produção (dart2js)

* [Adicionado interceptadores para tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Analisador (Analyzer)

* {{versioned}} [Promoção de campo final privado][2020] pode fazer com que o seguinte
  avisos do analisador sejam acionados em códigos existentes que anteriormente passavam na análise:
  
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


## 3.1.0 {:#3-1-0}

### Bibliotecas {:.no_toc}

#### `dart:async`

* [Adicionado o modificador `interface` a classes puramente abstratas:][52334]
  `MultiStreamController`, `StreamConsumer`, `StreamIterator` e `StreamTransformer`.

#### `dart:io`

* [Adicionado `sameSite` à classe `Cookie` e adicionado a classe `SameSite`][51486].
* [`FileSystemEvent` é `sealed`][52027]. Isso significa que `FileSystemEvent` não pode ser 
  estendida ou implementada.

#### `dart:js_interop`

* {{experimental}} {{removed}} `ObjectLiteral`; crie um literal de objeto com
  sem membros nomeados usando `{}.jsify()`.

#### `package:js`

* Membros `external` `@staticInterop` e membros de extensão `external` não podem
  mais serem usados como tear-offs. Declare um closure ou um método não-`external` que
  chame esses membros e use isso em vez disso.
* Membros `external` `@staticInterop` e membros de extensão `external` irão
  gerar um código JS ligeiramente diferente para métodos que tenham parâmetros opcionais.

[52334]: {{site.repo.dart.sdk}}/issues/52334
[51486]: {{site.repo.dart.sdk}}/issues/51486
[52027]: {{site.repo.dart.sdk}}/issues/52027

## 3.0.0 {:#3-0-0}

:::tip
O [guia de migração do Dart 3.0][dart3] aborda os detalhes completos
sobre todas as mudanças nesta seção.
:::

### Linguagem {:.no_toc}

* {{versioned}} Alterada a interpretação de [casos switch] de constante
  expressões para padrões.

* {{versioned}} Declarações de classe de bibliotecas que foram atualizadas
  para o Dart 3.0 [não podem mais ser usadas como mixins por padrão][mixin class].

* [O Dart reporta um erro em tempo de compilação][50902] se uma instrução `continue` tem como alvo
  um [rótulo (label)] que não é um loop (instruções `for`, `do` e `while`) ou
  um membro `switch`.

### Bibliotecas {:.no_toc}

* As seguintes classes existentes foram transformadas em classes mixin:
  `Iterable`, `IterableMixin`, `IterableBase`, `ListMixin`, `SetMixin`, `MapMixin`,
  `LinkedListEntry`, `StringConversionSink`.

#### `dart:core`

* {{deprecated}} [APIs descontinuadas][49529].

#### `dart:async`

* {{removed}} [Removida a classe descontinuada][49529] [`DeferredLibrary`][`DeferredLibrary`].

#### `dart:collection` {:#dart-collection}

* {{versioned}} [Mudanças para bibliotecas da plataforma][collection].

#### `dart:developer`

* {{removed}} [Removida a constante descontinuada][49529] [`MAX_USER_TAGS`][`MAX_USER_TAGS`].
  Use [`maxUserTags`][`maxUserTags`] em vez disso.
* {{removed}} [Removidas as classes descontinuadas][50231] [`Metrics`][`Metrics`], [`Metric`][`Metric`], [`Counter`][`Counter`],
  e [`Gauge`][`Gauge`] pois estão quebradas desde o Dart 2.0.

#### `dart:ffi`

* {{experimental}} {{deprecated}} A anotação `@FfiNative` é
  agora descontinuada. Os usos devem ser atualizados para usar a anotação `@Native`.

#### `dart:html`

* {{removed}} [Removidos os métodos descontinuados `registerElement` e `registerElement2`][49536]
  em `Document` e `HtmlDocument`.

#### `dart:math` {:#dart-math}

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


## 2.19.0 {:#2-19-0}

### Linguagem {:.no_toc}

* [Sinalizado código adicional como inalcançável][49635] devido aos tipos `Null` e `Never`.
* [Não delegue nomes privados inacessíveis para `noSuchMethod`][49687].
* [Reporte um erro em tempo de compilação][50383] para todas as dependências cíclicas durante
  a inferência de tipo de nível superior.

### Bibliotecas {:.no_toc}

#### `dart:convert`

* {{removido}} [A API previamente descontinuada][34233] [`DEFAULT_BUFFER_SIZE`] em `JsonUtf8Encoder`
  foi removida.

#### `dart:developer`

* {{removido}} [APIs previamente descontinuadas removidas][34233] `kInvalidParams`,
  `kExtensionError`, `kExtensionErrorMax` e `kExtensionErrorMin` em
  [`ServiceExtensionResponse`].

#### `dart:ffi`

* [Alterado o argumento de tipo de tempo de execução de `Pointer` para `Never`][49935]
  em preparação para remover completamente o argumento de tipo de tempo de execução.
  Alterado `Pointer.toString` para não relatar nenhum argumento de tipo.

#### `dart:io`

* [Não permitir cabeçalhos de comprimento de conteúdo negativo ou hexadecimal][49305].
* [`File.create` agora aceita um novo parâmetro `exclusive` `bool` opcional][49647],
  e quando for `true` a operação falhará se o arquivo de destino já existir.
* Chamar `ResourceHandle.toFile()`, `ResourceHandle.toSocket()`,
  `ResourceHandle.toRawSocket()` ou `ResourceHandle.toRawDatagramSocket()`,
  mais de uma vez [agora lança um `StateError`][49878].

#### `dart:isolate`

* Revertido [`SendPort.send`] de volta para verificações estritas sobre o conteúdo
  de mensagens ao enviar mensagens entre isolates que não se sabe que compartilham o mesmo código.

#### `dart:mirrors`

* {{removido}} [APIs removidas][34233] `MirrorsUsed` e `Comment`.

#### `package:js`

* Mudanças que causam quebra na funcionalidade de pré-visualização `@staticInterop`:
  * Não permitir classes com esta anotação de usar construtores geradores
    `external`. Veja [48730] e [49941] para mais detalhes.
  * [Não permitir membros de extensão externa de classes com esta anotação de
    usar parâmetros de tipo][49350].
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


## 2.18.0 {:#2-18-0}

### Linguagem {:.no_toc}

* [Removido o suporte para mixin de classes que não estendem `Object`][48167].

### Bibliotecas {:.no_toc}

#### `dart:io`

* [Alterada a propriedade `uri` de `RedirectException` em `dart:io` para ser anulável][49045].
* [Removidas constantes nas APIs de rede `dart:io` seguindo a convenção
  `SCREAMING_CAPS`][34218].
* [A VM Dart não restaura mais automaticamente as configurações de terminal iniciais][45630]
  após a saída.

### Ferramentas {:.no_toc}

* [Descontinuado completamente o arquivo `.packages`][48272].

#### Linha de comando Dart

* [Removidas as ferramentas `dart2js` e `dartdevc` autônomas][46100].
* [Removida a ferramenta `dartanalyzer` autônoma][46100].

[48167]: {{site.repo.dart.sdk}}/issues/48167
[49045]: {{site.repo.dart.sdk}}/issues/49045
[34218]: {{site.repo.dart.sdk}}/issues/34218
[45630]: {{site.repo.dart.sdk}}/issues/45630
[48272]: {{site.repo.dart.sdk}}/issues/48272
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.17.0 {:#2-17-0}

### Bibliotecas {:.no_toc}

#### `dart:io`

* [Adicionada nova propriedade `connectionFactory` a `HttpClient`][47887].
* [Adicionada nova propriedade `keyLog` a `HttpClient`][48093], que permite que
  chaves TLS sejam registradas para fins de depuração.
* [Removidas constantes em `dart:io` seguindo `SCREAMING_CAPS`][34218]
* [Adicionada uma nova propriedade `allowLegacyUnsafeRenegotiation` a
  `SecurityContext`][48513], que permite a renegociação TLS para sockets seguros de cliente.

### Ferramentas {:.no_toc}

#### Linha de comando Dart

* {{descontinuado}} [Descontinuada a ferramenta `dart2js` autônoma][46100].
* {{descontinuado}} [Descontinuada a ferramenta `dartdevc` autônoma][46100].
* {{removido}} [Removida a ferramenta `dartdoc` autônoma][46100].

[47887]: {{site.repo.dart.sdk}}/issues/47887
[48093]: {{site.repo.dart.sdk}}/issues/48093
[34218]: {{site.repo.dart.sdk}}/issues/34218
[48513]: {{site.repo.dart.sdk}}/issues/48513
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.16.0 {:#2-16-0}

### Bibliotecas {:.no_toc}

#### `dart:io`

* No Windows, [`Directory.rename` não irá mais apagar um diretório][47653] se
  `newPath` especificar um. Em vez disso, uma `FileSystemException` será lançada.
* {{removed}} [Removida a API `Platform.packageRoot`][47769].

#### `dart:isolate`

* {{removed}} [Removida a API `Isolate.packageRoot`][47769].

### Ferramentas {:.no_toc}

#### Linha de comando Dart

* {{deprecated}} [Descontinuada a ferramenta `dartanalyzer` independente][46100].
* {{deprecated}} [Descontinuada a ferramenta `dartdoc` independente][46100].
* {{removed}} [Removida a ferramenta `pub` independente descontinuada][46100].

[47653]: {{site.repo.dart.sdk}}/issues/47653
[47769]: {{site.repo.dart.sdk}}/issues/47769
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.15.0 {:#2-15-0}

### Bibliotecas {:.no_toc}

#### `dart:io`

* [Atualizada a classe `SecurityContext`][46875] para definir a versão mínima
  do protocolo TLS para TLS1_2_VERSION (1.2) em vez de TLS1_VERSION.

#### `dart:web_sql` {:#dart-web-sql}

* [Completamente deletada a biblioteca `dart:web_sql`][46316].

#### `dart:html`

* [Removido `window.openDatabase`][46316] (relacionado à deleção de `dart:web_sql` acima).

### Ferramentas {:.no_toc}

#### Linha de comando Dart

* [Removida a ferramenta `dart2native` independente][46100].
* Removida a ferramenta `dartfmt` independente.

#### Dart VM

* [Removido o suporte para extensões nativas no estilo `dart-ext:`][45451]
* [Agrupados os isolates gerados via API `Isolate.spawn()`][46754] para operar no
  mesmo heap gerenciado e, portanto, compartilhar várias estruturas de dados internas da VM.

[46875]: {{site.repo.dart.sdk}}/issues/46875
[46316]: {{site.repo.dart.sdk}}/issues/46316
[45451]: {{site.repo.dart.sdk}}/issues/45451
[46754]: {{site.repo.dart.sdk}}/issues/46754

## 2.14.0 {:#2-14-0}

### Bibliotecas {:.no_toc}

#### `dart:io`

* As funções de retorno de chamada (callbacks) setter `.authenticate` e `.authenticateProxy` em `HttpClient`
  agora devem aceitar um argumento `realm` anulável (para código null safe pré-migrado).

#### `dart:typed_data`

* A maioria dos tipos expostos por esta biblioteca [não podem mais ser estendidos, implementados ou
  misturados (mixed-in)][45115].

### Ferramentas {:.no_toc}

#### Dart VM

* Expandos, e os parâmetros `object` de `Dart_NewWeakPersistentHandle` e
  `Dart_NewFinalizableHandle`, [não aceitam mais `Pointer` e subtipos de `Struct`][45071]

#### Linha de comando Dart

* [Descontinuada a ferramenta `dart2native` independente][46100]
* Descontinuada a ferramenta `dartfmt` independente.

#### `dart2js`

* [`dart2js` não suporta mais navegadores legados][46545], porque emite ES6+
  JavaScript por padrão.

#### Dart Dev Compiler (DDC)

* [Alteradas as relações de subtipagem de classes `package:js`][44154] para serem mais corretas e
  consistentes com o Dart2JS.

[45115]: {{site.repo.dart.sdk}}/issues/45115
[45071]: {{site.repo.dart.sdk}}/issues/45071
[46545]: {{site.repo.dart.sdk}}/issues/46545
[44154]: {{site.repo.dart.sdk}}/issues/44154


## 2.13.0 {:#2-13-0}

### Bibliotecas {:.no_toc}

#### `package:js`

* [Não é mais válido][44211] usar uma `String` que corresponda a uma anotação `@Native`
  em uma anotação `@JS()` para uma classe de interop JS não anônima.

[44211]: {{site.repo.dart.sdk}}/issues/44211

## 2.12.0 {:#2-12-0}

### Linguagem {:.no_toc}

* [Null safety (segurança nula)] agora está habilitado por padrão em todo o código que
  não foi desativado.
* [Corrigido um bug de implementação][44660] onde `this` às vezes passava por type
  promotion em extensões.

### Bibliotecas {:.no_toc}

#### `dart:ffi`

* [Descontinuadas as invocações com um `T` genérico][44621] de `sizeOf<T>`,
  `Pointer<T>.elementAt()`, `Pointer<T extends Struct>.ref` e
  `Pointer<T extends Struct>[]`
* [Descontinuado `allocate` em `package:ffi`][44621], pois não será mais
  capaz de invocar `sizeOf<T>` genericamente.
* [Descontinuados subtipos de `Struct` sem nenhum membro nativo][44622].

### Ferramentas {:.no_toc}

#### Dart VM

* `Dart_WeakPersistentHandle` não se auto-deleta mais][42312] quando o
  objeto referenciado é coletado pelo garbage collector para evitar condições de corrida.
* [Renomeado `Dart_WeakPersistentHandleFinalizer` para `Dart_HandleFinalizer`][42312]
  e removido seu argumento `handle`.

#### Pub

* [A restrição do SDK Dart agora é **obrigatória** em `pubspec.yaml`][44072].

[Null safety]: /null-safety/understanding-null-safety
[44660]: {{site.repo.dart.sdk}}/issues/44660
[44621]: {{site.repo.dart.sdk}}/issues/44621
[42312]: {{site.repo.dart.sdk}}/issues/42312
[44622]: {{site.repo.dart.sdk}}/issues/44622
[44072]: {{site.repo.dart.sdk}}/issues/44072

## 2.10.0 {:#2-10-0}

### Ferramentas {:.no_toc}

#### Dart VM

* [Renomeado `dart_api_dl.cc` para `dart_api_dl.c`][42982] e alterado para um arquivo C puro.

[42982]: {{site.repo.dart.sdk}}/issues/42982

## 2.9.0 {:#2-9-0}

### Bibliotecas {:.no_toc}

#### `dart:convert`

* Ao codificar uma string contendo substitutos (surrogates) não pareados com
   UTF-8, [os substitutos não pareados serão codificados como caracteres de substituição][41100] (`U+FFFD`).
* Ao decodificar UTF-8, [os substitutos codificados serão tratados como entrada malformada][41100].
* [Alterado o número de caracteres de substituição emitidos][41100] para
  sequências de entrada malformadas para corresponder ao [padrão de codificação WHATWG][padrão de codificação whatwg]
  ao decodificar UTF-8 com `allowMalformed: true`.

#### `dart:html`

* `CssClassSet.add()` e `CssClassSet.toggle` agora retornam `false` em vez de
  `null` se o `CssClassSet` corresponder a vários elementos.

#### `dart:mirrors`

* [Compiladores da web (dart2js e DDC) agora produzem um erro de tempo de compilação][42714] se
  `dart:mirrors` for importado.

### Ferramentas {:.no_toc}

#### Dart VM

* Ao imprimir uma string usando a função `print`, [a implementação padrão
  imprimirá quaisquer substitutos não pareados na string como caracteres de substituição][41100]
  (`U+FFFD`).
* A função `Dart_StringToUTF8` na API Dart [converterá substitutos não pareados
  em caracteres de substituição][41100].
  

[41100]: {{site.repo.dart.sdk}}/issues/41100
[padrão de codificação whatwg]: https://encoding.spec.whatwg.org/#utf-8-decoder
[42714]: {{site.repo.dart.sdk}}/issues/42714

## 2.8.1 {:#2-8-1}

### Linguagem {:.no_toc}

* [Corrigido um bug de implementação][40675] onde a inferência de variável local
  usaria incorretamente o tipo promovido de uma variável de tipo.
* [Corrigido um bug de implementação][41362] em torno das cláusulas
  `implements Function`, `extends Function` ou `with Function` não tendo mais
  efeito desde o Dart 2.0.0.

### Bibliotecas {:.no_toc}

#### `dart:async`

* [Alterado o tipo de retorno de `StreamSubscription.cancel()` para `Future<void>`][40676].
* [Dividida a função `runZoned()` em duas funções][40681]:
  `runZoned()` e `runZonedGuarded()`, onde a última tem um
  parâmetro `onError` obrigatório, e a primeira não tem nenhum.
* Erros passados para `Completer.completeError()`, `Stream.addError()`,
  `Future.error()`, etc. [não podem mais ser `null`][40683].
* [Feitas as stack traces não nulas][40130].

#### `dart:core`

* Três membros em `RuneIterator` [não retornam mais `null`][40674] quando acessados
  antes da primeira chamada para `moveNext()`.
* O valor padrão de `String.fromEnvironment()` para `defaultValue`
  [agora é uma string vazia em vez de `null`][40678].
* O valor padrão para o parâmetro `defaultValue` de `int.fromEnvironment()`
  [agora é zero][40678].

#### `dart:ffi`

* Alterado `Pointer.asFunction()` e `DynamicLibrary.lookupFunction()` para
  métodos de extensão.

#### `dart:io`

* [Alterada a assinatura dos métodos de `HttpHeaders`][33501] `add()` e `set`.
* [A classe `Socket` agora lança uma `SocketException`][40702] se o socket foi
  explicitamente destruído ou atualizado para um socket seguro ao definir ou obter opções de socket.
* [A classe `Process` agora lança um `StateError`][40483]
  se o processo for desanexado (`ProcessStartMode.detached` e
  `ProcessStartMode.detachedWithStdio`) ao acessar o getter `exitCode`.
* [A classe `Process` agora também lança][40483] quando não conectado ao stdio do processo filho
  (`ProcessStartMode.detached` e `ProcessStartMode.inheritStdio`) ao acessar os getters `stdin`, `stdout` e `stderr`.
* O objeto dummy retornado se `FileStat.stat()` ou `FileStat.statSync()` falhar
  [agora contém timestamps da época Unix][40706] em vez de `null` para os getters
  `accessed`, `changed` e `modified`.
* [A classe `HeaderValue` agora analisa mais estritamente][40709] em dois casos extremos inválidos.

### Ferramentas {:.no_toc}

#### Dart Dev Compiler (DDC)

Corrigimos várias inconsistências entre o DDC e o Dart2JS para que os usuários
encontrem menos frequentemente código que é aceito por um compilador, mas falha
no outro.

* Deletada a versão legada (baseada em analisador) do [DDC][ddc].
* Funções passadas para JavaScript usando a especificação de interop `package:js` recomendada
  agora devem ser envolvidas com uma chamada para `allowInterop`.
* Construtores em classes `@JS()` devem ser marcados com `external`.

#### `dart2js`

* Os limites de parâmetros de tipo correspondentes agora só precisam ser subtipos
  mútuos, em vez de estruturalmente iguais até a renomeação de variáveis de tipo
  vinculadas e igualar todos os tipos superiores.
* Os tipos agora são [normalizados].
* Construtores em classes `@JS()` devem ser marcados com `external`.
* Removida completamente a flag `--package-root`, que estava oculta e desabilitada
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

## 2.7.1 {:#2-7-1}

* [O SDK Dart para macOS agora está disponível apenas para x64][39810].

[39810]: {{site.repo.dart.sdk}}/issues/39810

## 2.7.0 {:#2-7-0}

### Linguagem {:.no_toc}

* [Membros de extensão estática são acessíveis quando importados com um prefixo][671].

### Bibliotecas {:.no_toc}

#### `dart:io`

* Adicionado `IOOverrides.serverSocketBind` para auxiliar na escrita de testes que desejam simular
  `ServerSocket.bind`.

## 2.6.0 {:#2-6-0}

### Linguagem {:.no_toc}

* [Alterada a inferência ao usar valores `Null` em um contexto `FutureOr`][37985].
  Ou seja, restrições de formas semelhantes a `Null` <: `FutureOr<T>` agora resultam
  em `Null` como a solução para `T`.

### Bibliotecas {:.no_toc}

#### `dart:ffi`

* A API agora faz uso de membros de extensão estática.
* Removido o gerenciamento de memória `Pointer.allocate` e `Pointer.free`.
* `Pointer.offsetBy` foi removido, use `cast` e `elementAt` em vez disso.

[671]: {{site.repo.dart.lang}}/issues/671
[37985]: {{site.repo.dart.sdk}}/issues/37985

## 2.5.0 {:#2-5-0}

### Bibliotecas {:.no_toc}

* Vários métodos e propriedades em várias bibliotecas principais, que costumavam
  declarar um tipo de retorno de `List<int>`, foram [atualizados para declarar um tipo de retorno
  de `Uint8List`][36900].

#### `dart:io`

* Os parâmetros posicionais opcionais `name` e `value` do construtor da classe `Cookie`
  [agora são obrigatórios][37192].
* [Os setters `name` e `value` da classe `Cookie` agora validam][37192]
  que as strings são feitas a partir do conjunto de caracteres permitido e não são nulas.

### Ferramentas {:.no_toc}

#### Pub

* Pacotes publicados em [pub.dev]({{site.pub}}) [não podem mais conter
  dependências git][36765].

[36900]: {{site.repo.dart.sdk}}/issues/36900
[37192]: {{site.repo.dart.sdk}}/issues/37192
[37192]: {{site.repo.dart.sdk}}/issues/37192
[36765]: {{site.repo.dart.sdk}}/issues/36765

## 2.4.0 {:#2-4-0}

### Linguagem {:.no_toc}

* [A covariância de variáveis de tipo usadas em superinterfaces agora é aplicada][35097].

### Bibliotecas {:.no_toc}

#### `dart:isolate`

* `Isolate.resolvePackageUri` sempre lançará um `UnsupportedError` quando
  compilado com dart2js ou DDC.

#### `dart:async`

* [Corrigido um bug na classe `StreamIterator`][36382] onde `await for` permitia
  `null` como um fluxo.

[35097]: {{site.repo.dart.sdk}}/issues/35097
[36382]: {{site.repo.dart.sdk}}/issues/36382

## 2.2.0 {:#2-2-0}

### Bibliotecas {:.no_toc}

#### `package:kernel` {:#package-kernel}

* O getter `klass` na classe `InstanceConstant` na API Kernel AST foi renomeado
  para `classNode` para consistência.
* [Atualizada a implementação de `Link`][33966] para utilizar links simbólicos
  verdadeiros em vez de junções no Windows.

[33966]: {{site.repo.dart.sdk}}/issues/33966

## 2.1.1 {:#2-1-1}

### Bibliotecas {:.no_toc}

#### `dart:io`

* [Adicionar a um `IOSink` fechado agora lança um `StateError`][29554].

[29554]: {{site.repo.dart.sdk}}/issues/29554

### Ferramentas {:.no_toc}

#### Dart VM

* [Corrigida uma falha de solidez ao usar `dart:mirrors`][35611] para refletir
  invocar um método de forma incorreta que viola seus tipos estáticos.

[29554]: {{site.repo.dart.sdk}}/issues/29554
[35611]: {{site.repo.dart.sdk}}/issues/35611

## 2.1.0 {:#2-1-0}

### Linguagem {:.no_toc}

* Vários erros estáticos que deveriam ter sido detectados
  e relatados não foram suportados em 2.0.0. Eles são relatados agora, o que significa
  que o código incorreto existente pode mostrar novos erros:
  * [Mixins devem sobrescrever corretamente suas superclasses][34235].
  * [Argumentos de tipo implícitos em cláusulas extends devem satisfazer os limites da classe][34532].
  * [Membros de instância devem ocultar prefixos][34498].
  * [Invocações de construtor devem usar sintaxe válida, mesmo com `new` opcional][34403].
  * [Argumentos de tipo para typedefs genéricos devem satisfazer seus limites][33308].
  * [Classes não podem implementar FutureOr][33744].
  * [Métodos abstratos não podem sobrescrever de forma insegura um método concreto][32014].
  * [Construtores constantes não podem redirecionar para construtores não constantes][34161].
  * [Setters com o mesmo nome da classe delimitadora não são permitidos][34225].

### Ferramentas {:.no_toc}

#### `dart2js`

* Chaves duplicadas em um mapa const não são permitidas e produzem um erro de tempo de compilação.

[32014]: {{site.repo.dart.sdk}}/issues/32014
[33308]: {{site.repo.dart.sdk}}/issues/33308
[33744]: {{site.repo.dart.sdk}}/issues/33744
[34161]: {{site.repo.dart.sdk}}/issues/34161
[34225]: {{site.repo.dart.sdk}}/issues/34225
[34235]: {{site.repo.dart.sdk}}/issues/34235
[34403]: {{site.repo.dart.sdk}}/issues/34403
[34498]: {{site.repo.dart.sdk}}/issues/34498
[34532]: {{site.repo.dart.sdk}}/issues/34532

## 2.0.0 {:#2-0-0}

### Linguagem {:.no_toc}

* Substituído o sistema de tipo estático opcional não seguro por um sistema de tipo
  estático seguro usando inferência de tipo e verificações de tempo de execução, anteriormente chamado de [strong mode].
* [Funções marcadas como `async` agora são executadas de forma síncrona][30345] até a primeira
  instrução `await`.

### Bibliotecas {:.no_toc}

* Renomeadas as constantes nas bibliotecas principais de `SCREAMING_CAPS` para `lowerCamelCase`.
* Adicionados muitos novos métodos às classes da biblioteca principal que precisarão ser implementados
  se você implementar as interfaces dessas classes.
* `dart:isolate` e `dart:mirrors` não são mais suportados ao
  usar o Dart para a web.

### Ferramentas {:.no_toc}

#### Pub

* Substituído o sistema de build baseado em transformadores do pub por um [novo sistema de build][build system].

[30345]: {{site.repo.dart.sdk}}/issues/30345
[strong mode]: /language/type-system
[build system]: {{site.repo.dart.org}}/build
