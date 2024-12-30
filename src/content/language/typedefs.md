---
ia-translate: true
title: Typedefs
description: Saiba mais sobre aliases de tipo em Dart.
toc: false
prevpage:
  url: /language/generics
  title: Generics
nextpage:
  url: /language/type-system
  title: Sistema de tipos
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Um alias de tipo—frequentemente chamado de _typedef_ porque
é declarado com a palavra-chave `typedef`—é uma maneira
concisa de se referir a um tipo.
Aqui está um exemplo de como declarar e usar um alias de tipo chamado `IntList`:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (int-list)"?>
```dart
typedef IntList = List<int>;
IntList il = [1, 2, 3];
```

Um alias de tipo pode ter parâmetros de tipo:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (list-mapper)"?>
```dart
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verboroso.
ListMapper<String> m2 = {}; // A mesma coisa, mas mais curto e claro.
```

:::version-note
Antes da versão 2.13, typedefs eram restritos a tipos de função.
Usar os novos typedefs requer uma [versão da linguagem][language version] de pelo menos 2.13.
:::

Recomendamos usar [tipos de função inline][inline function types] em vez de typedefs para funções,
na maioria das situações.
No entanto, typedefs de função ainda podem ser úteis:

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
