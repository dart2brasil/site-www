---
ia-translate: true
title: deprecated_optional
description: "Detalhes sobre o diagnóstico deprecated_optional produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Omitir um argumento para o parâmetro '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando um argumento é omitido para um
parâmetro opcional anotado com `@Deprecated.optional`. Esta anotação
indica que omitir um argumento para o parâmetro está deprecated, e
o parâmetro em breve se tornará obrigatório.

## Example

Dada uma biblioteca `p` que define uma função com um parâmetro opcional
anotado com `@Deprecated.optional`:

```dart
void f({@Deprecated.optional() int a = 0}) {}
```

O código a seguir produz este diagnóstico, porque a invocação
não passa um valor para o parâmetro `a`:

```dart
import 'package:p/p.dart';

void g() {
  [!f!]();
}
```

## Common fixes

Siga quaisquer instruções específicas fornecidas na anotação `@Deprecated.optional`.

Se nenhuma instrução estiver presente, passe um argumento apropriado para o
parâmetro correspondente:


```dart
import 'package:p/p.dart';

void g() {
  f(a: 0);
}
```

Usar o valor default preservará o comportamento atual do código.
