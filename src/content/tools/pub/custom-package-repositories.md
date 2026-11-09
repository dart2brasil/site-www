---
ia-translate: true
title: Custom package repositories
description: >-
  Como a ferramenta de gerenciamento de pacotes do Dart, o pub,
  funciona com repositórios de pacotes customizados.
---

A ferramenta `dart pub` oferece suporte a repositórios de pacotes de terceiros.
Um repositório de pacotes é um servidor que hospeda pacotes Dart
para consumo pela ferramenta `dart pub`.
O repositório de pacotes padrão, [pub.dev]({{site.pub}}),
é operado pelo time do Dart para
facilitar a publicação de pacotes Dart para uso público.
Um repositório de pacotes é identificado por uma
_hosted-url_, como `https://dart-packages.example.com/`.

Às vezes, um repositório de pacotes customizado pode ser útil
para hospedar pacotes privados,
incluindo em alguns dos cenários a seguir:

1. Compartilhar pacotes internos e proprietários dentro de uma organização.
2. Controle rigoroso de dependências em ambientes corporativos.
3. Ambientes seguros, sem acesso à internet pública.

Também é comum usar [dependências git](/tools/pub/dependencies#git-packages)
para hospedar pacotes privados. No entanto,
a ferramenta `dart pub` não oferece suporte a resolver versões a partir de um repositório git;
ela apenas busca uma revisão específica do repositório git.
Portanto, quando muitas pessoas colaboram,
costuma ser preferível usar um repositório de pacotes privado.

## Autenticação com um repositório de pacotes customizado {:#token-authentication}

A maioria dos repositórios de pacotes customizados são
repositórios privados que exigem autenticação.
Para autenticar nesses repositórios,
a ferramenta `dart pub` anexa um token secreto às requisições.

Você pode obter o token secreto no seu repositório de pacotes customizado
e informá-lo manualmente ou por meio de uma variável de ambiente.
Para informar o token secreto manualmente,
use o comando `dart pub token add`,
que pede o token:

```console
$ dart pub token add https://dart-packages.example.com
Enter secret token: [enter secret token]
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token.
```

Você também pode dizer ao `dart pub` para ler o token de uma variável de ambiente,
inclusive em um ambiente de CI, com a flag `--env-var`:

```console
$ dart pub token add https://dart-packages.example.com --env-var MY_SECRET_TOKEN
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token stored in the environment variable "MY_SECRET_TOKEN".
```

Isso garante que o `dart pub` não armazene de fato o token secreto na sua configuração;
em vez disso, ele apenas registra o fato de que
deve ler o segredo da variável de ambiente `$MY_SECRET_TOKEN`.
Isso reduz o risco de que segredos vazem acidentalmente
se o ambiente de execução for compartilhado entre jobs de CI.

:::note
Quando a ferramenta `dart pub` não tem um token para uma determinada URL de repositório,
ela tenta fazer as requisições sem autenticação.
:::


## Buscar dependências de um repositório de pacotes customizado {:#retrieving-dependencies-from-a-custom-package-repository}

Para buscar um pacote de um repositório de pacotes customizado,
você deve especificar a _hosted-url_ do pacote no `pubspec.yaml`,
usando a sintaxe de [pacotes hospedados](/tools/pub/dependencies#hosted-packages).
Por exemplo:

```yaml
dependencies:
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

No exemplo anterior, o `package:example_package`
é buscado em `https://dart-packages.example.com`.
Se o repositório exigir autenticação para esse pacote,
veja [Autenticação com um repositório de pacotes customizado](#token-authentication)
para mais informações sobre como autenticar as suas requisições.

Você também pode usar o comando `dart pub add`
com a flag `--hosted` para adicionar uma dependência de um repositório de pacotes customizado:

```console
$ dart pub add example_package --hosted https://dart-packages.example.com
```

### Usar vários repositórios de pacotes {:#using-multiple-package-repositories}

Você também pode buscar dependências diferentes
de repositórios de pacotes diferentes,
já que a _hosted-url_ pode ser especificada para cada dependência:

```yaml
dependencies:
  # package retry is fetched from pub.dev (the default package repository)
  retry: ^3.0.0
  # package example_package is fetched from https://dart-packages.example.com
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

Isso permite manter pacotes privados em um repositório de pacotes privado
enquanto usa os pacotes públicos mais atualizados como dependências.

No entanto, conflitos podem surgir facilmente se as suas dependências exigirem
um pacote com o mesmo nome de repositórios diferentes.
Por exemplo, se o pacote `retry` exige `meta` do pub.dev,
e o `example_package` exige `meta` de `https://dart-packages.example.com`.
Por isso, se você espelhar quaisquer pacotes em um repositório de pacotes privado,
costuma ser necessário espelhar todas as dependências
e atualizar a seção `dependencies` de cada pacote,
ou [sobrescrever o repositório de pacotes padrão](#default-override).

:::note
Para garantir que os pacotes públicos sejam utilizáveis por todos,
o repositório oficial de pacotes, [pub.dev]({{site.pub}}),
não permite a publicação de pacotes
com dependências git ou com dependências hospedadas em repositórios de pacotes customizados.

No entanto, esses pacotes podem ser publicados em um repositório de pacotes customizado.
:::


## Publicar em um repositório de pacotes customizado {:#publishing-to-a-custom-package-repository}

Para publicar um pacote em um repositório de pacotes customizado
em vez de no [pub.dev]({{site.pub}}),
especifique a propriedade
[`publish_to`](/tools/pub/pubspec#publish_to) no `pubspec.yaml`.
Se a autenticação estiver habilitada,
a publicação usa a mesma [autenticação por token](#token-authentication)
usada para buscar pacotes.

:::note
Para evitar a publicação acidental no [pub.dev]({{site.pub}})
ao trabalhar em um pacote privado,
é uma boa ideia especificar isso logo no início do desenvolvimento.
:::

Para preparar um pacote para publicação em `https://dart-packages.example.com`,
o seu `pubspec.yaml` deve ficar, no mínimo, assim:

```yaml
name: example_package
version: 1.0.0
# Ensures the package is published to https://dart-packages.example.com
publish_to: https://dart-packages.example.com
```

Para publicar uma nova versão do pacote,
use `dart pub publish`:

```console
$ dart pub publish
Publishing example_package 1.0.0 to https://dart-packages.example.com
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- lib
|   '-- example_package.dart
'-- pubspec.yaml
...
```

:::note
Mesmo que você não esteja usando um repositório privado,
você pode especificar `publish_to: none`,
o que impede qualquer publicação acidental.
:::


### Sobrescrever o repositório de pacotes padrão {:#default-override}

Por padrão, o `dart pub` busca dependências e publica pacotes
no [site pub.dev]({{site.pub}}),
a menos que a sintaxe de dependência hospedada
seja usada para especificar um repositório de pacotes customizado.
No entanto, você pode sobrescrever o repositório de pacotes padrão usando a
variável de ambiente [`PUB_HOSTED_URL`](/tools/pub/environment-variables).

Essa abordagem é especialmente útil ao espelhar todos os pacotes
em um repositório de pacotes privado, ou um subconjunto do pub.dev,
ao trabalhar em um ambiente de rede restrito.


## Configurar um repositório de pacotes customizado {:#setting-up-a-custom-package-repository}

Você pode escrever um repositório de pacotes customizado implementando
a API REST descrita na
[Hosted Pub Repository Specification Version 2][repository-spec-v2.md].

### Repositórios de pacotes Dart como serviço {:#dart-package-repositories-as-a-service}

Repositórios de pacotes customizados também são oferecidos como serviço
com suporte à autenticação por token, por vários fornecedores,
poupando você do trabalho de hospedar e manter
o seu próprio repositório de pacotes customizado:

<ul class="logo-link-grids">
<li>
  <a href="https://help.cloudsmith.io/docs/dart-repository">
    <img src="/assets/img/tools/cloudsmith.svg" alt="Cloudsmith logo">
    <span>Cloudsmith</span>
  </a>
</li>
<li>
  <a href="https://docs.inedo.com/docs/proget/feeds/pub">
    <img src="/assets/img/tools/proget.svg" alt="Inedo ProGet logo">
    <span>Inedo ProGet</span>
  </a>
</li>
<li>
  <a href="https://www.jfrog.com/confluence/display/JFROG/Pub+Repositories">
    <img src="/assets/img/tools/jfrog.svg" alt="JFrog logo">
    <span>JFrog Artifactory</span>
  </a>
</li>
<li>
  <a href="https://onepub.dev">
    <img src="/assets/img/tools/onepub.svg" alt="OnePub logo">
    <span>OnePub Dart Repository</span>
  </a>
</li>
<li>
  <a href="https://publy.dev/docs/getting-started">
    <img src="/assets/img/tools/publy.svg" alt="Publy logo">
    <span>Publy</span>
  </a>
</li>
<li>
  <a href="https://glpub.dev/">
    <img src="/assets/img/tools/glpub.png" alt="GLPub logo">
    <span>GLPub.dev</span>
  </a>
</li>
</ul>


[repository-spec-v2.md]: {{site.repo.dart.org}}/pub/blob/master/doc/repository-spec-v2.md
