---
ia-translate: true
title: Loops
description: "Aprenda como usar loops para controlar o fluxo do seu código Dart."
prevpage:
  url: /language/pattern-types
  title: Pattern types
nextpage:
  url: /language/branches
  title: "Ramificações"
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
for (var candidate in candidates) {
  candidate.interview();
}
```

In the previous example loop, `candidate` is
defined within the loop body and
set to reference one value from `candidates` at a time.
`candidate` is a local [variable][].
Reassigning `candidate` inside the loop body only
changes the local variable for that iteration and
doesn't modify the original `candidates` iterable.

To process the values obtained from the iterable, 
you can also use a [pattern][] in a `for-in` loop:

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

[variable]: /language/variables

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

## Labels

A label is an identifier followed by a colon (`labelName:`)
that you can place before a statement to create a
_labeled statement_. Loops and switch cases are often used as
labeled statements. A labeled statement can be referenced later
in a `break` or `continue` statement as follows:

* `break labelName;`
  Terminates the execution of the labeled statement.
  This is useful for breaking out of a specific outer loop when you're
  within a nested loop.

* `continue labelName;`
  Skips the rest of the current iteration of the
  labeled statement loop and continues with the next iteration.

Labels are used to manage control flow. They are often used with
loops and switch cases and allow you to specify which statement to
break out of or continue, rather than affecting the innermost
loop by default.

### Labels in for loop using `break` {:.no_toc}

The following code demonstrates the usage of a label called `outerLoop`
in a  `for` loop with a `break` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-for-loop-break)"?>
```dart
outerLoop:
for (var i = 1; i <= 3; i++) {
  for (var j = 1; j <= 3; j++) {
    print('i = $i, j = $j');
    if (i == 2 && j == 2) {
      break outerLoop;
    }
  }
}
print('outerLoop exited');
```

In the previous example, when `i == 2` and `j == 2`, the `break outerLoop;`
statement stops both inner and outer loops. As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels in for loop using `continue` {:.no_toc}

The following code demonstrates the use of a label called `outerLoop`
in a  `for` loop with a `continue` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-for-loop-continue)"?>
```dart
outerLoop:
for (var i = 1; i <= 3; i++) {
  for (var j = 1; j <= 3; j++) {
    if (i == 2 && j == 2) {
      continue outerLoop;
    }
    print('i = $i, j = $j');
  }
}
```

In the previous example, when `i == 2` and `j == 2`, `continue outerLoop;` skips the
rest of the iterations for `i = 2` and moves to `i = 3`. As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
```

### Labels in while loop using `break` {:.no_toc}

The following code demonstrates the use of a label called `outerLoop` in
a `while` loop with a `break` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-while-loop-break)"?>
```dart
var i = 1;

outerLoop:
while (i <= 3) {
  var j = 1;
  while (j <= 3) {
    print('i = $i, j = $j');
    if (i == 2 && j == 2) {
      break outerLoop;
    }
    j++;
  }
  i++;
}
print('outerLoop exited');
```

In the previous example, the program breaks out of both inner and outer `while` loops
when `i == 2` and `j == 2`. As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels in while loop using `continue` {:.no_toc}

The following code demonstrates the use of a label called `outerLoop` in
a `while` loop with a `continue` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-while-loop-continue)"?>
```dart
var i = 1;

outerLoop:
while (i <= 3) {
  var j = 1;
  while (j <= 3) {
    if (i == 2 && j == 2) {
      i++;
      continue outerLoop;
    }
    print('i = $i, j = $j');
    j++;
  }
  i++;
}
```

In the previous example, the iteration for `i = 2` and `j = 2` is skipped and the loop moves
directly to `i = 3`. As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
```

### Labels in do-while loop using `break` {:.no_toc}

The following code demonstrates the use of a label called `outerLoop` in
a `do while` loop with a `break` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-do-while-loop-break)"?>
```dart
var i = 1;

outerLoop:
do {
  var j = 1;
  do {
    print('i = $i, j = $j');
    if (i == 2 && j == 2) {
      break outerLoop;
    }
    j++;
  } while (j <= 3);
  i++;
} while (i <= 3);

print('outerLoop exited');
```

In the previous example, the program breaks out of both inner and outer loops when `i == 2` and
`j == 2`. As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels in do-while loop using `continue` {:.no_toc}

The following code demonstrates the use of a label called `outerLoop` in
a `do while` loop with a `continue` statement:

<?code-excerpt "language/lib/control_flow/loops.dart (label-do-while-loop-continue)"?>
```dart
var i = 1;

outerLoop:
do {
  var j = 1;
  do {
    if (i == 2 && j == 2) {
      i++;
      continue outerLoop;
    }
    print('i = $i, j = $j');
    j++;
  } while (j <= 3);
  i++;
} while (i <= 3);
```

In the previous example, the loop skips `i = 2` and `j = 2` and moves directly to `i = 3`.
As a result, the output is:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
```

[exceptions]: /language/error-handling
[branching]: /language/branches
[iteration]: /libraries/dart-core#iteration
[forEach()]: {{site.dart-api}}/dart-core/Iterable/forEach.html
[`Iterable`]: {{site.dart-api}}/dart-core/Iterable-class.html
[pattern]: /language/patterns
