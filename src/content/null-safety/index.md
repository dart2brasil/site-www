---
ia-translate: true
title: Sound null safety
breadcrumb: Null safety
description: Informações sobre o recurso null safety do Dart.
---

A linguagem Dart implementa sound null safety.

Null safety previne erros que resultam do acesso não intencional
de variáveis definidas como `null`.

Por exemplo, se um método espera um inteiro mas recebe `null`,
seu aplicativo causa um erro em tempo de execução.
Este tipo de erro, um erro de desreferenciamento nulo, pode ser difícil de depurar.

Com sound null safety, todas as variáveis requerem um valor.
Isso significa que o Dart considera todas as variáveis como _non-nullable_.
Você pode atribuir valores apenas do tipo declarado, como `int i=42`.
Você nunca pode atribuir um valor `null` aos tipos de variável padrão.
Para especificar que um tipo de variável pode ter um valor `null`, adicione um `?` após
a anotação de tipo: `int? i`.
Esses tipos específicos podem conter tanto `null` _quanto_
um valor do tipo definido.

Sound null safety transforma **erros de runtime** potenciais
em erros de análise em **tempo de edição**.
Com null safety, o analisador e compiladores do Dart
sinalizam se uma variável non-nullable tem:

* Não sido inicializada com um valor non-null
* Sido atribuída um valor `null`.

Essas verificações permitem que você corrija esses erros _antes_ de fazer deploy do seu aplicativo.

## Introdução através de exemplos

Com null safety, nenhuma das variáveis no código a seguir pode ser `null`:

```dart
// With null safety, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

<a id="creating-variables"></a>
Para indicar que uma variável pode ter o valor `null`,
apenas adicione `?` à sua declaração de tipo:

```dart
int? aNullableInt = null;
```

- Para experimentar alguns exemplos interativos,
  confira alguns dos exemplos orientados a null-safety na
  [Dart cheatsheet](/resources/dart-cheatsheet).
- Para aprender mais sobre null safety, confira
  [Understanding null safety](/null-safety/understanding-null-safety).


## Princípios do null safety

O Dart suporta null safety usando os seguintes dois princípios fundamentais de design:

**Non-nullable por padrão**
: A menos que você explicitamente diga ao Dart que uma variável pode ser null,
  ela é considerada non-nullable.
  Este padrão foi escolhido após pesquisas constatarem que
  non-null era de longe a escolha mais comum em APIs.

**Totalmente sound**
: O null safety do Dart é sound.
  Se o sistema de tipos determina que
  uma variável ou expressão tem um tipo non-nullable,
  é garantido que ela nunca pode ser avaliada como `null` em tempo de execução.

Sound null safety em todo o programa permite que o Dart
aproveite esses princípios para
menos bugs, binários menores e execução mais rápida.

## Dart 3 e null safety

O Dart 3 tem sound null safety integrado.
O Dart 3 impede que código sem ele seja executado.

Para aprender como migrar para o Dart 3,
confira o [guia de migração do Dart 3](/resources/dart-3-migration).
Pacotes desenvolvidos sem suporte a null safety causam problemas
ao resolver dependências:

```console
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Bibliotecas incompatíveis com o Dart 3 causam erros de análise ou compilação.


```console
$ dart analyze .
Analyzing ....                         0.6s

  error • lib/pkg1.dart:1:1 • The language version must be >=2.12.0.
  Try removing the language version override and migrating the code.
  • illegal_language_version_override
```

```console
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Library doesn't support null safety.
// @dart=2.9
^^^^^^^^^^^^
```

Para resolver esses problemas:

1. Verifique por [versões null safe](/null-safety/migration-guide#check-dependency-status)
   de quaisquer pacotes que você instalou do pub.dev
2. [migre](#migrate) todo o seu código fonte para usar sound null safety.

O Dart 3 pode ser encontrado nos canais estáveis do Dart e Flutter.
Para aprender mais, confira [a página de download][] para detalhes.
Para testar seu código para compatibilidade com Dart 3, use Dart 3 ou posterior.

```console
$ dart --version                     # make sure this reports 3.0.0-417.1.beta or higher
$ dart pub get / flutter pub get     # this should resolve without issues
$ dart analyze / flutter analyze     # this should pass without errors
```

Se a etapa `pub get` falhar, verifique o [status das dependências][].

Se a etapa `analyze` falhar, atualize seu código para resolver os problemas
listados pelo analisador.

[the download page]: /get-dart/archive
[status of the dependencies]: /null-safety/migration-guide#check-dependency-status

## Dart 2.x e null safety {:#enable-null-safety}

Do Dart 2.12 ao 2.19, você precisa habilitar null safety.
Você não pode usar null safety em versões do SDK anteriores ao Dart 2.12.

<a id="constraints"></a>
Para habilitar sound null safety, defina o
[limite inferior da restrição do SDK](/tools/pub/pubspec#sdk-constraints)
para uma [versão da linguagem][] de 2.12 ou posterior.
Por exemplo, seu arquivo `pubspec.yaml` pode ter as seguintes restrições:

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[language version]: /resources/language/evolution#language-versioning

## Migrando código existente {:#migrate}

:::warning
O Dart 3 remove a ferramenta `dart migrate`.
Se você precisa de ajuda para migrar seu código,
execute a ferramenta com o SDK 2.19, e então faça upgrade para o Dart 3.

Você pode migrar sem a ferramenta, mas isso envolve
edição manual de código.
:::

Código Dart escrito sem suporte a null safety pode ser migrado para usar null
safety. Recomendamos usar a ferramenta `dart migrate`, incluída nas versões do Dart SDK
de 2.12 a 2.19.

```console
$ cd my_app
$ dart migrate
```

Para aprender como migrar seu código para null safety,
confira o [guia de migração][].

## Onde aprender mais

Para aprender mais sobre null safety, confira os seguintes recursos:

* [Understanding null safety][]
* [Guia de migração para código existente][migration guide]
* [Null safety FAQ][]
* [Código de exemplo de null safety][calculate_lix]

[calculate_lix]: {{site.repo.dart.samples}}/tree/main/null_safety/calculate_lix
[migration guide]: /null-safety/migration-guide
[Null safety FAQ]: /null-safety/faq
[Understanding null safety]: /null-safety/understanding-null-safety
[#34233]: {{site.repo.dart.sdk}}/issues/34233
[#49529]: {{site.repo.dart.sdk}}/issues/49529
[#2357]: {{site.repo.dart.lang}}/issues/2357
