---
title: JS interop anterior
breadcrumb: Contexto
description: Arquivo do suporte a JS interop anterior do Dart.
ia-translate: true
prevpage:
  url: /interop/js-interop/tutorials
  title: Tutoriais de JS interop
nextpage:
  url: /interop/js-interop/package-web/
  title: Migrar para package:web
---

:::warning
Nenhuma dessas bibliotecas interop legadas é suportada ao compilar para [Wasm][].
:::

Esta página aborda iterações anteriores de JS interop para Dart que
foram consideradas legadas e estão depreciadas a partir do Dart 3.7 (Fev 2025).
Portanto, prefira usar [`dart:js_interop`][] daqui em diante e
migre usos de bibliotecas interop antigas quando possível.
Suporte para APIs de browser, como [`dart:html`][], agora são suportadas por
[`package:web`][].

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:html`]: {{site.dart-api}}/dart-html/
[`package:web`]: /interop/js-interop/package-web

## `dart:js`

[`dart:js`] expôs um [`object wrapper`] concreto para interoperar com objetos JS.
Este wrapper continha métodos baseados em String para obter, definir e chamar dinamicamente
propriedades no objeto JS envolvido. Era menos performático devido aos custos de wrapping
e ergonomicamente mais difícil de usar. Por exemplo, você não obtinha
code-completion, pois não podia declarar membros interop e, em vez disso, dependia de
Strings. Muitas das funcionalidades expostas em `dart:js` como [`allowInterop`]
foram posteriormente re-expostas através de outras bibliotecas interop.

Esta biblioteca tem sido legada desde que
`package:js` e `dart:js_util` foram lançados.

## `package:js`

[`package:js`] introduziu funcionalidade para declarar tipos e membros interop.
Permitia que usuários escrevessem classes interop em vez de extension types interop. Em
runtime, essas classes eram apagadas para um tipo similar ao
[`JSObject`] de `dart:js_interop`.

```dart
@JS()
class JSType {}
```

Usuários de `package:js` acharão a sintaxe e semântica de `dart:js_interop`
familiar. Você pode ser capaz de migrar para `dart:js_interop` substituindo a definição de classe
por um extension type e fazer funcionar em muitos casos.

Existem diferenças significativas, no entanto:

- Tipos `package:js` não podiam ser usados para interoperar com APIs de browser.
  Tipos `dart:js_interop` podem.
- `package:js` permitia dispatch dinâmico. Isso significava que se você convertesse o
  tipo `package:js` para `dynamic` e chamasse um membro interop nele, ele
  redirecionaria para o membro correto. Isso não é mais possível com
  `dart:js_interop`.
- O `@JS` de `package:js` não tem garantias de soundness, pois tipos de retorno de
  membros `external` não eram verificados. `dart:js_interop` é sound.
- Tipos `package:js` não podiam renomear membros de instância ou ter membros
  não-`external`.
- Tipos `package:js` podiam ser subtipos e supertipos de classes não-interop.
  Isso era frequentemente usado para mocks. Com `dart:js_interop`, mocking é feito
  substituindo o objeto JS em vez disso. Veja o [tutorial sobre mocking][tutorial on mocking].
- Tipos [`@anonymous`] eram uma maneira de declarar um tipo interop com um
  construtor de object literal. `dart:js_interop` não distingue tipos dessa forma e
  qualquer construtor de argumento nomeado `external` é um construtor de object literal.

### `@staticInterop`

Junto com `@JS` e `@anonymous`, `package:js` posteriormente expôs
[`@staticInterop`], que era um protótipo de extension types interop. É tão
expressivo e restritivo quanto `dart:js_interop` e foi planejado para ser uma
sintaxe transitória até que extension types estivessem disponíveis.

Tipos `@staticInterop` eram implicitamente apagados para `JSObject`. Exigia que usuários
declarassem todos os membros de instância em extensions para que apenas semânticas estáticas
pudessem ser usadas, e tinha garantias de soundness mais fortes. Usuários podiam usá-lo para
interagir com APIs de browser, e também permitia coisas como renomeação e
membros não-`external`. Como extension types interop, não tinha suporte para
dispatch dinâmico.

Classes `@staticInterop` quase sempre podem ser migradas para um extension
type interop simplesmente mudando a classe para um extension type e removendo as
anotações.

`dart:js_interop` expôs `@staticInterop` (e `@anonymous`, mas apenas se
`@staticInterop` também for usado) para suportar semânticas de interop estático até que
extension types fossem adicionados à linguagem. Todos esses tipos devem agora ser
migrados para extension types.

## `dart:js_util`

[`dart:js_util`] forneceu várias funções utilitárias que não podiam ser
declaradas em um tipo `package:js` ou eram necessárias para que valores fossem passados de um lado
para outro. Isso incluía membros como:

- `allowInterop` (que agora é [`Function.toJS`])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (que agora estão em
  [`dart:js_interop_unsafe`])
- Vários operadores JS
- Helpers de verificação de tipo
- Suporte a mocking
- E mais.

`dart:js_interop` e `dart:js_interop_unsafe` contêm esses helpers agora com
possivelmente sintaxe alternativa.


[`dart:js`]: {{site.dart-api}}/dart-js/
[`object wrapper`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html
[`package:js`]: {{site.pub-pkg}}/js
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[tutorial on mocking]: /interop/js-interop/mock
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[Wasm]: /web/wasm
