---
ia-translate: true
---

# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> O site da linguagem Dart (dartbrasil.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![OpenSSF Scorecard SVG][]][Scorecard Results]

<a href="https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Fdart-lang%2Fsite-www">
  <img
    height="32"
    alt="Open in Firebase Studio"
    src="https://cdn.firebasestudio.dev/btn/open_blue_32.svg">
</a>

O site de documentação para a [linguagem de programação Dart](https://dartbrasil.dev),
construído com [Jaspr][] e hospedado no [Firebase][].

Recebemos contribuições de todos os tipos!
Para configurar o site localmente, siga as
orientações abaixo em [Construindo o site](#build-the-site).
Para saber mais sobre como contribuir com este repositório,
confira as [Diretrizes de contribuição](CONTRIBUTING.md).

## Primeiros passos

Comece procurando por uma [issue](https://github.com/dart-lang/site-www/issues)
que desperte seu interesse, ou crie uma issue com sua mudança proposta.
Considere adicionar um comentário para informar a todos que você está trabalhando nela, e
fique à vontade para fazer quaisquer perguntas na mesma issue.

Para atualizar este site, faça um fork do repo, faça suas mudanças,
e gere um pull request.
Para mudanças pequenas e contidas (como correções de estilo e erros de digitação),
você provavelmente não precisa construir este site.
Frequentemente você pode fazer mudanças usando a interface do GitHub.
Podemos preparar as mudanças automaticamente no seu pull request.

Se sua mudança envolve exemplos de código, adiciona/remove páginas, ou afeta a navegação,
considere construir e testar seu trabalho antes de enviar.

Se você quer ou precisa construir o site, siga os passos abaixo.

## Construindo o site

Para mudanças além de simples ajustes de texto e CSS,
recomendamos executar o site localmente para
permitir um ciclo de edição e atualização.

### Obtenha os pré-requisitos

Instale as seguintes ferramentas para construir e desenvolver o site:

#### Dart

A versão stable mais recente do Dart é necessária para construir o site
e executar suas ferramentas. Pode ser o Dart incluído no Flutter SDK.
Se você não tem o Dart ou precisa atualizar, siga as
instruções em [Get the Dart SDK][].

Se você já tem o Dart instalado, verifique se está no seu path
e já é a versão stable mais recente:

```terminal
dart --version
```

### Clone este repo

Se você não é membro da organização Dart,
recomendamos que você [crie um fork][create a fork] deste repo na sua própria conta,
e então envie um PR a partir desse fork.

Depois de ter um fork (ou se você é membro da organização Dart),
clone o repositório com `git clone`:

```bash
git clone https://github.com/dart-lang/site-www.git
```

[create a fork]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo

## Configure seu ambiente local e sirva as mudanças

Antes de continuar configurando a infraestrutura do site,
verifique se a versão correta do Dart está configurada e disponível
seguindo as instruções em [Obtenha os pré-requisitos](#get-the-prerequisites).

1. _Opcional:_ Depois de clonar o repo,
   crie um branch para suas mudanças:

   ```terminal
   git checkout -b <BRANCH_NAME>
   ```

2. Do diretório raiz do repositório,
   busque as dependências Dart do site.

   ```terminal
   dart pub get
   ```

3. Do diretório raiz, execute a ferramenta `dash_site` para
   validar sua configuração e aprender sobre os comandos disponíveis.

   ```terminal
   dart run dash_site --help
   ```

4. Do diretório raiz, sirva o site localmente.

   ```terminal
   dart run dash_site serve
   ```

   Este comando gera e serve o site em uma
   porta local que é impressa no seu terminal.

5. Visualize suas mudanças no navegador navegando para <http://localhost:8080>.

   Note que a porta pode ser diferente se `8080` estiver ocupada.

6. Faça suas mudanças no repo local.

   O site deve reconstruir automaticamente na maioria das mudanças, mas se
   algo não atualizar, saia do processo e execute o comando novamente.
   Melhorias nesta funcionalidade estão planejadas.
   Por favor, abra uma nova issue para acompanhar o problema se isso ocorrer.

9. Faça commit das suas mudanças no branch e envie seu PR.

   Se sua mudança é grande, ou você gostaria de testá-la,
   considere [validar suas mudanças](#validate-your-changes).

> [!TIP]
> Para encontrar comandos adicionais que você pode executar,
> execute `dart run dash_site --help` do diretório raiz do repositório.

## Valide suas mudanças

### Verifique a documentação e o código de exemplo

Se você fez mudanças no código nos diretórios `/examples` ou `/tool`,
faça commit do seu trabalho, então execute o seguinte comando para
verificar se está atualizado e corresponde aos padrões do site.

```terminal
dart run dash_site check-all
```

Se este script reportar erros ou avisos,
então resolva esses problemas e execute o comando novamente.
Se você tiver problemas, deixe um comentário na sua issue ou pull request,
e faremos o nosso melhor para ajudá-lo.
Você também pode conversar conosco no canal `#hackers-devrel`
no [Flutter contributors Discord][]!

[Flutter contributors Discord]: https://github.com/flutterbrasil/flutter/wiki/Chat

### Atualize os trechos de código

Uma build que falha com o erro
`Error: Some code excerpts needed to be updated!`
significa que um ou mais trechos de código nos arquivos Markdown do site
não são idênticos às regiões de código declaradas
nos arquivos `.dart` correspondentes.

Para resolver este erro,
a partir da raiz do diretório `site-www`,
execute `dart run dash_site refresh-excerpts`.

Para saber mais sobre criar, editar e usar trechos de código,
confira a [documentação do pacote excerpt updater][excerpt updater package documentation].

[excerpt updater package documentation]: https://github.com/dart-lang/site-shared/tree/main/pkgs/excerpter#readme


[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart-lang/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[Jaspr]: https://jaspr.site
[Firebase]: https://firebase.google.com/
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amain
[Get the Dart SDK]: https://dartbrasil.dev/get-dart
