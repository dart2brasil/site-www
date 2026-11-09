---
ia-translate: true
title: Mudanças incompatíveis e descontinuações
breadcrumb: Legado
description: Uma lista de mudanças incompatíveis por versão do Dart.
maxTocDepth: 2
lastVerified: 2026-05-19
---

{% assign versioned = '<span class="tag-label language-versioned-tag">Language versioned</span>' %}
{% assign deprecated = '<span class="tag-label deprecated-tag">Deprecated</span>' %}
{% assign removed = '<span class="tag-label removed-tag">Removed</span>' %}
{% assign experimental = '<span class="tag-label experimental-tag">Experimental</span>' %}

:::warning
**Esta página foi descontinuada.**
Veja o [Changelog](/changelog) para as mudanças na linguagem e no SDK,
e [Versionamento da linguagem](/language/versioning) para entender como o versionamento é usado
com o Dart e o SDK.
:::

Esta página lista todas as mudanças incompatíveis e descontinuações em
atualizações do SDK do Dart, organizadas por versão e área,
para ajudar os desenvolvedores Dart a entender e gerenciar o impacto delas.
As notas de versão completas estão disponíveis no [changelog do SDK do Dart][changelog].
O documento [política de mudanças incompatíveis][breaking change policy] descreve a política e o processo
relacionados a mudanças incompatíveis e descontinuações no Dart.

**Esta página inclui os seguintes tipos de mudanças incompatíveis:**

**Sem versionamento**
: O SDK do Dart não mantém compatibilidade com versões anteriores, e o código pode quebrar assim que você
  [atualizar a versão do seu SDK][sdk] se ele depender do comportamento anterior.

  _Estas são a maioria das mudanças e não são marcadas de forma especial nesta lista._

**Versionado por idioma**
: O SDK do Dart mantém a compatibilidade com versões anteriores para o código existente,
  e a mudança de comportamento só tem efeito (podendo quebrar
  código que depende do comportamento anterior) quando você
  atualiza a [versão da linguagem][language version] do seu código.

  _Estas são marcadas como:_ {{versioned}}

**Descontinuações**
: O SDK do Dart mantém a compatibilidade com código descontinuado, emitindo um aviso.
  As descontinuações são então removidas por completo em uma versão posterior,
  quebrando qualquer código que dependa do comportamento anterior.

  _Estas são marcadas como:_ {{deprecated}} / {{removed}}

**Experimental**
: Parte da versão, mas ainda não tratada como estável no SDK, e
  pode quebrar de uma versão para outra.
  Mudanças experimentais nem sempre têm uma issue de mudança incompatível correspondente,
  mas podem ter mais detalhes no [changelog do SDK][changelog].

  Estas são marcadas como: {{experimental}}

Se você tiver dúvidas ou preocupações sobre qualquer uma dessas mudanças incompatíveis,
comente na issue de mudança incompatível vinculada à entrada relevante.
Para ser notificado sobre futuras mudanças incompatíveis, entre no grupo [Dart announce][].

