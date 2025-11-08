---
ia-translate: true
title: Começando com interoperabilidade JavaScript
breadcrumb: Primeiros passos
description: Um exemplo básico de uso de APIs do navegador e uma biblioteca JS empacotada.
---

Este tutorial ensina os conceitos básicos de interação com JavaScript
em código Dart usando várias APIs do navegador e JavaScript.

## Acessar e definir um objeto JavaScript

Para acessar um objeto JavaScript global, como o objeto
`document` do navegador, declare um getter externo de nível superior
anotado com `@JS`. Isso retorna o valor como um `JSObject` opaco.

```dart
import 'dart:js_interop';

// All top-level JS interop APIs need the @JS annotation.
@JS()
external JSObject get document;
```

Um `JSObject` é opaco e não fornece segurança de tipos ou autocompletar.
Para adicionar membros type-safe, defina um tipo de interoperabilidade usando um extension type.
Isso age como uma interface, permitindo que você declare mais APIs de interoperabilidade como
membros externos. Você pode definir um tipo de interoperabilidade usando
[extension types][] para visualizá-lo de forma diferente:

```dart
@JS()
external Document get document;

extension type Document._(JSObject _) implements JSObject {}
```

Agora, você pode adicionar métodos externos à sua interface `Document`. Por exemplo,
adicione o método de instância `createElement()`:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(JSString tag);
}
```

Com o método `createElement` definido, você pode chamá-lo no objeto
`document`. Note que você deve converter `'button'` de
um `String` para um `JSString` usando o método de extensão `.toJS`.

```dart
var button = document.createElement('button'.toJS);
```

Valores passados para e de APIs de interoperabilidade devem ser um
tipo de interoperabilidade (como `JSObject` ou `JSString`) ou um
primitivo Dart permitido.

## Usar conversões automáticas de tipos

O compilador converte automaticamente a maioria dos tipos primitivos Dart
(como `String`, `num`, `bool` e `null`), então você pode frequentemente
usá-los diretamente em assinaturas de interoperabilidade para simplificar seu código.

Por exemplo, você pode reescrever a declaração de `createElement`
da seção anterior para aceitar um `String` Dart diretamente.
Por exemplo:

```dart
external JSObject createElement(String tag);
```

Agora, você pode chamá-lo sem a conversão explícita `.toJS`.
Por exemplo:

```dart
var button = document.createElement('button');
```

Para adicionar o botão recém-criado ao corpo do documento, primeiro
defina tipos de interoperabilidade para o `body` e seu método `appendChild()`:

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

## Lidar com eventos e callbacks

Para lidar com interações do usuário, como um clique de botão,
você pode registrar um event listener usando `addEventListener()`.

Primeiro, crie uma interface para um elemento de botão. Então, chame
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
limitações de tipo que outras APIs de interoperabilidade, pois seus parâmetros
e valores de retorno devem ser tipos de interoperabilidade ou primitivos compatíveis.

## Trabalhar com Promises e Arrays

A interoperabilidade JavaScript fornece helpers para outros tipos comuns, como
converter JavaScript Promises para e de `Futures` Dart, e
`Arrays` para e de `Lists`.

### Promises e futures

Este exemplo usa a API `fetch`, que retorna uma `Promise`.
A extensão `.toDart` converte a `Promise` em uma `Future`,
então você pode usar `await` em seu resultado em Dart:

```dart
import 'dart:js_interop';

extension type Response._(JSObject _) implements JSObject {
  external bool get ok;
}

@JS()
external Response fetch(String resource);

void main() async {
  var response = await fetch('image.png').toDart;
  print(response.ok);
}
```

### Arrays e Lists

Este exemplo chama o método estático JavaScript `Array.of`
para criar um `JSArray`. Ele então converte o array em uma
`List` Dart, itera sobre ela e imprime cada elemento.

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

Ao converter um tipo genérico como uma `List`, seus elementos
devem já ser tipos de interoperabilidade JS. Por exemplo, para converter
uma `List<String>`, você deve primeiro converter cada `String`
em um `JSString`.

```dart
// Option 1: Create the list with JS types initially.
List<JSString> list = ['hello'.toJS, 'world'.toJS];
JSArray jsArray1 = list.toJS;

// Option 2: Map a Dart list to a list of JS types.
List<String> dartList = ['hello', 'world'];
JSArray jsArray2 = dartList.map((e) => e.toJS).toList().toJS;
```

## Saiba mais

* Para mais informações sobre conversões de tipos, confira [Conversions][].
* Para mais informações sobre como escrever APIs de interoperabilidade, veja o [Usage guide][].
* Para acessar funções utilitárias comuns, consulte:
  * A biblioteca [`dart:js_interop`][], e
  * A biblioteca [`dart:js_interop_unsafe`][].
* O [`package:web`][] expõe muitas das APIs do navegador
  (incluindo aquelas usadas nos exemplos acima) através de declarações de interoperabilidade.

[extension types]: /language/extension-types
[Conversions]: /interop/js-interop/js-types#conversions
[Usage guide]: /interop/js-interop/usage
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`package:web`]: /interop/js-interop/package-web
