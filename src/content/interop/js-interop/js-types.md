---
title: Tipos JS
breadcrumb: Tipos
description: Informações de uso sobre os tipos principais em JS interop.
ia-translate: true
prevpage:
  url: /interop/js-interop/usage
  title: Uso
nextpage:
  url: /interop/js-interop/tutorials
  title: Tutoriais de JS interop
---

Valores Dart e valores JS pertencem a domínios de linguagem separados. Ao compilar para
[Wasm][], eles executam em *runtimes* separados também. Dessa forma, você deve tratar valores JS
como tipos estrangeiros. Para fornecer tipos Dart para valores JS,
[`dart:js_interop`] expõe um conjunto de tipos prefixados com `JS` chamados "tipos JS".
Esses tipos são usados para distinguir entre valores Dart e valores JS em
tempo de compilação.

Importante notar que esses tipos são reificados de forma diferente dependendo se você compila para
Wasm ou JS. Isso significa que seu tipo em runtime será diferente e, portanto, você
[não pode usar verificações `is` e conversões `as`](#compatibility-type-checks-and-casts).
Para interagir e examinar esses valores JS, você deve usar
membros interop [`external`] ou [conversões](#conversions).

## Hierarquia de tipos

Os tipos JS formam uma hierarquia de tipos natural:

- Tipo superior: `JSAny`, que é qualquer valor JS não-nulo
  - Primitivos: `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - `JSObject`, que é qualquer objeto JS
    - `JSFunction`
      - `JSExportedDartFunction`, que representa um callback Dart que foi
      convertido para uma função JS
    - `JSArray`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - Typed arrays JS como `JSUint8Array`
    - `JSBoxedDartObject`, que permite aos usuários empacotar e passar valores Dart
      de forma opaca dentro do mesmo runtime Dart
      - A partir do Dart 3.4, o tipo `ExternalDartReference` em
      `dart:js_interop` também permite aos usuários passar valores Dart de forma opaca, mas
      *não* é um tipo JS. Saiba mais sobre as compensações entre cada opção
      [aqui](#jsboxeddartobject-vs-externaldartreference).

Você pode encontrar a definição de cada tipo na [documentação da API `dart:js_interop`][`dart:js_interop` API docs].

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversões

Para usar um valor de um domínio para outro, você provavelmente vai querer *converter* o
valor para o tipo correspondente do outro domínio. Por exemplo, você pode querer
converter uma `List<JSString>` Dart em um array JS de strings, que é
representado pelo tipo JS `JSArray<JSString>`, para que você possa passar o array
para uma API de interop JS.

Dart fornece vários membros de conversão em vários tipos Dart e tipos JS
para converter os valores entre os domínios para você.

Membros que convertem valores de Dart para JS geralmente começam com `toJS`:

```dart
String str = 'hello world';
JSString jsStr = str.toJS;
```

Membros que convertem valores de JS para Dart geralmente começam com `toDart`:

```dart
JSNumber jsNum = ...;
int integer = jsNum.toDartInt;
```

Nem todos os tipos JS têm uma conversão, e nem todos os tipos Dart têm uma conversão.
Geralmente, a tabela de conversão se parece com o seguinte:

| `dart:js_interop` type              | Dart type                                |
| ----------------------------------- | ---------------------------------------- |
| `JSNumber`, `JSBoolean`, `JSString` | `num`, `int`, `double`, `bool`, `String` |
| `JSExportedDartFunction`            | `Function`                               |
| `JSArray<T extends JSAny?>`         | `List<T extends JSAny?>`                 |
| `JSPromise<T extends JSAny?>`       | `Future<T extends JSAny?>`               |
| Typed arrays like `JSUint8Array`    | Typed lists from `dart:typed_data`       |
| `JSBoxedDartObject`                 | Opaque Dart value                        |
| `ExternalDartReference`             | Opaque Dart value                        |

{:.table .table-striped}

:::warning
Compilar para JavaScript vs [Wasm][] pode introduzir inconsistências tanto em
desempenho quanto em semântica para conversões. Conversões podem ter custos diferentes
dependendo do compilador, então prefira converter valores somente se você precisar.

Conversões também podem ou não produzir um novo valor. Isso não importa para
valores imutáveis como números, mas importa para tipos como `List`. Dependendo
da implementação, uma conversão para `JSArray` pode retornar uma referência, um
proxy ou um clone da lista original. Para evitar isso, não confie em nenhuma
relação entre a `List` e `JSArray` e confie apenas em seus conteúdos sendo
os mesmos. Conversões de typed array têm uma limitação similar. Consulte a
função de conversão específica para mais detalhes.
:::

## Requisitos em declarações `external` e `Function.toJS`

Para garantir segurança de tipos e consistência, o compilador estabelece requisitos
sobre quais tipos podem fluir para dentro e para fora de JS. Passar valores Dart arbitrários para JS
não é permitido. Em vez disso, o compilador exige que os usuários usem um tipo interop
compatível, `ExternalDartReference` ou um primitivo, que então seria implicitamente
convertido pelo compilador. Por exemplo, estes seriam permitidos:

```dart tag=good
@JS()
external void primitives(String a, int b, double c, num d, bool e);
```

```dart tag=good
@JS()
external JSArray jsTypes(JSObject _, JSString __);
```

```dart tag=good
extension type InteropType(JSObject _) implements JSObject {}

@JS()
external InteropType get interopType;
```

```dart tag=good
@JS()
external void externalDartReference(ExternalDartReference _);
```

Enquanto estes retornariam um erro:

```dart tag=bad
@JS()
external Function get function;
```

```dart tag=bad
@JS()
external set list(List _);
```

Esses mesmos requisitos existem quando você usa [`Function.toJS`] para tornar uma função Dart
chamável em JS. Os valores que fluem para dentro e para fora desse callback devem
ser um tipo interop compatível ou um primitivo.

Se você usar um primitivo Dart como `String`, uma conversão implícita acontece no
compilador para converter esse valor de um valor JS para um valor Dart. Se o desempenho
é crítico e você não precisa examinar o conteúdo da string, então usar
`JSString` em vez disso para evitar o custo de conversão pode fazer sentido como no
segundo exemplo.

## Compatibilidade, verificações de tipo e conversões

O tipo em runtime dos tipos JS pode diferir com base no compilador. Isso afeta
verificação de tipo em runtime e conversões. Portanto, quase sempre evite verificações `is`
onde o valor é um tipo interop ou onde o tipo alvo é um tipo interop:

```dart tag=bad
void f(JSAny a) {
  if (a is String) { … }
}
```

```dart tag=bad
void f(JSAny a) {
  if (a is JSObject) { … }
}
```

Além disso, evite conversões entre tipos Dart e tipos interop:

```dart tag=bad
void f(JSString s) {
  s as String;
}
```

Para verificar o tipo de um valor JS, use um membro interop como [`typeofEquals`] ou
[`instanceOfString`] que examina o próprio valor JS:

```dart tag=good
void f(JSAny a) {
  // Here `a` is verified to be a JS function, so the cast is okay.
  if (a.typeofEquals('function')) {
    a as JSFunction;
  }
}
```

A partir do Dart 3.4, você pode usar a função auxiliar [`isA`] para verificar se
um valor é de qualquer tipo interop:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `instanceOfString('Array')`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Dependendo do parâmetro de tipo, ele transformará a chamada na
verificação de tipo apropriada para esse tipo.

{% comment %}
TODO: Add a link to and an example using `isA` once it's in a dev release. Users
should prefer that method if it's available.
{% endcomment %}

Dart pode adicionar lints para tornar verificações em runtime com tipos interop JS mais fáceis de evitar.
Veja a issue [#4841] para mais detalhes.

## `null` vs `undefined`

JS tem tanto um valor `null` quanto um `undefined`. Isso contrasta com Dart,
que tem apenas `null`. Para tornar valores JS mais ergonômicos de usar, se um
membro interop retornar `null` ou `undefined` JS, o compilador mapeia
esses valores para `null` Dart. Portanto, um membro como `value` no seguinte
exemplo pode ser interpretado como retornando um objeto JS, `null` JS ou `undefined`:

```dart
@JS()
external JSObject? get value;
```

Se o tipo de retorno não foi declarado como nullable, então o programa lançará um
erro se o valor retornado for `null` ou `undefined` JS para garantir soundness.

:::warning
Há uma inconsistência sutil com relação a `undefined` entre compilar para
JS e [Wasm][]. Enquanto compilar para JS *trata* valores `undefined` como se fossem
`null` Dart, ele não *altera* o valor em si. Se um membro interop
retorna `undefined` e você passa esse valor de volta para JS, JS verá
`undefined`, *não* `null`, ao compilar para JS.

No entanto, ao compilar para Wasm, este não é o caso,
e o valor será `null` em JS. Isso ocorre porque
o compilador implicitamente *converte* o valor para `null` Dart ao compilar para
Wasm, perdendo assim informação sobre se o valor original era `null` ou
`undefined` JS. Evite escrever código onde essa distinção importa passando explicitamente
`null` Dart em vez disso para um membro interop.

Atualmente, não há uma maneira consistente entre plataformas para fornecer `undefined`
para membros interop ou distinguir entre valores `null` e `undefined` JS,
mas isso provavelmente mudará no futuro. Veja [#54025] para mais detalhes.
:::

## `JSBoxedDartObject` vs `ExternalDartReference`

A partir do Dart 3.4, tanto [`JSBoxedDartObject`] quanto [`ExternalDartReference`]
podem ser usados para passar referências opacas para `Object`s Dart através de JavaScript.
No entanto, `JSBoxedDartObject` envolve a referência opaca em um objeto JavaScript,
enquanto `ExternalDartReference` é a própria referência e, portanto, não é um tipo JS.

Use `JSBoxedDartObject` se você precisar de um tipo JS ou se precisar de verificações extras para
garantir que valores Dart não sejam passados para outro runtime Dart. Por exemplo, se
o objeto Dart precisa ser colocado em um `JSArray` ou passado para uma API que
aceita um `JSAny`, use `JSBoxedDartObject`. Use `ExternalDartReference`
caso contrário, pois será mais rápido.

Veja [`toExternalReference`] e [`toDartObject`] para converter de e para um
`ExternalDartReference`.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`external`]: /language/functions#external
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop` API docs]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html#extension-types
[`typeofEquals`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/typeofEquals.html
[`instanceOfString`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/instanceOfString.html
[`isA`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/isA.html
[#4841]: {{site.repo.dart.org}}/linter/issues/4841
[#54025]: {{site.repo.dart.sdk}}/issues/54025
[`JSBoxedDartObject`]: {{site.dart-api}}/dart-js_interop/JSBoxedDartObject-extension-type.html
[`ExternalDartReference`]: {{site.dart-api}}/dart-js_interop/ExternalDartReference-extension-type.html
[`toExternalReference`]: {{site.dart-api}}/dart-js_interop/ObjectToExternalDartReference/toExternalReference.html
[`toDartObject`]: {{site.dart-api}}/dart-js_interop/ExternalDartReferenceToObject/toDartObject.html
[Wasm]: /web/wasm