---
ia-translate: true
title: Loops
description: Aprenda como usar loops para controlar o fluxo do seu código Dart.
prevpage:
  url: /language/functions
  title: Funções
nextpage:
  url: /language/branches
  title: Ramificações
---

Esta página mostra como você pode controlar o fluxo do seu código Dart usando loops e
instruções de suporte:

-   loops `for`
-   loops `while` e `do while`
-   `break` e `continue`

Você também pode manipular o fluxo de controle em Dart usando:

- [Ramificações][branching], como `if` e `switch`
- [Exceções][exceptions], como `try`, `catch` e `throw`

## Loops For {:#for-loops}

Você pode iterar com o loop `for` padrão. Por exemplo:

<?code-excerpt "language/test/control_flow/loops_test.dart (for)"?>
```dart
var message = StringBuffer('Dart is fun');
for (var i = 0; i < 5; i++) {
  message.write('!');
}
```

Closures (fechamentos) dentro dos loops `for` do Dart capturam o _valor_ do índice.
Isso evita uma armadilha comum encontrada em JavaScript. Por exemplo, considere:

<?code-excerpt "language/test/control_flow/loops_test.dart (for-and-closures)"?>
```dart
var callbacks = [];
for (var i = 0; i < 2; i++) {
  callbacks.add(() => print(i));
}

for (final c in callbacks) {
  c();
}
```

A saída é `0` e depois `1`, como esperado. Em contraste, o exemplo
imprimiria `2` e depois `2` em JavaScript.

Às vezes, você pode não precisar saber o contador de iteração atual
ao iterar sobre um tipo [`Iterable`][`Iterable`], como `List` ou `Set`.
Nesse caso, use o loop `for-in` para um código mais limpo:

<?code-excerpt "language/lib/control_flow/loops.dart (collection)"?>
```dart
for (final candidate in candidates) {
  candidate.interview();
}
```

Para processar os valores obtidos do iterável,
você também pode usar um [pattern (padrão)][pattern] em um loop `for-in`:

<?code-excerpt "language/lib/control_flow/loops.dart (collection-for-pattern)"?>
```dart
for (final Candidate(:name, :yearsExperience) in candidates) {
  print('$name has $yearsExperience of experience.');
}
```

:::tip
Para praticar o uso de `for-in`, siga o
[tutorial de coleções Iterable](/libraries/collections/iterables).
:::

Classes Iterable também possuem um método [forEach()][forEach()] como outra opção:

<?code-excerpt "language/test/control_flow/loops_test.dart (for-each)"?>
```dart
var collection = [1, 2, 3];
collection.forEach(print); // 1 2 3
```

## While e do-while {:#while-and-do-while}

Um loop `while` avalia a condição antes do loop:

<?code-excerpt "language/lib/control_flow/loops.dart (while)"?>
```dart
while (!isDone()) {
  doSomething();
}
```

Um loop `do`-`while` avalia a condição *após* o loop:

<?code-excerpt "language/lib/control_flow/loops.dart (do-while)"?>
```dart
do {
  printLine();
} while (!atEndOfPage());
```

## Break e continue {:#break-and-continue}

Use `break` para interromper o loop:

<?code-excerpt "language/lib/control_flow/loops.dart (while-break)"?>
```dart
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
```

Use `continue` para pular para a próxima iteração do loop:

<?code-excerpt "language/lib/control_flow/loops.dart (for-continue)"?>
```dart
for (int i = 0; i < candidates.length; i++) {
  var candidate = candidates[i];
  if (candidate.yearsExperience < 5) {
    continue;
  }
  candidate.interview();
}
```

Se você estiver usando um [`Iterable`][`Iterable`] como uma lista ou conjunto,
a forma como você escreve o exemplo anterior pode ser diferente:

<?code-excerpt "language/lib/control_flow/loops.dart (where)"?>
```dart
candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());
```

[exceptions]: /language/error-handling
[branching]: /language/branches
[iteration]: /libraries/dart-core#iteration
[forEach()]: {{site.dart-api}}/dart-core/Iterable/forEach.html
[`Iterable`]: {{site.dart-api}}/dart-core/Iterable-class.html
[pattern]: /language/patterns
