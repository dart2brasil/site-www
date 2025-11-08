---
ia-translate: true
title: const_set_element_not_primitive_equality
description: "Detalhes sobre o diagnóstico const_set_element_not_primitive_equality produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_(Anteriormente conhecido como `const_set_element_type_implements_equals`)_

_An element in a constant set can't override the '==' operator, or 'hashCode', but the type '{0}' does._

## Descrição

O analisador produz este diagnóstico quando a classe do objeto usado como
elemento em um literal de Set constante implementa o operador `==`, o
getter `hashCode`, ou ambos. A implementação de Sets constantes usa tanto
o operador `==` quanto o getter `hashCode`, então qualquer implementação
diferente daquelas herdadas de `Object` requer executar código arbitrário em
tempo de compilação, o que não é suportado.

## Exemplo

O código a seguir produz este diagnóstico porque o Set constante
contém um elemento cujo tipo é `C`, e a classe `C` sobrescreve a
implementação de `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const set = {[!C()!]};
```

O código a seguir produz este diagnóstico porque o Set constante
contém um elemento cujo tipo é `C`, e a classe `C` sobrescreve a
implementação de `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!]};
```

## Correções comuns

Se você pode remover a implementação de `==` e `hashCode` da
classe, então faça isso:

```dart
class C {
  const C();
}

const set = {C()};
```

Se você não pode remover a implementação de `==` e `hashCode` da
classe, então torne o Set não constante:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final set = {C()};
```
