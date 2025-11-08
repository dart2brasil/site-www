---
ia-translate: true
title: unused_element
description: >-
  Detalhes sobre o diagnóstico unused_element
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A declaração '{0}' não é referenciada._

## Descrição

O analisador produz este diagnóstico quando uma declaração privada não é
referenciada na biblioteca que contém a declaração. Os seguintes
tipos de declarações são analisados:
- Declarações privadas de nível superior e todos os seus membros
- Membros privados de declarações públicas

Nem todas as referências a um elemento irão marcá-lo como "usado":
- Atribuir um valor a uma variável de nível superior (com uma atribuição `=`
  padrão, ou uma atribuição null-aware `??=`) não conta como usar
  ela.
- Referenciar um elemento em uma referência de comentário de documentação não conta como
  usá-lo.
- Referenciar uma classe, mixin ou enum no lado direito de uma expressão `is`
  não conta como usá-lo.

## Exemplo

Assumindo que nenhum código na biblioteca referencia `_C`, o código a seguir
produz este diagnóstico:

```dart
class [!_C!] {}
```

## Correções comuns

Se a declaração não é necessária, então remova-a.

Se a declaração pretende ser usada, então adicione o código para usá-la.
