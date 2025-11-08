---
ia-translate: true
title: super_in_extension_type
description: "Detalhes sobre o diagnóstico super_in_extension_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A keyword 'super' não pode ser usada em um extension type porque um extension type não possui uma superclasse._

## Descrição

O analisador produz este diagnóstico quando `super` é usado em um membro
de instância de um extension type. Extension types não possuem superclasses, então
não há membro herdado que possa ser invocado.

## Exemplo

O código a seguir produz este diagnóstico porque:

```dart
extension type E(String s) {
  void m() {
    [!super!].m();
  }
}
```

## Correções comuns

Substitua ou remova a invocação de `super`:

```dart
extension type E(String s) {
  void m() {
    s.toLowerCase();
  }
}
```
