<!-- ia-translate: true -->
# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> O site da linguagem Dart (dartbrasil.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![OpenSSF Scorecard SVG][]][Scorecard Results]

<a href="https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2Fdart-lang%2Fsite-www">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <img
      height="32"
      alt="Abrir no IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

O site de documentação para a [linguagem de programação Dart](https://dartbrasil.dev),
construído com [Eleventy][] e hospedado no [Firebase][].

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

> [!IMPORTANTE]
> Se você estiver clonando este repositório localmente,
> siga as instruções abaixo sobre clonagem com seu submódulo.

Se a sua alteração envolver exemplos de código, adicionar/remover páginas ou afetar a navegação,
considere construir e testar seu trabalho antes de enviar.

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

#### Node.js

A **mais recente** versão LTS estável do Node.js é necessária para construir o site.
Se você não tiver o Node.js ou precisar atualizá-lo, baixe a
versão correspondente do seu computador e siga as instruções
do [arquivo de download do Node.js][].
Se preferir, você pode usar um gerenciador de versões como o [nvm][],
e executar `nvm install` a partir do diretório raiz do repositório.

Se você já tiver o Node instalado, verifique se ele está disponível no seu path
e se já é a versão estável mais recente _(atualmente `20.14` ou posterior)_:

```terminal
node --version
```

Se a sua versão estiver desatualizada,
siga as instruções de atualização de como você a instalou originalmente.

[Obtenha o SDK do Dart]: https://dartbrasil.dev/get-dart
[arquivo de download do Node.js]: https://nodejs.org/en/download/
[nvm]: https://github.com/nvm-sh/nvm

### Clone este repositório e seus submódulos

> [!NOTA]
> Este repositório tem _submódulos_ git, o que afeta a forma como você o clona.
> A documentação do GitHub tem ajuda geral sobre
> [forking][] e [clonagem][] de repositórios.

Se você não for membro da organização Dart,
recomendamos que você **crie um fork** deste repositório em sua própria conta,
e então envie um PR desse fork.

Depois de ter um fork (ou você for um membro da organização Dart),
_escolha uma_ das seguintes técnicas de clonagem de submódulo:

1. Clone o repositório e seu submódulo ao mesmo tempo
   usando a opção `--recurse-submodules`:

    ```terminal
    git clone --recurse-submodules https://github.com/dart2brasil/site-www.git
    ```

2. Se você já clonou o repositório sem seu submódulo,
   então execute este comando a partir da raiz do repositório:

    ```terminal
    git submodule update --init --recursive
    ```

> [!NOTA]
> A qualquer momento durante o desenvolvimento,
> você pode usar o comando `git submodule` para atualizar os submódulos:
>
> ```terminal
> git pull && git submodule update --init --recursive
> ```

## Configure seu ambiente local e sirva as mudanças

Antes de continuar configurando a infraestrutura do site,
verifique se as versões corretas do Dart e do Node.js estão configuradas e disponíveis, seguindo
as instruções em [Obtenha os pré-requisitos](#get-the-prerequisites).

1. _Opcional:_ Depois de clonar o repositório e seus submódulos,
   crie um branch para as suas alterações:

   ```terminal
   git checkout -b <NOME_DO_BRANCH>
   ```

2. A partir do diretório raiz do repositório,
   busque as dependências Dart do site.

    ```terminal
    dart pub get
    ```

3. Instale o [`pnpm`][] usando seu [método de instalação][pnpm-install] preferido.
   `pnpm` é um gerenciador de pacotes alternativo e eficiente para pacotes npm.
   Se você já tiver o `pnpm`, verifique se você tem a versão estável mais recente.
   Recomendamos o uso do [`corepack`][] para instalar e gerenciar as versões do `pnpm`,
   já que ele vem junto com a maioria das instalações do Node.

   Se você não usou o `corepack` antes, você precisará
   primeiro habilitá-lo com `corepack enable`.
   Então, para instalar a versão correta do `pnpm`, a partir da
   raiz do diretório do repositório, execute `corepack install`:

    ```terminal
    corepack enable
    corepack install
    ```

4. Depois de ter o `pnpm` instalado e configurado,
   busque as dependências npm do site usando `pnpm install`.
   Recomendamos que você use o `pnpm`, mas você também pode usar o `npm`.

    ```terminal
    pnpm install
    ```

5. A partir do diretório raiz, execute a ferramenta `dash_site` para
   validar sua configuração e aprender sobre os comandos disponíveis.

    ```terminal
    ./dash_site --help
    ```

6. A partir do diretório raiz, sirva o site localmente.

    ```terminal
    ./dash_site serve
    ```

   Este comando gera e serve o site em uma
   porta local que é impressa em seu terminal.

7. Veja as suas alterações no navegador navegando para <http://localhost:4000>.

   Observe que a porta pode ser diferente se `4000` estiver em uso.

   Se você quiser verificar a saída e estrutura HTML bruta e gerada,
   veja o diretório `_site` em um explorador de arquivos ou um IDE.

8. Faça as suas alterações no repositório local.

   O site deve ser reconstruído automaticamente na maioria das alterações, mas se
   algo não atualizar, saia do processo e execute o comando novamente.
   Melhorias para esta funcionalidade estão planejadas.
   Por favor, abra uma nova issue para rastrear o problema se isso ocorrer.

9. Envie suas alterações para o branch e envie seu PR.

   Se a sua alteração for grande ou se você quiser testá-la,
   considere [validar as suas alterações](#validate-your-changes).

> [!DICA]
> Para encontrar comandos adicionais que você pode executar,
> execute `./dash_site --help` a partir do diretório raiz do repositório.

[`corepack`]: https://nodejs.org/api/corepack.html
[`pnpm`]: https://pnpm.io/
[pnpm-install]: https://pnpm.io/installation

## Validar as suas alterações

### Verifique a documentação e o código de exemplo

Se você fez alterações no código nos diretórios `/examples` ou `/tool`,
envie seu trabalho e execute o seguinte comando para
verificar se ele está atualizado e corresponde aos padrões do site.

```terminal
./dash_site check-all
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

Para resolver este erro,
a partir da raiz do diretório `site-www`,
execute `./dash_site refresh-excerpts`.

Para saber mais sobre a criação, edição e uso de excertos de código,
consulte a [documentação do pacote de atualização de excertos][].

[documentação do pacote de atualização de excertos]: https://github.com/dart-lang/site-shared/tree/main/packages/excerpter#readme

## [Opcional] Implante em um site de staging

Pull requests enviados podem ser automaticamente preparados
por um mantenedor do site.
Se você quiser preparar o site por conta própria, no entanto,
você pode construir uma versão completa e carregá-la no Firebase.

1. Se você ainda não tiver um projeto Firebase,

   - Navegue até o [Console do Firebase](https://console.firebase.google.com)
     e crie seu próprio projeto Firebase (por exemplo, `dart-dev-staging`).

   - Volte para o seu terminal local e verifique se você está logado.

      ```terminal
      firebase login
      ```

   - Certifique-se de que seu projeto exista e ative esse projeto:

     ```terminal
     firebase projects:list
     firebase use <seu-projeto>
     ```

2. A partir do diretório raiz do repositório, construa o site:

    ```terminal
    ./dash_site build
    ```

   Isso constrói o site e o copia para seu diretório local `_site`.
   Se esse diretório já existia antes, ele será substituído.

3. Implante no site de hospedagem padrão do seu projeto Firebase ativado:

   ```terminal
   firebase deploy --only hosting
   ```

4. Navegue até o seu PR no GitHub e inclua o link da versão preparada.
   Considere adicionar uma referência ao commit que você preparou,
   para que os revisores saibam se mais alguma alteração foi feita.

4.  Navegue até o seu PR no GitHub e inclua o link da versão preparada.
    Considere adicionar uma referência ao commit que você preparou,
    para que os revisores saibam se alguma outra alteração foi feita.
    

[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart2brasil/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[clonagem]: https://docs.github.com/repositories/creating-and-managing-repositories/cloning-a-repository
[Eleventy]: https://www.11ty.dev/
[Firebase]: https://firebase.google.com/
[forking]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo
[Repo on GitHub Actions]: https://github.com/dart2brasil/site-www/actions?query=workflow%3Abuild+branch%3Amain
