---
ia-translate: true
title: undefined_class
description: "Detalhes sobre o diagnóstico undefined_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classe não definida '{0}'._

## Description

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de uma classe mas não está definido ou não está visível
no escopo em que está sendo referenciado.

## Example

O código a seguir produz este diagnóstico porque `Piont` não está definido:

```dart
class Point {}

void f([!Piont!] p) {}
```

## Common fixes

Se o identificador não está definido, então defina-o ou substitua-o pelo
nome de uma classe que está definida. O exemplo acima pode ser corrigido
corrigindo a ortografia da classe:

```dart
class Point {}

void f(Point p) {}
```

Se a classe está definida mas não está visível, então você provavelmente precisa adicionar um
import.
