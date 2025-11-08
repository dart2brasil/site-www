---
ia-translate: true
title: Typedefs
description: Aprenda sobre type aliases em Dart.
showToc: false
prevpage:
  url: /language/generics
  title: Generics
nextpage:
  url: /language/type-system
  title: Type system
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Um type alias—frequentemente chamado de _typedef_ porque
é declarado com a keyword `typedef`—é
uma forma concisa de se referir a um tipo.
Aqui está um exemplo de declaração e uso de um type alias chamado `IntList`:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (int-list)"?>
```dart
typedef IntList = List<int>;
IntList il = [1, 2, 3];
```

Um type alias pode ter parâmetros de tipo:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (list-mapper)"?>
```dart
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verbose.
ListMapper<String> m2 = {}; // Same thing but shorter and clearer.
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
  assert(sort is Compare<int>); // True!
}
```

[language version]: /resources/language/evolution#language-versioning
[inline function types]: /effective-dart/design#prefer-inline-function-types-over-typedefs
