---
ia-translate: true
title: Uso
description: Como declarar e usar membros de interoperabilidade JS.
---

A interoperabilidade JS fornece os mecanismos para interagir com APIs
JavaScript a partir do Dart.
Ela permite que você invoque essas APIs e interaja com os valores que você
obtém delas usando uma sintaxe explícita e idiomática.

Normalmente, você acessa uma API JavaScript disponibilizando-a em algum lugar
dentro do [escopo global JS]. Para chamar e receber valores JS dessa API,
você usa [`external` membros de interoperabilidade](#membros-de-interoperabilidade).
Para construir e fornecer tipos para valores JS, você usa e declara
[tipos de interoperabilidade](#tipos-de-interoperabilidade), que também
contêm membros de interoperabilidade. Para passar valores Dart como `List`s
ou `Function` para membros de interoperabilidade ou converter valores JS para
valores Dart, você usa [funções de conversão], a menos que o membro de
interoperabilidade [contenha um tipo primitivo].

## Tipos de interoperabilidade

Ao interagir com um valor JS, você precisa fornecer um tipo Dart para ele. Você
pode fazer isso usando ou declarando um tipo de interoperabilidade.
Tipos de interoperabilidade são ou um ["tipo JS"] fornecido pelo Dart ou um
[tipo de extensão] envolvendo um tipo de interoperabilidade.

Os tipos de interoperabilidade permitem que você forneça uma interface para um
valor JS e permitem que você declare APIs de interoperabilidade para seus
membros. Eles também são usados ​​na assinatura de outras APIs de
interoperabilidade.

```dart
extension type Window(JSObject _) implements JSObject {}
```

`Window` é um tipo de interoperabilidade para um `JSObject` arbitrário. Não há
[garantia de tempo de execução][runtime
guarantee] de que `Window` seja realmente um [`Window`] JS. Também não há
conflito com qualquer outra interface de interoperabilidade que seja definida
para o mesmo valor. Se você quiser verificar se `Window` é realmente um `Window`
JS, você pode [verificar o tipo do valor JS por meio da
interoperabilidade].

Você também pode declarar seu próprio tipo de interoperabilidade para os tipos
JS que o Dart fornece, envolvendo-os:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external Array();
}
```

Na maioria dos casos, você provavelmente declarará um tipo de interoperabilidade
usando `JSObject` como o [tipo de representação] porque você provavelmente
está interagindo com objetos JS que não possuem um tipo de interoperabilidade
fornecido pelo Dart.

Os tipos de interoperabilidade também devem geralmente [implementar] seu tipo de
representação para que possam ser usados ​​onde o tipo de representação é
esperado, como em muitas APIs em [`package:web`].

## Membros de interoperabilidade

Os membros de interoperabilidade [`external`] fornecem uma sintaxe idiomática
para membros JS. Eles permitem que você escreva uma assinatura de tipo Dart para
seus argumentos e valor de retorno. Os tipos que podem ser escritos na
assinatura desses membros têm [restrições]. A API JS à qual o membro de
interoperabilidade corresponde é determinada por uma combinação de onde ele é
declarado, seu nome, que tipo de membro Dart ele é e quaisquer
[renomeações](#js).

### Membros de interoperabilidade de nível superior

Dados os seguintes membros JS:

```js
globalThis.name = 'global';
globalThis.isNameEmpty = function() {
  return globalThis.name.length == 0;
}
```

Você pode escrever membros de interoperabilidade para eles assim:

```dart
@JS()
external String get name;

@JS()
external set name(String value);

@JS()
external bool isNameEmpty();
```

Aqui, existe uma propriedade `name` e uma função `isNameEmpty` que são expostas
no escopo global. Para acessá-los, você usa membros de interoperabilidade de
nível superior. Para obter e definir `name`, você declara e usa um getter e
setter de interoperabilidade com o mesmo nome. Para usar `isNameEmpty`, você
declara e chama uma função de interoperabilidade com o mesmo nome. Você pode
declarar getters, setters, métodos e campos de interoperabilidade de nível
superior. Os campos de interoperabilidade são equivalentes a pares de getter e
setter.

Os membros de interoperabilidade de nível superior devem ser declarados com uma
anotação [`@JS()`](#js) para distingui-los de outros membros de nível superior
`external`, como aqueles que podem ser escritos usando `dart:ffi`.

### Membros de tipo de interoperabilidade

Dada uma interface JS como a seguinte:

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

Você pode escrever uma interface de interoperabilidade para ela assim:

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

Dentro de um tipo de interoperabilidade, você pode declarar vários tipos
diferentes de membros de interoperabilidade `external`:

- **Construtores**. Quando chamados, os construtores com apenas parâmetros
  posicionais criam um novo objeto JS cujo construtor é definido pelo nome do
  tipo de extensão usando `new`. Por exemplo, chamar `Time(0, 0)` no Dart irá
  gerar uma invocação JS que se parece com `new Time(0, 0)`. Da mesma forma,
  chamar `Time.onlyHours(0)` irá gerar uma invocação JS que se parece com
  `new Time(0)`. Observe que as invocações JS dos dois construtores seguem a
  mesma semântica, independentemente de receberem um nome Dart ou se forem uma
  factory.

  - **Construtores de literal de objeto**. Às vezes é útil criar um [literal
    de objeto] JS que simplesmente contém um número de propriedades e seus
    valores. Para fazer isso, você declara um construtor com apenas parâmetros
    nomeados, onde os nomes dos parâmetros serão os nomes das propriedades:

    ```dart
    extension type Options._(JSObject o) implements JSObject {
      external Options({int a, int b});
      external int get a;
      external int get b;
    }
    ```

    Uma chamada para `Options(a: 0, b: 1)` resultará na criação do objeto JS
    `{a: 0, b: 1}`. O objeto é definido pelos argumentos de invocação, então
    chamar `Options(a: 0)` resultaria em `{a: 0}`. Você pode obter ou definir as
    propriedades do objeto por meio de membros de instância `external`.

    :::warning
    Antes do Dart 3.3.1, os construtores de literal de objeto exigiam uma
    anotação [`@JS`](#js) na biblioteca para compilar.
    Para saber mais, confira [`dart-lang/sdk#54801`][54801].
    :::

- **Membros `static`**. Como os construtores, esses membros usam o nome do tipo
  de extensão para gerar o código JS. Por exemplo, chamar
  `Time.getTimeDifference(t1, t2)` irá gerar uma invocação JS que se parece com
  `Time.getTimeDifference(t1, t2)`. Da mesma forma, chamar `Time.dinnerTime`
  resultará em uma invocação JS que se parece com `Time.dinnerTime`. Como os
  níveis superiores, você pode declarar métodos `static`, getters, setters e
  campos.

- **Membros de instância**. Como em outros tipos Dart, esses membros requerem
  uma instância para serem usados. Esses membros obtêm, definem ou invocam
  propriedades na instância. Por exemplo:

  ```dart
    final time = Time(0, 0);
    print(time.isDinnerTime()); // false
    final dinnerTime = Time.dinnerTime;
    time.hours = dinnerTime.hours;
    time.minutes = dinnerTime.minutes;
    print(time.isDinnerTime()); // true
  ```

  A chamada para `dinnerTime.hours` obtém o valor da propriedade `hours` de
  `dinnerTime`. Da mesma forma, a chamada para `time.minutes=` define o valor da
  propriedade `minutes` de time. A chamada para `time.isDinnerTime()` chama a
  função na propriedade `isDinnerTime` de `time` e retorna o valor.
  Como os níveis superiores e membros `static`, você pode declarar métodos de
  instância, getters, setters e campos.

- **Operadores**. Existem apenas dois operadores de interoperabilidade
  `external` permitidos em tipos de interoperabilidade: `[]` e `[]=`. Estes são
  membros de instância que correspondem à semântica dos [acessores de
  propriedade] JS. Por exemplo, você pode declará-los como:

  ```dart
  extension type Array(JSArray<JSNumber> _) implements JSArray<JSNumber> {
    external JSNumber operator [](int index);
    external void operator []=(int index, JSNumber value);
  }
  ```

  Chamar `array[i]` obtém o valor no `i`ésimo slot de `array`, e
  `array[i] = i.toJS` define o valor nesse slot para `i.toJS`. Outros operadores
  JS são expostos por meio de [funções utilitárias] em `dart:js_interop`.

Por fim, como qualquer outro tipo de extensão, você pode declarar quaisquer
[membros não `external`] no tipo de interoperabilidade. `isMidnight` é um desses
exemplos.

### Membros de extensão em tipos de interoperabilidade

Você também pode escrever membros `external` em [extensões] de tipos de
interoperabilidade. Por exemplo:

```dart
extension on Array {
  external int push(JSAny? any);
}
```

A semântica de chamar `push` é idêntica ao que seria se estivesse na definição
de `Array`. As extensões podem ter membros de instância `external` e operadores,
mas não podem ter membros `static` `external` ou construtores. Como nos tipos de
interoperabilidade, você pode escrever quaisquer membros não `external` na
extensão. Essas extensões são úteis para quando um tipo de interoperabilidade
não expõe o membro `external` de que você precisa e você não deseja criar um
novo tipo de interoperabilidade.

### Parâmetros

Os métodos de interoperabilidade `external` só podem conter argumentos
posicionais e opcionais. Isso ocorre porque os membros JS só aceitam argumentos
posicionais. A única exceção são os construtores de literal de objeto, onde eles
podem conter apenas argumentos nomeados.

Ao contrário dos métodos não `external`, os argumentos opcionais não são
substituídos por seu valor padrão, mas são omitidos. Por exemplo:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Chamar `array.push(0.toJS)` no Dart resultará em uma invocação JS de
`array.push(0.toJS)` e *não* `array.push(0.toJS, null)`. Isso permite que os
usuários não precisem escrever vários membros de interoperabilidade para a mesma
API JS para evitar passar `null`s. Se você declarar um parâmetro com um valor
padrão explícito, receberá um aviso de que o valor será ignorado.

## `@JS()`

Às vezes é útil referir-se a uma propriedade JS com um nome diferente do que foi
escrito. Por exemplo, se você quiser escrever duas APIs `external` que apontam
para a mesma propriedade JS, você precisaria escrever um nome diferente para
pelo menos uma delas. Da mesma forma, se você quiser definir vários tipos de
interoperabilidade que se referem à mesma interface JS, você precisa renomear
pelo menos um deles. Outro exemplo é se o nome JS não puder ser escrito em Dart,
por exemplo, `$a`.

Para fazer isso, você pode usar a anotação [`@JS()`] com um valor de string
constante. Por exemplo:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

Chamar `push` ou `pushString` resultará em código JS que usa `push`.

Você também pode renomear tipos de interoperabilidade:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate();

  external static int now();
}
```

Chamar `JSDate()` resultará em uma invocação JS de `new Date()`. Da mesma
forma, chamar `JSDate.now()` resultará em uma invocação JS de `Date.now()`.

Além disso, você pode adicionar um namespace a uma biblioteca inteira, o que
adicionará um prefixo a todos os membros de interoperabilidade de nível
superior, tipos de interoperabilidade e membros de interoperabilidade
`static` dentro desses tipos. Isso é útil se você quiser evitar adicionar muitos
membros ao escopo global JS.

```dart
@JS('library1')
library;

