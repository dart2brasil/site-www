---
ia-translate: true
title: Como simular objetos de interoperabilidade JavaScript
---

Neste tutorial, você aprenderá como simular (mockar) objetos JS para que possa testar membros de instâncias de interoperabilidade sem precisar usar uma implementação real.

## Contexto e motivação {:#background-and-motivation}

Simular classes em Dart geralmente é feito por meio da sobreposição de membros de instância. No entanto, como [tipos de extensão](extension types) são usados para declarar tipos de interoperabilidade, todos os membros do tipo de extensão são despachados estaticamente e, portanto, a sobreposição não pode ser usada. Essa [limitação também se aplica a membros de extensão](limitation is true for extension members), e, portanto, membros de tipo de extensão ou membros de extensão de instância não podem ser simulados.

Embora isso se aplique a qualquer membro de tipo de extensão não `external`, membros de interoperabilidade `external` são especiais, pois invocam membros em um valor JS.

```dart
extension type Date(JSObject _) implements JSObject {
  external int getDay();
}
```

Como discutido na seção [Uso](Usage), chamar `getDay()` resultará em uma chamada a `getDay()` no objeto JS. Portanto, usando um `JSObject` diferente, uma implementação diferente de `getDay` pode ser chamada.

Para fazer isso, deve haver algum mecanismo para criar um objeto JS que tenha uma propriedade `getDay` que, quando chamada, chame uma função Dart. Uma maneira simples é criar um objeto JS e definir a propriedade `getDay` como um callback convertido, por exemplo:

```dart
final date = Date(JSObject());
date['getDay'] = (() => 0).toJS;
```

Embora isso funcione, é propenso a erros e não escala bem quando você está usando muitos membros de interoperabilidade. Também não lida com getters ou setters corretamente. Em vez disso, você deve usar uma combinação de [`createJSInteropWrapper`] e [`@JSExport`] para declarar um tipo que forneça uma implementação para todos os membros de instância `external`.

## Exemplo de simulação {:#mocking-example}

```dart
import 'dart:js_interop';

import 'package:expect/minitest.dart';

// A classe Dart deve ter `@JSExport` nela ou em pelo menos um de seus membros de instância.
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
  // Retorna um objeto JS cujas propriedades chamam os membros de instância relevantes em
  // `fakeCounter`.
  var counter = createJSInteropWrapper<FakeCounter>(fakeCounter) as Counter;
  // Chama `FakeCounter.value`.
  expect(counter.value, 0);
  // `FakeCounter.renamedIncrement` é renomeado para `increment`, então ele é chamado.
  counter.increment();
  expect(counter.value, 1);
  expect(fakeCounter.value, 1);
  // Alterações no fake afetam o wrapper e vice-versa.
  fakeCounter.value = 0;
  expect(counter.value, 0);
  counter.decrement();
  // Como `Counter.decrement` é não `external`, nunca chamamos
  // `FakeCounter.decrement`.
  expect(counter.value, -2);
}
```

## [`@JSExport`] e [`createJSInteropWrapper`] {:#jsexport-and-createjsinteropwrapper}

`@JSExport` permite declarar uma classe que pode ser usada em `createJSInteropWrapper`. `createJSInteropWrapper` criará um objeto literal que mapeia cada um dos nomes dos membros de instância da classe (ou renomeia) para um callback JS, que é criado usando [`Function.toJS`]. Quando chamado, o callback JS, por sua vez, chamará o membro de instância. No exemplo acima, obter e definir `counter.value` obtém e define `fakeCounter.value`.

Você pode especificar apenas alguns membros de uma classe para serem exportados, omitindo a anotação da classe e, em vez disso, anotando apenas os membros específicos. Você pode ver mais detalhes sobre exportações mais especializadas (incluindo herança) na documentação de [`@JSExport`].

Observe que esse mecanismo não é específico apenas para testes. Você pode usá-lo para fornecer uma interface JS para um objeto Dart arbitrário, permitindo que você essencialmente *exporte* objetos Dart para JS com uma interface predefinida.

{% comment %}
TODO: Devemos adicionar uma seção sobre testes gerais? Não podemos realmente simular membros não instanciados, a menos que o usuário substitua explicitamente a API real em JS.
{% endcomment %}

[Uso]: /interop/js-interop/usage
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[limitation is true for extension members]: {{site.repo.dart.org}}/mockito/blob/master/FAQ.md#how-do-i-mock-an-extension-method
[extension types]: /language/extension-types

