---
ia-translate: true
title: collection_element_from_deferred_library
description: "Detalhes sobre o diagnóstico collection_element_from_deferred_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores constantes de uma biblioteca deferred não podem ser usados como chaves em um literal de map 'const'._

_Valores constantes de uma biblioteca deferred não podem ser usados como valores em um construtor 'const'._

_Valores constantes de uma biblioteca deferred não podem ser usados como valores em um literal de list 'const'._

_Valores constantes de uma biblioteca deferred não podem ser usados como valores em um literal de map 'const'._

_Valores constantes de uma biblioteca deferred não podem ser usados como valores em um literal de set 'const'._

## Description

O analisador produz este diagnóstico quando um literal de coleção que é
explicitamente (porque é prefixado pela keyword `const`) ou
implicitamente (porque aparece em um [constant context][]) uma constante
contém um valor que é declarado em uma biblioteca que é importada usando um
deferred import. Constantes são avaliadas em tempo de compilação, e valores de
bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca de forma lazy](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque o literal de list constante
contém `a.zero`, que é importado usando um `deferred` import:

```dart
import 'a.dart' deferred as a;

var l = const [a.[!zero!]];
```

## Common fixes

Se o literal de coleção não precisa ser constante, então remova a
keyword `const`:

```dart
import 'a.dart' deferred as a;

var l = [a.zero];
```

Se a coleção precisa ser constante e a constante importada deve
ser referenciada, então remova a keyword `deferred` do import:

```dart
import 'a.dart' as a;

var l = const [a.zero];
```

Se você não precisa referenciar a constante, então substitua-a por um
valor adequado:

```dart
var l = const [0];
```

[constant context]: /resources/glossary#constant-context
