---
ia-translate: true
title: redirect_generative_to_missing_constructor
description: "Detalhes sobre o diagnóstico redirect_generative_to_missing_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor '{0}' não pôde ser encontrado em '{1}'._

## Descrição

O analisador produz este diagnóstico quando um construtor generativo
redireciona para um construtor que não está definido.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor `C.a`
redireciona para o construtor `C.b`, mas `C.b` não está definido:

```dart
class C {
  C.a() : [!this.b()!];
}
```

## Correções comuns

Se o construtor ausente deve ser chamado, defina-o:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

Se o construtor ausente não precisa ser chamado, remova o
redirecionamento:

```dart
class C {
  C.a();
}
```
