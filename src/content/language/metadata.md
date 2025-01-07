---
ia-translate: true
title: Metadados
description: Metadados e anotações em Dart.
toc: false
prevpage:
  url: /language/comments
  title: Comentários
nextpage:
  url: /language/libraries
  title: Libraries
---


Use metadados para fornecer informações adicionais sobre seu código. Uma
anotação de metadados começa com o caractere `@`, seguido por uma referência
a uma constante em tempo de compilação (como `deprecated`) ou uma chamada a
um construtor constante.

Quatro anotações estão disponíveis para todo o código Dart:
[`@Deprecated`][], [`@deprecated`][], [`@override`][], e [`@pragma`][].
Para exemplos de uso de `@override`,
veja [Estendendo uma classe][].
Aqui está um exemplo de como usar a anotação `@Deprecated`:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (deprecated)" replace="/@Deprecated.*/[!$&!]/g"?>
```dart
class Television {
  /// Use [turnOn] to turn the power on instead.
  [!@Deprecated('Use turnOn instead')!]
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {...}
  // ···
}
```

Você pode usar `@deprecated` se não quiser especificar uma mensagem.
No entanto, nós [recomendamos][dep-lint] sempre
especificar uma mensagem com `@Deprecated`.

Você pode definir suas próprias anotações de metadados. Aqui está um exemplo de
definindo uma anotação `@Todo` que recebe dois argumentos:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart"?>
```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

E aqui está um exemplo de como usar a anotação `@Todo`:

<?code-excerpt "misc/lib/language_tour/metadata/misc.dart (usage)"?>
```dart
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

Metadados podem aparecer antes de uma biblioteca, classe, `typedef`, parâmetro de tipo,
construtor, fábrica, função, campo, parâmetro ou declaração de variável
e antes de uma diretiva `import` ou `export`.

[`@Deprecated`]: {{site.dart-api}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/dart-core/pragma-class.html
[dep-lint]: /tools/linter-rules/provide_deprecation_message
[Estendendo uma classe]: /language/extend
