---
ia-translate: true
title: extension_override_with_cascade
description: "Detalhes sobre o diagnóstico extension_override_with_cascade produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Overrides de extension não têm valor, portanto não podem ser usados como receptor de uma expressão cascade._

## Descrição

O analisador produz este diagnóstico quando um override de extension é usado como
o receptor de uma expressão cascade. O valor de uma expressão cascade
`e..m` é o valor do receptor `e`, mas overrides de extension não são
expressões e não têm um valor.

## Exemplo

O código a seguir produz este diagnóstico porque `E(3)` não é uma
expressão:

```dart
extension E on int {
  void m() {}
}
f() {
  [!E!](3)..m();
}
```

## Correções comuns

Use `.` ao invés de `..`:

```dart
extension E on int {
  void m() {}
}
f() {
  E(3).m();
}
```

Se houver múltiplos acessos em cascata, você precisará duplicar o
override de extension para cada um.
