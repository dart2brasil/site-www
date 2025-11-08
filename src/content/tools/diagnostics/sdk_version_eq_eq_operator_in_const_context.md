---
ia-translate: true
title: sdk_version_eq_eq_operator_in_const_context
description: "Detalhes sobre o diagnóstico sdk_version_eq_eq_operator_in_const_context produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O uso do operador '==' para tipos não primitivos não era suportado até a versão 2.3.2, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando o operador `==` é usado em um
tipo não primitivo dentro de um [contexto constante][] encontrado em código que tem
uma restrição de SDK cuja limite inferior é menor que 2.3.2. O uso deste operador
em um [contexto constante][] não era suportado em versões anteriores, então este
código não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
class C {}
const C a = null;
const C b = null;
const bool same = a [!==!] b;
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não usar o operador `==`, ou altere o código para que a expressão não
esteja em um [contexto constante][]:

```dart
class C {}
const C a = null;
const C b = null;
bool same = a == b;
```

[constant context]: /resources/glossary#constant-context