import 'dart:js_interop';

@JS()
external void method();

extension type JSType._(JSObject _) implements JSObject {
  external JSType();

  external static int get staticMember;
}
```

Chamar `method()` resultará em uma invocação JS de `library1.method()`, chamar
`JSType()` resultará em uma invocação JS de `new library1.JSType()`, e chamar
`JSType.staticMember` resultará em uma invocação JS de
`library1.JSType.staticMember`.

Ao contrário dos membros de interoperabilidade e tipos de interoperabilidade, o
Dart só adiciona um nome de biblioteca na invocação JS se você fornecer um valor
não vazio na anotação `@JS()` na biblioteca. Ele não usa o nome Dart da
biblioteca como padrão.

```dart
library interop_library;

import 'dart:js_interop';

@JS()
external void method();
```

Chamar `method()` resultará em uma invocação JS de `method()` e não
`interop_library.method()`.

Você também pode escrever vários namespaces delimitados por um `.` para
bibliotecas, membros de nível superior e tipos de interoperabilidade:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method();

@JS('library3.JSType')
extension type JSType._(JSObject _) implements JSObject {
  external JSType();
}
```

Chamar `method()` resultará em uma invocação JS de
`library1.library2.library3.method()`, chamar `JSType()` resultará em uma
invocação JS de `new library1.library2.library3.JSType()`, e assim por diante.

