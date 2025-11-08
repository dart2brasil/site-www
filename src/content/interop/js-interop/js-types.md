---
ia-translate: true
title: Tipos JS
breadcrumb: Tipos
description: Informações de uso sobre os tipos principais em interoperação JS.
prevpage:
  url: /interop/js-interop/usage
  title: Uso
nextpage:
  url: /interop/js-interop/tutorials
  title: Tutoriais de interoperação JS
---

Valores Dart e valores JS pertencem a domínios de linguagem separados. Ao compilar para
[Wasm][], eles também são executados em *runtimes* separados. Como tal, você deve tratar
valores JS como tipos estrangeiros. Para fornecer tipos Dart para valores JS,
[`dart:js_interop`] expõe um conjunto de tipos prefixados com `JS`, chamados de "tipos
JS". Esses tipos são usados para distinguir entre valores Dart e valores JS em tempo de
compilação.

É importante destacar que esses tipos são reificados de forma diferente dependendo se
você compila para Wasm ou JS. Isso significa que seu tipo em tempo de execução será
diferente e, portanto, você [não pode usar verificações `is` e conversões `as`](#compatibility-type-checks-and-casts).
Para interagir e examinar esses valores JS, você deve usar membros de
interoperabilidade [`external`] ou [conversões](#conversions).

## Hierarquia de tipos {:#hierarquia-de-tipos}

Os tipos JS formam uma hierarquia de tipos natural:

- Top type: `JSAny`, which is any non-nullish JS value
  - Primitives: `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - `JSObject`, which is any JS object
    - `JSFunction`
      - `JSExportedDartFunction` (representa um callback Dart que foi convertido para
      uma função JS)
    - `JSArray`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - Vetores tipados JS como `JSUint8Array`
    - `JSBoxedDartObject` (permite que os usuários encapsulem e passem valores Dart
      de forma opaca dentro do mesmo runtime Dart)
      - A partir do Dart 3.4, o tipo `ExternalDartReference` em `dart:js_interop`
      também permite que os usuários passem valores Dart de forma opaca, mas *não* é
      um tipo JS. Saiba mais sobre as compensações entre cada opção
      [aqui](#jsboxeddartobject-vs-externaldartreference).

Você pode encontrar a definição de cada tipo na [documentação da API `dart:js_interop`].

{% comment %}
TODO (srujzs): Devemos adicionar um diagrama de árvore em vez disso para os tipos JS?
{% endcomment %}

## Conversões {:#conversions}

Para usar um valor de um domínio para outro, você provavelmente desejará *converter* o
valor para o tipo correspondente do outro domínio. Por exemplo, você pode querer
converter uma `List<JSString>` Dart em um array JS de strings, que é
representado pelo tipo JS `JSArray<JSString>`, para que você possa passar o array
para uma API de interoperabilidade JS.

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
Geralmente, a tabela de conversão é semelhante à seguinte:

| Tipo `dart:js_interop`              | Tipo Dart                                |
| ----------------------------------- | ---------------------------------------- |
| `JSNumber`, `JSBoolean`, `JSString` | `num`, `int`, `double`, `bool`, `String` |
| `JSExportedDartFunction`            | `Function`                               |
| `JSArray<T extends JSAny?>`         | `List<T extends JSAny?>`                 |
| `JSPromise<T extends JSAny?>`       | `Future<T extends JSAny?>`               |
| Vetores tipados como `JSUint8Array` | Listas tipadas de `dart:typed_data`       |
| `JSBoxedDartObject`                 | Valor Dart opaco                        |
| `ExternalDartReference`             | Valor Dart opaco                        |

{:.table .table-striped}

:::warning
Compilar para JavaScript versus [Wasm][] pode introduzir inconsistências em termos de
desempenho e semântica para conversões. As conversões podem ter custos diferentes
dependendo do compilador, portanto, prefira converter valores apenas se necessário.

As conversões também podem ou não produzir um novo valor. Isso não importa para
valores imutáveis como números, mas importa para tipos como `List`. Dependendo
da implementação, uma conversão para `JSArray` pode retornar uma referência, um
proxy ou uma cópia da lista original. Para evitar isso, não dependa de nenhuma
relação entre `List` e `JSArray` e apenas confie no fato de seus conteúdos serem
os mesmos. As conversões de vetores tipados têm uma limitação semelhante. Consulte a
função de conversão específica para obter mais detalhes.
:::

## Requisitos para declarações `external` e `Function.toJS` {:#requirements-on-external-declarations-and-function-tojs}

Para garantir a segurança de tipos e a consistência, o compilador impõe requisitos
sobre quais tipos podem fluir para dentro e para fora do JS. Passar valores Dart
arbitrários para JS não é permitido. Em vez disso, o compilador exige que os usuários
usem um tipo de interoperabilidade compatível, `ExternalDartReference`, ou um
primitivo, que então seria implicitamente convertido pelo compilador. Por exemplo, esses seriam permitidos:

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

Enquanto esses retornariam um erro:

```dart tag=bad
@JS()
external Function get function;
```

```dart tag=bad
@JS()
external set list(List _);
```

Esses mesmos requisitos existem quando você usa [`Function.toJS`] para tornar uma
função Dart chamávelem JS. Os valores que fluem para dentro e para fora desse
callback devem ser um tipo de interoperabilidade compatível ou um primitivo.

Se você usar um primitivo Dart como `String`, uma conversão implícita ocorre no
compilador para converter esse valor de um valor JS para um valor Dart. Se o
desempenho for crítico e você não precisar examinar o conteúdo da string, usar
`JSString` para evitar o custo de conversão pode fazer sentido, como no
segundo exemplo.

## Compatibilidade, verificações de tipo e conversões {:#compatibility-type-checks-and-casts}

O tipo em tempo de execução dos tipos JS pode diferir com base no compilador. Isso afeta
a verificação de tipo e as conversões em tempo de execução. Portanto, quase sempre
evite verificações `is` onde o valor é um tipo de interoperabilidade ou onde o tipo de destino é um tipo de interoperabilidade:

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

Além disso, evite conversões entre tipos Dart e tipos de interoperabilidade:

```dart tag=bad
void f(JSString s) {
  s as String;
}
```

Para verificar o tipo de um valor JS, use um membro de interoperabilidade como
[`typeofEquals`] ou [`instanceOfString`] que examina o próprio valor JS:

```dart tag=good
void f(JSAny a) {
  // Aqui `a` é verificado para ser uma função JS, então a conversão está ok.
  if (a.typeofEquals('function')) {
    a as JSFunction;
  }
}
```

A partir do Dart 3.4, você pode usar a função auxiliar [`isA`] para verificar se
um valor é qualquer tipo de interoperabilidade:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `instanceOfString('Array')`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Dependendo do parâmetro de tipo, ele transformará a chamada na verificação de tipo
apropriada para esse tipo.

{% comment %}
TODO: Adicione um link e um exemplo usando `isA` assim que estiver em uma versão de
desenvolvimento. Os usuários devem preferir esse método se estiver disponível.
{% endcomment %}

O Dart pode adicionar lints para tornar as verificações em tempo de execução com tipos
de interoperabilidade JS mais fáceis de evitar. Veja a issue [#4841] para obter mais detalhes.

## `null` vs `undefined` {:#null-vs-undefined}

JS tem um valor `null` e um valor `undefined`. Isso contrasta com o Dart, que só tem
`null`. Para tornar os valores JS mais ergonômicos de usar, se um membro de
interoperabilidade retornasse JS `null` ou `undefined`, o compilador mapeia esses
valores para Dart `null`. Portanto, um membro como `value` no exemplo a seguir pode
ser interpretado como retornando um objeto JS, JS `null` ou `undefined`:

```dart
@JS()
external JSObject? get value;
```

Se o tipo de retorno não fosse declarado como anulável, o programa lançaria um erro se
o valor retornado fosse JS `null` ou `undefined` para garantir a segurança.

:::warning
Há uma inconsistência sutil com relação a `undefined` entre a compilação para JS e
[Wasm][]. Enquanto a compilação para JS *trata* os valores `undefined` como se fossem
Dart `null`, ela não *altera* o valor em si. Se um membro de interoperabilidade
retornar `undefined` e você passar esse valor de volta para JS, JS verá
`undefined`, *não* `null`, ao compilar para JS.

No entanto, ao compilar para Wasm, isso não é o caso,
e o valor será `null` em JS.
Isso ocorre porque o compilador implicitamente*converte* o valor para Dart `null` ao
compilar para Wasm, perdendo informações sobre se o valor original era JS `null` ou
`undefined`. Evite escrever código onde essa distinção seja importante, passando
explicitamente Dart `null` para um membro de interoperabilidade.

Atualmente, não há uma maneira consistente na plataforma de fornecer `undefined`
para membros de interoperabilidade ou distinguir entre valores JS `null` e
`undefined`, mas isso provavelmente mudará no futuro. Veja [#54025] para obter mais detalhes.
:::

## `JSBoxedDartObject` vs `ExternalDartReference` {:#jsboxeddartobject-vs-externaldartreference}

A partir do Dart 3.4, tanto [`JSBoxedDartObject`] quanto [`ExternalDartReference`]
podem ser usados para passar referências opacas a `Object`s Dart por meio de JavaScript.
No entanto, `JSBoxedDartObject` encapsula a referência opaca em um objeto JavaScript,
enquanto `ExternalDartReference` é a própria referência e, portanto,
não é um tipo JS.

Use `JSBoxedDartObject` se você precisar de um tipo JS ou se precisar de verificações
extras para garantir que os valores Dart não sejam passados para outro runtime Dart.
Por exemplo, se o objeto Dart precisar ser colocado em um `JSArray` ou passado para
uma API que aceita um `JSAny`, use `JSBoxedDartObject`. Use `ExternalDartReference`
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
