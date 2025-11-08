---
ia-translate: true
title: field_initializer_redirecting_constructor
description: "Detalhes sobre o diagnóstico field_initializer_redirecting_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor de redirecionamento não pode ter um inicializador de campo._

## Descrição

O analisador produz este diagnóstico quando um construtor de redirecionamento
inicializa um campo no objeto. Isso não é permitido porque a instância
que possui o campo não foi criada no ponto em que deveria ser
inicializada.

## Exemplos

O código a seguir produz este diagnóstico porque o construtor
`C.zero`, que redireciona para o construtor `C`, possui um parâmetro formal
inicializador que inicializa o campo `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero([!this.f!]) : this(f);
}
```

O código a seguir produz este diagnóstico porque o construtor
`C.zero`, que redireciona para o construtor `C`, possui um inicializador que
inicializa o campo `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : [!f = 0!], this(1);
}
```

## Correções comuns

Se a inicialização for feita por um parâmetro formal inicializador, então
use um parâmetro normal:

```dart
class C {
  int f;

  C(this.f);

  C.zero(int f) : this(f);
}
```

Se a inicialização for feita em um inicializador, então remova o
inicializador:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : this(0);
}
```
