---
ia-translate: true
title: undefined_identifier_await
description: "Detalhes sobre o diagnóstico undefined_identifier_await produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nome indefinido 'await' em corpo de função não marcado com 'async'._

## Descrição

O analisador produz este diagnóstico quando o nome `await` é usado em um
corpo de método ou função sem ser declarado, e o corpo não está marcado
com a keyword `async`. O nome `await` apenas introduz uma expressão await
em uma função assíncrona.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `await` é
usado no corpo de `f` mesmo que o corpo de `f` não esteja marcado com a
keyword `async`:

```dart
void f(p) { [!await!] p; }
```

## Correções comuns

Adicione a keyword `async` ao corpo da função:

```dart
void f(p) async { await p; }
```
