---
ia-translate: true
title: Comentários
description: Os diferentes tipos de comentários em Dart.
prevpage:
  url: /language/operators
  title: Operators
nextpage:
  url: /language/built-in-types
  title: Built-in types
---

Dart suporta comentários de linha única, comentários multi-linha e
comentários de documentação.


## Comentários de linha única

Um comentário de linha única começa com `//`. Tudo entre `//` e o
final da linha é ignorado pelo compilador Dart.

<?code-excerpt "misc/lib/language_tour/comments.dart (single-line-comments)"?>
```dart
void main() {
  // TODO: refactor into an AbstractLlamaGreetingFactory?
  print('Welcome to my Llama farm!');
}
```

## Comentários multi-linha

Um comentário multi-linha começa com `/*` e termina com `*/`. Tudo
entre `/*` e `*/` é ignorado pelo compilador Dart (a menos que o
comentário seja um comentário de documentação; veja a próxima seção). Comentários multi-linha
podem ser aninhados.

<?code-excerpt "misc/lib/language_tour/comments.dart (multi-line-comments)"?>
```dart
void main() {
  /*
   * This is a lot of work. Consider raising chickens.

  Llama larry = Llama();
  larry.feed();
  larry.exercise();
  larry.clean();
   */
}
```

## Comentários de documentação

Comentários de documentação são comentários multi-linha ou de linha única que começam
com `///` ou `/**`. Usar `///` em linhas consecutivas tem o mesmo
efeito que um comentário de documentação multi-linha.

Dentro de um comentário de documentação, o analyzer ignora todo o texto
a menos que esteja entre colchetes. Usando colchetes, você pode se referir a
classes, métodos, campos, variáveis de nível superior, funções e
parâmetros. Os nomes entre colchetes são resolvidos no escopo léxico do
elemento de programa documentado.

Aqui está um exemplo de comentários de documentação com referências a outras
classes e argumentos:

<?code-excerpt "misc/lib/language_tour/comments.dart (doc-comments)"?>
```dart
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
///
/// Just like any other animal, llamas need to eat,
/// so don't forget to [feed] them some [Food].
class Llama {
  String? name;

  /// Feeds your llama [food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Food food) {
    // ...
  }

  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
```

Na documentação gerada da classe, `[feed]` se torna um link
para a documentação do método `feed`,
e `[Food]` se torna um link para a documentação da classe `Food`.

Para analisar código Dart e gerar documentação HTML, você pode usar a
ferramenta de geração de documentação do Dart, [`dart doc`](/tools/dart-doc).
Para um exemplo de documentação gerada, veja a
[documentação da API Dart.]({{site.dart-api}})
Para conselhos sobre como estruturar seus comentários, veja
[Effective Dart: Documentation.](/effective-dart/documentation)
