---
ia-translate: true
title: subtype_of_base_or_final_is_not_base_final_or_sealed
description: "Detalhes sobre o diagnóstico subtype_of_base_or_final_is_not_base_final_or_sealed produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O mixin '{0}' deve ser 'base' porque o supertipo '{1}' é 'base'._

_O mixin '{0}' deve ser 'base' porque o supertipo '{1}' é 'final'._

_O tipo '{0}' deve ser 'base', 'final' ou 'sealed' porque o supertipo '{1}' é 'base'._

_O tipo '{0}' deve ser 'base', 'final' ou 'sealed' porque o supertipo '{1}' é 'final'._

## Descrição

O analisador produz este diagnóstico quando uma classe ou mixin tem um
supertipo direto ou indireto que é `base` ou `final`, mas a própria classe ou
mixin não está marcada como `base`, `final` ou `sealed`.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `B` é um
subtipo de `A`, e `A` é uma classe `base`, mas `B` não é `base`,
`final` ou `sealed`:

```dart
base class A {}
class [!B!] extends A {}
```

## Correções comuns

Adicione `base`, `final` ou `sealed` à declaração da classe ou mixin:

```dart
base class A {}
final class B extends A {}
```
