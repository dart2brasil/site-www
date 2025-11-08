---
ia-translate: true
title: inconsistent_inheritance
description: "Detalhes sobre o diagnóstico inconsistent_inheritance produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Superinterfaces não têm uma sobrescrita válida para '{0}': {1}._

## Descrição

O analisador produz este diagnóstico quando uma classe herda duas ou mais
assinaturas conflitantes para um membro e não fornece uma implementação
que satisfaça todas as assinaturas herdadas.

## Exemplo

O código a seguir produz este diagnóstico porque `C` está herdando a
declaração de `m` de `A`, e essa implementação não é consistente com
a assinatura de `m` que é herdada de `B`:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class [!C!] extends A implements B {
}
```

## Correções comuns

Adicione uma implementação do método que satisfaça todas as assinaturas
herdadas:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class C extends A implements B {
  void m({int? a, int? b}) {}
}
```
