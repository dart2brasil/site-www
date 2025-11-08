---
ia-translate: true
title: extension_override_argument_not_assignable
description: >-
  Detalhes sobre o diagnóstico extension_override_argument_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo do argumento para o override de extension '{0}' não é atribuível ao tipo estendido '{1}'._

## Descrição

O analisador produz este diagnóstico quando o argumento para um override de
extension não é atribuível ao tipo sendo estendido pela extension.

## Exemplo

O código a seguir produz este diagnóstico porque `3` não é um `String`:

```dart
extension E on String {
  void method() {}
}

void f() {
  E([!3!]).method();
}
```

## Correções comuns

Se você está usando a extension correta, então atualize o argumento para ter o
tipo correto:

```dart
extension E on String {
  void method() {}
}

void f() {
  E(3.toString()).method();
}
```

Se há uma extension diferente que é válida para o tipo do argumento,
então substitua o nome da extension ou desembrulhe o argumento para que
a extension correta seja encontrada.
