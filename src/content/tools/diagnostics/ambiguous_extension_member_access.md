---
ia-translate: true
title: ambiguous_extension_member_access
description: >-
  Detalhes sobre o diagnóstico ambiguous_extension_member_access
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um membro chamado '{0}' está definido em '{1}' e '{2}', e nenhum é mais específico._

_Um membro chamado '{0}' está definido em {1}, e nenhum é mais específico._

## Descrição

Quando o código se refere a um membro de um objeto (por exemplo, `o.m()` ou `o.m` ou
`o[i]`) onde o tipo estático de `o` não declara o membro (`m` ou
`[]`, por exemplo), então o analisador tenta encontrar o membro em uma
extension. Por exemplo, se o membro é `m`, então o analisador procura por
extensions que declaram um membro chamado `m` e têm um tipo estendido ao qual
o tipo estático de `o` pode ser atribuído. Quando há mais de uma extension
no escopo, a extension cujo tipo estendido é mais específico é
selecionada.

O analisador produz este diagnóstico quando nenhuma das extensions tem um
tipo estendido que seja mais específico do que os tipos estendidos de todas as
outras extensions, tornando a referência ao membro ambígua.

## Exemplo

O código a seguir produz este diagnóstico porque não há forma de
escolher entre o membro em `E1` e o membro em `E2`:

```dart
extension E1 on String {
  int get charCount => 1;
}

extension E2 on String {
  int get charCount => 2;
}

void f(String s) {
  print(s.[!charCount!]);
}
```

## Correções comuns

Se você não precisa de ambas as extensions, então você pode deletar ou ocultar uma delas.

Se você precisa de ambas, então selecione explicitamente a que você quer usar usando
um override de extension:

```dart
extension E1 on String {
  int get charCount => length;
}

extension E2 on String {
  int get charCount => length;
}

void f(String s) {
  print(E2(s).charCount);
}
```
