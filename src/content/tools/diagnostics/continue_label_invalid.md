---
ia-translate: true
title: continue_label_invalid
description: "Detalhes sobre o diagnóstico continue_label_invalid produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_(Anteriormente conhecido como `continue_label_on_switch`)_

_The label used in a 'continue' statement must be defined on either a loop or a switch member._

## Descrição

O analisador produz este diagnóstico quando o label em uma declaração
`continue` resolve para um label em uma declaração `switch`.

## Exemplo

O código a seguir produz este diagnóstico porque o label `l`, usado para
rotular uma declaração `switch`, é usado na declaração `continue`:

```dart
void f(int i) {
  l: switch (i) {
    case 0:
      [!continue l;!]
  }
}
```

## Correções comuns

Encontre uma maneira diferente de alcançar o fluxo de controle necessário;
por exemplo, introduzindo um loop que re-execute a declaração `switch`.
