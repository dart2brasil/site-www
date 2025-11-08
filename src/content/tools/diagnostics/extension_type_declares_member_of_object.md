---
ia-translate: true
title: extension_type_declares_member_of_object
description: "Detalhes sobre o diagnóstico extension_type_declares_member_of_object produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension types não podem declarar membros com o mesmo nome de um membro declarado por 'Object'._

## Descrição

O analisador produz este diagnóstico quando o corpo de uma declaração de extension type
contém um membro com o mesmo nome de um dos membros
declarados por `Object`.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `Object`
já define um membro chamado `hashCode`:

```dart
extension type E(int i) {
  int get [!hashCode!] => 0;
}
```

## Correções comuns

Se você precisa de um membro com a semântica implementada, então renomeie o
membro:

```dart
extension type E(int i) {
  int get myHashCode => 0;
}
```

Se você não precisa de um membro com a semântica implementada, então remova o
membro:

```dart
extension type E(int i) {}
```
