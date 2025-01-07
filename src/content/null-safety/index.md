---
ia-translate: true
title: Segurança contra nulos (Sound null safety)
description: Informações sobre o recurso de segurança contra nulos do Dart
---

A linguagem Dart impõe a segurança contra nulos (sound null safety).

A segurança contra nulos impede erros que resultam do acesso não intencional
de variáveis definidas como `null`.

Por exemplo, se um método espera um inteiro, mas recebe `null`,
seu aplicativo causa um erro de tempo de execução.
Este tipo de erro, um erro de desreferência nula, pode ser difícil de depurar.

Com a segurança contra nulos, todas as variáveis exigem um valor.
Isso significa que o Dart considera todas as variáveis _não anuláveis_ (non-nullable).
Você pode atribuir valores apenas do tipo declarado, como `int i=42`.
Você nunca pode atribuir um valor `null` aos tipos de variáveis padrão.
Para especificar que um tipo de variável pode ter um valor `null`, adicione `?` após
a anotação de tipo: `int? i`.
Esses tipos específicos podem conter um `null` _ou_
um valor do tipo definido.

A segurança contra nulos transforma potenciais **erros de tempo de execução**
em erros de análise de **tempo de edição**.
Com a segurança contra nulos, o analisador e os compiladores do Dart
sinalizam se uma variável não anulável (non-nullable) tem:

* Não foi inicializada com um valor não nulo (non-null)
* Foi atribuído um valor `null`.

Essas verificações permitem que você corrija esses erros _antes_ de implantar seu aplicativo.

## Introdução através de exemplos {:#introduction-through-examples}

Com a segurança contra nulos, nenhuma das variáveis no código a seguir pode ser `null`:

```dart
// Com a segurança contra nulos, nenhuma delas pode ser nula.
var i = 42; // Inferido para ser um int.
String name = getFileName();
final b = Foo();
```

<a id="creating-variables"></a>
Para indicar que uma variável pode ter o valor `null`,
basta adicionar `?` à sua declaração de tipo:

```dart
int? aNullableInt = null;
```

- Para experimentar alguns exemplos interativos,
  experimente alguns dos exemplos orientados à segurança contra nulos na
  [folha de dicas do Dart](/resources/dart-cheatsheet).
- Para saber mais sobre a segurança contra nulos, confira
  [Entendendo a segurança contra nulos](/null-safety/understanding-null-safety).
  

## Princípios da segurança contra nulos {:#null-safety-principles}

O Dart oferece suporte à segurança contra nulos usando os dois princípios de design principais a seguir:

* **Não anulável por padrão**. A menos que você diga explicitamente ao Dart que uma variável
   pode ser nula, ela é considerada não anulável (non-nullable). Este padrão foi escolhido
   após pesquisas constatarem que não nulo (non-null) era de longe a escolha mais comum em APIs.

* **Totalmente (sound)**. A segurança contra nulos do Dart é total (sound), o que permite otimizações do compilador.
  Se o sistema de tipos determinar que algo não é nulo, então essa coisa _nunca_ poderá ser
  nula. Depois de migrar todo o seu projeto
  e suas dependências para a segurança contra nulos,
  você colhe todos os benefícios da totalidade (soundness) — não apenas
  menos bugs, mas binários menores e execução mais rápida.


## Dart 3 e segurança contra nulos {:#dart-3-and-null-safety}

O Dart 3 possui segurança contra nulos (sound null safety) integrada.
O Dart 3 impede a execução de código sem ela.

Para saber como migrar para o Dart 3,
confira o [guia de migração do Dart 3](/resources/dart-3-migration).
Pacotes desenvolvidos sem suporte à segurança contra nulos causam problemas
ao resolver dependências:

```console
$ dart pub get

Porque pkg1 não suporta segurança contra nulos, a resolução de versão falhou.
O limite inferior de "sdk: '>=2.9.0 <3.0.0'" deve ser 2.12.0 ou superior para habilitar a segurança contra nulos.
```

