---
ia-translate: true
title: extension_declares_instance_field
description: "Detalhes sobre o diagnóstico extension_declares_instance_field produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extensions não podem declarar campos de instância._

## Descrição

O analisador produz este diagnóstico quando uma declaração de campo de instância é
encontrada em uma extension. Não é válido definir um campo de instância porque
extensions podem apenas adicionar comportamento, não estado.

## Exemplo

O código a seguir produz este diagnóstico porque `s` é um campo de
instância:

```dart
extension E on String {
  String [!s!];
}
```

## Correções comuns

Se o valor pode ser computado sem armazená-lo em um campo, então tente
usar um getter ou um método:

```dart
extension E on String {
  String get s => '';

  void s(String value) => print(s);
}
```

Se o valor precisa ser armazenado, mas é o mesmo para todas as instâncias,
tente usar um campo static:

```dart
extension E on String {
  static String s = '';
}
```

Se cada instância precisa ter seu próprio valor armazenado, então tente
usar um par de getter e setter apoiado por um `Expando` static:

```dart
extension E on SomeType {
  static final _s = Expando<String>();

  String get s => _s[this] ?? '';
  set s(String value) => _s[this] = value;
}
```
