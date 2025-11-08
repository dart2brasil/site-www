---
ia-translate: true
title: sdk_version_gt_gt_gt_operator
description: "Detalhes sobre o diagnóstico sdk_version_gt_gt_gt_operator produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operador '>>>' não era suportado até a versão 2.14.0, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando o operador `>>>` é usado em
código que tem uma restrição de SDK cuja limite inferior é menor que 2.14.0. Este
operador não era suportado em versões anteriores, então este código não será capaz
de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.14.0:

```yaml
environment:
 sdk: '>=2.0.0 <2.15.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
int x = 3 [!>>>!] 4;
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.14.0 <2.15.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não usar o operador `>>>`:

```dart
int x = logicalShiftRight(3, 4);

int logicalShiftRight(int leftOperand, int rightOperand) {
  int divisor = 1 << rightOperand;
  if (divisor == 0) {
    return 0;
  }
  return leftOperand ~/ divisor;
}
```
