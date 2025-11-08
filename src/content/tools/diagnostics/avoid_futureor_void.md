---
ia-translate: true
title: avoid_futureor_void
description: >-
  Detalhes sobre o diagnóstico avoid_futureor_void
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_futureor_void"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não use o tipo 'FutureOr<void>'._

## Description

O analisador produz este diagnóstico quando o tipo `FutureOr<void>`
é usado como o tipo de um resultado (para ser preciso: é usado em uma
posição que não é contravariante). O tipo `FutureOr<void>` é
problemático porque pode parecer codificar que um resultado é um
`Future<void>`, ou o resultado deve ser descartado (quando é
`void`). No entanto, não há uma maneira segura de detectar se temos um
ou outro caso porque uma expressão do tipo `void` pode avaliar
para qualquer objeto, incluindo um future de qualquer tipo.

Também é conceitualmente inconsistente ter um tipo cujo significado é
algo como "ignore este objeto; também, dê uma olhada porque pode
ser um future".

Uma exceção é feita para ocorrências contravariantes do tipo
`FutureOr<void>` (por exemplo, para o tipo de um parâmetro formal), e nenhum
aviso é emitido para essas ocorrências. A razão para esta
exceção é que o tipo não descreve um resultado, ele descreve uma
restrição sobre um valor fornecido por outros. Similarmente, uma exceção é
feita para declarações de alias de tipo, porque elas podem ser usadas em uma
posição contravariante (por exemplo, como o tipo de um parâmetro
formal). Portanto, em declarações de alias de tipo, apenas os limites dos
parâmetros de tipo são verificados.

## Example

```dart
import 'dart:async';

[!FutureOr<void>!] m() => null;
```

## Common fixes

Uma substituição para o tipo `FutureOr<void>` que é frequentemente útil é
`Future<void>?`. Este tipo codifica que um resultado é um
`Future<void>` ou é null, e não há ambiguidade em tempo de execução
já que nenhum objeto pode ter ambos os tipos.

Nem sempre é possível usar o tipo `Future<void>?` como uma
substituição para o tipo `FutureOr<void>`, porque este último é um
supertipo de todos os tipos, e o primeiro não é. Neste caso, pode ser um
remédio útil substituir `FutureOr<void>` pelo tipo `void`.
