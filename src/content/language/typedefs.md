---
ia-translate: true
title: Typedefs
description: Aprenda sobre aliases de tipo em Dart.
toc: false
prevpage:
  url: /language/generics
  title: Generics
nextpage:
  url: /language/type-system
  title: Sistema de tipos
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Um alias de tipo—frequentemente chamado de _typedef_ (definição de tipo) porque
é declarado com a palavra-chave `typedef`—é
uma forma concisa de se referir a um tipo.
Aqui está um exemplo de declaração e uso de um alias de tipo chamado `IntList`:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (int-list)"?>
```dart
typedef IntList = List<int>;
IntList il = [1, 2, 3];
```

Um alias de tipo pode ter parâmetros de tipo:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (list-mapper)"?>
```dart
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verbose. (Verborrágico)
ListMapper<String> m2 = {}; // Mesmo resultado, mas mais curto e claro.
```

:::version-note
Antes da versão 2.13, typedefs (definições de tipo) eram restritos a tipos de função.
Usar os novos typedefs (definições de tipo) requer uma [versão da linguagem][] de pelo menos 2.13.
:::

Recomendamos usar [tipos de função inline][] em vez de typedefs (definições de tipo) para funções,
na maioria das situações.
No entanto, typedefs (definições de tipo) de função ainda podem ser úteis:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (compare)"?>
```dart
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // Verdadeiro!
}
```

[language version]: /resources/language/evolution#language-versioning
[inline function types]: /effective-dart/design#prefer-inline-function-types-over-typedefs