Bibliotecas incompatíveis com Dart 3 causam erros de análise ou compilação.


```console
$ dart analyze .
Analisando ....                         0.6s

  error • lib/pkg1.dart:1:1 • A versão da linguagem deve ser >=2.12.0.
  Tente remover a substituição da versão da linguagem e migrar o código.
  • illegal_language_version_override
```

```console
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Biblioteca não suporta segurança contra nulos.
// @dart=2.9
^^^^^^^^^^^^
```

Para resolver esses problemas:

1. Verifique se há [versões com segurança contra nulos](/null-safety/migration-guide#check-dependency-status)
   de todos os pacotes que você instalou do pub.dev
2. [migre](#migrate) todo o seu código-fonte para usar a segurança contra nulos.

O Dart 3 pode ser encontrado nos canais estáveis para Dart e Flutter.
Para saber mais, consulte [a página de download][a página de download] para obter detalhes.
Para testar seu código quanto à compatibilidade com Dart 3, use Dart 3 ou posterior.

```console
$ dart --version                     # verifique se isso relata 3.0.0-417.1.beta ou superior
$ dart pub get / flutter pub get     # isso deve resolver sem problemas
$ dart analyze / flutter analyze     # isso deve passar sem erros
```

Se a etapa `pub get` falhar, verifique o [status das dependências][status das dependências].

Se a etapa `analyze` falhar, atualize seu código para resolver os problemas
listados pelo analisador.

[a página de download]: /get-dart/archive
[status das dependências]: /null-safety/migration-guide#check-dependency-status

## Dart 2.x e segurança contra nulos {:#enable-null-safety}

Do Dart 2.12 ao 2.19, você precisa habilitar a segurança contra nulos.
Você não pode usar a segurança contra nulos em versões do SDK anteriores ao Dart 2.12.

<a id="constraints"></a>
Para habilitar a segurança contra nulos, defina o
[limite inferior da restrição do SDK](/tools/pub/pubspec#sdk-constraints)
para uma [versão de linguagem][versão de linguagem] de 2.12 ou posterior.
Por exemplo, seu arquivo `pubspec.yaml` pode ter as seguintes restrições:

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[versão de linguagem]: /resources/language/evolution#language-versioning

## Migrando código existente {:#migrate}

:::warning
O Dart 3 remove a ferramenta `dart migrate`.
Se você precisar de ajuda para migrar seu código,
execute a ferramenta com o SDK 2.19 e, em seguida, atualize para o Dart 3.

Você pode migrar sem a ferramenta, mas envolve
edição manual de código.
:::

O código Dart escrito sem suporte à segurança contra nulos pode ser migrado para usar a segurança contra nulos.
Recomendamos usar a ferramenta `dart migrate`, incluída no SDK do Dart
versões 2.12 a 2.19.

```console
$ cd my_app
$ dart migrate
```

Para saber como migrar seu código para a segurança contra nulos,
confira o [guia de migração][migration guide].

## Onde aprender mais {:#where-to-learn-more}

Para saber mais sobre a segurança contra nulos, consulte os seguintes recursos:

* [Entendendo a segurança contra nulos][Entendendo a segurança contra nulos]
* [Guia de migração para código existente][migration guide]
* [FAQ sobre segurança contra nulos][FAQ sobre segurança contra nulos]
* [Código de exemplo de segurança contra nulos][calculate_lix]

[calculate_lix]: {{site.repo.dart.org}}/samples/tree/main/null_safety/calculate_lix
[migration guide]: /null-safety/migration-guide
[FAQ sobre segurança contra nulos]: /null-safety/faq
[Entendendo a segurança contra nulos]: /null-safety/understanding-null-safety
[#34233]: {{site.repo.dart.sdk}}/issues/34233
[#49529]: {{site.repo.dart.sdk}}/issues/49529
[#2357]: {{site.repo.dart.lang}}/issues/2357
