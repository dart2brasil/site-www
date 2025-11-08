---
ia-translate: true
title: "dart:math"
description: "Saiba mais sobre os principais recursos da biblioteca dart:math do Dart."
prevpage:
  url: /libraries/dart-async
  title: dart:async
nextpage:
  url: /libraries/dart-convert
  title: dart:convert
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

A biblioteca dart:math ([referência da API][dart:math])
fornece funcionalidades comuns como seno e cosseno,
máximo e mínimo, e constantes como *pi* e *e*. A maior parte da
funcionalidade na biblioteca Math é implementada como funções de nível superior.

Para usar esta biblioteca em seu aplicativo, importe dart:math.

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
```dart
import 'dart:math';
```


## Trigonometria {:#trigonometry}

A biblioteca Math fornece funções trigonométricas básicas:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
```dart
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
```

:::note
Essas funções usam radianos, não graus!
:::


## Máximo e mínimo {:#maximum-and-minimum}

A biblioteca Math fornece os métodos `max()` e `min()`:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
```dart
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
```


## Constantes matemáticas {:#math-constants}

Encontre suas constantes favoritas—*pi*, *e* e mais—na biblioteca Math:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
```dart
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
```


## Números aleatórios {:#random-numbers}

Gere números aleatórios com a classe [Random][] (Aleatório). Você pode,
opcionalmente, fornecer uma seed (semente) para o construtor Random.

<?code-excerpt "misc/test/library_tour/math_test.dart (random)"?>
```dart
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

Você pode até gerar booleanos aleatórios:

<?code-excerpt "misc/test/library_tour/math_test.dart (random-bool)"?>
```dart
var random = Random();
random.nextBool(); // true or false
```

:::warning
A implementação padrão de `Random` fornece um fluxo de bits pseudoaleatórios
que não são adequados para fins criptográficos.
Para criar um gerador de números aleatórios criptograficamente seguro,
use o construtor [`Random.secure()`][].
:::

## Mais informações {:#more-information}

Consulte a [referência da API Math][dart:math] para obter uma lista completa de métodos.
Consulte também a referência da API para [num,][num] [int,][int] e [double.][double]

[Random]: {{site.dart-api}}/dart-math/Random-class.html
[`Random.secure()`]: {{site.dart-api}}/dart-math/Random/Random.secure.html
[dart:math]: {{site.dart-api}}/dart-math/dart-math-library.html
[double]: {{site.dart-api}}/dart-core/double-class.html
[int]: {{site.dart-api}}/dart-core/int-class.html
[num]: {{site.dart-api}}/dart-core/num-class.html
