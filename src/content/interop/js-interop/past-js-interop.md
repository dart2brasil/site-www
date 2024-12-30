---
ia-translate: true
title: Interoperabilidade JS Anterior
description: Arquivo de implementações passadas de interoperabilidade JS.
---

:::warning
Nenhuma dessas bibliotecas legadas de interoperabilidade são suportadas ao compilar para [Wasm][Wasm].
:::

Esta página aborda iterações anteriores de interoperabilidade JS para Dart que são
consideradas legadas. Elas não estão obsoletas ainda, mas provavelmente estarão no
futuro. Portanto, prefira usar `dart:js_interop` daqui para frente e migre
usos de bibliotecas antigas de interoperabilidade quando possível. Embora
[`dart:html`] e outras bibliotecas web estejam intimamente relacionadas, elas são abordadas
na página do [`package:web`].

## `dart:js`

[`dart:js`] expôs um [`object wrapper`] concreto para interoperar com objetos JS.
Este wrapper continha métodos baseados em String para obter, definir e chamar
propriedades dinamicamente no objeto JS encapsulado. Era menos performático devido
aos custos de encapsulamento e ergonomicamente mais difícil de usar. Por exemplo, você não
tinha code-completion, pois não podia declarar membros de interoperabilidade e, em vez disso, dependia
de Strings. Muitas das funcionalidades expostas em `dart:js` como [`allowInterop`]
foram posteriormente reexpostas por meio de outras bibliotecas de interoperabilidade.

Esta biblioteca tem sido legada desde que `package:js` e `dart:js_util` foram
lançados. Provavelmente será a primeira a ser descontinuada.

## `package:js`

[`package:js`] introduziu funcionalidade para declarar tipos e membros de interoperabilidade.
Ele permitiu que os usuários escrevessem classes de interoperabilidade em vez de tipos de extensão de interoperabilidade. Em
tempo de execução, essas classes foram apagadas para um tipo semelhante a
`JSObject` do `dart:js_interop`.

```dart
@JS()
class JSType {}
```

Os usuários do `package:js` acharão a sintaxe e a semântica do `dart:js_interop`
familiares. Você pode migrar para `dart:js_interop` substituindo a classe
definição com um tipo de extensão e fazer com que funcione em muitos casos.

Existem diferenças significativas, no entanto:

- os tipos `package:js` não podiam ser usados para interoperar com APIs do navegador.
  Os tipos `dart:js_interop` podem.
- `package:js` permitia despacho dinâmico. Isso significava que se você convertesse o
  tipo `package:js` para `dynamic` e chamasse um membro de interoperabilidade nele, ele
  encaminharia para o membro certo. Isso não é mais possível com
  `dart:js_interop`.
- O [`@JS`] do `package:js` não tem garantias de solidez, pois os tipos de retorno de
  membros `external` não eram verificados. `dart:js_interop` é sólido.
- Os tipos `package:js` não podiam renomear membros de instância ou ter
  membros não `external`.
- Os tipos `package:js` podiam subtipar e ser um supertipo de classes que não sejam de interoperabilidade.
  Isso era frequentemente usado para mocks. Com `dart:js_interop`, o mock é feito por
  substituir o objeto JS. Consulte o [tutorial sobre mock][tutorial on mocking].
- Os tipos [`@anonymous`] eram uma forma de declarar um tipo de interoperabilidade com um objeto
  construtor literal. `dart:js_interop` não distingue os tipos dessa forma e
  qualquer construtor de argumento nomeado `external` é um construtor literal de objeto.

### `@staticInterop`

Junto com `@JS` e `@anonymous`, `package:js` mais tarde expôs
[`@staticInterop`], que era um protótipo de tipos de extensão de interoperabilidade. É tão
expressivo e restritivo quanto `dart:js_interop` e foi concebido para ser um
sintaxe transitória até que os tipos de extensão estivessem disponíveis.

Os tipos `@staticInterop` foram implicitamente apagados para `JSObject`. Ele exigia que os usuários
declarassem todos os membros da instância em extensões para que apenas a semântica estática
pudesse ser usado e tinha garantias de solidez mais fortes. Os usuários poderiam usá-lo para
interagir com APIs do navegador e também permitia coisas como renomeação e
membros não `external`. Como os tipos de extensão de interoperabilidade, ele não tinha suporte para
despacho dinâmico.

As classes `@staticInterop` quase sempre podem ser migradas para um tipo de extensão de interoperabilidade
apenas alterando a classe para um tipo de extensão e removendo o
anotações.

`dart:js_interop` expôs `@staticInterop` (e `@anonymous`, mas apenas se
`@staticInterop` também for usado) para suportar semântica de interoperabilidade estática até
tipos de extensão foram adicionados à linguagem. Todos esses tipos devem agora ser
migrado para tipos de extensão.

## `dart:js_util`

[`dart:js_util`] forneceu uma série de funções de utilidade que não podiam ser
declaradas em um tipo `package:js` ou eram necessárias para que os valores fossem passados de um lado para outro. Isso incluía membros como:

- `allowInterop` (que agora é [`Function.toJS`])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (que agora estão em
  [`dart:js_interop_unsafe`])
- Vários operadores JS
- Auxiliares de verificação de tipo
- Suporte a mock
- E mais.

`dart:js_interop` e `dart:js_interop_unsafe` contêm esses auxiliares agora com
possivelmente sintaxe alternativa.

{% comment %}
TODO: adicionar links (com stable) quando pronto:
TODO: Link para a seção `package:web`
{% endcomment %}

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:html`]: {{site.dart-api}}/dart-html/dart-html-library.html
[`package:web`]: /interop/js-interop/package-web
[`dart:js`]: {{site.dart-api}}/dart-js/dart-js-library.html
[`object wrapper`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html
[`package:js`]: {{site.pub-pkg}}/js
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`@JS`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L11
[tutorial on mocking]: /interop/js-interop/mock
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[Wasm]: /web/wasm
