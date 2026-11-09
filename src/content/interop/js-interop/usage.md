---
ia-translate: true
title: Uso da interop JS
breadcrumb: Uso
description: Como declarar e usar membros de interop JS.
prevpage:
  url: /interop/js-interop/
  title: Interop JS
nextpage:
  url: /interop/js-interop/js-types
  title: Tipos JS
---

A biblioteca `dart:js_interop` permite chamar APIs JavaScript e interagir com
valores JS usando sintaxe idiomática do Dart.
Para acessar uma API JavaScript a partir do Dart, exponha-a no [escopo global do JS][global JS scope] e
use os seguintes mecanismos:

- Declare [membros de interop `external`](#interop-members) para chamar APIs JS e
  receber valores JS.
- Use ou declare [tipos de interop](#interop-types) para fornecer tipos e
  interfaces do Dart para valores JS.
- Use [funções de conversão][conversion functions] para converter valores entre Dart e JS, a menos que uma
  assinatura de interop use [tipos primitivos permitidos][contains a primitive type].

[global JS scope]: https://developer.mozilla.org/docs/Glossary/Global_scope
[conversion functions]: /interop/js-interop/js-types#conversions
[contains a primitive type]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

## Tipos de interop {:#interop-types}

Ao interagir com um valor JS, você precisa fornecer um tipo Dart para ele.
Você pode fazer isso usando ou declarando um tipo de interop.
Tipos de interop são um [tipo JS][JS type] fornecido pelo Dart ou
um [extension type][extension type] que envolve um tipo de interop.

Tipos de interop permitem fornecer uma interface para um valor JS e
declarar APIs de interop para os membros dele.
Você também os usa nas assinaturas de outras APIs de interop:

```dart
extension type Window(JSObject _) implements JSObject {}
```

O extension type `Window` é um tipo de interop para uma instância arbitrária de
`JSObject`.
O compilador não oferece uma [garantia em tempo de execução][runtime guarantee] de que um valor `Window`
seja de fato um objeto [`Window`][] do JS,
e definir várias interfaces de interop para o mesmo valor JS subjacente
não causa conflito.
Se você quiser verificar se um valor `Window` é de fato um objeto `Window` do JS,
pode [verificar o tipo do valor JS por meio da interop][check the type of the JS value through interop].

Você também pode declarar seu próprio tipo de interop para os tipos JS que
o Dart fornece, envolvendo-os:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external Array();
}
```

Na maioria dos casos, declare um tipo de interop usando
o tipo `JSObject` como [tipo de representação][representation type] ao
interagir com objetos JS que não têm um tipo de interop fornecido pelo Dart.

Além disso, faça os tipos de interop [implementar][implement] o tipo de representação deles para que
você possa usá-los onde uma API espera o tipo de representação,
como em muitas APIs fornecidas pelo [`package:web`][`package:web`].

[JS type]: /interop/js-interop/js-types
[extension type]: /language/extension-types
[`Window`]: https://developer.mozilla.org/docs/Web/API/Window
[runtime guarantee]: /language/extension-types#type-considerations
[check the type of the JS value through interop]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[representation type]: /language/extension-types#declaration
[implement]: /language/extension-types#implements
[`package:web`]: {{site.pub-pkg}}/web

## Membros de interop {:#interop-members}

Membros de interop declarados com a palavra-chave [`external`][`external`] oferecem uma
sintaxe idiomática para membros JS, permitindo escrever uma assinatura de tipo Dart para
seus argumentos e valores de retorno.
O compilador impõe [restrições][restrictions] aos tipos que você pode usar na
assinatura desses membros.
A combinação de onde você declara um membro de interop, seu nome,
qual tipo de membro Dart ele é e quaisquer [renomeações](#js) determina
a qual API JS ele corresponde.

[`external`]: /language/functions#external
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

### Membros de interop de nível superior {:#top-level-interop-members}

Considere os seguintes membros JS:

```js
globalThis.name = 'global';
globalThis.isNameEmpty = function() {
  return globalThis.name.length == 0;
}
```

Você pode escrever membros de interop para eles, como mostrado no exemplo a seguir:

```dart
@JS()
external String get name;

@JS()
external set name(String value);

@JS()
external bool isNameEmpty();
```

Aqui, o escopo global expõe a propriedade `name` e a função `isNameEmpty`.
Para acessá-las, você usa membros de interop de nível superior.
Para obter e definir a propriedade `name`, declare e use
um getter e um setter de interop com o mesmo nome.
Para usar a função `isNameEmpty`, declare e chame
uma função de interop com o mesmo nome.
Você pode declarar getters, setters, métodos e campos de interop de nível superior.
Campos de interop são equivalentes a pares de getter e setter.

Declare membros de interop de nível superior com a anotação [`@JS()`](#js) para
distingui-los de outros membros `external` de nível superior,
como os que usam a biblioteca `dart:ffi`.

### Membros de tipos de interop {:#interop-type-members}

Considere a seguinte classe `Time` do JS:

```js
class Time {
  constructor(hours, minutes) {
    this._hours = Math.abs(hours) % 24;
    this._minutes = arguments.length == 1 ? 0 : Math.abs(minutes) % 60;
  }

  static dinnerTime = new Time(18, 0);

  static getTimeDifference(t1, t2) {
    return new Time(t1.hours - t2.hours, t1.minutes - t2.minutes);
  }

  get hours() {
    return this._hours;
  }

  set hours(value) {
    this._hours = Math.abs(value) % 24;
  }

  get minutes() {
    return this._minutes;
  }

  set minutes(value) {
    this._minutes = Math.abs(value) % 60;
  }

  isDinnerTime() {
    return this.hours == Time.dinnerTime.hours && this.minutes == Time.dinnerTime.minutes;
  }
}
// Need to expose the type to the global scope.
globalThis.Time = Time;
```

Você pode escrever uma interface de interop para a classe `Time`, como mostrado no
exemplo a seguir:

```dart
extension type Time._(JSObject _) implements JSObject {
  external Time(int hours, int minutes);
  external factory Time.onlyHours(int hours);

  external static Time dinnerTime;
  external static Time getTimeDifference(Time t1, Time t2);

  external int hours;
  external int minutes;
  external bool isDinnerTime();

  bool isMidnight() => hours == 0 && minutes == 0;
}
```

Dentro de um tipo de interop, você pode declarar vários tipos diferentes de
membros de interop `external`.

### Construtores {:#constructors}

Construtores posicionais criam um novo objeto JS chamando `new` no
nome JS do extension type:

```dart
final time = Time(0, 0); // Calls `new Time(0, 0)`
final midnight = Time.onlyHours(0); // Calls `new Time(0)`
```

Construtores sem nome, construtores nomeados e construtores `factory` com
parâmetros posicionais seguem a mesma semântica de invocação JS.

### Construtores de objeto literal {:#object-literal-constructors}

Para criar um [objeto literal][object literal] do JS com propriedades específicas, declare um
construtor (com ou sem a palavra-chave `factory`) que receba apenas parâmetros
nomeados correspondentes aos nomes das propriedades JS:

```dart
extension type Options._(JSObject o) implements JSObject {
  external Options({int a, int b});
  external int get a;
  external int get b;
}

final full = Options(a: 0, b: 1); // Creates `{a: 0, b: 1}`
final partial = Options(a: 0); // Creates `{a: 0}`
```

Apenas os argumentos que você passa são incluídos como propriedades no objeto JS
criado.
Você pode ler ou modificar essas propriedades por meio de membros de instância `external`.

:::note
Diferente do pacote legado `package:js`,
os construtores de object literal na biblioteca `dart:js_interop`
não usam as anotações `@anonymous` nem [`@JS()`](#js).
:::

### Membros estáticos {:#static-members}

Assim como os construtores, métodos `static`, getters, setters e campos usam o
nome JS do extension type:

```dart
final dinner = Time.dinnerTime; // Gets `Time.dinnerTime`
// Calls `Time.getTimeDifference(t1, t2)`
final diff = Time.getTimeDifference(t1, t2);
```

### Membros de instância {:#instance-members}

Métodos, getters, setters e campos de instância obtêm, definem ou invocam propriedades em
uma instância de objeto JS:

```dart
final time = Time(0, 0);
print(time.isDinnerTime()); // Calls `time.isDinnerTime()` -> false
final dinnerTime = Time.dinnerTime;
time.hours = dinnerTime.hours; // Gets `dinnerTime.hours` and sets `time.hours`
time.minutes = dinnerTime.minutes;
print(time.isDinnerTime()); // true
```

### Operadores {:#operators}

Tipos de interop suportam apenas dois operadores de interop `external`: `[]` e `[]=`,
que correspondem aos [acessadores de propriedade][property accessors] do JavaScript:

```dart
extension type Array(JSArray<JSNumber> _) implements JSArray<JSNumber> {
  external JSNumber operator [](int index);
  external void operator []=(int index, JSNumber value);
}

final first = array[0]; // Reads `array[0]`
array[0] = 42.toJS; // Sets `array[0] = 42`
```

A biblioteca `dart:js_interop` expõe outros operadores JS por meio de
[funções utilitárias][utility functions].

Tipos de interop também podem declarar [membros não-`external`][non-`external` members], como o
método `isMidnight` no exemplo de `Time`.

[object literal]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Object_initializer
[property accessors]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation
[utility functions]: {{site.dart-api}}/dart-js_interop/JSAnyOperatorExtension.html
[non-`external` members]: /language/extension-types#members

### Membros de extension em tipos de interop {:#extension-members-on-interop-types}

Você também pode escrever membros `external` em [extensions][extensions] de tipos de interop,
incluindo extensions sobre um parâmetro de tipo genérico limitado por um tipo de interop,
como mostrado no exemplo a seguir:

```dart
extension on Array {
  external int push(JSAny? any);
}

extension <T extends JSObject> on T {
  external T clone();
}
```

Chamar o método `push` se comporta da mesma forma que se você
o tivesse declarado diretamente no extension type `Array`.
De modo semelhante, chamar o método `clone` em qualquer subtipo do tipo `JSObject`
invoca o método `clone` do JS
e preserva o tipo estático `T` do receptor.
Extensions podem ter membros de instância e operadores `external`, mas
não podem ter membros `static` nem construtores `external`.
Assim como nos tipos de interop, você pode
escrever quaisquer membros não-`external` na extension.
Extensions são úteis quando um tipo de interop não
expõe o membro `external` de que você precisa e você não quer
criar um novo tipo de interop.

[extensions]: /language/extension-methods

### Parâmetros {:#parameters}

Um método `external` de interop pode conter apenas argumentos posicionais e opcionais.
Essa restrição existe porque membros JS recebem apenas argumentos posicionais.
A única exceção são os construtores de object literal,
que aceitam apenas argumentos nomeados.

Diferente dos métodos não-`external`, o compilador omite argumentos opcionais
em vez de substituí-los pelos valores padrão.
Por exemplo, considere o seguinte método:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Chamar `array.push(0.toJS)` no Dart resulta em
uma invocação JS de `array.push(0)`, e não de `array.push(0, null)`.
Esse comportamento evita a necessidade de escrever vários membros de interop para
a mesma API JS só para omitir argumentos `null`.
Se você declarar um parâmetro com um valor padrão explícito,
o compilador avisa que ele ignora esse valor.

## `@JS()` {:#js}

A anotação [`@JS()`][`@JS()`] informa ao compilador que uma declaração é
um membro ou tipo de interop JS e, opcionalmente, a renomeia ou a coloca em um namespace no JS:

- Em declarações de nível superior, a anotação `@JS()` é obrigatória (com ou sem um valor
  string) para distingui-las de outras declarações `external`,
  como as da biblioteca `dart:ffi`.
- Em tipos de interop e membros de extension, a anotação `@JS()` é opcional
  quando o nome no Dart é igual ao nome no JS, porque o compilador infere a
  interop JS a partir do tipo de representação ou do tipo `on`.

### Renomear membros e tipos de interop {:#rename-interop-members-and-types}

Passe uma string constante para a anotação `@JS()`
quando o nome no Dart precisar ser diferente do nome no JS.
Por exemplo, você pode sobrecarregar um método JS com várias assinaturas no Dart,
definir vários tipos de interop para a mesma interface JS,
ou vincular um identificador JS como `$a` que não é um nome válido no Dart:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

Os métodos `push` e `pushString` invocam `push` no JS.

Você também pode renomear um tipo de interop:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate(); // Calls `new Date()`
  external static int now(); // Calls `Date.now()`
}
```

Como os construtores sempre invocam o nome JS do extension type que os contém,
você não pode colocar uma anotação `@JS()` em um construtor ou factory `external`
de um extension type de interop.
Anote a declaração do extension type.

### Colocar uma biblioteca em um namespace {:#namespace-a-library}

Coloque a anotação `@JS()` em uma diretiva `library` para adicionar um prefixo de namespace a todos os
membros de interop de nível superior, tipos de interop e membros `static` de interop
nessa biblioteca.
Você também pode usar namespaces separados por `.` em bibliotecas, membros de
nível superior e tipos de interop:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method(); // Calls `library1.library2.library3.method()`

@JS('library3.JSType')
extension type JSType._(JSObject _) implements JSObject {
  // Calls `new library1.library2.library3.JSType()`
  external JSType();
  // Gets `library1.library2.library3.JSType.staticMember`
  external static int get staticMember;
}
```

Tenha em mente estas regras de namespace:

- Um nome de `library` do Dart (como `library interop_library;`) nunca é usado como
  namespace do JS, a menos que você forneça uma string não vazia em `@JS('...')`.
- Você também pode usar nomes separados por `.` nas anotações `@JS()` de membros de
  tipos de interop e de membros de extension.
- Se você omitir o valor em `@JS()` ou passar uma string vazia, o compilador usa
  o nome Dart da declaração.

[`@JS()`]: {{site.dart-api}}/dart-js_interop/JS-class.html

<a id="exporting-dart-functions-and-objects-to-js" aria-hidden="true"></a>
## Exportar funções e objetos do Dart para o JS {:#export}

As seções anteriores mostram como chamar membros JS a partir do Dart.
Também é útil exportar código Dart para que você possa chamá-lo a partir do JS.
Para exportar uma função Dart para o JS, primeiro converta-a usando o
getter [`Function.toJS`][`Function.toJS`] (que também converte qualquer `Future` retornado em um
`JSPromise`), ou usando o getter `toJSVarArgs` para callbacks variádicos síncronos.
Depois, passe a função encapsulada para o JS por meio de um membro de interop.
A partir daí, o código JS pode chamar a função.

Por exemplo, o código a seguir exporta funções Dart síncronas, assíncronas e variádicas
para propriedades globais do JS e as chama a partir do JS:

```dart
import 'dart:js_interop';

@JS()
external set exportedFunction(JSFunction value);

@JS()
external set asyncFunction(JSFunction value);

@JS()
external set joinAll(JSFunction value);

void printString(JSString string) {
  print(string.toDart);
}

Future<JSString> fetchGreeting(JSString name) async =>
    'Hello, ${name.toDart}!'.toJS;

JSString joinArgs(JSArray<JSString> args) =>
    args.toDartStringList.join(', ').toJS;

void main() {
  exportedFunction = printString.toJS;
  asyncFunction = fetchGreeting.toJS;
  joinAll = joinArgs.toJSVarArgs;
}
```

```js
globalThis.exportedFunction('hello world');
await globalThis.asyncFunction('Dash');
globalThis.joinAll('a', 'b', 'c'); // 'a, b, c'
```

Funções exportadas dessa forma têm [restrições][restrictions] de tipo semelhantes
às dos membros de interop.

Às vezes, é útil exportar uma interface Dart inteira para que
o JS possa interagir com um objeto Dart.
Para isso, marque a classe Dart como exportável usando a anotação [`@JSExport`][`@JSExport`]
e envolva instâncias dessa classe usando a função [`createJSInteropWrapper`][`createJSInteropWrapper`].
Para uma explicação mais detalhada dessa técnica, incluindo como
fazer mock de valores JS, consulte [Como fazer mock de objetos de interop JavaScript][How to mock JavaScript interop objects].

[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[How to mock JavaScript interop objects]: /interop/js-interop/mock

## `dart:js_interop` e `dart:js_interop_unsafe` {:#dart-js_interop-and-dart-js_interop_unsafe}

A biblioteca [`dart:js_interop`][`dart:js_interop`] contém os membros principais de que você precisa,
incluindo a anotação `@JS()`, os tipos JS, as funções de conversão e várias
funções utilitárias.
As funções utilitárias incluem:

- [`globalContext`][`globalContext`]: representa o escopo global que
  os compiladores usam para encontrar membros e tipos de interop.
- [Helpers para inspecionar o tipo de valores JS][Helpers to inspect the type of JS values]: examinam o
  valor JavaScript subjacente de um tipo de interop.
- [Operadores JS][utility functions]: expõem operadores JavaScript como membros utilitários.
- [`dartify`][`dartify`] e [`jsify`][`jsify`]: verificam o tipo de certos valores JS e
  os convertem de valores JS para valores Dart ou de valores Dart para valores JS.
  Prefira usar a conversão específica quando você souber o tipo do valor JS,
  pois a verificação extra de tipo pode ser custosa.
- [`importModule`][`importModule`]: importa módulos dinamicamente como uma instância de `JSObject`.
- [`isA`][`isA`]: verifica se um valor de interop JS é
  uma instância do tipo JS especificado pelo argumento de tipo.
- `jsIdentical`: verifica se dois valores JS são idênticos
  usando a semântica de igualdade estrita `===` do JavaScript.

A biblioteca [`dart:js_interop_unsafe`][`dart:js_interop_unsafe`] contém membros que permitem
buscar propriedades dinamicamente.
Por exemplo, você pode acessar a propriedade `log` de `console` usando uma string:

```dart
JSFunction f = console['log'] as JSFunction;
```

Em vez de declarar um membro de interop chamado `log`,
você pode usar uma string para acessar a propriedade.
A biblioteca `dart:js_interop_unsafe` também fornece funções para
verificar, obter, definir e chamar propriedades dinamicamente.

:::tip
Evite usar `dart:js_interop_unsafe` quando possível.
Ele dificulta garantir a conformidade com requisitos de segurança e
pode levar a violações, e por isso pode ser "unsafe".
:::

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`globalContext`]: {{site.dart-api}}/dart-js_interop/globalContext.html
[Helpers to inspect the type of JS values]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension.html
[`dartify`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/dartify.html
[`jsify`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/jsify.html
[`importModule`]: {{site.dart-api}}/dart-js_interop/importModule.html
[`isA`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/isA.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
