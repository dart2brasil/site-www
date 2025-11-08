---
ia-translate: true
title: not_initialized_non_nullable_instance_field
description: "Detalhes sobre o diagnóstico not_initialized_non_nullable_instance_field produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Non-nullable instance field '{0}' must be initialized._

## Description

O analisador produz este diagnóstico quando um campo é declarado e possui todas
estas características:
- Possui um tipo que é [potentially non-nullable][]
- Não possui um inicializador
- Não está marcado como `late`

## Examples

O código a seguir produz este diagnóstico porque `x` é implicitamente
inicializado para `null` quando não é permitido ser `null`:

```dart
class C {
  int [!x!];
}
```

Similarmente, o código a seguir produz este diagnóstico porque `x` é
implicitamente inicializado para `null`, quando não é permitido ser `null`, por
um dos construtores, embora seja inicializado por outros
construtores:

```dart
class C {
  int x;

  C(this.x);

  [!C!].n();
}
```

## Common fixes

Se há um valor default razoável para o campo que é o mesmo para todas
as instâncias, então adicione uma expressão inicializadora:

```dart
class C {
  int x = 0;
}
```

Se o valor do campo deve ser fornecido quando uma instância é criada,
então adicione um construtor que define o valor do campo ou atualize um
construtor existente:

```dart
class C {
  int x;

  C(this.x);
}
```

Você também pode marcar o campo como `late`, o que remove o diagnóstico, mas se
o campo não for atribuído com um valor antes de ser acessado, então isso resulta
em uma exceção sendo lançada em tempo de execução. Esta abordagem só deve ser usada se
você tiver certeza de que o campo sempre será atribuído antes de ser referenciado.

```dart
class C {
  late int x;
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
