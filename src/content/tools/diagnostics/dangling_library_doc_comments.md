---
ia-translate: true
title: dangling_library_doc_comments
description: >-
  Detalhes sobre o diagnóstico dangling_library_doc_comments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/dangling_library_doc_comments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Comentário de documentação de biblioteca solto._

## Descrição

O analisador produz este diagnóstico quando um comentário de documentação que
parece ser documentação de biblioteca não é seguido por uma diretiva `library`.
Mais especificamente, ele é produzido quando um comentário de documentação
aparece antes da primeira diretiva na biblioteca, assumindo que não seja
uma diretiva `library`, ou antes da primeira declaração de nível superior e está
separado da declaração por uma ou mais linhas em branco.

## Exemplo

O código a seguir produz este diagnóstico porque há um
comentário de documentação antes da primeira diretiva `import`:

```dart
[!/// This is a great library.!]
import 'dart:core';
```

O código a seguir produz este diagnóstico porque há um
comentário de documentação antes da primeira declaração de classe, mas há uma
linha em branco entre o comentário e a declaração.

```dart
[!/// This is a great library.!]

class C {}
```

## Correções comuns

Se o comentário for documentação de biblioteca, então adicione uma diretiva `library`
sem nome:

```dart
/// This is a great library.
library;

import 'dart:core';
```

Se o comentário for documentação para a declaração seguinte, então remova
a linha em branco:

```dart
/// This is a great library.
class C {}
```
