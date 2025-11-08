---
ia-translate: true
title: prefix_identifier_not_followed_by_dot
description: >-
  Detalhes sobre o diagnóstico prefix_identifier_not_followed_by_dot
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' refere-se a um prefixo de import, então deve ser seguido por '.'._

## Descrição

O analisador produz este diagnóstico quando um prefixo de import é usado
sozinho, sem acessar nenhum dos nomes declarados nas bibliotecas
associadas ao prefixo. Prefixos não são variáveis e, portanto, não podem
ser usados como um valor.

## Exemplo

O código a seguir produz este diagnóstico porque o prefixo `math` está
sendo usado como se fosse uma variável:

```dart
import 'dart:math' as math;

void f() {
  print([!math!]);
}
```

## Correções comuns

Se o código estiver incompleto, então referencie algo em uma das bibliotecas
associadas ao prefixo:

```dart
import 'dart:math' as math;

void f() {
  print(math.pi);
}
```

Se o nome estiver errado, então corrija o nome.
