---
ia-translate: true
title: extension_type_representation_depends_on_itself
description: "Detalhes sobre o diagnóstico extension_type_representation_depends_on_itself produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A representação de extension type não pode depender de si mesma._

## Descrição

O analisador produz este diagnóstico quando um extension type tem um
tipo de representação que depende do próprio extension type, seja
diretamente ou indiretamente.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo de representação
do extension type `A` depende de `A` diretamente:

```dart
extension type [!A!](A a) {}
```

Os dois exemplos de código a seguir produzem este diagnóstico porque o
tipo de representação do extension type `A` depende de `A`
indiretamente através do extension type `B`:

```dart
extension type [!A!](B b) {}

extension type [!B!](A a) {}
```

```dart
extension type [!A!](List<B> b) {}

extension type [!B!](List<A> a) {}
```

## Correções comuns

Remova a dependência escolhendo um tipo de representação diferente para pelo
menos um dos tipos no ciclo:

```dart
extension type A(String s) {}
```
