---
ia-translate: true
title: unused_catch_stack
description: >-
  Detalhes sobre o diagnóstico unused_catch_stack
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável de stack trace '{0}' não é usada e pode ser removida._

## Descrição

O analisador produz este diagnóstico quando o parâmetro de stack trace em uma
cláusula `catch` não é referenciado dentro do corpo do bloco `catch`.

## Exemplo

O código a seguir produz este diagnóstico porque `stackTrace` não é
referenciado:

```dart
void f() {
  try {
    // ...
  } catch (exception, [!stackTrace!]) {
    // ...
  }
}
```

## Correções comuns

Se você precisa referenciar o parâmetro de stack trace, então adicione uma referência a
ele. Caso contrário, remova-o:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    // ...
  }
}
```
