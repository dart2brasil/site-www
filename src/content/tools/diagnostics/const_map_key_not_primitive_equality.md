---
ia-translate: true
title: const_map_key_not_primitive_equality
description: "Detalhes sobre o diagnóstico const_map_key_not_primitive_equality produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type of a key in a constant map can't override the '==' operator, or 'hashCode', but the class '{0}' does._

## Descrição

O analisador produz este diagnóstico quando a classe do objeto usado como
chave em um literal de Map constante implementa o operador `==`, o
getter `hashCode`, ou ambos. A implementação de Maps constantes usa tanto
o operador `==` quanto o getter `hashCode`, então qualquer implementação
diferente daquelas herdadas de `Object` requer executar código arbitrário em
tempo de compilação, o que não é suportado.

## Exemplos

O código a seguir produz este diagnóstico porque o Map constante
contém uma chave cujo tipo é `C`, e a classe `C` sobrescreve a
implementação de `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const map = {[!C()!] : 0};
```

O código a seguir produz este diagnóstico porque o Map constante
contém uma chave cujo tipo é `C`, e a classe `C` sobrescreve a
implementação de `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!] : 0};
```

## Correções comuns

Se você pode remover a implementação de `==` e `hashCode` da
classe, então faça isso:

```dart
class C {
  const C();
}

const map = {C() : 0};
```

Se você não pode remover a implementação de `==` e `hashCode` da
classe, então torne o Map não constante:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final map = {C() : 0};
```
