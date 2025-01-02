---
ia-translate: true
title: Implementações JS Interop anteriores
description: Arquivo de implementações JS interop anteriores.
---

:::warning
Nenhuma dessas bibliotecas legacy de interop é suportada ao compilar para [Wasm][].
:::

Esta página aborda iterações anteriores de JS interop para Dart que são consideradas legado (herança). Elas ainda não estão depreciadas, mas provavelmente estarão no futuro. Portanto, prefira usar [`dart:js_interop`] daqui para frente e migre os usos de bibliotecas antigas de interop quando possível. Embora [`dart:html`] e outras bibliotecas web estejam intimamente relacionadas, elas são abordadas na página [`package:web`].

## `dart:js` {:#dart-js}

[`dart:js`] expunha um [`wrapper de objeto`] (envoltório de objeto) concreto para interoperabilidade com objetos JS. Este wrapper continha métodos baseados em String para obter, definir e chamar propriedades dinamicamente no objeto JS encapsulado. Era menos eficiente devido aos custos de encapsulamento e ergonomicamente mais difícil de usar. Por exemplo, você não obtinha conclusão de código, pois não conseguia declarar membros de interoperabilidade e, em vez disso, dependia de Strings. Muitas das funcionalidades expostas em `dart:js`, como [`allowInterop`], foram posteriormente reexpostas por meio de outras bibliotecas de interop.

Esta biblioteca é legado desde o lançamento de `package:js` e `dart:js_util`. Provavelmente será a primeira a ser depreciada.

## `package:js` {:#package-js}

[`package:js`] introduziu a funcionalidade para declarar tipos e membros de interop. Permitiu que os usuários escrevessem classes de interop em vez de tipos de extensão de interop. Em tempo de execução, essas classes eram apagadas para um tipo semelhante a [`JSObject`] de `dart:js_interop`.

```dart
@JS()
class JSType {}
```

Usuários de `package:js` encontrarão a sintaxe e a semântica de `dart:js_interop` familiares. Você poderá migrar para `dart:js_interop` substituindo a definição da classe por um tipo de extensão e fazendo-a funcionar em muitos casos.

No entanto, existem diferenças significativas:

- Tipos `package:js` não podiam ser usados para interoperar com APIs do navegador. Tipos `dart:js_interop` podem.
- `package:js` permitia despacho dinâmico. Isso significava que, se você convertesse o tipo `package:js` para `dynamic` e chamasse um membro de interop nele, ele seria encaminhado para o membro correto. Isso não é mais possível com `dart:js_interop`.
- [`@JS`] de `package:js` não possui garantias de segurança, pois os tipos de retorno dos membros `external` não eram verificados. `dart:js_interop` é seguro.
- Tipos `package:js` não podiam renomear membros de instância ou ter membros não `external`.
- Tipos `package:js` podiam ser subtipos e supertipos de classes não interop. Isso era frequentemente usado para mocks. Com `dart:js_interop`, a simulação é feita substituindo o objeto JS. Veja o [tutorial sobre mocks].
- Tipos [`@anonymous`] eram uma maneira de declarar um tipo de interop com um construtor literal de objeto. `dart:js_interop` não distingue tipos dessa maneira e qualquer construtor `external` com argumentos nomeados é um construtor literal de objeto.

### `@staticInterop` {:#staticinterop}

Juntamente com `@JS` e `@anonymous`, `package:js` expôs posteriormente [`@staticInterop`], que era um protótipo de tipos de extensão de interop. É tão expressivo e restritivo quanto `dart:js_interop` e destinava-se a ser uma sintaxe transitória até que os tipos de extensão estivessem disponíveis.

Tipos `@staticInterop` eram implicitamente apagados para `JSObject`. Exigia que os usuários declarassem todos os membros de instância em extensões para que apenas a semântica estática pudesse ser usada e tinha garantias de segurança mais fortes. Os usuários podiam usá-lo para interagir com APIs do navegador, e também permitia coisas como renomeação e membros não `external`. Como os tipos de extensão de interop, não tinha suporte para despacho dinâmico.

Classes `@staticInterop` quase sempre podem ser migradas para um tipo de extensão de interop simplesmente alterando a classe para um tipo de extensão e removendo as anotações.

`dart:js_interop` expôs `@staticInterop` (e `@anonymous`, mas apenas se `@staticInterop` também for usado) para dar suporte à semântica de interop estática até que os tipos de extensão fossem adicionados à linguagem. Todos esses tipos devem agora ser migrados para tipos de extensão.

## `dart:js_util` {:#dart-js-util}

[`dart:js_util`] fornecia várias funções utilitárias que não podiam ser declaradas em um tipo `package:js` ou eram necessárias para que os valores fossem passados para frente e para trás. Isso incluía membros como:

- `allowInterop` (que agora é [`Function.toJS`])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (que agora estão em [`dart:js_interop_unsafe`])
- Vários operadores JS
- Auxiliares de verificação de tipo
- Suporte a mocks
- E mais.

`dart:js_interop` e `dart:js_interop_unsafe` agora contêm esses auxiliares com sintaxe possivelmente alternativa.

{% comment %}
TODO: add links (with stable) when ready:
TODO: Link to `package:web` section
{% endcomment %}

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:html`]: {{site.dart-api}}/dart-html/dart-html-library.html
[`package:web`]: /interop/js-interop/package-web
[`dart:js`]: {{site.dart-api}}/dart-js/dart-js-library.html
[`wrapper de objeto`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html
[`package:js`]: {{site.pub-pkg}}/js
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`@JS`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L11
[tutorial sobre mocks]: /interop/js-interop/mock
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[Wasm]: /web/wasm

