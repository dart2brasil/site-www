---
title: invalid_null_aware_operator
description: >-
  Details about the invalid_null_aware_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The element can't be null, so the null-aware operator '?' is unnecessary._

_The map entry key can't be null, so the null-aware operator '?' is unnecessary._

_The map entry value can't be null, so the null-aware operator '?' is unnecessary._

_The receiver can't be 'null' because of short-circuiting, so the null-aware operator '{0}' can't be used._

_The receiver can't be null, so the null-aware operator '{0}' is unnecessary._

## Descrição

O analisador produz este diagnóstico quando a null-aware operator (`?.`,
`?..`, `?[`, `?..[`, or `...?`) is used on a receiver that's known to be
non-nullable.

## Exemplos

O código a seguir produz este diagnóstico porque `s` can't be `null`:

```dart
int? getLength(String s) {
  return s[!?.!]length;
}
```

O código a seguir produz este diagnóstico porque `a` can't be `null`:

```dart
var a = [];
var b = [[!...?!]a];
```

O código a seguir produz este diagnóstico porque `s?.length` can't
return `null`:

```dart
void f(String? s) {
  s?.length[!?.!]isEven;
}
```

The reason `s?.length` can't return `null` is because the null-aware
operator following `s` short-circuits the evaluation of both `length` and
`isEven` if `s` is `null`. In other words, if `s` is `null`, then neither
`length` nor `isEven` will be invoked, and if `s` is non-`null`, then
`length` can't return a `null` value. Either way, `isEven` can't be invoked
on a `null` value, so the null-aware operator isn't necessary. See
[Understanding null safety](/null-safety/understanding-null-safety#smarter-null-aware-methods)
for more details.

O código a seguir produz este diagnóstico porque `s` can't be `null`.

```dart
void f(Object? o) {
  var s = o as String;
  s[!?.!]length;
}
```

The reason `s` can't be null, despite the fact that `o` can be `null`, is
because of the cast to `String`, which is a non-nullable type. If `o` ever
has the value `null`, the cast will fail and the invocation of `length`
will not happen.

O código a seguir produz este diagnóstico porque `s` can't be `null`:

```dart
List<String> makeSingletonList(String s) {
  return <String>[[!?!]s];
}
```

## Correções comuns

Replace the null-aware operator with a non-null-aware equivalent; for
example, change `?.` to  `.`:

```dart
int getLength(String s) {
  return s.length;
}
```

(Note that the return type was also changed to be non-nullable, which might
not be appropriate in some cases.)
