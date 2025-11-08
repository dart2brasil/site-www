---
ia-translate: true
title: Repositórios de pacotes personalizados
description: >-
  Como a ferramenta de gerenciamento de pacotes do Dart, pub,
  funciona com repositórios de pacotes personalizados.
---

A ferramenta `dart pub` suporta repositórios de pacotes de terceiros.
Um repositório de pacotes é um servidor que hospeda pacotes Dart
para consumo pela ferramenta `dart pub`.
O repositório de pacotes padrão usado, [pub.dev]({{site.pub}}),
é operado pela equipe do Dart para
facilitar a publicação de pacotes Dart para uso público.
Um repositório de pacotes é identificado por um
_hosted-url_ (URL hospedada), como `https://dart-packages.example.com/`.

Às vezes, um repositório de pacotes personalizado pode ser útil
para hospedar pacotes privados,
inclusive em alguns dos seguintes cenários:

1. Compartilhamento de pacotes proprietários internos dentro de uma organização.
2. Controle rigoroso de dependências em ambientes corporativos.
3. Ambientes seguros sem acesso público à internet.

Também é comum usar [git-dependencies]( /tools/pub/dependencies#git-packages)
para hospedar pacotes privados, no entanto,
a ferramenta `dart pub` não suporta a resolução de versões em relação a um repositório git;
ela apenas busca uma revisão específica do repositório git.
Portanto, quando muitas pessoas estão colaborando,
geralmente é preferível usar um repositório de pacotes privado.

## Autenticação com um repositório de pacotes personalizado {:#token-authentication}

A maioria dos repositórios de pacotes personalizados são
repositórios de pacotes privados que exigem autenticação.
Para autenticar em repositórios de pacotes personalizados,
a ferramenta `dart pub` anexa um token secreto às solicitações.

Você pode obter o token secreto do seu repositório de pacotes personalizado
e especificá-lo manualmente ou através de uma variável de ambiente.
Para especificar manualmente o token secreto,
use o comando `dart pub token add`
que solicita o token:

```console
$ dart pub token add https://dart-packages.example.com
Enter secret token: [insira o token secreto]
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token.
(Solicitações para "https://dart-packages.example.com" agora serão autenticadas usando o token secreto.)
```

Você também pode instruir o `dart pub` a ler o token de uma variável de ambiente,
inclusive em um ambiente CI (Integração Contínua), com a flag `--env-var`:

```console
$ dart pub token add https://dart-packages.example.com --env-var MY_SECRET_TOKEN
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token stored in the environment variable "MY_SECRET_TOKEN".
(Solicitações para "https://dart-packages.example.com" agora serão autenticadas usando o token secreto armazenado na variável de ambiente "MY_SECRET_TOKEN".)
```

Isso garante que o `dart pub` não armazene de fato
o token secreto em sua configuração,
em vez disso, ele apenas armazena o fato de que
deve ler o segredo da variável de ambiente `$MY_SECRET_TOKEN`.
Isso reduz o risco de que segredos sejam acidentalmente vazados
se o ambiente de execução for compartilhado entre trabalhos de CI.

:::note
Quando a ferramenta `dart pub` não tem um token para uma determinada URL de repositório,
ela tenta fazer solicitações sem autenticação.
:::


## Recuperando dependências de um repositório de pacotes personalizado {:#retrieving-dependencies-from-a-custom-package-repository}

Para buscar um pacote de um repositório de pacotes personalizado,
você deve especificar o _hosted-url_ para o pacote em `pubspec.yaml`,
usando a sintaxe para [pacotes hospedados]( /tools/pub/dependencies#hosted-packages).
Por exemplo:

```yaml
dependencies:
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

No exemplo anterior, `package:example_package`
é buscado de `https://dart-packages.example.com`.
Se a autenticação for exigida por este repositório de pacotes,
consulte [Autenticação com um repositório de pacotes personalizado](#token-authentication)
para obter mais informações sobre como autenticar suas solicitações.

Você também pode usar o comando `dart pub add`
com a flag `--hosted` para adicionar uma dependência de um repositório de pacotes personalizado:

```console
$ dart pub add example_package --hosted https://dart-packages.example.com
```

### Usando vários repositórios de pacotes {:#using-multiple-package-repositories}

Você também pode buscar diferentes dependências
de diferentes repositórios de pacotes,
já que o _hosted-url_ pode ser especificado para cada dependência:

```yaml
dependencies:
  # o pacote retry é buscado de pub.dev (o repositório de pacotes padrão)
  retry: ^3.0.0
  # o pacote example_package é buscado de https://dart-packages.example.com
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

Isso permite que você mantenha pacotes privados em um repositório de pacotes privado
enquanto usa os pacotes públicos mais atualizados como dependências.

No entanto, conflitos podem surgir facilmente se suas dependências exigirem
um pacote com o mesmo nome de repositórios diferentes.
Por exemplo, se o pacote `retry` exige `meta` de pub.dev,
e `example_package` exige `meta` de `https://dart-packages.example.com`.
Portanto, se espelhar quaisquer pacotes em um repositório de pacotes privado,
muitas vezes é necessário espelhar todas as dependências
e atualizar a seção `dependencies` de cada pacote,
ou [substituir o repositório de pacotes padrão](#default-override).

:::note
Para garantir que os pacotes públicos sejam utilizáveis por todos,
o repositório de pacotes oficial, [pub.dev]({{site.pub}}),
não permite a publicação de pacotes
com git-dependencies ou hosted-dependencies de repositórios de pacotes personalizados.

No entanto, tais pacotes podem ser publicados em um repositório de pacotes personalizado.
:::


## Publicando em um repositório de pacotes personalizado {:#publishing-to-a-custom-package-repository}

Para publicar um pacote em um repositório de pacotes personalizado
em vez de [pub.dev]({{site.pub}}),
especifique a propriedade
[`publish_to`](/tools/pub/pubspec#publish-to) em `pubspec.yaml`.
Se a autenticação estiver habilitada,
a publicação usa a mesma [autenticação por token](#token-authentication)
que a recuperação de pacotes.

:::note
Para evitar a publicação acidental em [pub.dev]({{site.pub}})
ao trabalhar em um pacote privado,
é uma boa ideia especificar isso no início do desenvolvimento.
:::

Para preparar um pacote para publicação em `https://dart-packages.example.com`,
seu `pubspec.yaml` deve ter no mínimo a seguinte aparência:

```yaml
name: example_package
version: 1.0.0
# Garante que o pacote seja publicado em https://dart-packages.example.com {:#ensures-the-package-is-published-to-https-dart-packages-example-com}
publish_to: https://dart-packages.example.com
```

Para então publicar uma nova versão do pacote,
use `dart pub publish`:

```console
$ dart pub publish
Publishing example_package 1.0.0 to https://dart-packages.example.com
(Publicando example_package 1.0.0 em https://dart-packages.example.com)
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
você pode especificar `publish_to: none`
que impede qualquer publicação acidental.
:::


### Substituindo o repositório de pacotes padrão {:#default-override}

Por padrão, o `dart pub` recupera dependências e publica pacotes
no [site pub.dev]({{site.pub}})
a menos que a sintaxe de hosted-dependency
seja usada para especificar um repositório de pacotes personalizado.
No entanto, você pode substituir o repositório de pacotes padrão usando a
variável de ambiente [`PUB_HOSTED_URL`](/tools/pub/environment-variables).

Essa abordagem é particularmente útil ao espelhar todos os pacotes
em um repositório de pacotes privado ou um subconjunto de pub.dev
ao trabalhar em um ambiente de rede restrito.


## Configurando um repositório de pacotes personalizado {:#setting-up-a-custom-package-repository}

Você pode escrever um repositório de pacotes personalizado implementando
a API REST descrita na
[Especificação de Repositório Pub Hospedado Versão 2][repository-spec-v2.md].

### Repositórios de pacotes Dart como serviço {:#dart-package-repositories-as-a-service}

Repositórios de pacotes personalizados também são oferecidos como um serviço
com suporte para autenticação por token por vários fornecedores,
aliviando você da sobrecarga de hospedar e manter
seu próprio repositório de pacotes personalizado:

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
