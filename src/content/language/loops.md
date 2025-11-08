---
ia-translate: true
title: Loops
description: Aprenda como usar loops para controlar o fluxo do seu código Dart.
prevpage:
  url: /language/pattern-types
  title: Pattern types
nextpage:
  url: /language/branches
  title: Branches
---

Esta página mostra como você pode controlar o fluxo do seu código Dart usando loops e
instruções de suporte:

-   Loops `for`
-   Loops `while` e `do while`
-   `break` e `continue`

Você também pode manipular o fluxo de controle em Dart usando:

- [Branching][], como `if` e `switch`
- [Exceptions][], como `try`, `catch` e `throw`

## Loops for

Você pode iterar com o loop `for` padrão. Por exemplo:

<?code-excerpt "language/test/control_flow/loops_test.dart (for)"?>
```dart
var message = StringBuffer('Dart is fun');
for (var i = 0; i < 5; i++) {
  message.write('!');
}
```

Closures dentro dos loops `for` do Dart capturam o _valor_ do índice.
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

A saída é `0` e então `1`, como esperado. Em contraste, o exemplo
imprimiria `2` e então `2` em JavaScript.

Às vezes você pode não precisar saber o contador de iteração atual
ao iterar sobre um tipo [`Iterable`][], como `List` ou `Set`.
Nesse caso, use o loop `for-in` para um código mais limpo:

<?code-excerpt "language/lib/control_flow/loops.dart (collection)"?>
```dart
for (var candidate in candidates) {
  candidate.interview();
}
```

No exemplo de loop anterior, `candidate` é
definido dentro do corpo do loop e
configurado para referenciar um valor de `candidates` por vez.
`candidate` é uma [variável][variable] local.
Reatribuir `candidate` dentro do corpo do loop apenas
muda a variável local para aquela iteração e
não modifica o iterável original `candidates`.

Para processar os valores obtidos do iterável,
você também pode usar um [pattern][] em um loop `for-in`:

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

Classes Iterable também têm um método [forEach()][] como outra opção:

<?code-excerpt "language/test/control_flow/loops_test.dart (for-each)"?>
```dart
var collection = [1, 2, 3];
collection.forEach(print); // 1 2 3
```

[variable]: /language/variables

## While e do-while

Um loop `while` avalia a condição antes do loop:

<?code-excerpt "language/lib/control_flow/loops.dart (while)"?>
```dart
while (!isDone()) {
  doSomething();
}
```

Um loop `do`-`while` avalia a condição *depois* do loop:

<?code-excerpt "language/lib/control_flow/loops.dart (do-while)"?>
```dart
do {
  printLine();
} while (!atEndOfPage());
```


## Break e continue

Use `break` para parar o loop:

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

Se você está usando um [`Iterable`][] como uma lista ou set,
como você escreve o exemplo anterior pode diferir:

<?code-excerpt "language/lib/control_flow/loops.dart (where)"?>
```dart
candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());
```

## Labels

Um label é um identificador seguido por dois pontos (`labelName:`)
que você pode colocar antes de uma instrução para criar uma
_instrução rotulada_. Loops e cases switch são frequentemente usados como
instruções rotuladas. Uma instrução rotulada pode ser referenciada posteriormente
em uma instrução `break` ou `continue` da seguinte forma:

* `break labelName;`
  Termina a execução da instrução rotulada.
  Isso é útil para sair de um loop externo específico quando você está
  dentro de um loop aninhado.

* `continue labelName;`
  Pula o restante da iteração atual do
  loop da instrução rotulada e continua com a próxima iteração.

Labels são usados para gerenciar o fluxo de controle. Eles são frequentemente usados com
loops e cases switch e permitem que você especifique qual instrução
sair ou continuar, em vez de afetar o loop mais interno
por padrão.

### Labels em loop for usando `break` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop`
em um loop `for` com uma instrução `break`:

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

No exemplo anterior, quando `i == 2` e `j == 2`, a instrução `break outerLoop;`
para os loops interno e externo. Como resultado, a saída é:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels em loop for usando `continue` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop`
em um loop `for` com uma instrução `continue`:

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

No exemplo anterior, quando `i == 2` e `j == 2`, `continue outerLoop;` pula o
restante das iterações para `i = 2` e se move para `i = 3`. Como resultado, a saída é:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
```

### Labels em loop while usando `break` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop` em
um loop `while` com uma instrução `break`:

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

No exemplo anterior, o programa sai dos loops `while` interno e externo
quando `i == 2` e `j == 2`. Como resultado, a saída é:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels em loop while usando `continue` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop` em
um loop `while` com uma instrução `continue`:

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

No exemplo anterior, a iteração para `i = 2` e `j = 2` é pulada e o loop se move
diretamente para `i = 3`. Como resultado, a saída é:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
```

### Labels em loop do-while usando `break` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop` em
um loop `do while` com uma instrução `break`:

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

No exemplo anterior, o programa sai dos loops interno e externo quando `i == 2` e
`j == 2`. Como resultado, a saída é:

```plaintext
i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited
```

### Labels em loop do-while usando `continue` {:.no_toc}

O código a seguir demonstra o uso de um label chamado `outerLoop` em
um loop `do while` com uma instrução `continue`:

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

No exemplo anterior, o loop pula `i = 2` e `j = 2` e se move diretamente para `i = 3`.
Como resultado, a saída é:

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