[breaking change policy]: {{site.repo.dart.sdk}}/blob/main/docs/process/breaking-changes.md
[changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[sdk]: /get-dart
[language version]: /language/versioning
[Dart announce]: {{site.announce}}

{% comment %}
Create a new section from these headers for each release.
If no changes exist in a section (such as Language, `dart:async`, etc.),
don't include the section header.

## x.x.x

### Language

### Libraries

#### (`dart:core`, `package:js`, etc)

### Tools

#### (Dart VM, Pub, Linter, `dart2js`, etc)
{% endcomment %}

## 3.13.0

### Linguagem {:#language}

- {{versioned}}
  Você não pode mais usar `final` ou `var` em parâmetros que não são declarações.
  O Dart agora reserva ambos para
  [declarar parâmetros em construtores primários][primary constructors].
  Remova `final` ou `var` das declarações de parâmetros afetadas.
  Se você ainda quiser impedir a reatribuição de parâmetros,
  pode usar a regra de lint [`parameter_assignments`][].
- A inferência de tipo promovido em funções geradoras internas foi [ajustada][62889].

[62889]: {{site.repo.dart.sdk}}/issues/62889
[primary constructors]: /language/primary-constructors#field-declarations-in-parameters
[`parameter_assignments`]: /tools/linter-rules/parameter_assignments

### Bibliotecas {:#libraries}

#### `dart:io`

- `NetworkInterface.addresses` [agora retorna `List<InterfaceAddress>`][63216]
  em vez de `List<InternetAddress>`.
  O novo subtipo `InterfaceAddress` de `InternetAddress`
  expõe um campo `prefixLength` e um getter `broadcast`.
  Código que implementa `NetworkInterface` e sobrescreve `addresses`
  deve atualizar o tipo de retorno.
- `InternetAddress.lookup` não aceita mais endereços IPv4 inválidos
  que são tradicionalmente aceitos por `inet_aton`.

[63216]: {{site.repo.dart.sdk}}/issues/63216

#### `dart:js_interop`

- `JSFunction` e `JSExportedDartFunction` [agora são genéricos][54557].
  `JSExportedDartFunction<T>.toDart` agora converte
  a função original encapsulada para o argumento de tipo `T`,
  e `isA<JSExportedDartFunction<T>>` agora também
  verifica se a função encapsulada é um `T`.
  Os tipos em runtime de `JSFunction` e `JSExportedDartFunction` não mudam.

[54557]: {{site.repo.dart.sdk}}/issues/54557

### Ferramentas {:#tools}

### Analisador {:#analyzer}

- {{deprecated}}
  A regra de lint [`avoid_private_typedef_functions`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

- {{deprecated}}
  A regra de lint [`one_member_abstracts`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

[`avoid_private_typedef_functions`]: /tools/linter-rules/avoid_private_typedef_functions
[`one_member_abstracts`]: /tools/linter-rules/one_member_abstracts

#### Formatador (`dart format`) {:#formatter-dart-format}

- Deixou de adicionar uma linha em branco antes de um comentário no
  fim de uma unidade de compilação ou de um corpo com chaves.
- As cláusulas de representação de extension types agora são formatadas da mesma forma que
  as listas de parâmetros formais de construtores primários.
- Quando [as vírgulas finais são preservadas][trailing-commas],
  não insere mais uma quebra de linha antes do `;` em um enum com membros,
  a menos que haja uma vírgula final.
- Corrigido um bug em que algumas coleções ou argumentos podiam ser divididos desnecessariamente.

- {{versioned}}
  Listas de parâmetros agora podem ser formatadas em bloco.
- {{versioned}}
  Expressões `as`, `is` e `is!` agora podem ser formatadas em bloco.
- {{versioned}}
  Linhas em branco são adicionadas ao redor de declarações `mixin` e `extension type`
  se elas não tiverem um corpo com `;`.
- {{versioned}}
  Os imports agora são separados em seções.
- {{versioned}}
  Vírgulas finais agora são adicionadas para dividir as cláusulas de representação de extension types.

[trailing-commas]: /tools/analysis#trailing_commas

### Runtime

- {{removed}}
  Os certificados raiz de fallback embutidos, usados quando
  os certificados do sistema não podem ser encontrados, não são mais incluídos.
  Se os certificados do sistema não forem encontrados,
  use as opções `--root-certs-file` ou `--root-certs-cache` para
  fornecer certificados de fallback à VM standalone do Dart.

#### API do Embedder {:#embedder-api}

- `Dart_FileModifiedCallback` em `runtime/include/dart_tools_api.h` agora
  passa `int64_t since` como microssegundos desde a época, em vez de milissegundos.

## 3.12.0

### Bibliotecas {:#libraries}

#### `dart:js_interop`

- O método de extensão `isA` foi
  [movido de `JSAnyUtilityExtension` para `NullableObjectUtilExtension`][56905]
  para dar suporte à verificação de tipo de qualquer `Object?`.
  Essa mudança só é incompatível se você referenciou o nome da extensão diretamente,
  seja aplicando a extensão diretamente ou por meio das diretivas `show`/`hide`.
- `isA<JSObject>()` agora trata corretamente objetos JS sem protótipos,
  e `isA<JSAny>()` faz uma verificação não trivial de que o valor é um valor JS.
- `isA<JSExportedDartFunction>()` agora verifica se a função é
  realmente uma função wrapper JS retornada por
  `Function.toJS` ou `Function.toJSCaptureThis`.

[56905]: {{site.repo.dart.sdk}}/issues/56905

### Ferramentas {:#tools}

#### Pub

- `dart pub cache repair` agora repara, por padrão, apenas os pacotes referenciados
  pelo arquivo `pubspec.lock` do projeto atual.
  Para reparar todos os pacotes do cache do pub, como nas versões anteriores,
  passe a nova flag `--all`.

#### Compilador Wasm (dart2wasm) {:#wasm-compiler-dart2wasm}

- A API de carregamento de módulos com carregamento deferido foi atualizada para permitir
  o download em lote de módulos deferidos.
  O embedder agora usa `loadDeferredModules` em vez de `loadDeferredModule`,
  em que a nova função deve receber um array de nomes de módulos
  em vez de nomes individuais.
  Todas as funções de carregamento de módulos também devem aceitar agora um callback `instantiator`
  ao qual devem passar os resultados carregados.

#### Compilador JavaScript de produção (dart2js) {:#production-javascript-compiler-dart2js}

- `JSExportedDartFunction.toDart` agora lança exceção se a função JS wrapper
  não for resultado de `Function.toJS` ou `Function.toJSCaptureThis`,
  para ser consistente com DDC e dart2wasm.
  Antes, às vezes ela retornava incorretamente a
  função Dart original, mesmo se a função JS wrapper tivesse sido
  convertida de uma chamada à função descontinuada `allowInterop`.

## 3.11.0

### Ferramentas {:#tools}

#### Analisador {:#analyzer}

- {{deprecated}}
  A regra de lint [`avoid_null_checks_in_equality_operators`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

- {{deprecated}}
  A regra de lint [`prefer_final_parameters`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

- {{deprecated}}
  A regra de lint [`use_if_null_to_convert_nulls_to_bools`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

[`avoid_null_checks_in_equality_operators`]: /tools/linter-rules/avoid_null_checks_in_equality_operators
[`prefer_final_parameters`]: /tools/linter-rules/prefer_final_parameters
[`use_if_null_to_convert_nulls_to_bools`]: /tools/linter-rules/use_if_null_to_convert_nulls_to_bools

#### Compilação Wasm (`dart compile wasm`) {:#wasm-compilation-dart-compile-wasm}

- {{removed}}
  Código que importa `dart:js_util` ou `package:js` agora
  [resulta em erro de compilação][61550] ao compilar para WebAssembly.

  Invocar qualquer API dessas bibliotecas resultará em erro de runtime.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.

[61550]: {{site.repo.dart.sdk}}/issues/61550

## 3.10.0

### Linguagem {:#language}

- Funções geradoras `sync*` e `async*` sem um retorno especificado agora
  inferem corretamente os tipos de retorno como non-nullable quando nenhum valor `null` é produzido.
  Isso pode disparar novos diagnósticos relacionados a elementos de código desnecessários,
  como um operador de acesso com null-aware desnecessário (`?.`).

### Bibliotecas {:#libraries}

#### `dart:core`

- As funções `Uri.parseIPv4Address` e `Uri.parseIPv6Address`
  [não permitem mais incorretamente][61392] zeros à esquerda em endereços IPv4.

- {{deprecated}}
  A possibilidade de implementar `RegExp` e `RegExpMatch` está descontinuada
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

- A função `Function.toJSCaptureThis` agora resulta em verificações adicionais em tempo de compilação
  para igualar `Function.toJS`.
  Se a função não tiver um tipo conhecido estaticamente,
  tiver tipos não suportados na assinatura, incluir parâmetros de tipo
  ou tiver quaisquer parâmetros nomeados, a chamada resultará em erro de compilação.

### Ferramentas {:#tools}

#### SDK

- A CLI `dart` e a VM do Dart agora são executáveis separados,
  com o executável e o processo da VM do Dart puro chamados `dartvm`.
  Programas Dart ainda devem ser executados com [`dart run`][].

- Os subcomandos da ferramenta `dart`, como `dart format` e `dart compile`,
  agora executam snapshots compilados com AOT das ferramentas subjacentes.
  Não deve haver diferença funcional além de melhorias de desempenho,
  mas se você encontrar incompatibilidades, por favor [reporte-as][sdk report].

- {{removed}}
  A ferramenta `dart` não está mais disponível para plataformas IA32,
  pois o SDK do Dart não oferece mais suporte a IA32.

[`dart run`]: /tools/dart-run
[sdk report]: {{site.repo.dart.sdk}}/issues/new/choose

#### Analisador {:#analyzer}

- Usar membros marcados como `@experimental` fora
  do pacote em que são declarados
  agora resulta em um aviso.

- Regras de lint habilitadas em arquivos de opções de análise incluídos
  agora resultam em diagnósticos de lint incompatíveis quando apropriado.

- {{removed}}
  A anotação `@required` descontinuada de
  `package:meta` não é mais suportada.
  Para marcar um parâmetro como obrigatório, use a palavra-chave `required`.

#### Compilação Wasm (`dart compile wasm`) {:#wasm-compilation-dart-compile-wasm}

- `dart:js_util` e `package:js` [não são mais suportados][61550] ao
  compilar para WebAssembly.
  Invocar qualquer API dessas bibliotecas resultará em erro de runtime.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.

- Para igualar os compiladores JS, `dartify` quando compilado para Wasm
  [agora converte][54573] objetos JS `Promise` em objetos Dart `Future`
  em vez de objetos Dart `JSValue`.

[61550]: {{site.repo.dart.sdk}}/issues/61550
[54573]: {{site.repo.dart.sdk}}/issues/54573

## 3.9.0

### Linguagem {:#language}

- {{versioned}}
  Null safety agora é assumido ao calcular
  a promoção de tipo, a alcançabilidade e a atribuição definida.
  Como resultado, a análise aprimorada de código morto pode
  fazer com que novos diagnósticos do analisador sejam disparados em
  código existente que antes passava na análise.

### Ferramentas {:#tools}

- Alguns subcomandos da ferramenta `dart`, como `dart analyze` e `dart fix`,
  agora executam snapshots compilados com AOT das ferramentas subjacentes.
  Não deve haver diferença funcional além de melhorias de desempenho,
  mas se você encontrar incompatibilidades, por favor [reporte-as][sdk report].

[sdk report]: {{site.repo.dart.sdk}}/issues/new/choose

#### Pub

- {{versioned}}
  O limite superior da restrição do SDK `flutter` no pacote raiz
  do seu workspace agora é respeitado.
  Se o seu SDK atual não atender ao limite especificado,
  `dart pub get` e outras ações que recuperam dependências falharão.

#### Build do Dart {:#dart-build}

- {{experimental}}
  Gerar um bundle de aplicação CLI com suporte experimental a native assets agora
  exige o uso do subcomando `dart build cli` e
  a especificação do entrypoint da aplicação com a nova opção `--target`.

## 3.8.0

### Bibliotecas {:#libraries}

#### `dart:html`

- {{removed}}
  O construtor `Element.created` foi removido.
- Classes nativas em `dart:html`, como `HtmlElement`,
  [não podem mais ser estendidas][53264].

[53264]: {{site.repo.dart.sdk}}/issues/53264

### Ferramentas {:#tools}

#### Analisador {:#analyzer}

- {{deprecated}}
  A regra de lint [`avoid_null_checks_in_equality_operators`][] está descontinuada
  e deve ser removida dos arquivos `analysis_options.yaml`.

[`avoid_null_checks_in_equality_operators`]: /tools/linter-rules/avoid_null_checks_in_equality_operators

#### Compilador JavaScript de desenvolvimento (DDC) {:#development-javascript-compiler-ddc}

- Agora lança um erro de runtime quando um
  construtor factory de redirecionamento é [destacado][tear-offs] e
  um de seus parâmetros opcionais não nullable não recebe nenhum valor.
  No futuro, provavelmente isso será um erro de compilação.

[tear-offs]: /language/functions#tear-offs

#### Compilador JavaScript de produção (dart2js) {:#production-javascript-compiler-dart2js}

- {{experimental}} {{removed}}
  As flags `--experiment-new-rti` e `--use-old-rti` não são mais suportadas.

#### Formatador (`dart format`) {:#formatter-dart-format}

- {{versioned}}
  O formatador fez mudanças e correções que resultam em nova saída ao
  formatar código com uma [versão da linguagem][language version] 3.8 ou superior.

[language version]: /language/versioning

## 3.7.0

### Linguagem {:#language}

- {{versioned}} [Variáveis locais e parâmetros nomeados `_`][wildcards] agora
  não são mais de vinculação e não podem mais ser usados ou acessados.
- [A análise de alcançabilidade agora considera se um campo é
  promovido para `Null` por meio de `is` ou `as`][56893].
  Isso torna o sistema de tipos mais autoconsistente, pois espelha
  o comportamento de variáveis locais promovidas.
  Não se espera que essa mudança faça diferença na prática.

[wildcards]: /language/variables#wildcard-variables
[56893]: {{site.repo.dart.sdk}}/issues/56893

### Bibliotecas {:#libraries}

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audio`, `dart:web_gl`, `dart:js`

- {{deprecated}} Estas bibliotecas web legadas estão oficialmente descontinuadas.
  Espera-se que sejam removidas em uma versão futura.
  Os projetos devem migrar para usar [`package:web`][] e `dart:js_interop`.
  Para saber mais, veja [Migre para `package:web`][Migrate to `package:web`].

[`package:web`]: {{site.pub-pkg}}/web
[Migrate to `package:web`]: /interop/js-interop/package-web

#### `dart:js`, `dart:js_util`, `package:js`

- {{deprecated}} Estas bibliotecas legadas de interop com JS estão oficialmente descontinuadas.
  Espera-se que sejam removidas em uma versão futura.
  Os projetos devem migrar para usar `dart:js_interop`.
  Para saber mais, veja [uso de interop com JS][JS interop usage].

[JS interop usage]: /interop/js-interop/usage

### Ferramentas {:#tools}

#### Analisador {:#analyzer}

- {{removed}} As regras de lint [`package_api_docs`][] e [`unsafe_html`][]
  foram removidas e devem ser retiradas dos arquivos `analysis_options.yaml`.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Formatador (`dart format`) {:#formatter-dart-format}

- {{versioned}} O formatador implementa um [novo estilo][new style] que resulta em
  nova saída ao formatar código com uma [versão da linguagem][language version] 3.7 ou superior.
- {{removed}} A flag `--fix` do `dart format` não é mais suportada.
  Para aplicar correções semelhantes e outras,
  [configure suas opções de análise][configure your analysis options] e execute [`dart fix`][].
- {{deprecated}} A opção `--line-length` do `dart format` foi
  descontinuada e está marcada para remoção.
  Todos os usos devem ser migrados para a nova opção `--page-width`.

[new style]: {{site.repo.dart.org}}/dart_style/issues/1253
[language version]: /language/versioning
[configure your analysis options]: /tools/analysis
[`dart fix`]: /tools/dart-fix

## 3.6.0

### Linguagem {:#language}

- [O contexto usado pelo Dart para realizar a inferência de tipo sobre
  o operando de uma expressão throw foi alterado de
  "tipo desconhecido" para `Object`][56065].
  Isso torna o sistema de tipos mais autoconsistente, pois
  reflete o fato de que não é legal lançar `null`.
  Não se espera que essa mudança faça diferença na prática.

[56065]: {{site.repo.dart.sdk}}/issues/56065

### Bibliotecas {:#libraries}

#### `dart:io`

- {{removed}} [O construtor `Platform()` foi removido][52444].
  Todas as instanciações de `Platform` devem ser removidas.
- `HttpClient` agora responde a um redirecionamento sem o header "Location"
  [lançando um `RedirectException` em vez de um `StateError`][53618].

[52444]: {{site.repo.dart.sdk}}/issues/52444
[53618]: {{site.repo.dart.sdk}}/issues/53618

### Ferramentas {:#tools}

#### Analisador {:#analyzer}

- {{deprecated}} As regras de lint [`package_api_docs`][] e [`unsafe_html`][]
  foram descontinuadas e estão marcadas para remoção no Dart 3.7.

[`package_api_docs`]: /tools/linter-rules/package_api_docs
[`unsafe_html`]: /tools/linter-rules/unsafe_html

#### Front end do compilador (cfe) {:#compiler-front-end-cfe}

- O compilador do Dart agora [calcula os closures superior e inferior dos schemas de tipo
  logo antes de serem passados para o procedimento de teste de subtipo][56466].
  Antes do Dart 3.6, o compilador os calculava no início das
  computações de limite superior e inferior.
  O analisador já seguia esse comportamento, então aplicações que
  já passam na análise dificilmente serão afetadas por essa mudança.

[56466]: {{site.repo.dart.sdk}}/issues/56466

#### Compilador Wasm (dart2wasm) {:#wasm-compiler-dart2wasm}

- A condição `dart.library.js` agora é `false` em imports condicionais
  ao compilar para WebAssembly.
  Deve-se usar a condição `dart.library.js_interop` em vez dela.

#### Formatador (`dart format`) {:#formatter-dart-format}

As seguintes mudanças podem resultar em pequenas alterações de formatação
ao executar `dart format` com um SDK do Dart 3.6 ou posterior:

- Preserva parâmetros de tipo em parâmetros formais de função tipada no estilo antigo que
  também usam `this.` ou `super.`.
- Formata corretamente imports com as cláusulas `as` e `if`.

#### Pub

- `dart pub publish` agora avisa se arquivos
  rastreados no git têm alterações não commitadas.

## 3.5.0

### Linguagem {:#language}

- [O contexto usado pelo compilador para realizar a inferência de tipo sobre
  o operando de uma expressão `await` foi alterado para
  igualar o comportamento do analisador.][55418]
- [O contexto usado pelo compilador para realizar a inferência de tipo sobre
  o lado direito de uma expressão "if-null" (`e1 ?? e2`) foi
  alterado para igualar o comportamento do analisador.][55436]
  O comportamento antigo pode ser restaurado fornecendo tipos explícitos.

[55418]: {{site.repo.dart.sdk}}/issues/55418
[55436]: {{site.repo.dart.sdk}}/issues/55436

### Bibliotecas {:#libraries}

#### `dart:core`

- [`DateTime` agora armazena microssegundos na plataforma web][44876],
  aproximando-se mais do comportamento nas plataformas nativas.

[44876]: {{site.repo.dart.sdk}}/issues/44876

#### `dart:io`

- [`SecurityContext` agora é `final` e não pode mais ser subclassificado][55786].

[55786]: {{site.repo.dart.sdk}}/issues/55786

#### `dart:js_interop`

- [`importModule` agora aceita um `JSAny` em vez de uma `String`][55508] para
  dar suporte a outros valores JS também, como objetos `TrustedScriptURL`.
- [`isTruthy` e `not` agora retornam `JSBoolean` em vez de `bool`][55267] para
  ser consistente com os outros métodos de operador JS.
- [`ExternalDartReference` não implementa mais `Object`][56015].
  Em vez disso, agora aceita um parâmetro de tipo (`T`) com limite
  `Object?` para capturar o tipo do objeto Dart que é externalizado.

[55508]: {{site.repo.dart.sdk}}/issues/55508
[55267]: {{site.repo.dart.sdk}}/issues/55267
[56015]: {{site.repo.dart.sdk}}/issues/56015

#### `dart:typed_data`

- {{removed}}
  [As classes de visão não modificável para dados tipados foram removidas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` nas listas de dados tipados.

### Runtime

- {{removed}} A VM do Dart não oferece mais suporte a null safety unsound.
  - A opção de CLI `--no-sound-null-safety` foi removida.
  - As funções `Dart_NewListOf` e `Dart_IsLegacyType` foram
    removidas da API C.
- {{removed}} A função `Dart_DefaultCanonicalizeUrl` foi
  removida da API C.

## 3.4.0

### Linguagem {:#language}

- [O schema de contexto de tipo de padrão para padrões de cast
  agora é `_` (o tipo desconhecido) em vez de `Object?`][54640].
- [O schema de tipo usado pelos compiladores do Dart para
  realizar a inferência de tipo sobre o operando de um operador spread com null-aware (`...?`)
  em literais de map e set foi tornado nullable][54828],
  para igualar o que já acontece em literais de lista.

[54640]: {{site.repo.dart.sdk}}/issues/54640
[54828]: {{site.repo.dart.sdk}}/issues/54828

### Bibliotecas {:#libraries}

#### `dart:cli`

- {{experimental}} {{removed}} [A função `waitFor`][52121]
  foi removida.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audio`, `dart:web_gl`

- {{deprecated}} Estas bibliotecas agora estão marcadas como legadas e
  receberão menos suporte no futuro.
  Novos projetos devem preferir usar [`package:web`][] e `dart:js_interop`.
  Para saber mais, veja [Migre para `package:web`][Migrate to `package:web`].

[`package:web`]: {{site.pub-pkg}}/web
[Migrate to `package:web`]: /interop/js-interop/package-web

#### `dart:js`

- {{deprecated}}
  Esta biblioteca agora está marcada como legada e receberá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, veja [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:js_util`

- {{deprecated}}
  Esta biblioteca agora está marcada como legada e receberá menos suporte no futuro.
  Os usos devem ser migrados para `dart:js_interop` e `dart:js_interop_unsafe`.
  Para saber mais, veja [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:io`

- [`Stdout` tem um novo campo `lineTerminator`, que permite que
  desenvolvedores controlem o terminador de linha usado por `stdout` e `stderr`.][53863]
  Classes que implementam `Stdout` devem definir o campo `lineTerminator`.
  A semântica padrão de `stdout` e `stderr` não muda.
- {{deprecated}} A propriedade `FileSystemDeleteEvent.isDirectory`.
  Ela sempre retorna `false`.

[53863]: {{site.repo.dart.sdk}}/issues/53863

#### `dart:typed_data`

- {{deprecated}}
  [As classes de visão não modificável para dados tipados estão descontinuadas][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` nas listas de dados tipados.

[53128]: {{site.repo.dart.sdk}}/issues/53218

### Ferramentas {:#tools}

#### Compilador JavaScript de produção (dart2js) {:#production-javascript-compiler-dart2js}

- {{experimental}} {{deprecated}} Agora você deve especificar um formato para
  a opção de CLI `--dump-info` como `binary` ou `json`.
  O formato `json` está descontinuado e pode ser removido em uma versão futura do Dart.

#### Compilador Wasm (dart2wasm) {:#wasm-compiler-dart2wasm}

- {{experimental}} Vários argumentos de CLI de `dart compile wasm` foram
  atualizados, removidos ou substituídos.
  Para saber mais, execute `dart compile wasm --verbose --help`.

### Runtime

- {{removed}} A VM do Dart não oferece mais suporte a strings externas.
  Como resultado, as funções `Dart_IsExternalString`, `Dart_NewExternalLatin1String` e
  `Dart_NewExternalUTF16String` foram removidas da API C do Dart.

## 3.3.0

### SDK

* {{experimental}} {{removed}} Os seguintes experimentos estão agora aposentados, pois
  foram lançados no Dart 3 e não são mais necessários com
  uma versão da linguagem 3.0 ou superior.
  A configuração deles deve ser removida das
  opções de análise, dos comandos de CLI e das configurações da IDE.

  * `patterns`
  * `records`
  * `class-modifiers`
  * `sealed-class`

### Linguagem {:#language}

* [Um getter abstrato agora é considerado promovível se
  não houver declarações conflitantes][54056].

[54056]: {{site.repo.dart.sdk}}/issues/54056

### Bibliotecas {:#libraries}

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`][52121]
  continua descontinuada por mais uma versão e está marcada para remoção no Dart 3.4.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:ffi`

* {{deprecated}} [Os métodos de aritmética de ponteiro `elementAt`
  nos tipos `Pointer` estão descontinuados][54250].
  Migre para os operadores `-` e `+`.
* {{experimental}} {{removed}} A anotação `@FfiNative`,
  previamente descontinuada, foi removida. Os usos devem ser
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
* {{experimental}} Classes `@staticInterop` definidas pelo usuário não podem mais
  [implementar `JSAny` ou `JSObject`][52687].
  Os usos devem ser migrados para `JSObject.fromInteropObject` ou
  ser definidos como extension types.
* {{experimental}} `JSArray` e `JSPromise` agora têm parâmetros genéricos.
* {{experimental}} Vários membros de extensão foram movidos ou renomeados.
  Para saber sobre as extensões atualizadas, consulte
  `JSAnyUtilityExtension` e `JSAnyOperatorExtension`.

[52687]: {{site.repo.dart.sdk}}/issues/52687

#### `dart:typed_data`

* [As classes de visão não modificável para dados tipados serão
  descontinuadas no Dart 3.4][53128].
  Em vez de usar os construtores dessas classes, use
  os novos métodos `asUnmodifiableView` nas listas de dados tipados.

[53128]: {{site.repo.dart.sdk}}/issues/53218

#### `dart:nativewrappers`

* {{experimental}} [Todas as classes wrapper nativas agora são marcadas como `base`][51896]
  para que nenhum de seus subtipos possa ser implementado.

[51896]: {{site.repo.dart.sdk}}/issues/51896

### Ferramentas {:#tools}

#### Compilador JavaScript de produção (dart2js) {:#production-javascript-compiler-dart2js}

* [O `Invocation` que é passado para `noSuchMethod` não tem mais
  um `memberName` minificado][54201], mesmo quando compilado com `--minify`.

[54201]: {{site.repo.dart.sdk}}/issues/54201

#### Compilador Wasm (dart2wasm) {:#wasm-compiler-dart2wasm}

* {{experimental}} [Proíbe importar bibliotecas legadas de interop com JS][54004].
  Prefira usar `dart:js_interop` e `dart:js_interop_unsafe`.

[54004]: {{site.repo.dart.sdk}}/issues/54004

#### Analisador {:#analyzer}

* {{experimental}} Diretivas inválidas em comentários `dart doc` agora são
  reportadas pelo analisador.
* Devido a [melhorias na promoção de tipo][54056], os seguintes diagnósticos
  do analisador podem ser disparados em código existente que antes passava na análise:

  * `unnecessary_non_null_assertion`
  * `unnecessary_cast`
  * `invalid_null_aware_operator`

[54056]: {{site.repo.dart.sdk}}/issues/54056

#### Linter

* As regras `iterable_contains_unrelated_type` e
  `list_remove_unrelated_type` foram removidas.
  Considere migrar para a regra
  [`collection_methods_unrelated_type`][] ampliada.
* As seguintes regras foram removidas por não serem mais
  necessárias com o sound null safety. Você deve remover a configuração delas
  dos seus arquivos `analysis_options.yaml` e de quaisquer comentários de ignore.

  * `always_require_non_null_named_parameters`
  * `avoid_returning_null`
  * `avoid_returning_null_for_future`

[`collection_methods_unrelated_type`]: /tools/linter-rules/collection_methods_unrelated_type

## 3.2.0

### Linguagem {:#language}

* {{versioned}} [Mudou o ponto de divisão para padrões refutáveis][53167]
  para o padrão de nível superior, de modo que a promoção de tipo em instruções if-case seja consistente
  independentemente de o valor avaliado poder lançar uma exceção.

### Bibliotecas {:#libraries}

#### `dart:cli`

* {{experimental}} {{deprecated}} [A função `waitFor`.][52121]

#### `dart:convert`

* [Os tipos de retorno de `utf8.encode()` e `Utf8Codec.encode()` foram alterados][52801]
 de `List<int>` para `Uint8List`.

#### `dart:developer`

* {{deprecated}} O método `Service.getIsolateID`.

#### `dart:ffi`

* [`NativeCallable.nativeFunction` foi alterado para que as chamadas agora lancem um erro se
  o receptor já estiver fechado][53311], em vez de retornar `nullptr`.

#### `dart:io`

* [Eliminou espaços em branco no final dos headers HTTP][53005].
* [Inseriu um espaço no ponto de dobra de valores de header dobrados][53227]
  que `HttpClientResponse.headers` e `HttpRequest.headers` retornam.

#### `dart:js_interop`

* {{experimental}} {{removed}} `JSNumber.toDart` em favor de `toDartDouble` e
  `toDartInt`.
* {{experimental}} {{removed}} `Object.toJS` em favor de `Object.toJSBox.`
* {{experimental}} APIs de interop externo com JS usando `dart:js_interop` foram restritas
  a um conjunto de tipos permitidos.
* {{experimental}} Uso de `isNull` e `isUndefined` no dart2wasm foi proibido.
* {{experimental}} As APIs `typeofEquals` e `instanceof` foram alteradas para retornar
  bool em vez de `JSBoolean`.
  Além disso, `typeofEquals` agora recebe `String` em vez de `JSString`.
* {{experimental}} Os tipos `JSAny` e `JSObject` foram alterados para que só possam ser implementados,
  e não estendidos, por tipos `@staticInterop` definidos pelo usuário.
* {{experimental}} `JSArray.withLength` foi alterado para receber `int` em vez de `JSNumber`.

### Ferramentas {:#tools}

#### Compilador JavaScript de desenvolvimento (DDC) {:#development-javascript-compiler-ddc}

* [Foram adicionados interceptors para os tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Compilador JavaScript de produção (dart2js) {:#production-javascript-compiler-dart2js}

* [Foram adicionados interceptors para os tipos JavaScript `Symbol` e `BigInt`][53106];
  eles não devem mais ser usados com classes `package:js`.

#### Analisador {:#analyzer}

* {{versioned}} [A promoção de campos privados final][2020] pode fazer com que os seguintes
  avisos do analisador sejam disparados em código existente que antes passava na análise:

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

### Bibliotecas {:#libraries}

#### `dart:async`

* [Adicionado o modificador `interface` a classes puramente abstratas:][52334]
 `MultiStreamController`, `StreamConsumer`, `StreamIterator` e `StreamTransformer`.

#### `dart:io`

* [Adicionado `sameSite` à classe `Cookie`, e adicionada a classe `SameSite`][51486].
* [`FileSystemEvent` é `sealed`][52027]. Isso significa que `FileSystemEvent` não pode
  ser estendido nem implementado.

#### `dart:js_interop`

* {{experimental}} {{removed}} `ObjectLiteral`; crie um literal de objeto sem
  membros nomeados usando `{}.jsify()`.

#### `package:js`

* Membros `external` `@staticInterop` e membros de extensão `external` não podem mais
  ser usados como tear-offs. Declare um closure ou um método não `external` que
  chame esses membros, e use-o no lugar.
* Membros `external` `@staticInterop` e membros de extensão `external` vão
  gerar um código JS um pouco diferente para métodos que têm parâmetros opcionais.

[52334]: {{site.repo.dart.sdk}}/issues/52334
[51486]: {{site.repo.dart.sdk}}/issues/51486
[52027]: {{site.repo.dart.sdk}}/issues/52027

## 3.0.0

:::tip
O [guia de migração para o Dart 3.0][dart3] cobre todos os detalhes
sobre todas as mudanças desta seção.
:::

### Linguagem {:#language}

* {{versioned}} A interpretação de [casos de switch][switch cases] foi alterada de
  expressões constantes para padrões.

* {{versioned}} Declarações de classe de bibliotecas que foram atualizadas para
  o Dart 3.0 [não podem mais ser usadas como mixins por padrão][mixin class].

* [O Dart reporta um erro de compilação][50902] se uma instrução `continue` tiver como alvo um
  [label] que não é um loop (instruções `for`, `do` e `while`) nem um membro
  de `switch`.

### Bibliotecas {:#libraries}

* As seguintes classes existentes foram transformadas em classes mixin:
  `Iterable`, `IterableMixin`, `IterableBase`, `ListMixin`, `SetMixin`, `MapMixin`,
  `LinkedListEntry`, `StringConversionSink`.

#### `dart:core`

* {{deprecated}} [APIs descontinuadas][49529].

#### `dart:async`

* {{removed}} [Removida a classe descontinuada][49529] [`DeferredLibrary`][].

#### `dart:collection`

* {{versioned}} [Mudanças nas bibliotecas da plataforma][collection].

#### `dart:developer`

* {{removed}} [Removida a constante descontinuada][49529] [`MAX_USER_TAGS`][].
  Use [`maxUserTags`][] em vez dela.
* {{removed}} [Removidas as classes descontinuadas][50231] [`Metrics`][], [`Metric`][], [`Counter`][],
  e [`Gauge`][], pois estavam quebradas desde o Dart 2.0.

#### `dart:ffi`

* {{experimental}} {{deprecated}} A anotação `@FfiNative` agora está
  descontinuada. Os usos devem ser atualizados para usar a anotação `@Native`.

#### `dart:html`

* {{removed}} [Removidos os métodos descontinuados `registerElement` e `registerElement2`][49536]
  em `Document` e `HtmlDocument`.

#### `dart:math`

* {{versioned}} A interface `Random` só pode ser implementada,
  não estendida.

#### `dart:io`

* [Atualizado `NetworkProfiling`][51035] para acomodar novos ids `String` que são
  introduzidos no vm_service:11.0.0.

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
[`maxUserTags`]: {{site.dart-api}}/dart-developer/UserTag/maxUserTags-constant.html
[50231]: {{site.repo.dart.sdk}}/issues/50231
[`Metrics`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Gauge-class.html
[49536]: {{site.repo.dart.sdk}}/issues/49536
[51035]: {{site.repo.dart.sdk}}/issues/51035


## 2.19.0

### Linguagem {:#language}

* [Marcado código adicional como inalcançável][49635] devido aos tipos `Null` e `Never`.
* [Não delega nomes privados inacessíveis para `noSuchMethod`][49687].
* [Reporta um erro de compilação][50383] para todas as dependências cíclicas durante a
  inferência de tipo de nível superior.

### Bibliotecas {:#libraries}

#### `dart:convert`

* {{removed}} [A API previamente descontinuada][34233] [`DEFAULT_BUFFER_SIZE`] em `JsonUtf8Encoder`
  foi removida.

#### `dart:developer`

* {{removed}} [APIs previamente descontinuadas removidas][34233] `kInvalidParams`,
  `kExtensionError`, `kExtensionErrorMax` e `kExtensionErrorMin` em
  [`ServiceExtensionResponse`].

#### `dart:ffi`

* [O tipo de argumento de runtime de `Pointer` foi alterado para `Never`][49935] em
  preparação para remover completamente o argumento de tipo de runtime.
  `Pointer.toString` foi alterado para não reportar nenhum argumento de tipo.

#### `dart:io`

* [Não permite content-length headers negativos ou hexadecimais][49305].
* [`File.create` agora recebe um novo parâmetro `bool` opcional `exclusive`][49647],
  e, quando é `true`, a operação falha se o arquivo de destino já existir.
* Chamar `ResourceHandle.toFile()`, `ResourceHandle.toSocket()`,
  `ResourceHandle.toRawSocket()` ou `ResourceHandle.toRawDatagramSocket()`
  mais de uma vez [agora lança um `StateError`][49878].

#### `dart:isolate`

* [`SendPort.send`] voltou a ter verificações estritas sobre o conteúdo das mensagens
  ao enviar mensagens entre isolates que não são conhecidos por compartilhar o mesmo código.

#### `dart:mirrors`

* {{removed}} [APIs removidas][34233] `MirrorsUsed` e `Comment`.

#### `package:js`

* Mudanças incompatíveis na funcionalidade de preview `@staticInterop`:
  * Classes com essa anotação não podem mais usar construtores generativos `external`.
    Veja [48730] e [49941] para mais detalhes.
  * [Classes com membros de extensão `external` dessa anotação não podem mais
    usar parâmetros de tipo][49350].
  * Classes com essa anotação também devem ter a anotação `@JS`.
  * Classes com essa anotação não podem ser implementadas por classes sem essa anotação.

#### `dart2js`

* [`dart2js` não aceita mais URIs HTTP como entradas][49473].

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

### Linguagem {:#language}

* [Removido o suporte a mixin de classes que não estendem `Object`][48167].

### Bibliotecas {:#libraries}

#### `dart:io`

* [Alterada a propriedade `uri` de `RedirectException` em `dart:io` para ser nullable][49045].
* [Removidas constantes nas APIs de rede de `dart:io` seguindo a
  convenção `SCREAMING_CAPS`][34218].
* [A VM do Dart não restaura mais automaticamente as configurações iniciais do terminal][45630]
  ao sair.

### Ferramentas {:#tools}

* [Descontinuado por completo o arquivo `.packages`][48272].

#### Linha de comando do Dart {:#dart-command-line}

* [Removidas as ferramentas standalone `dart2js` e `dartdevc`][46100].
* [Removida a ferramenta standalone `dartanalyzer`][46100].

[48167]: {{site.repo.dart.sdk}}/issues/48167
[49045]: {{site.repo.dart.sdk}}/issues/49045
[34218]: {{site.repo.dart.sdk}}/issues/34218
[45630]: {{site.repo.dart.sdk}}/issues/45630
[48272]: {{site.repo.dart.sdk}}/issues/48272
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.17.0

### Bibliotecas {:#libraries}

#### `dart:io`

* [Adicionada nova propriedade `connectionFactory` a `HttpClient`][47887].
* [Adicionada nova propriedade `keyLog` a `HttpClient`][48093], que permite registrar
  chaves TLS para fins de depuração.
* [Removidas constantes em `dart:io` seguindo a convenção `SCREAMING_CAPS`][34218]
* [Adicionada nova propriedade `allowLegacyUnsafeRenegotiation` a `SecurityContext`][48513],
  que permite renegociação TLS para sockets seguros de cliente.

### Ferramentas {:#tools}

#### Linha de comando do Dart {:#dart-command-line}

* {{deprecated}} [Descontinuada a ferramenta standalone `dart2js`][46100].
* {{deprecated}} [Descontinuada a ferramenta standalone `dartdevc`][46100].
* {{removed}} [Removida a ferramenta standalone `dartdoc`][46100].

[47887]: {{site.repo.dart.sdk}}/issues/47887
[48093]: {{site.repo.dart.sdk}}/issues/48093
[34218]: {{site.repo.dart.sdk}}/issues/34218
[48513]: {{site.repo.dart.sdk}}/issues/48513
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.16.0

### Bibliotecas {:#libraries}

#### `dart:io`

* No Windows, [`Directory.rename` não vai mais excluir um diretório][47653] se
  `newPath` especificar um. Em vez disso, uma `FileSystemException` será lançada.
* {{removed}} [Removida a API `Platform.packageRoot`][47769].

#### `dart:isolate`

* {{removed}} [Removida a API `Isolate.packageRoot`][47769].

### Ferramentas {:#tools}

#### Linha de comando do Dart {:#dart-command-line}

* {{deprecated}} [Descontinuada a ferramenta standalone `dartanalyzer`][46100].
* {{deprecated}} [Descontinuada a ferramenta standalone `dartdoc`][46100].
* {{removed}} [Removida a ferramenta standalone `pub` descontinuada][46100].

[47653]: {{site.repo.dart.sdk}}/issues/47653
[47769]: {{site.repo.dart.sdk}}/issues/47769
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.15.0

### Bibliotecas {:#libraries}

#### `dart:io`

* [Atualizada a classe `SecurityContext`][46875] para definir a versão mínima
  do protocolo TLS como TLS1_2_VERSION (1.2) em vez de TLS1_VERSION.

#### `dart:web_sql`

* [A biblioteca `dart:web_sql` foi totalmente excluída][46316].

#### `dart:html`

* [Removido `window.openDatabase`][46316] (relacionado à exclusão de `dart:web_sql` acima).

### Ferramentas {:#tools}

#### Linha de comando do Dart {:#dart-command-line}

* [Removida a ferramenta standalone `dart2native`][46100].
* Removida a ferramenta standalone `dartfmt`.

#### VM do Dart {:#dart-vm}

* [Removido o suporte a native extensions no estilo `dart-ext:`][45451]
* [Isolates criados pela API `Isolate.spawn()` agrupados][46754] para operar no
  mesmo heap gerenciado e, portanto, compartilhar várias estruturas de dados internas da VM.

[46875]: {{site.repo.dart.sdk}}/issues/46875
[46316]: {{site.repo.dart.sdk}}/issues/46316
[45451]: {{site.repo.dart.sdk}}/issues/45451
[46754]: {{site.repo.dart.sdk}}/issues/46754

## 2.14.0

### Bibliotecas {:#libraries}

#### `dart:io`

* Os callbacks de setter `.authenticate` e `.authenticateProxy` em `HttpClient`
  agora devem aceitar um argumento `realm` nullable (para código já migrado para null safety).

#### `dart:typed_data`

* A maioria dos tipos expostos por esta biblioteca [não pode mais ser estendida, implementada ou
  usada como mixin][45115].

### Ferramentas {:#tools}

#### VM do Dart {:#dart-vm}

* Expandos e os parâmetros `object` de `Dart_NewWeakPersistentHandle` e
  `Dart_NewFinalizableHandle` [não aceitam mais `Pointer` e subtipos de `Struct`][45071]

#### Linha de comando do Dart {:#dart-command-line}

* [Descontinuada a ferramenta standalone `dart2native`][46100]
* Descontinuada a ferramenta standalone `dartfmt`.

#### `dart2js`

* [`dart2js` não oferece mais suporte a navegadores legados][46545], porque emite
  JavaScript ES6+ por padrão.

#### Dart Dev Compiler (DDC)

* [Alteradas as relações de subtipo das classes de `package:js`][44154] para ficarem mais corretas e
  consistentes com o Dart2JS.

[45115]: {{site.repo.dart.sdk}}/issues/45115
[45071]: {{site.repo.dart.sdk}}/issues/45071
[46545]: {{site.repo.dart.sdk}}/issues/46545
[44154]: {{site.repo.dart.sdk}}/issues/44154


## 2.13.0

### Bibliotecas {:#libraries}

#### `package:js`

* [Não é mais válido][44211] usar uma `String` que corresponda a uma anotação `@Native`
  em uma anotação `@JS()` para uma classe de interop JS não anônima.

[44211]: {{site.repo.dart.sdk}}/issues/44211

## 2.12.0

### Linguagem {:#language}

* [O null safety][Null safety] agora é habilitado por padrão em todo código
  que não optou por sair.
* [Corrigido um bug de implementação][44660] em que `this` às vezes passava por promoção de tipo
  em extensões.

### Bibliotecas {:#libraries}

#### `dart:ffi`

* [Descontinuadas invocações com um `T` genérico][44621] de `sizeOf<T>`,
  `Pointer<T>.elementAt()`, `Pointer<T extends Struct>.ref` e
  `Pointer<T extends Struct>[]`
* [Descontinuado `allocate` em `package:ffi`][44621], pois ele não será mais
  capaz de invocar `sizeOf<T>` de forma genérica.
* [Descontinuados subtipos de `Struct` sem nenhum membro nativo][44622].

### Ferramentas {:#tools}

#### VM do Dart {:#dart-vm}

* [`Dart_WeakPersistentHandle` não se auto-exclui mais][42312] quando o
  objeto referenciado é coletado pelo garbage collector, para evitar race conditions.
* [Renomeado `Dart_WeakPersistentHandleFinalizer` para `Dart_HandleFinalizer`][42312]
  e removido o argumento `handle` dele.

#### Pub

* [A restrição do SDK do Dart agora é **obrigatória** no `pubspec.yaml`][44072].

[Null safety]: /null-safety/understanding-null-safety
[44660]: {{site.repo.dart.sdk}}/issues/44660
[44621]: {{site.repo.dart.sdk}}/issues/44621
[42312]: {{site.repo.dart.sdk}}/issues/42312
[44622]: {{site.repo.dart.sdk}}/issues/44622
[44072]: {{site.repo.dart.sdk}}/issues/44072

## 2.10.0

### Ferramentas {:#tools}

#### VM do Dart {:#dart-vm}

* [Renomeado `dart_api_dl.cc` para `dart_api_dl.c`][42982] e alterado para um arquivo C puro.

[42982]: {{site.repo.dart.sdk}}/issues/42982

## 2.9.0

### Bibliotecas {:#libraries}

#### `dart:convert`

* Ao codificar uma string contendo surrogates não pareados como UTF-8, [os surrogates
  não pareados serão codificados como caracteres de substituição][41100] (`U+FFFD`).
* Ao decodificar UTF-8, [surrogates codificados serão tratados como entrada malformada][41100].
* [Alterado o número de caracteres de substituição emitidos][41100] para sequências
  de entrada malformadas, para igualar o [padrão de codificação WHATWG][WHATWG encoding standard], ao decodificar UTF-8
  com `allowMalformed: true`.

#### `dart:html`

* `CssClassSet.add()` e `CssClassSet.toggle` agora retornam `false` em vez de
   `null` se o `CssClassSet` corresponder a múltiplos elementos.

#### `dart:mirrors`

* [Os compiladores web (dart2js e DDC) agora produzem um erro de compilação][42714] se
  `dart:mirrors` for importado.

### Ferramentas {:#tools}

#### VM do Dart {:#dart-vm}

* Ao imprimir uma string usando a função `print`, [a implementação padrão
  imprime quaisquer surrogates não pareados da string como caracteres de substituição][41100]
  (`U+FFFD`).
* A função `Dart_StringToUTF8` na API do Dart [converte surrogates
  não pareados em caracteres de substituição][41100].


[41100]: {{site.repo.dart.sdk}}/issues/41100
[whatwg encoding standard]: https://encoding.spec.whatwg.org/#utf-8-decoder
[42714]: {{site.repo.dart.sdk}}/issues/42714

## 2.8.1

### Linguagem {:#language}

* [Corrigido um bug de implementação][40675] em que a inferência de variáveis locais
  usava incorretamente o tipo promovido de uma variável de tipo.
* [Corrigido um bug de implementação][41362] envolvendo as cláusulas
  `implements Function`, `extends Function` ou `with Function`, que não tinham
  mais efeito desde o Dart 2.0.0.

### Bibliotecas {:#libraries}

#### `dart:async`

* [Alterado o tipo de retorno de `StreamSubscription.cancel()` para `Future<void>`][40676].
* [Dividida a função `runZoned()` em duas funções][40681]:
  `runZoned()` e `runZonedGuarded()`, sendo que esta última tem um
  parâmetro `onError` obrigatório, e a primeira não tem nenhum.
* Erros passados para `Completer.completeError()`, `Stream.addError()`,
  `Future.error()`, etc. [não podem mais ser `null`][40683].
* [Stack traces agora são non-null][40130].

#### `dart:core`

* Três membros de `RuneIterator` [não retornam mais `null`][40674] quando acessados
  antes da primeira chamada a `moveNext()`.
* O valor padrão de `defaultValue` em `String.fromEnvironment()`
  [agora é uma string vazia em vez de `null`][40678].
* O valor padrão do parâmetro `defaultValue` de `int.fromEnvironment()`
  [agora é zero][40678].

#### `dart:ffi`

* Alterados `Pointer.asFunction()` e `DynamicLibrary.lookupFunction()` para
  métodos de extensão.

#### `dart:io`

* [Alterada a assinatura dos métodos de `HttpHeaders`][33501] `add()` e `set`.
* [A classe `Socket` agora lança uma `SocketException`][40702] se o socket tiver
  sido explicitamente destruído ou atualizado para um socket seguro ao definir ou obter opções de socket.
* [A classe `Process` agora lança um `StateError`][40483]
  se o processo estiver desanexado (`ProcessStartMode.detached` e
  `ProcessStartMode.detachedWithStdio`) ao acessar o getter `exitCode`.
* [A classe `Process` agora também lança][40483] quando não está conectada ao
  stdio do processo filho (`ProcessStartMode.detached` e `ProcessStartMode.inheritStdio`) ao acessar os getters `stdin`, `stdout` e `stderr`.
* O objeto fictício retornado se `FileStat.stat()` ou `FileStat.statSync()` falhar
  [agora contém timestamps Unix epoch][40706] em vez de `null` para os getters `accessed`,
  `changed` e `modified`.
* [A classe `HeaderValue` agora faz o parsing de forma mais estrita][40709] em dois casos de borda inválidos.

### Ferramentas {:#tools}

#### Dart Dev Compiler (DDC)

Corrigimos várias inconsistências entre o DDC e o Dart2JS para que os usuários
encontrem com menos frequência código aceito por um compilador, mas que depois falha no
outro.

* Excluída a versão legada (baseada no analisador) do [DDC][ddc].
* Funções passadas para JavaScript usando a especificação de interop `package:js`
  recomendada agora devem ser encapsuladas com uma chamada a `allowInterop`.
* Construtores em classes `@JS()` devem ser marcados com `external`.

#### `dart2js`

* Os limites de parâmetros de tipo correspondentes agora só precisam ser subtipos
  mútuos, em vez de estruturalmente iguais, salvo renomeação das variáveis de tipo dos limites
  e equiparação de todos os tipos topo.
* Os tipos agora são [normalizados][normalized].
* Construtores em classes `@JS()` devem ser marcados com `external`.
* Removida por completo a flag `--package-root`, que era oculta e desabilitada
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

* [O SDK do Dart para macOS agora está disponível apenas para x64][39810].

[39810]: {{site.repo.dart.sdk}}/issues/39810

## 2.7.0

### Linguagem {:#language}

* [Membros de extensão estáticos são acessíveis quando importados com um prefixo][671].

### Bibliotecas {:#libraries}

#### `dart:io`

* Adicionado `IOOverrides.serverSocketBind` para facilitar a escrita de testes que desejam
  simular `ServerSocket.bind`.

## 2.6.0

### Linguagem {:#language}

* [Alterada a inferência ao usar valores `Null` em um contexto `FutureOr`][37985].
  Ou seja, restrições de formas semelhantes a `Null` <: `FutureOr<T>` agora produzem
  `Null` como solução para `T`.

### Bibliotecas {:#libraries}

#### `dart:ffi`

* A API agora usa membros de extensão estáticos.
* Removidos `Pointer.allocate` e `Pointer.free` de gerenciamento de memória.
* `Pointer.offsetBy` foi removido; use `cast` e `elementAt` no lugar.

[671]: {{site.repo.dart.lang}}/issues/671
[37985]: {{site.repo.dart.sdk}}/issues/37985

## 2.5.0

### Bibliotecas {:#libraries}

* Vários métodos e propriedades de várias bibliotecas principais, que
  declaravam um tipo de retorno `List<int>`, foram [atualizados para declarar um tipo de retorno
  `Uint8List`][36900].

#### `dart:io`

* Os parâmetros posicionais opcionais `name` e `value` do construtor da classe `Cookie`
  [agora são obrigatórios][37192].
* [Os setters `name` e `value` da classe `Cookie` agora validam][37192]
  que as strings são formadas pelo conjunto de caracteres permitido e não são null.

### Ferramentas {:#tools}

#### Pub

* Pacotes publicados no [pub.dev]({{site.pub}}) [não podem mais conter dependências git][36765].

[36900]: {{site.repo.dart.sdk}}/issues/36900
[37192]: {{site.repo.dart.sdk}}/issues/37192
[37192]: {{site.repo.dart.sdk}}/issues/37192
[36765]: {{site.repo.dart.sdk}}/issues/36765

## 2.4.0

### Linguagem {:#language}

* [A covariância de variáveis de tipo usadas em super-interfaces agora é imposta][35097].

### Bibliotecas {:#libraries}

#### `dart:isolate`

* `Isolate.resolvePackageUri` sempre lançará um `UnsupportedError` quando
  compilado com dart2js ou DDC.

#### `dart:async`

* [Corrigido um bug na classe `StreamIterator`][36382] em que `await for` permitia
  `null` como stream.

[35097]: {{site.repo.dart.sdk}}/issues/35097
[36382]: {{site.repo.dart.sdk}}/issues/36382

## 2.2.0

### Bibliotecas {:#libraries}

#### `package:kernel`

* A propriedade `klass` do getter na classe `InstanceConstant` da API
  de AST do Kernel foi renomeada para `classNode`, por consistência.
* [Atualizada a implementação de `Link`][33966] para usar links simbólicos verdadeiros
  em vez de junctions no Windows.

[33966]: {{site.repo.dart.sdk}}/issues/33966

## 2.1.1

### Bibliotecas {:#libraries}

#### `dart:io`

* [Adicionar a um `IOSink` fechado agora lança um `StateError`][29554].

[29554]: {{site.repo.dart.sdk}}/issues/29554

### Ferramentas {:#tools}

#### VM do Dart {:#dart-vm}

* [Corrigida uma brecha de soundness ao usar `dart:mirrors`][35611] para invocar
  refletivamente um método de forma incorreta, violando seus tipos estáticos.

[29554]: {{site.repo.dart.sdk}}/issues/29554
[35611]: {{site.repo.dart.sdk}}/issues/35611

## 2.1.0

### Linguagem {:#language}

* Vários erros estáticos que deveriam ter sido detectados
  e reportados não eram suportados no 2.0.0. Eles agora são reportados, o que significa que
  código incorreto existente pode mostrar novos erros:
  * [Mixins devem sobrescrever corretamente suas superclasses][34235].
  * [Argumentos de tipo implícitos em cláusulas extends devem satisfazer os limites da classe][34532].
  * [Membros de instância devem sombrear prefixos][34498].
  * [Invocações de construtor devem usar sintaxe válida, mesmo com `new` opcional][34403].
  * [Argumentos de tipo de typedefs genéricos devem satisfazer seus limites][33308].
  * [Classes não podem implementar FutureOr][33744].
  * [Métodos abstratos não podem sobrescrever de forma unsound um método concreto][32014].
  * [Construtores constantes não podem redirecionar para construtores não constantes][34161].
  * [Setters com o mesmo nome da classe envolvente não são permitidos][34225].

### Ferramentas {:#tools}

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

### Linguagem {:#language}

* Substituído o sistema de tipos estático opcional e unsound por um sistema de tipos
  sound que usa inferência de tipos e verificações em runtime, anteriormente chamado de [strong mode].
* [Funções marcadas como `async` agora executam de forma síncrona][30345] até a primeira
  instrução `await`.

### Bibliotecas {:#libraries}

* Constantes nas bibliotecas principais renomeadas de `SCREAMING_CAPS` para `lowerCamelCase`.
* Adicionados muitos novos métodos às classes das bibliotecas principais que precisarão ser implementados
  se você implementar as interfaces dessas classes.
* `dart:isolate` e `dart:mirrors` não são mais suportados ao
  usar o Dart para web.

### Ferramentas {:#tools}

#### Pub

* Substituído o sistema de build baseado em transformers do pub por um [novo sistema de build][build system].

[30345]: {{site.repo.dart.sdk}}/issues/30345
[strong mode]: /language/type-system
[build system]: {{site.repo.dart.org}}/build
