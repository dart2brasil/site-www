---
ia-translate: true
title: extension_override_without_access
description: >-
  Detalhes sobre o diagnóstico extension_override_without_access
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um override de extension só pode ser usado para acessar membros de instância._

## Descrição

O analisador produz este diagnóstico quando um override de extension é encontrado
que não está sendo usado para acessar um dos membros da extension. A
sintaxe de override de extension não tem semântica em tempo de execução; ela apenas
controla qual membro é selecionado em tempo de compilação.

## Exemplo

O código a seguir produz este diagnóstico porque `E(i)` não é uma
expressão:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print([!E(i)!]);
}
```

## Correções comuns

Se você deseja invocar um dos membros da extension, então adicione a
invocação:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(E(i).a);
}
```

Se você não deseja invocar um membro, então desembrulhe o argumento:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(i);
}
```
