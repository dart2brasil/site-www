---
title: Como fazer mock de objetos de interop JavaScript
shortTitle: Mock de objetos JS interop
description: Aprenda como fazer mock de objetos JS interop em Dart para testes.
ia-translate: true
---

Neste tutorial, você aprenderá como fazer mock de objetos JS para que possa testar
membros de instância interop sem precisar usar uma implementação real.

## Contexto e motivação

Fazer mock de classes em Dart geralmente é feito através de sobrescrita de membros de instância.
No entanto, como [extension types] são usados para declarar tipos interop, todos os
membros de extension type são despachados estaticamente e, portanto, a sobrescrita não pode
ser usada. Essa [limitação também é verdadeira para membros de extension][limitation is true for extension members], e portanto
membros de extension type ou extension de instância não podem ter mock feito.

Embora isso se aplique a qualquer membro de extension type não-`external`, membros
interop `external` são especiais, pois invocam membros em um valor JS.

```dart
extension type Date(JSObject _) implements JSObject {
  external int getDay();
}
```

Como discutido na seção [Uso][Usage], chamar `getDay()` resultará em chamar
`getDay()` no objeto JS. Portanto, ao usar um `JSObject` diferente, uma
*implementação* diferente de `getDay` pode ser chamada.

Para fazer isso, deve haver algum mecanismo de criar um objeto JS que
tenha uma propriedade `getDay` que quando chamada, chame uma função Dart. Uma maneira simples
é criar um objeto JS e definir a propriedade `getDay` para um callback convertido
por exemplo

```dart
final date = Date(JSObject());
date['getDay'] = (() => 0).toJS;
```

Embora isso funcione, é propenso a erros e não escala bem quando você está
usando muitos membros interop. Também não lida com getters ou setters adequadamente.
Em vez disso, você deve usar uma combinação de [`createJSInteropWrapper`] e
[`@JSExport`] para declarar um tipo que fornece uma implementação para todos os
membros de instância `external`.

## Exemplo de mocking

```dart
import 'dart:js_interop';

import 'package:expect/minitest.dart';

// The Dart class must have `@JSExport` on it or at least one of its instance
// members.
@JSExport()
class FakeCounter {
  int value = 0;
  @JSExport('increment')
  void renamedIncrement() {
    value++;
  }
  void decrement() {
    value--;
  }
}

extension type Counter(JSObject _) implements JSObject {
  external int value;
  external void increment();
  void decrement() {
    value -= 2;
  }
}

void main() {
  var fakeCounter = FakeCounter();
  // Returns a JS object whose properties call the relevant instance members in
  // `fakeCounter`.
  var counter = createJSInteropWrapper<FakeCounter>(fakeCounter) as Counter;
  // Calls `FakeCounter.value`.
  expect(counter.value, 0);
  // `FakeCounter.renamedIncrement` is renamed to `increment`, so it gets
  // called.
  counter.increment();
  expect(counter.value, 1);
  expect(fakeCounter.value, 1);
   // Changes in the fake affect the wrapper and vice-versa.
  fakeCounter.value = 0;
  expect(counter.value, 0);
  counter.decrement();
  // Because `Counter.decrement` is non-`external`, we never called
  // `FakeCounter.decrement`.
  expect(counter.value, -2);
}
```

## [`@JSExport`] e [`createJSInteropWrapper`]

`@JSExport` permite que você declare uma classe que pode ser usada em
`createJSInteropWrapper`. `createJSInteropWrapper` criará um object literal
que mapeia cada um dos nomes de membros de instância da classe (ou renomeações) para um
callback JS, que é criado usando [`Function.toJS`]. Quando chamado, o callback JS
por sua vez chamará o membro de instância. No exemplo acima, obter e definir
`counter.value` obtém e define `fakeCounter.value`.

Você pode especificar apenas alguns membros de uma classe para serem exportados omitindo a
anotação da classe e em vez disso anotar apenas os membros específicos. Você
pode ver mais especificidades sobre exportação mais especializada (incluindo herança) na
documentação de [`@JSExport`].

Note que este mecanismo não é específico apenas para testes. Você pode usar isso para
fornecer uma interface JS para um objeto Dart arbitrário, permitindo que você essencialmente
*exporte* objetos Dart para JS com uma interface predefinida.

{% comment %}
TODO: Should we add a section on general testing? We can't really mock
non-instance members unless the user explicitly replaces the real API in JS.
{% endcomment %}

[Usage]: /interop/js-interop/usage
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[limitation is true for extension members]: {{site.repo.dart.org}}/mockito/blob/master/FAQ.md#how-do-i-mock-an-extension-method
[extension types]: /language/extension-types
