<!-- ia-translate: true -->
# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> O site da linguagem Dart (dartbrasil.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![OpenSSF Scorecard SVG][]][Scorecard Results]

<a href="https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Fdart-lang%2Fsite-www">
  <img
    height="32"
    alt="Open in Firebase Studio"
    src="https://cdn.firebasestudio.dev/btn/open_blue_32.svg">
</a>

The documentation site for the [Dart programming language](https://dart.dev), 
built with [Jaspr][] and hosted on [Firebase][].

Aceitamos contribuições de todos os tipos!
Para configurar o site localmente, siga as
diretrizes abaixo em [Construindo o site](#build-the-site).
Para saber mais sobre como contribuir com este repositório,
consulte as [diretrizes de contribuição](CONTRIBUTING.md).

## Primeiros passos

Comece procurando uma [issue](https://github.com/dart-lang/site-www/issues)
que lhe interesse, ou crie uma issue com a sua mudança proposta.
Considere adicionar um comentário para que todos saibam que você está trabalhando nisso e
sinta-se à vontade para fazer qualquer pergunta que tenha na mesma issue.

Para atualizar este site, faça um fork do repositório, faça as suas alterações,
e gere um pull request.
Para alterações pequenas e isoladas (como correções de estilo e erros de digitação),
você provavelmente não precisa construir este site.
Muitas vezes, você pode fazer alterações usando a interface do GitHub.
Podemos preparar as alterações automaticamente no seu pull request.

If your change involves code samples, adds/removes pages, or affects navigation,
do consider building and testing your work before submitting.

Se você quiser ou precisar construir o site, siga os passos abaixo.

## Construir o site

Para mudanças além de simples ajustes de texto e CSS,
recomendamos executar o site localmente para
permitir um ciclo de edição e atualização.

### Obtenha os pré-requisitos

Instale as seguintes ferramentas para construir e desenvolver o site:

#### Dart

A versão estável mais recente do Dart é necessária para construir o site
e executar suas ferramentas. Esta pode ser a versão do Dart incluída no SDK do Flutter.
Se você não tiver o Dart ou precisar atualizá-lo, siga as
instruções em [Obtenha o SDK do Dart][].

Se você já tiver o Dart instalado, verifique se ele está no seu path
e se já é a versão estável mais recente:

```terminal
dart --version
```

### Clone this repo

If you're not a member of the Dart organization,
we recommend you [create a fork][] of this repo under your own account,
and then submit a PR from that fork.

Once you have a fork (or you're a Dart org member),
clone the repository with `git clone`:

```bash
git clone https://github.com/dart-lang/site-www.git
```

[create a fork]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo

## Configure seu ambiente local e sirva as mudanças

Before you continue setting up the site infrastructure,
verify the correct version of Dart is set up and available by
following the instructions in [Get the prerequisites](#get-the-prerequisites).

1. _Optional:_ After cloning the repo,
   create a branch for your changes:

   ```terminal
   git checkout -b <NOME_DO_BRANCH>
   ```

2. A partir do diretório raiz do repositório,
   busque as dependências Dart do site.

    ```terminal
    dart pub get
    ```

3. From the root directory, run the `dash_site` tool to
   validate your setup and learn about the available commands.

   ```terminal
   dart run dash_site --help
   ```

4. From the root directory, serve the site locally.

   ```terminal
   dart run dash_site serve
   ```

   Este comando gera e serve o site em uma
   porta local que é impressa em seu terminal.

5. View your changes in the browser by navigating to <http://localhost:8080>.

   Note the port might be different if `8080` is taken.

6. Make your changes to the local repo.

   O site deve ser reconstruído automaticamente na maioria das alterações, mas se
   algo não atualizar, saia do processo e execute o comando novamente.
   Melhorias para esta funcionalidade estão planejadas.
   Por favor, abra uma nova issue para rastrear o problema se isso ocorrer.

9. Envie suas alterações para o branch e envie seu PR.

   Se a sua alteração for grande ou se você quiser testá-la,
   considere [validar as suas alterações](#validate-your-changes).

> [!TIP]
> To find additional commands that you can run,
> run `dart run dash_site --help` from the repository's root directory.

## Validar as suas alterações

### Verifique a documentação e o código de exemplo

Se você fez alterações no código nos diretórios `/examples` ou `/tool`,
envie seu trabalho e execute o seguinte comando para
verificar se ele está atualizado e corresponde aos padrões do site.

```terminal
dart run dash_site check-all
```

Se este script relatar quaisquer erros ou avisos,
então resolva esses problemas e execute o comando novamente.
Se você tiver algum problema, deixe um comentário em sua issue ou pull request,
e faremos o possível para ajudá-lo.
Você também pode conversar conosco no canal `#hackers-devrel`
no [Discord de contribuidores do Flutter][]!

[Discord de contribuidores do Flutter]: https://github.com/flutter/flutter/wiki/Chat

### Atualizar excertos de código

Um build que falha com o erro
`Error: Some code excerpts needed to be updated!`
significa que um ou mais excertos de código nos arquivos Markdown do site
não são idênticos às regiões de código declaradas
nos arquivos `.dart` correspondentes.

To resolve this error,
from the root of the `site-www` directory,
run `dart run dash_site refresh-excerpts`.

Para saber mais sobre a criação, edição e uso de excertos de código,
consulte a [documentação do pacote de atualização de excertos][].

[documentação do pacote de atualização de excertos]: https://github.com/dart-lang/site-shared/tree/main/pkgs/excerpter#readme


[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart2brasil/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[Jaspr]: https://jaspr.site
[Firebase]: https://firebase.google.com/
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amain
