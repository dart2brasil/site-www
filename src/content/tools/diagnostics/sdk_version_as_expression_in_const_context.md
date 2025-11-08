---
ia-translate: true
title: sdk_version_as_expression_in_const_context
description: "Detalhes sobre o diagnóstico sdk_version_as_expression_in_const_context produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O uso de uma expressão as em uma expressão constante não era suportado até a versão 2.3.2, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando uma expressão `as` dentro de um
[contexto constante][] é encontrada em código que tem uma restrição de SDK cuja
limite inferior é menor que 2.3.2. O uso de uma expressão `as` em um
[contexto constante][] não era suportado em versões anteriores, então este código
não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
const num n = 3;
const int i = [!n as int!];
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que a expressão seja usada:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não usar uma expressão `as`, ou altere o código para que a expressão `as` não
esteja em um [contexto constante][]:

```dart
num x = 3;
int y = x as int;
```

[constant context]: /resources/glossary#constant-context
