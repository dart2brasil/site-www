<!-- ia-translate: true -->

# Contribuindo :heart:

Obrigado por pensar em ajudar com [dartbrasil.dev][www]!
Você pode contribuir de algumas maneiras.

* **Corrigir erros de digitação.** A interface do GitHub facilita contribuições pequenas, e
  você receberá crédito pela sua contribuição! Para começar, clique no **ícone de página**
  no canto superior direito da página. Então clique no **ícone de lápis** para começar
  a editar o arquivo. Depois de corrigir o erro de digitação, faça commit das suas alterações em um novo
  branch no seu repositório fork e crie um **pull request.**

  Depois de revisarmos e aprovarmos sua alteração, faremos o merge. Normalmente, vamos
  revisar sua correção em até um dia útil, e sua correção aparecerá online menos de
  uma hora depois de fazermos o merge do seu PR.

  **Nota:** Se esta é sua primeira contribuição para
  um projeto Google—_bem-vindo!_—você precisará [assinar o CLA][sign the CLA].

* **[Reportar problemas][Report issues].**

* **Corrigir problemas conhecidos.** Esses problemas podem ou não ser fáceis de corrigir. Às vezes
  são problemas para os quais não temos a expertise para corrigir, e adoraríamos
  trabalhar com um contribuidor que tenha as habilidades certas.

Mais informações:

* Para evitar desperdiçar seu tempo, converse conosco antes de fazer qualquer
  pull request não trivial. O [rastreador de problemas][issue tracker] é uma boa forma de rastrear seu progresso
  publicamente, mas também usamos o canal `#hackers-devrel`
  [no servidor Discord do Flutter][on Flutter's Discord server].
* Usamos o processo usual de [pull request do GitHub][GitHub pull request].
* Seguimos o [Google Developer Documentation Style Guide][],
  com algumas convenções adicionais que tentamos documentar
  [no repositório site-shared][in the site-shared repo].
  Em particular, usamos [quebras de linha semânticas][semantic line breaks].
* Para mais formas de contribuir com Dart, veja a
  [página de Contribuição do dart-lang/sdk][dart-lang/sdk Contributing page].

[dart-lang/sdk Contributing page]: https://github.com/dart-lang/sdk/blob/main/CONTRIBUTING.md
[GitHub pull request]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests
[Google Developer Documentation Style Guide]: https://developers.google.com/style/
[in the site-shared repo]: https://github.com/dart-lang/site-shared/blob/main/doc
[issue tracker]: https://github.com/dart-lang/site-www/issues
[on Flutter's Discord server]: https://github.com/flutter/flutter/wiki/Chat
[Report issues]: https://github.com/dart-lang/site-www/issues/new/choose
[semantic line breaks]: https://github.com/dart-lang/site-shared/blob/main/doc/writing-for-dart-and-flutter-websites.md#semantic-line-breaks
[sign the CLA]: https://developers.google.com/open-source/cla/individual
[www]: https://dartbrasil.dev


## Atualizando exemplos de código

Se seu PR alterar código Dart em uma página,
você provavelmente precisará alterar o código em dois lugares:

1. Em um arquivo `.md` para a página.
2. Em um arquivo `.dart` no diretório `/examples`.

Por exemplo, digamos que você queira alterar o seguinte código na
[documentação de Variables](https://dartbrasil.dev/language/variables):

````
<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
```dart
var name = 'Bob';
```
````

Além de editar
[`/src/content/language/variables.md`][]
(que você pode encontrar clicando no ícone do GitHub no canto superior direito da página),
você também precisará editar a região `var-decl` de
[`/examples/misc/lib/language_tour/variables.dart`][].

Se você criar um PR mas esquecer de editar o arquivo Dart,
ou se suas alterações não analisarem/testarem corretamente,
o build de CI do [GitHub Actions][] falhará.
Apenas atualize o PR, e o GitHub Actions executará novamente.

Se você seguiu a configuração no README,
você pode executar `dart run dash_site refresh-excerpts`
do diretório raiz do repositório para atualizar os arquivos Markdown.

[GitHub Actions]: https://docs.github.com/actions/learn-github-actions/understanding-github-actions
[`/src/content/language/variables.md`]: https://github.com/dart-lang/site-www/blob/main/src/content/language/variables.md
[`/examples/misc/lib/language_tour/variables.dart`]: https://github.com/dart-lang/site-www/blob/main/examples/misc/lib/language_tour/variables.dart

## Uma palavra sobre conduta

Nós nos comprometemos a manter um ambiente aberto e acolhedor.
Para detalhes, veja nosso [código de conduta][code of conduct].

[code of conduct]: https://dartbrasil.dev/community/code-of-conduct
