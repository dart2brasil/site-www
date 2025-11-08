---
title: Custom package repositories
description: >-
  How Dart's package management tool, pub,
  works with custom package repositories.
ia-translate: true
---

A ferramenta `dart pub` suporta repositórios de pacotes de terceiros.
Um repositório de pacotes é um servidor que hospeda pacotes Dart
para consumo pela ferramenta `dart pub`.
O repositório de pacotes padrão usado, [pub.dev]({{site.pub}}),
é operado pelo time Dart para
facilitar a publicação de pacotes Dart para uso público.
Um repositório de pacotes é identificado por uma
_hosted-url_, como `https://dart-packages.example.com/`.

Às vezes um repositório de pacotes customizado pode ser útil
para hospedar pacotes privados,
incluindo em alguns dos seguintes cenários:

1. Compartilhar pacotes proprietários internos dentro de uma organização.
2. Controle rigoroso de dependências em ambientes corporativos.
3. Ambientes seguros sem acesso à internet pública.

Também é comum usar [git-dependencies](/tools/pub/dependencies#git-packages)
para hospedar pacotes privados, no entanto,
a ferramenta `dart pub` não suporta resolver versões contra um repositório git;
ela apenas busca uma revisão específica do repositório git.
Portanto, quando muitas pessoas estão colaborando
é frequentemente preferível usar um repositório de pacotes privado.

## Authenticating with a custom package repository {:#token-authentication}

A maioria dos repositórios de pacotes customizados são
repositórios de pacotes privados que requerem autenticação.
Para autenticar contra repositórios de pacotes customizados,
a ferramenta `dart pub` anexa um token secreto às requisições.

Você pode obter o token secreto do seu repositório de pacotes customizado
e especificá-lo manualmente ou através de uma variável de ambiente.
Para especificar manualmente o token secreto,
use o comando `dart pub token add`
que solicita o token:

```console
$ dart pub token add https://dart-packages.example.com
Enter secret token: [enter secret token]
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token.
```

Você também pode dizer ao `dart pub` para ler o token de uma variável de ambiente,
incluindo em um ambiente CI, com a flag `--env-var`:

```console
$ dart pub token add https://dart-packages.example.com --env-var MY_SECRET_TOKEN
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token stored in the environment variable "MY_SECRET_TOKEN".
```

Isso garante que `dart pub` não
armazene realmente o token secreto em sua configuração,
em vez disso ele apenas armazena o fato de que
deve ler o segredo da variável de ambiente `$MY_SECRET_TOKEN`.
Isso reduz o risco de que segredos vazem acidentalmente
se o ambiente de execução for compartilhado entre jobs CI.

:::note
Quando a ferramenta `dart pub` não tem um token para uma URL de repositório específica,
ela tenta fazer requisições sem autenticação.
:::


## Retrieving dependencies from a custom package repository

Para buscar um pacote de um repositório de pacotes customizado,
você deve especificar a _hosted-url_ para o pacote no `pubspec.yaml`,
usando a sintaxe para [hosted packages](/tools/pub/dependencies#hosted-packages).
Por exemplo:

```yaml
dependencies:
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

No exemplo anterior, `package:example_package`
é buscado de `https://dart-packages.example.com`.
Se a autenticação for requerida por este repositório de pacotes,
veja [Authenticating with a custom package repository](#token-authentication)
para mais informações sobre como autenticar suas requisições.

Você também pode usar o comando `dart pub add`
com a flag `--hosted` para adicionar uma dependência de um repositório de pacotes customizado:

```console
$ dart pub add example_package --hosted https://dart-packages.example.com
```

### Using multiple package repositories

Você também pode buscar diferentes dependências
de diferentes repositórios de pacotes,
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

Isso permite que você mantenha pacotes privados em um repositório de pacotes privado
enquanto usa os pacotes públicos mais atualizados como dependências.

No entanto, conflitos podem facilmente surgir se suas dependências requerem
um pacote com o mesmo nome de diferentes repositórios.
Por exemplo, se o pacote `retry` requer `meta` do pub.dev,
e `example_package` requer `meta` de `https://dart-packages.example.com`.
Portanto, se estiver espelhando quaisquer pacotes em um repositório de pacotes privado
é frequentemente necessário espelhar todas as dependências
e atualizar a seção `dependencies` de cada pacote,
ou [sobrescrever o repositório de pacotes padrão](#default-override).

:::note
Para garantir que pacotes públicos sejam usáveis por todos,
o repositório de pacotes oficial, [pub.dev]({{site.pub}}),
não permite publicação de pacotes
com git-dependencies ou hosted-dependencies de repositórios de pacotes customizados.

No entanto, tais pacotes podem ser publicados em um repositório de pacotes customizado.
:::


## Publishing to a custom package repository

Para publicar um pacote em um repositório de pacotes customizado
em vez de [pub.dev]({{site.pub}}),
especifique a
propriedade [`publish_to`](/tools/pub/pubspec#publish_to) no `pubspec.yaml`.
Se a autenticação estiver habilitada,
a publicação usa a mesma [token authentication](#token-authentication)
da recuperação de pacotes.

:::note
Para prevenir publicação acidental no [pub.dev]({{site.pub}})
ao trabalhar em um pacote privado,
é uma boa ideia especificar isso cedo no desenvolvimento.
:::

Para preparar um pacote para publicação em `https://dart-packages.example.com`,
seu `pubspec.yaml` deve parecer minimamente com o seguinte:

```yaml
name: example_package
version: 1.0.0
# Ensures the package is published to https://dart-packages.example.com
publish_to: https://dart-packages.example.com
```

Para então publicar uma nova versão do pacote,
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
Mesmo se você não estiver usando um repositório privado,
você pode especificar `publish_to: none`
o que impede qualquer publicação acidental.
:::


### Overriding the default package repository {:#default-override}

Por padrão, `dart pub` recupera dependências e publica pacotes
no [site pub.dev]({{site.pub}})
a menos que a sintaxe hosted-dependency
seja usada para especificar um repositório de pacotes customizado.
No entanto, você pode sobrescrever o repositório de pacotes padrão usando a
variável de ambiente [`PUB_HOSTED_URL`](/tools/pub/environment-variables).

Esta abordagem é particularmente útil ao espelhar todos os pacotes
em um repositório de pacotes privado ou um subconjunto do pub.dev
ao trabalhar em um ambiente de rede restrito.


## Setting up a custom package repository

Você pode escrever um repositório de pacotes customizado implementando
a REST API descrita na
[Hosted Pub Repository Specification Version 2][repository-spec-v2.md].

### Dart package repositories as a service

Repositórios de pacotes customizados também são oferecidos como um serviço
com suporte para autenticação por token por múltiplos fornecedores,
aliviando você da sobrecarga de hospedar e manter
seu próprio repositório de pacotes customizado:

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
</ul>


[repository-spec-v2.md]: {{site.repo.dart.org}}/pub/blob/master/doc/repository-spec-v2.md