Você não pode usar anotações `@JS()` com `.` no valor em membros de tipo de
interoperabilidade ou membros de extensão de tipos de interoperabilidade, no
entanto.

Se não houver valor fornecido para `@JS()` ou o valor estiver vazio, nenhuma
renomeação ocorrerá.

`@JS()` também informa ao compilador que um membro ou tipo deve ser tratado como
um membro ou tipo de interoperabilidade JS. É necessário (com ou sem um valor)
para todos os membros de nível superior para distingui-los de outros membros de
nível superior `external`, mas muitas vezes pode ser omitido em e dentro de
tipos de interoperabilidade e em membros de extensão, pois o compilador pode
dizer que é um tipo de interoperabilidade JS a partir do tipo de representação e
do tipo.

<a id="exporting-dart-functions-and-objects-to-js" aria-hidden="true"></a>
## Exportar funções e objetos Dart para JS {:#export}

As seções acima mostram como chamar membros JS do Dart. Também é útil *exportar*
o código Dart para que ele possa ser usado em JS. Para exportar uma função Dart
para JS, primeiro converta-a usando [`Function.toJS`], que envolve a função Dart
com uma função JS. Em seguida, passe a função envolvida para JS por meio de um
membro de interoperabilidade. Nesse ponto, ela está pronta para ser chamada por
outro código JS.

