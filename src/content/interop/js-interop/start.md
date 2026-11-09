---
ia-translate: true
title: Começando com interop JavaScript
breadcrumb: Começando
description: Um exemplo básico de uso de APIs do navegador e de uma biblioteca JS empacotada.
---

Este tutorial ensina o básico de interagir com JavaScript
em código Dart usando várias APIs do navegador e do JavaScript.

## Acessar e definir um objeto JavaScript {:#access-and-define-a-javascript-object}

Para acessar um objeto global do JavaScript, como o objeto
`document` do navegador, declare um getter external de nível superior
anotado com `@JS`. Isso retorna o valor como um `JSObject` opaco.

```dart
import 'dart:js_interop';

// All top-level JS interop APIs need the @JS annotation.
@JS()
external JSObject get document;
```

Um `JSObject` é opaco e não oferece segurança de tipos nem auto-completar.
Para adicionar membros com tipagem segura, defina um tipo de interop usando um extension type.
Ele funciona como uma interface, permitindo que você declare mais APIs de interop como
membros external. Você pode definir um tipo de interop usando
[extension types][] para visualizá-lo de outra forma:

```dart
@JS()
external Document get document;

extension type Document._(JSObject _) implements JSObject {}
```

Agora você pode adicionar métodos external à sua interface `Document`. Por exemplo,
adicione o método de instância `createElement()`:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(JSString tag);
}
```

Com o método `createElement` definido, você pode chamá-lo no
objeto `document`. Observe que você precisa converter `'button'` de
uma `String` para uma `JSString` usando o método de extensão `.toJS`.

```dart
var button = document.createElement('button'.toJS);
```

Os valores passados para APIs de interop e recebidos delas precisam ser
um tipo de interop (como `JSObject` ou `JSString`) ou um
primitivo Dart permitido.

## Usar conversões automáticas de tipo {:#use-automatic-type-conversions}

O compilador converte automaticamente a maioria dos tipos primitivos do Dart
(como `String`, `num`, `bool` e `null`), então você pode usá-los
diretamente nas assinaturas de interop para simplificar o código.

Por exemplo, você pode reescrever a declaração `createElement`
da seção anterior para aceitar uma `String` do Dart diretamente:

```dart
external JSObject createElement(String tag);
```

Agora você pode chamá-lo sem a conversão explícita `.toJS`:

```dart
var button = document.createElement('button');
```

Para adicionar o botão recém-criado ao corpo do documento, primeiro
defina tipos de interop para o `body` e para o seu método `appendChild()`:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(String tag);
  external Body get body;
}

extension type Body._(JSObject _) implements JSObject {
  external JSObject appendChild(JSObject child);
}
```

Com essas definições, você pode criar um botão e adicioná-lo à
página:

```dart
var button = document.createElement('button');
document.body.appendChild(button);
```

## Lidar com eventos e callbacks {:#handle-events-and-callbacks}

Para tratar interações do usuário, como um clique em um botão,
você pode registrar um event listener usando `addEventListener()`.

Primeiro, crie uma interface para um elemento button. Depois, chame
`addEventListener` com o nome do evento e uma função de callback.

```dart
extension type ButtonElement(JSObject _) implements JSObject {
  external void addEventListener(String event, JSFunction listener);
}
```

```dart
var button = ButtonElement(document.createElement('button'));
document.body.appendChild(button);
button.addEventListener('click', (JSObject event) {
  print('Clicked!');
}.toJS);
```

Callbacks convertidos para JS com `.toJS` têm as mesmas
limitações de tipo que as outras APIs de interop: seus parâmetros
e valores de retorno devem ser tipos de interop ou primitivos compatíveis.

## Criar um objeto literal do JavaScript {:#create-a-javascript-object-literal}

Muitas APIs do JavaScript aceitam objetos literais simples (`{ key: 'value' }`)
como opções de configuração.
Para criar um objeto literal do JavaScript em Dart,
declare um construtor `external` com parâmetros nomeados em um extension type,
em que o nome de cada parâmetro corresponde ao nome de uma propriedade do JavaScript:

```dart
extension type RequestOptions._(JSObject _) implements JSObject {
  external RequestOptions({String method, bool cache});
}
```

Chamar esse construtor cria um objeto JavaScript contendo
apenas os argumentos que você passou,
que podem ser enviados diretamente para qualquer API de interop:

```dart
@JS()
external JSPromise<JSObject> fetch(String resource, [RequestOptions options]);

void main() {
  // Creates the JS object `{method: 'POST'}` and passes it to `fetch()`.
  var options = RequestOptions(method: 'POST');
  fetch('data.json', options);
}
```

Para saber mais, consulte [Construtores de objeto literal][Object literal constructors] no guia de uso.

## Trabalhar com Promises e Arrays {:#work-with-promises-and-arrays}

A interop com JavaScript oferece helpers para outros tipos comuns, como
converter Promises do JavaScript de e para `Futures` do Dart, e
`Arrays` de e para `Lists`.

### Promises e futures {:#promises-and-futures}

Este exemplo usa a API `fetch`, que retorna uma `Promise`.
A extensão `.toDart` converte a `Promise` em uma `Future`,
então você pode usar `await` no resultado em Dart:

```dart
import 'dart:js_interop';

extension type Response._(JSObject _) implements JSObject {
  external bool get ok;
}

@JS()
external JSPromise<Response> fetch(String resource);

void main() async {
  var response = await fetch('image.png').toDart;
  print(response.ok);
}
```

### Arrays e Lists {:#arrays-and-lists}

Este exemplo chama o método estático `Array.of` do JavaScript
para criar um `JSArray`. Em seguida, converte o array para uma
`List` do Dart, percorre a lista e imprime cada elemento.

```dart
import 'dart:js_interop';

@JS('Array.of')
external JSArray<JSString> arrayOf(String a, String b);

void main() {
  var array = arrayOf('hello', 'world');
  var list = array.toDart;
  for (var element in list) {
    print(element.toDart);
  }
}
```

Você pode converter uma `List` de primitivos (`num`, `int`, `double`, `bool` ou
`String`) diretamente para uma instância de `JSArray` usando o getter `toJS`,
e converter de volta para uma lista do Dart usando os getters `toDartStringList`
(ou `toDartIntList`, `toDartDoubleList` ou `toDartBoolList`).
Para listas de outros tipos, os elementos precisam ser
tipos de interop do JS antes de você converter a lista:

```dart
// Primitive lists convert directly to and from JSArray.
List<String> dartList = ['hello', 'world'];
JSArray<JSString> jsArray1 = dartList.toJS;
List<String> roundTrip = jsArray1.toDartStringList;

// Non-primitive lists require elements to be JS interop types.
List<JSObject> jsObjects = [document, document.body];
JSArray<JSObject> jsArray2 = jsObjects.toJS;
```

## Saiba mais {:#learn-more}

* Para mais informações sobre conversões de tipos, confira [Conversões][Conversions].
* Para mais informações sobre como escrever APIs de interop, consulte o
  [Guia de uso][Usage guide].
* Para acessar funções utilitárias comuns, consulte:
  * A biblioteca [`dart:js_interop`][], e
  * A biblioteca [`dart:js_interop_unsafe`][].
* O [`package:web`][] expõe muitas das APIs do navegador
  (incluindo as usadas nos exemplos acima) por meio de declarações de interop.

[extension types]: /language/extension-types
[Object literal constructors]: /interop/js-interop/usage#object-literal-constructors
[Conversions]: /interop/js-interop/js-types#conversions
[Usage guide]: /interop/js-interop/usage
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`package:web`]: /interop/js-interop/package-web
