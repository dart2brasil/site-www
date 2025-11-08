---
ia-translate: true
title: remove_deprecations_in_breaking_versions
description: "Detalhes sobre o diagnóstico remove_deprecations_in_breaking_versions produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Remova elementos obsoletos em versões breaking._

## Description

O analisador produz este diagnóstico em pacotes que têm um número de versão
"breaking" (`x.0.0` ou `0.x.0`) para toda declaração que tem uma
anotação `@Deprecated`.

## Example

Dado um pacote com um arquivo `pubspec.yaml` contendo:

```yaml
name: p
version: 2.0.0
environment:
  sdk: ^3.9.0
```

O código a seguir produz este diagnóstico porque a função `f` está
anotada com `@deprecated`:

```dart
@[!deprecated!]
void f() {}

void g() {}
```

## Common fixes

* Se a declaração deve ser removida na próxima versão do pacote,
então remova a declaração:

```dart
void g() {}
```

* Se você não está fazendo uma mudança breaking, então use um incremento de versão
  minor ou patch para o pacote:

```yaml
name: p
version: 1.0.1
environment:
  sdk: ^3.9.0
```
