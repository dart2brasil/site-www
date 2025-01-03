---
ia-translate: true
title: Comentários
description: Os diferentes tipos de comentários em Dart.
prevpage:
  url: /language/operators
  title: Operadores
nextpage:
  url: /language/metadata
  title: Metadados
---

O Dart suporta comentários de uma linha, comentários de várias linhas e
comentários de documentação.


## Comentários de uma linha {:#single-line-comments}

Um comentário de uma linha começa com `//`. Tudo entre `//` e o
final da linha é ignorado pelo compilador Dart.

<?code-excerpt "misc/lib/language_tour/comments.dart (single-line-comments)"?>
```dart
void main() {
  // TODO: refatorar para uma AbstractLlamaGreetingFactory?
  print('Bem-vindo à minha fazenda de Lhamas!');
}
```

## Comentários de várias linhas {:#multi-line-comments}

Um comentário de várias linhas começa com `/*` e termina com `*/`. Tudo
entre `/*` e `*/` é ignorado pelo compilador Dart (a menos que o
comentário seja um comentário de documentação; veja a próxima seção). Comentários de
várias linhas podem ser aninhados.

<?code-excerpt "misc/lib/language_tour/comments.dart (multi-line-comments)"?>
```dart
void main() {
  /*
   * Isso é muito trabalhoso. Considere criar galinhas.

  Llama larry = Llama();
  larry.feed();
  larry.exercise();
  larry.clean();
   */
}
```

## Comentários de documentação {:#documentation-comments}

Comentários de documentação são comentários de várias linhas ou de uma linha que começam
com `///` ou `/**`. Usar `///` em linhas consecutivas tem o mesmo
efeito que um comentário de documentação de várias linhas.

Dentro de um comentário de documentação, o analisador ignora todo o texto,
a menos que esteja entre colchetes. Usando colchetes, você pode se referir a
classes, métodos, campos, variáveis de nível superior (top-level), funções e
parâmetros. Os nomes entre colchetes são resolvidos no escopo léxico do
elemento do programa documentado.

Aqui está um exemplo de comentários de documentação com referências a outras
classes e argumentos:

<?code-excerpt "misc/lib/language_tour/comments.dart (doc-comments)"?>
```dart
/// Um camelídeo domesticado da América do Sul (Lama glama).
///
/// As culturas andinas usam lhamas como fonte de carne e como
/// animais de carga desde os tempos pré-hispânicos.
///
/// Assim como qualquer outro animal, as lhamas precisam comer,
/// então não se esqueça de [feed] (alimentá-las) com alguma [Food] (comida).
class Llama {
  String? name;

  /// Alimenta sua lhama [food].
  ///
  /// A lhama típica come um fardo de feno por semana.
  void feed(Food food) {
    // ...
  }

  /// Exercita sua lhama com uma [activity] (atividade) por
  /// [timeLimit] (limite de tempo) minutos.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
```

Na documentação gerada da classe, `[feed]` torna-se um link
para a documentação do método `feed`,
e `[Food]` torna-se um link para a documentação da classe `Food`.

Para analisar o código Dart e gerar documentação HTML, você pode usar a ferramenta
de geração de documentação do Dart, [`dart doc`](/tools/dart-doc).
Para um exemplo de documentação gerada, consulte a
[documentação da API Dart]({{site.dart-api}}).
Para obter conselhos sobre como estruturar seus comentários, consulte
[Effective Dart: Documentação](/effective-dart/documentation).
