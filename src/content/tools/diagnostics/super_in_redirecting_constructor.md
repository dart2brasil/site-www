---
ia-translate: true
title: super_in_redirecting_constructor
description: >-
  Detalhes sobre o diagnóstico super_in_redirecting_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor de redirecionamento não pode ter um inicializador 'super'._

## Descrição

O analisador produz este diagnóstico quando um construtor que redireciona para
outro construtor também tenta invocar um construtor da
superclasse. O construtor da superclasse será invocado quando o construtor
para o qual o construtor de redirecionamento redireciona for invocado.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor `C.a`
tanto redireciona para `C.b` quanto invoca um construtor da superclasse:

```dart
class C {
  C.a() : this.b(), [!super()!];
  C.b();
}
```

## Correções comuns

Remova a invocação do construtor `super`:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
