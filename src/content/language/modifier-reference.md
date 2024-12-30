---
ia-translate: true
title: Referência de modificadores de classe
description: >-
  As combinações permitidas e não permitidas de modificadores de classe.
prevpage:
  url: /language/class-modifiers
  title: Modificadores de classe
nextpage:
  url: /language/concurrency
  title: Concorrência em Dart
---

Esta página contém informações de referência para
[modificadores de classe](/language/class-modifiers).

## Combinações válidas

As combinações válidas de modificadores de classe e suas capacidades resultantes são:

| Declaração                 | [Construir][Construct]? | [Estender][Extend]? | [Implementar][Implement]? | [Mix in][Mix in]? | [Exaustivo][Exhaustive]? |
|-----------------------------|----------------|-------------|----------------|-------------|-----------------|
| `class`                     | **Sim**        | **Sim**     | **Sim**        | Não          | Não              |
| `base class`                | **Sim**        | **Sim**     | Não             | Não          | Não              |
| `interface class`           | **Sim**        | Não          | **Sim**        | Não          | Não              |
| `final class`               | **Sim**        | Não          | Não             | Não          | Não              |
| `sealed class`              | Não             | Não          | Não             | Não          | **Sim**         |
| `abstract class`            | Não             | **Sim**     | **Sim**        | Não          | Não              |
| `abstract base class`       | Não             | **Sim**     | Não             | Não          | Não              |
| `abstract interface class`  | Não             | Não          | **Sim**        | Não          | Não              |
| `abstract final class`      | Não             | Não          | Não             | Não          | Não              |
| `mixin class`               | **Sim**        | **Sim**     | **Sim**        | **Sim**     | Não              |
| `base mixin class`          | **Sim**        | **Sim**     | Não             | **Sim**     | Não              |
| `abstract mixin class`      | Não             | **Sim**     | **Sim**        | **Sim**     | Não              |
| `abstract base mixin class` | Não             | **Sim**     | Não             | **Sim**     | Não              |
| `mixin`                     | Não             | Não          | **Sim**        | **Sim**     | Não              |
| `base mixin`                | Não             | Não          | Não             | **Sim**     | Não              |

{:.table .table-striped .nowrap}

[Construct]: /language/classes#using-constructors
[Extend]: /language/extend
[Implement]: /language/classes#implicit-interfaces
[Mix in]: /language/mixins
[Exhaustive]: /language/branches#exhaustiveness-checking

## Combinações inválidas

Certas [combinações](/language/class-modifiers#combining-modifiers)
de modificadores não são permitidas:

| Combinação                                   | Raciocínio                                                                                                                                 |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `base`, `interface` e `final`              | Todos controlam as mesmas duas capacidades (`extend` e `implement`), portanto, são mutuamente exclusivas.                           |
| `sealed` e `abstract`                       | Nenhum pode ser construído, então são redundantes juntos.                                                                                 |
| `sealed` com `base`, `interface` ou `final` | Tipos `sealed` já não podem ser misturados, estendidos ou implementados de outra biblioteca, por isso é redundante combinar com os modificadores listados. |
| `mixin` e `abstract`                        | Nenhum pode ser construído, então são redundantes juntos.                                                                                 |
| `mixin` e `interface`, `final` ou `sealed` | Uma declaração `mixin` ou `mixin class` destina-se a ser misturada, o que os modificadores listados impedem.                             |
| `enum` e quaisquer modificadores             | Declarações `enum` não podem ser estendidas, implementadas, misturadas e sempre podem ser instanciadas, então nenhum modificador se aplica a declarações `enum`. |
| `extension type` e quaisquer modificadores    | Declarações `extension type` não podem ser estendidas ou misturadas e só podem ser implementadas por outras declarações `extension type`.             |

{:.table .table-striped .nowrap}
