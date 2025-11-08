---
ia-translate: true
title: depend_on_referenced_packages
description: >-
  Detalhes sobre o diagnóstico depend_on_referenced_packages
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/depend_on_referenced_packages"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O pacote importado '{0}' não é uma dependência do pacote importador._

## Description

O analisador produz este diagnóstico quando um import de pacote se refere a um
pacote que não está especificado no arquivo `pubspec.yaml`.

Depender explicitamente de pacotes que você referencia garante que eles sempre
existam e permite que você coloque uma restrição de dependência neles para
se proteger contra mudanças incompatíveis.

## Example

Dado um arquivo `pubspec.yaml` contendo o seguinte:

```yaml
dependencies:
  meta: ^3.0.0
```

O código a seguir produz este diagnóstico porque não há dependência
no pacote `a`:

```dart
import 'package:a/a.dart';
```

## Common fixes

Se a dependência deve ser uma dependência regular ou dev dependency
depende se o pacote é referenciado de uma biblioteca pública (uma
sob `lib` ou `bin`), ou apenas bibliotecas privadas, (como uma
sob `test`).

Se o pacote é referenciado de pelo menos uma biblioteca pública, então adicione uma
dependência regular no pacote ao arquivo `pubspec.yaml` sob o
campo `dependencies`:

```yaml
dependencies:
  a: ^1.0.0
  meta: ^3.0.0
```

Se o pacote é referenciado apenas de bibliotecas privadas, então adicione uma
dev dependency no pacote ao arquivo `pubspec.yaml` sob o
campo `dev_dependencies`:

```yaml
dependencies:
  meta: ^3.0.0
dev_dependencies:
  a: ^1.0.0
```
