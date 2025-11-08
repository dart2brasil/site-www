---
ia-translate: true
title: enum_mixin_with_instance_variable
description: >-
  Detalhes sobre o diagnóstico enum_mixin_with_instance_variable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Mixins aplicados a enums não podem ter variáveis de instância._

## Descrição

O analisador produz este diagnóstico quando um mixin que é aplicado a um
enum declara uma ou mais variáveis de instância. Isso não é permitido porque
os valores do enum são constantes, e não há nenhuma forma para o construtor
no enum inicializar qualquer um dos campos do mixin.

## Exemplo

O código a seguir produz este diagnóstico porque o mixin `M` define
o campo de instância `x`:

```dart
mixin M {
  int x = 0;
}

enum E with [!M!] {
  a
}
```

## Correções comuns

Se você precisar aplicar o mixin, então altere todos os campos de instância em
pares de getter e setter e implemente-os no enum se necessário:

```dart
mixin M {
  int get x => 0;
}

enum E with M {
  a
}
```

Se você não precisar aplicar o mixin, então remova-o:

```dart
enum E {
  a
}
```
