---
ia-translate: true
title: mixin_class_declaration_extends_not_object
description: "Detalhes sobre o diagnóstico mixin_class_declaration_extends_not_object produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode ser declarada como mixin porque estende uma classe diferente de 'Object'._

## Description

O analisador produz este diagnóstico quando uma classe que é marcada com
o modificador `mixin` estende uma classe diferente de `Object`. Uma mixin class
não pode ter uma superclasse diferente de `Object`.

## Example

O código a seguir produz este diagnóstico porque a classe `B`, que
tem o modificador `mixin`, estende `A`:

```dart
class A {}

mixin class B extends [!A!] {}
```

## Common fixes

Se você quer que a classe seja usada como mixin, então mude a superclasse para
`Object`, seja explicitamente ou removendo a cláusula extends:

```dart
class A {}

mixin class B {}
```

Se a classe precisa ter uma superclasse diferente de `Object`, então remova
o modificador `mixin`:

```dart
class A {}

class B extends A {}
```

Se você precisa tanto de um mixin quanto de uma subclasse de uma classe diferente de `Object`,
então mova os membros da subclasse para um novo mixin, remova o modificador `mixin`
da subclasse, e aplique o novo mixin à subclasse:

```dart
class A {}

class B extends A with M {}

mixin M {}
```

Dependendo dos membros da subclasse, isso pode exigir adicionar uma cláusula `on`
ao mixin.
