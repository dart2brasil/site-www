---
ia-translate: true
title: Sound null safety
breadcrumb: Null safety
description: Uma introdução ao null safety no Dart.
---

A linguagem Dart impõe sound null safety,
tornando impossível acessar acidentalmente um membro de um valor `null`.

No Dart, os tipos são non-nullable por padrão.
Variáveis de tipos non-nullable devem ser inicializadas
e só podem receber valores non-null.

O analisador e os compiladores do Dart detectam o uso inseguro
de valores potencialmente `null` em tempo de edição,
transformando o que seriam **erros de runtime** em outras linguagens
em **erros de análise** que você pode corrigir antes de fazer o deploy.

<a id="creating-variables" aria-hidden="true"></a>
<a id="introduction-through-examples" aria-hidden="true"></a>

## Exemplos {:#examples}

Nenhuma das variáveis no código a seguir pode ser `null`:

```dart
// None of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

Para indicar que uma variável pode ter o valor `null`,
adicione `?` à sua declaração de tipo:

```dart
int? aNullableInt = null;
```

- Para exemplos interativos, experimente o [cheatsheet do Dart][Dart cheatsheet].
- Para aprender mais sobre null safety, veja
  [Entendendo null safety][Understanding null safety].

[Dart cheatsheet]: /resources/dart-cheatsheet
[Understanding null safety]: /null-safety/understanding-null-safety

## Princípios do null safety {:#null-safety-principles}

O null safety no Dart é baseado em dois princípios fundamentais de design:

**Non-nullable por padrão**
: A menos que você diga explicitamente ao Dart que uma variável pode ser null,
  ela é considerada non-nullable.
  Esse padrão foi escolhido depois que pesquisas constataram que
  non-null era, de longe, a escolha mais comum nas APIs.

**Totalmente sound**
: Se o sistema de tipos determina que
  uma variável ou expressão tem um tipo non-nullable,
  é garantido que ela nunca será avaliada como `null` em tempo de execução.

Juntos, esses princípios resultam em
menos bugs, binários menores e execução mais rápida.

<a id="dart-3-and-null-safety" aria-hidden="true"></a>
<a id="enable-null-safety" aria-hidden="true"></a>
<a id="where-to-learn-more" aria-hidden="true"></a>

## Recursos históricos de migração {:#migrate}

O Dart impõe sound null safety desde o Dart 3, lançado em maio de 2023.
Se você ainda precisa migrar seus aplicativos ou pacotes para null safety,
veja a documentação arquivada no repositório
[`dart-community/migrate-to-null-safety`][].

[`dart-community/migrate-to-null-safety`]: https://github.com/dart-community/migrate-to-null-safety#migrate-to-dart-null-safety
