---
ia-translate: true
title: non_exhaustive_switch_statement
description: "Detalhes sobre o diagnóstico non_exhaustive_switch_statement produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' não é exaustivamente correspondido pelos casos do switch, pois não corresponde ao padrão '{1}'._

## Description

O analisador produz este diagnóstico quando uma instrução `switch` alternando
sobre um tipo exaustivo está faltando um caso para um ou mais dos possíveis
valores que poderiam fluir através dela.

## Example

O código a seguir produz este diagnóstico porque a instrução switch
não tem um caso para o valor `E.three`, e `E` é um tipo
exaustivo:

```dart
enum E { one, two, three }

void f(E e) {
  [!switch!] (e) {
    case E.one:
    case E.two:
  }
}
```

## Common fixes

Adicione um caso para cada uma das constantes que não estão sendo correspondidas atualmente:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    case E.three:
  }
}
```

Se os valores faltantes não precisam ser correspondidos, então adicione uma cláusula `default`
ou um padrão wildcard:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    default:
  }
}
```

Mas esteja ciente de que adicionar uma cláusula `default` ou padrão wildcard fará com que
quaisquer valores futuros do tipo exaustivo também sejam tratados, então você terá
perdido a capacidade de o compilador avisá-lo se o `switch` precisa
ser atualizado.
