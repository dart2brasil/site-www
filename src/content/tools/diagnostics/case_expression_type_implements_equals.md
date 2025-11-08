---
ia-translate: true
title: case_expression_type_implements_equals
description: "Detalhes sobre o diagnóstico case_expression_type_implements_equals produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' da expressão do case do switch não pode sobrescrever o operador '=='._

## Descrição

O analisador produz este diagnóstico quando o tipo da expressão
que segue a keyword `case` tem uma implementação do operador `==`
diferente daquela em `Object`.

## Exemplo

O código a seguir produz este diagnóstico porque a expressão
que segue a keyword `case` (`C(0)`) tem o tipo `C`, e a classe `C`
sobrescreve o operador `==`:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c) {
    case [!C(0)!]:
      break;
  }
}
```

## Correções comuns

Se não houver uma razão forte para não fazer isso, reescreva o código para usar
uma estrutura if-else:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  if (c == C(0)) {
    // ...
  }
}
```

Se você não puder reescrever a instrução switch e a implementação de `==`
não for necessária, então remova-a:

```dart
class C {
  final int value;

  const C(this.value);
}

void f(C c) {
  switch (c) {
    case C(0):
      break;
  }
}
```

Se você não puder reescrever a instrução switch e não puder remover a
definição de `==`, então encontre algum outro valor que possa ser usado para controlar
o switch:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c.value) {
    case 0:
      break;
  }
}
```