Por exemplo, este código converte uma função Dart e usa interoperabilidade para
defini-la em uma propriedade global, que é então chamada em JS:

```dart
import 'dart:js_interop';

@JS()
external set exportedFunction(JSFunction value);

void printString(JSString string) {
  print(string.toDart);
}

void main() {
  exportedFunction = printString.toJS;
}
```

```js
globalThis.exportedFunction('hello world');
```

As funções que são exportadas dessa forma têm [restrições] de tipo semelhantes às
dos membros de interoperabilidade.

Às vezes é útil exportar uma interface Dart inteira para que o JS possa
interagir com um objeto Dart. Para fazer isso, marque a classe Dart como
exportável usando [`@JSExport`] e envolva as instâncias dessa classe usando
[`createJSInteropWrapper`]. Para uma explicação mais detalhada dessa técnica,
incluindo como simular valores JS, consulte o [tutorial de simulação].

## `dart:js_interop` e `dart:js_interop_unsafe`

[`dart:js_interop`] contém todos os membros necessários que você deve precisar,
incluindo `@JS`, tipos JS, funções de conversão e várias funções utilitárias. As
funções utilitárias incluem:

- [`globalContext`], que representa o escopo global que os compiladores usam
  para encontrar membros e tipos de interoperabilidade.
- [Auxiliares para inspecionar o tipo de valores JS]
- Operadores JS
- [`dartify`] e [`jsify`], que verificam o tipo de certos valores JS e os
  convertem para valores Dart e vice-versa. Prefira usar a conversão específica
  quando você souber o tipo do valor JS, pois a verificação extra de tipo pode
  ser cara.
- [`importModule`], que permite importar módulos dinamicamente como
  `JSObject`s.

Mais utilitários podem ser adicionados a esta biblioteca no futuro.

[`dart:js_interop_unsafe`] contém membros que permitem que você procure
propriedades dinamicamente. Por exemplo:

```dart
JSFunction f = console['log'];
```

Em vez de declarar um membro de interoperabilidade chamado `log`, estamos usando
uma string para representar a propriedade. `dart:js_interop_unsafe` fornece
funcionalidade para obter, definir e chamar propriedades dinamicamente.

:::tip
Evite usar `dart:js_interop_unsafe` se possível. Isso torna a conformidade com a
segurança mais difícil de garantir e pode levar a violações, e é por isso que
pode ser "inseguro".
:::

{% comment %}
TODO: Some of these are not available on stable. How do we link to dev?
{% endcomment %}

[escopo global JS]: https://developer.mozilla.org/docs/Glossary/Global_scope
[funções de conversão]: /interop/js-interop/js-types#conversions
[contenha um tipo primitivo]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
["tipo JS"]: /interop/js-interop/js-types
[`Window`]: https://developer.mozilla.org/docs/Web/API/Window
[verificar o tipo do valor JS por meio da interoperabilidade]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[`package:web`]: {{site.pub-pkg}}/web
[`external`]: /language/functions#external
[restrições]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[literal de objeto]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Object_initializer
[54801]: {{site.repo.dart.sdk}}/issues/54801
[acessores de propriedade]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation
[funções utilitárias]: {{site.dart-api}}/dart-js_interop/JSAnyOperatorExtension.html
[`@JS()`]: {{site.dart-api}}/dart-js_interop/JS-class.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[tutorial de simulação]: /interop/js-interop/mock
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`globalContext`]: {{site.dart-api}}/dart-js_interop/globalContext.html
[Auxiliares para inspecionar o tipo de valores JS]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension.html
[`dartify`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/dartify.html
[`jsify`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/jsify.html
[`importModule`]: {{site.dart-api}}/dart-js_interop/importModule.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[extensões]: /language/extension-methods
[tipo de extensão]: /language/extension-types
[runtime guarantee]: /language/extension-types#type-considerations
[tipo de representação]: /language/extension-types#declaration
[implementar]: /language/extension-types#implements
[membros não `external`]: /language/extension-types#members
