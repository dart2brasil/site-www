---
ia-translate: true
title: deprecated_subclass
description: "Detalhes sobre o diagnóstico deprecated_subclass produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Criar subclasse de '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando uma classe anotada com
`@Deprecated.subclass` é usada na cláusula `extends` de uma declaração de classe,
ou na cláusula `implements` de uma declaração de classe ou enum.

Esta anotação indica que estender ou implementar a classe anotada
está deprecated e em breve será removido. Esta mudança provavelmente será
aplicada marcando a classe com `final` ou `sealed`.

## Example

Se a biblioteca `p` define uma classe anotada com `@Deprecated.subclass`:

```dart
@Deprecated.subclass()
class C {}
```

Então, em qualquer biblioteca diferente de `p`, o código a seguir produz este
diagnóstico:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Common fixes

Siga quaisquer instruções específicas fornecidas na anotação `@Deprecated.subclass`.
Caso contrário, remova a cláusula `extends` relevante ou remova o
nome da classe da cláusula `implements`:

```dart
class D {}
```
