---
ia-translate: true
title: non_sync_factory
description: "Detalhes sobre o diagnóstico non_sync_factory produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Corpos de factory não podem usar 'async', 'async*', ou 'sync*'._

## Description

O analisador produz este diagnóstico quando o corpo de um construtor
factory é marcado com `async`, `async*`, ou `sync*`. Todos os construtores,
incluindo construtores factory, são obrigados a retornar uma instância da
classe na qual são declarados, não um `Future`, `Stream`, ou `Iterator`.

## Example

O código a seguir produz este diagnóstico porque o corpo do construtor
factory é marcado com `async`:

```dart
class C {
  factory C() [!async!] {
    return C._();
  }
  C._();
}
```

## Common fixes

Se o membro deve ser declarado como um construtor factory, então remova a
palavra-chave que aparece antes do corpo:

```dart
class C {
  factory C() {
    return C._();
  }
  C._();
}
```

Se o membro deve retornar algo diferente de uma instância da classe envolvente,
então torne o membro um método estático:

```dart
class C {
  static Future<C> m() async {
    return C._();
  }
  C._();
}
```
