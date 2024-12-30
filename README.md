# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> O site da linguagem Dart (dart.dev)

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
      alt="Open in IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

O site de documentação da [linguagem de programação Dart](https://dart.dev),
construído com [Eleventy][] e hospedado no [Firebase][].

Agradecemos contribuições de todos os tipos!
Para configurar o site localmente, siga as
diretrizes abaixo em [Construindo o site](#construindo-o-site).
Para saber mais sobre como contribuir com este repositório,
confira as [diretrizes de contribuição](CONTRIBUTING.md).

## Começando

Comece procurando por uma [issue](https://github.com/dart2brasilg/site-www/issues)
que chame sua atenção, ou crie uma issue com sua mudança proposta.
Considere adicionar um comentário para informar a todos que você está trabalhando nisso, e
sinta-se à vontade para fazer qualquer pergunta que tiver na mesma issue.

Para atualizar este site, faça um fork do repositório, faça suas alterações,
e gere um pull request.
Para pequenas alterações contidas (como correções de estilo e erros de digitação),
você provavelmente não precisa construir este site.
Muitas vezes você pode fazer alterações usando a interface do GitHub.
Podemos preparar as alterações automaticamente em seu pull request.

> [!IMPORTANTE]
> Se você estiver clonando este repositório localmente,
> siga as instruções abaixo sobre como clonar com seu submódulo.

Se sua alteração envolver amostras de código, adicionar/remover páginas ou afetar a navegação,
considere construir e testar seu trabalho antes de enviar.

Se você quiser ou precisar construir o site, siga as etapas abaixo.

## Construindo o site

Para alterações além de simples ajustes de texto e CSS,
recomendamos executar o site localmente para
habilitar um ciclo de edição-atualização.

### Obtenha os pré-requisitos

Instale as seguintes ferramentas para construir e desenvolver o site:

#### Dart

A versão estável mais recente do Dart é necessária para construir o site
e executar suas ferramentas. Este pode ser o Dart incluído no Flutter SDK.
Se você não tem o Dart ou precisa atualizar, siga as
instruções em [Obter o SDK do Dart][].

Se você já tem o Dart instalado, verifique se ele está no seu caminho
e já é a versão estável mais recente:

```terminal
dart --version
```

#### Node.js

A versão LTS estável **mais recente** do Node.js é necessária para construir o site.
Se você não tem o Node.js ou precisa atualizar, baixe o
versão correspondente do seu computador e siga as instruções
do [arquivo de download do Node.js][].
Se preferir, você pode usar um gerenciador de versões como o [nvm][],
e execute `nvm install` do diretório raiz do repositório.

Se você já tem o Node instalado, verifique se ele está disponível em seu caminho
e já a versão estável mais recente _(atualmente `20.14` ou posterior)_:

```terminal
node --version
```

Se sua versão estiver desatualizada,
siga as instruções de atualização para como você a instalou originalmente.

[Obter o SDK do Dart]: https://dart.dev/get-dart
[arquivo de download do Node.js]: https://nodejs.org/en/download/
[nvm]: https://github.com/nvm-sh/nvm

### Clone este repositório e seus submódulos

> [!NOTE]
> Este repositório tem _submódulos_ git, que afetam como você o clona.
> A documentação do GitHub tem ajuda geral sobre
> [forking][] e [cloning][] repositórios.

Se você não é membro da organização Dart,
recomendamos que você **crie um fork** deste repositório em sua própria conta,
e então envie um PR desse fork.

Depois de ter um fork (ou você é um membro da organização Dart),
_escolha uma_ das seguintes técnicas de clonagem de submódulos:

1.  Clone o repositório e seu submódulo ao mesmo tempo
    usando a opção `--recurse-submodules`:

    ```terminal
    git clone --recurse-submodules https://github.com/dart2brasil/site-www.git
    ```

2.  Se você já clonou o repositório sem seu submódulo,
    execute este comando a partir da raiz do repositório:

    ```terminal
    git submodule update --init --recursive
    ```

> [!NOTE]
> A qualquer momento durante o desenvolvimento
> você pode usar o comando `git submodule` para atualizar os submódulos:
>
> ```terminal
> git pull && git submodule update --init --recursive
> ```

## Configure seu ambiente local e sirva as alterações

Antes de continuar configurando a infraestrutura do site,
verifique se as versões corretas do Dart e Node.js estão configuradas e disponíveis
seguindo as instruções em [Obtenha os pré-requisitos](#obtenha-os-pré-requisitos).

1.  _Opcional:_ Depois de clonar o repositório e seus submódulos,
    crie uma branch para suas alterações:

    ```terminal
    git checkout -b <NOME_DA_BRANCH>
    ```

2.  A partir do diretório raiz do repositório,
    busque as dependências Dart do site.

    ```terminal
    dart pub get
    ```

3.  Instale o [`pnpm`][] usando seu [método de instalação][pnpm-install] preferido.
    O `pnpm` é um gerenciador de pacotes alternativo e eficiente para pacotes npm.
    Se você já tem o `pnpm`, verifique se você tem a versão estável mais recente.
    Recomendamos usar o [`corepack`][] para instalar e gerenciar as versões do `pnpm`,
    já que ele é incluído na maioria das instalações do Node.

    Se você não usou o `corepack` antes, você precisará
    primeiro habilitá-lo com `corepack enable`.
    Então, para instalar a versão correta do `pnpm`, a partir da
    raiz do diretório do repositório, execute `corepack install`:

    ```terminal
    corepack enable
    corepack install
    ```

4.  Depois de ter o `pnpm` instalado e configurado,
    busque as dependências npm do site usando `pnpm install`.
    Recomendamos que você use o `pnpm`, mas você também pode usar o `npm`.

    ```terminal
    pnpm install
    ```

5.  A partir do diretório raiz, execute a ferramenta `dash_site` para
    validar sua configuração e aprender sobre os comandos disponíveis.

    ```terminal
    ./dash_site --help
    ```

6.  A partir do diretório raiz, sirva o site localmente.

    ```terminal
    ./dash_site serve
    ```

    Este comando gera e serve o site em uma
    porta local que é impressa em seu terminal.

7.  Visualize suas alterações no navegador navegando para <http://localhost:4000>.

    Observe que a porta pode ser diferente se `4000` estiver ocupada.

    Se você quiser verificar a saída e a estrutura HTML brutas geradas,
    visualize o diretório `_site` em um explorador de arquivos ou IDE.

8.  Faça suas alterações no repositório local.

    O site deve ser reconstruído automaticamente na maioria das alterações, mas se
    algo não for atualizado, saia do processo e execute o comando novamente.
    Melhorias nesta funcionalidade estão planejadas.
    Por favor, abra uma nova issue para rastrear o problema se isso ocorrer.

9.  Confirme suas alterações na branch e envie seu PR.

    Se sua alteração for grande ou se você quiser testá-la,
    considere [validar suas alterações](#validar-suas-alterações).

> [!TIP]
> Para encontrar comandos adicionais que você pode executar,
> execute `./dash_site --help` a partir do diretório raiz do repositório.

[`corepack`]: https://nodejs.org/api/corepack.html
[`pnpm`]: https://pnpm.io/
[pnpm-install]: https://pnpm.io/installation

## Validar suas alterações

### Verificar documentação e código de exemplo

Se você fez alterações no código nos diretórios `/examples` ou `/tool`,
confirme seu trabalho, então execute o seguinte comando para
verificar se ele está atualizado e corresponde aos padrões do site.

```terminal
./dash_site check-all
```

Se este script reportar quaisquer erros ou avisos,
então aborde essas questões e execute o comando novamente.
Se você tiver algum problema, deixe um comentário em sua issue ou pull request,
e faremos o nosso melhor para ajudá-lo.
Você também pode conversar conosco no canal `#hackers-devrel`
no [Discord de contribuidores do Flutter][]!

[Discord de contribuidores do Flutter]: https://github.com/flutter/flutter/wiki/Chat

### Atualizar trechos de código

Uma build que falha com o erro
`Error: Some code excerpts needed to be updated!`
significa que um ou mais trechos de código nos arquivos Markdown do site
não são idênticos às regiões de código declaradas
nos arquivos `.dart` correspondentes.

Para resolver este erro,
a partir da raiz do diretório `site-www`,
execute `./dash_site refresh-excerpts`.

Para saber mais sobre como criar, editar e usar trechos de código,
confira a [documentação do pacote de atualização de trechos][].

[documentação do pacote de atualização de trechos]: https://github.com/dart-lang/site-shared/tree/main/packages/excerpter#readme

## [Opcional] Implante em um site de staging

Pull requests enviados podem ser preparados automaticamente
por um mantenedor do site.
Se você quiser preparar o site sozinho,
você pode construir uma versão completa e enviá-la para o Firebase.

1.  Se você ainda não tem um projeto Firebase,

    - Navegue até o [Console do Firebase](https://console.firebase.google.com)
      e crie seu próprio projeto Firebase (por exemplo, `dart-dev-staging`).

    - Volte para o seu terminal local e verifique se você está logado.

      ```terminal
      firebase login
      ```

    - Certifique-se de que seu projeto existe e ative esse projeto:

      ```terminal
      firebase projects:list
      firebase use <seu-projeto>
      ```

2.  A partir do diretório raiz do repositório, construa o site:

    ```terminal
    ./dash_site build
    ```

    Isso constrói o site e o copia para o seu diretório local `_site`.
    Se esse diretório existia anteriormente, ele será substituído.

3.  Implante no site de hospedagem padrão do seu projeto Firebase ativado:

    ```terminal
    firebase deploy --only hosting
    ```

4.  Navegue até o seu PR no GitHub e inclua o link da versão preparada.
    Considere adicionar uma referência ao commit que você preparou,
    para que os revisores saibam se alguma outra alteração foi feita.
    

[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart2brasil/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[cloning]: https://docs.github.com/repositories/creating-and-managing-repositories/cloning-a-repository
[Eleventy]: https://www.11ty.dev/
[Firebase]: https://firebase.google.com/
[forking]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo
[Repo on GitHub Actions]: https://github.com/dart2brasil/site-www/actions?query=workflow%3Abuild+branch%3Amain
