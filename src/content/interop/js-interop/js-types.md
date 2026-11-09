---
ia-translate: true
title: Tipos JS
breadcrumb: Types
description: Informações de uso sobre os tipos principais do JS interop.
prevpage:
  url: /interop/js-interop/usage
  title: Uso
nextpage:
  url: /interop/js-interop/tutorials
  title: Tutoriais de JS interop
---

Valores Dart e valores JS pertencem a domínios de linguagem separados.
Ao compilar para [Wasm][], eles também são executados em runtimes separados.
Trate valores JS como tipos estrangeiros.
Para fornecer tipos Dart para valores JS, a biblioteca [`dart:js_interop`] expõe
um conjunto de tipos prefixados com `JS`, chamados tipos JS.
Esses tipos distinguem valores Dart de valores JS em tempo de compilação.

O compilador representa esses tipos de forma diferente
dependendo de você compilar para Wasm ou JS.
Por causa dessa diferença, seus tipos em tempo de execução são diferentes, então você
[não pode usar verificações `is` nem casts `as`](#compatibility-type-checks-and-casts).
Para interagir com valores JS e examiná-los, use
membros de interop [`external`] ou [conversões](#conversions).

## Hierarquia de tipos {:#type-hierarchy}

Os tipos JS formam uma hierarquia de tipos natural:

- Tipo no topo: `JSAny`, que é qualquer valor JS não nullish
  - Primitivos: `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - `JSObject`, que é qualquer objeto JS
    - `JSFunction`
      - `JSExportedDartFunction`, que representa um callback Dart que foi
      convertido em uma função JS
    - `JSArray`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - Typed arrays JS como `JSUint8Array`
    - `JSBoxedDartObject`, que empacota valores Dart para que você possa passá-los
      de forma opaca dentro do mesmo runtime Dart
  - `JSIterable` e `JSIterator`

O tipo `ExternalDartReference` da biblioteca `dart:js_interop` também passa
valores Dart de forma opaca, mas não é um tipo JS.
Para comparar as duas opções, consulte a seção
[`JSBoxedDartObject` versus `ExternalDartReference`][boxed-vs-external]
nesta página.

Você encontra a definição de cada tipo e seus auxiliares integrados na
[documentação da API `dart:js_interop`][`dart:js_interop` API docs].
Esses auxiliares incluem `JSPromise.resolve`, `JSPromise.reject`,
`JSArray.fromAsync`, `JSFunction.length`, `JSFunction.name`,
e getters estáticos para valores `JSSymbol` bem conhecidos.

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversões {:#conversions}

Para usar um valor de um domínio no outro,
converta-o para o tipo correspondente.
Por exemplo, para passar uma `List<String>` do Dart para uma API de interop JS
que espera um array JS de strings,
converta a lista para o tipo `JSArray<JSString>`.

Membros que convertem valores de Dart para JS geralmente começam com `toJS`, e
membros que convertem valores de JS para Dart geralmente começam com `toDart`:

```dart
// Dart to JS
JSString jsStr = 'hello world'.toJS;
JSArray<JSString> jsArr = ['a', 'b'].toJS;

// JS to Dart
String dartStr = jsStr.toDart;
List<String> dartList = jsArr.toDartStringList;
JSAny? resolved = await jsPromise.toDart;
for (final item in jsIterable.toDartIterable) { /* ... */ }
```

Nem todo tipo JS tem uma conversão, e nem todo tipo Dart tem uma conversão.
As tabelas a seguir listam as conversões suportadas entre os tipos de `dart:js_interop`
e os tipos Dart.

### Primitivos, funções, futures e referências {:#primitives-functions-futures-and-references}

| Tipo `dart:js_interop` | Tipo Dart | Dart para JS | JS para Dart |
| --- | --- | --- | --- |
| `JSNumber` | `num`, `int`, `double` | `toJS` | `toDartDouble`, `toDartInt` |
| `JSBoolean`, `JSString` | `bool`, `String` | `toJS` | `toDart` |
| `JSExportedDartFunction` | `Function` | `toJS`, `toJSCaptureThis`, `toJSVarArgs`, `toJSCaptureThisVarArgs` | `toDart` |
| `JSPromise<T extends JSAny?>` | `Future<T extends JSAny?>` | `toJS` | `toDart` |
| `JSAny?` (`JSPromise` ou valor) | `FutureOr<T extends JSAny?>` (`FutureOr<JSAny?>` a partir de `toDartFutureOr`) | `toJSPromiseOrValue` | `toDartFutureOr` |
| `JSBoxedDartObject` | `Object` Dart opaco | `toJSBox` | `toDart` |
| `ExternalDartReference` | `Object?` Dart opaco | `toExternalReference` | `toDartObject` |

{:.table .table-striped}

### Coleções e dados tipados {:#collections-and-typed-data}

| Tipo `dart:js_interop` | Tipo Dart | Dart para JS | JS para Dart |
| --- | --- | --- | --- |
| `JSArray<T extends JSAny?>` | `List<T extends JSAny?>` | `toJS` | `toDart` |
| `JSArray<JSNumber?>`, `JSArray<JSBoolean?>`, `JSArray<JSString?>` | `List` de `num?`, `int?`, `double?`, `bool?` ou `String?` (e não nullable) | `toJS` | `toDartDoubleList`, `toDartIntList`, `toDartBoolList`, `toDartStringList` |
| `JSIterable<T extends JSAny?>` | `Iterable<T extends JSAny?>` (preguiçoso, sem copiar) | `toJSIterable` | `toDartIterable` |
| `JSIterator<T extends JSAny?>` | `Iterator<T extends JSAny?>` (preguiçoso, sem copiar) | `toJSIterator` | `toDartIterator` |
| Typed arrays como `JSUint8Array` | Listas tipadas de `dart:typed_data` | `toJS` | `toDart` |

{:.table .table-striped}

Ao converter valores `Function` ou `Future`,
tenha em mente os seguintes comportamentos:

- Use o getter [`Function.toJS`] para callbacks de aridade fixa,
  ou o getter `toJSVarArgs` para callbacks variádicos
  que recebem todos os argumentos em um `JSArray`.
  Use os getters [`Function.toJSCaptureThis`] ou `toJSCaptureThisVarArgs`
  para passar o valor `this` do JavaScript como primeiro parâmetro do callback.
- Quando um `Future` convertido com os getters `toJS` ou `toJSPromiseOrValue`
  falha, erros `JSAny` rejeitam o `JSPromise` diretamente,
  enquanto outros erros do Dart rejeitam com um `Error` JS
  contendo as propriedades `error` (do tipo [`JSBoxedDartObject`]) e `stack`.

:::warning
Os custos e a semântica de conversão variam entre os alvos JavaScript e [Wasm][],
então converta valores somente quando necessário.
Converter uma coleção mutável, como uma `List` ou uma lista tipada,
pode retornar uma referência, um proxy ou uma cópia.
Não dependa de mutações em um lado afetarem o outro.
:::

## Requisitos para declarações `external` e `Function.toJS` {:#requirements-on-external-declarations-and-function-tojs}

Para garantir a segurança de tipos, o compilador restringe
quais tipos podem entrar e sair do JS.
Os tipos de parâmetros e de retorno em declarações `external`
devem ser um dos seguintes:

- Um tipo JS de `dart:js_interop` (como `JSString` ou `JSArray`) ou um
  extension type de interop personalizado.
- Um valor `ExternalDartReference`.
- Um primitivo do Dart (`bool`, `num`, `int`, `double`, `String` ou `void`),
  que o compilador converte implicitamente.

```dart tag=good
extension type InteropType(JSObject _) implements JSObject {}

@JS()
external void primitives(String a, int b, double c, num d, bool e);

@JS()
external JSArray jsTypes(JSObject a, JSString b);

@JS()
external InteropType get interopType;

@JS()
external void externalReference(ExternalDartReference ref);
```

Tipos Dart arbitrários como `Function` ou `List` não são permitidos diretamente em
declarações `external` e causam um erro de compilação:

```dart tag=bad
@JS()
external Function get function;

@JS()
external set list(List value);
```

As mesmas restrições de tipo se aplicam aos parâmetros e valores de retorno de callbacks Dart
convertidos com os getters [`Function.toJS`] ou [`Function.toJSCaptureThis`].
Callbacks sem parâmetros posicionais opcionais
que você converte com os getters `toJS` ou `toJSCaptureThis`
também podem ser `async` e retornar `Future<T>`,
em que `T` é `void` ou um subtipo de `JSAny?`.
Em contraste, os getters `toJSVarArgs` (`R Function(JSArray<E>)`)
e `toJSCaptureThisVarArgs` (`R Function(T, JSArray<E>)`)
exigem que `R` e `E` sejam subtipos de `JSAny?`
e que `T` seja subtipo de `JSObject`.

:::tip
Primitivos do Dart como `String` têm um custo de conversão implícito.
Se o desempenho for crítico
e você não precisar inspecionar o conteúdo da string no Dart,
aceite ou retorne o tipo `JSString` em vez disso.
:::

## Compatibilidade, verificações de tipo e casts {:#compatibility-type-checks-and-casts}

Como os tipos de JS interop são extension types
que se reduzem a uma única representação em tempo de execução (`externref`) no WebAssembly,
as verificações `is` e os casts `as` padrão do Dart
não conseguem distinguir entre tipos JS em tempo de execução
e podem ter sucesso silenciosamente no tipo errado.

Evite verificações `is` e casts `as` envolvendo tipos de interop:

```dart tag=bad
void f(JSAny a, JSString s) {
  if (a is String) { /* ... */ }
  if (a is JSObject) { /* ... */ }
  var str = s as String;
}
```

Em vez disso, use o método auxiliar [`isA`] para verificar se um valor JS
corresponde a um tipo JS específico ou a um tipo de interop personalizado:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // Checks `typeof a === 'string'`
  if (a.isA<JSArray>()) {} // Checks `Array.isArray(a) || a instanceof Array`
  if (a.isA<CustomInteropType>()) {} // Checks `a instanceof CustomInteropType`
}
```

Você também pode inspecionar o valor JS subjacente com os métodos [`typeofEquals`] ou
[`instanceOfString`] antes de fazer o cast entre tipos de interop:

```dart tag=good
void f(JSAny a) {
  if (a.typeofEquals('function')) {
    var fn = a as JSFunction;
  }
}
```

Para detectar verificações de tipo e casts inválidos com tipos de JS interop,
ative a regra de lint [`invalid_runtime_check_with_js_interop_types`][].
A partir do [`package:lints`][] 7.0.0,
o `package:lints/core.yaml` inclui essa regra.

[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types

## `null` versus `undefined` {:#null-vs-undefined}

O JavaScript tem `null` e `undefined`, enquanto o Dart tem apenas `null`.
Quando um membro de interop retorna `null` ou `undefined` do JS,
o compilador mapeia o resultado para `null` do Dart:

```dart
@JS()
external JSObject? get value; // Can return a JSObject, JS null, or undefined.
```

Se um membro de interop não nullable retornar `null` ou `undefined` do JS,
o programa lança um erro em tempo de execução.

:::warning
Os alvos JavaScript e [Wasm][] tratam de forma diferente a ida e volta de `undefined`.
Ao compilar para JS, o Dart trata `undefined` como `null`
sem alterar o valor subjacente,
então, ao passá-lo de volta para o JS, o `undefined` é preservado.
Ao compilar para Wasm,
o compilador converte tanto `null` quanto `undefined` do JS para `null` do Dart,
então, ao passá-lo de volta para o JS, sempre resulta em `null`.
Passe `null` do Dart explicitamente em vez de depender da ida e volta de `undefined`.
Para mais detalhes, consulte a issue [#54025].
:::

## `JSBoxedDartObject` versus `ExternalDartReference` {:#jsboxeddartobject-vs-externaldartreference}

Tanto os tipos [`JSBoxedDartObject`] quanto [`ExternalDartReference`]
passam referências opacas a instâncias de `Object` do Dart através do JavaScript:

| Tipo | Representação | Quando usar |
| --- | --- | --- |
| [`ExternalDartReference`] ([`toExternalReference`] / [`toDartObject`]) | Referência opaca direta (não é subtipo de `JSAny`; aceita `Object?` nullable) | Escolha padrão por desempenho ao passar um objeto Dart de e para o JS. |
| [`JSBoxedDartObject`] (`toJSBox` / `toDart`) | Empacotado em um objeto JS (subtipo de `JSObject` e `JSAny`) | Quando uma API exige um subtipo de `JSAny` (como armazenar em um `JSArray`) ou quando você precisa de verificações em tempo de execução que impedem o acesso entre runtimes Dart diferentes. |

{:.table .table-striped}

[boxed-vs-external]: #jsboxeddartobject-vs-externaldartreference
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`external`]: /language/functions#external
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`Function.toJSCaptureThis`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJSCaptureThis.html
[`dart:js_interop` API docs]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html#extension-types
[`typeofEquals`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/typeofEquals.html
[`instanceOfString`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/instanceOfString.html
[`isA`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/isA.html
[#54025]: {{site.repo.dart.sdk}}/issues/54025
[`JSBoxedDartObject`]: {{site.dart-api}}/dart-js_interop/JSBoxedDartObject-extension-type.html
[`ExternalDartReference`]: {{site.dart-api}}/dart-js_interop/ExternalDartReference-extension-type.html
[`toExternalReference`]: {{site.dart-api}}/dart-js_interop/ObjectToExternalDartReference/toExternalReference.html
[`toDartObject`]: {{site.dart-api}}/dart-js_interop/ExternalDartReferenceToObject/toDartObject.html
[Wasm]: /web/wasm
[`package:lints`]: {{site.pub-pkg}}/lints
