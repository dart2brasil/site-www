---
title: late_final_local_already_assigned
description: "Detalhes sobre o diagnóstico late_final_local_already_assigned produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A variável local late final já foi atribuída._

## Descrição

O analisador produz este diagnóstico quando o analisador pode provar que uma
variável local marcada como `late` e `final` já foi atribuída com um
valor no ponto onde outra atribuição ocorre.

Como variáveis `final` só podem ser atribuídas uma vez, atribuições subsequentes
têm garantia de falhar, então elas são sinalizadas.

## Exemplo

O código a seguir produz este diagnóstico porque a variável `final`
`v` é atribuída com um valor em dois lugares:

```dart
int f() {
  late final int v;
  v = 0;
  [!v!] += 1;
  return v;
}
```

## Correções comuns

Se você precisa ser capaz de reatribuir a variável, então remova a palavra-chave `final`:

```dart
int f() {
  late int v;
  v = 0;
  v += 1;
  return v;
}
```

Se você não precisa reatribuir a variável, então remova todas as atribuições exceto a
primeira:

```dart
int f() {
  late final int v;
  v = 0;
  return v;
}
```
