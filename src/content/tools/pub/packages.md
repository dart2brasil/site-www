---
ia-translate: true
title: Como usar pacotes
shortTitle: Pacotes
breadcrumb: Visão geral
description: Saiba mais sobre pub, a ferramenta do Dart para gerenciar pacotes.
---

O ecossistema Dart usa _packages_ (pacotes) para gerenciar software compartilhado,
como bibliotecas e ferramentas.
Para obter packages Dart, você usa o **gerenciador de packages pub**.
Você pode encontrar packages disponíveis publicamente no
[**site pub.dev**,]({{site.pub}})
ou você pode carregar packages do sistema de arquivos local ou de outro lugar,
como repositórios Git.
De onde quer que seus packages venham, o pub gerencia as dependências de versão,
ajudando você a obter versões de packages que funcionem entre si e
com a sua versão do SDK.

A maioria das [IDEs com conhecimento de Dart][] oferece suporte para o uso do pub que
inclui criação, download, atualização e publicação de packages.
Ou você pode usar [`dart pub` na linha de comando](/tools/pub/cmd).

No mínimo,
um package Dart é um diretório contendo um [arquivo pubspec](/tools/pub/pubspec).
O pubspec contém alguns metadados sobre o package.
Além disso, um package pode conter dependências (listadas no pubspec),
bibliotecas Dart, aplicativos, recursos, testes, imagens e exemplos.

Para usar um package, faça o seguinte:

* Crie um pubspec (um arquivo chamado `pubspec.yaml` que
  lista as dependências do package e inclui
  outros metadados, como um número de versão).
* Use [`dart pub get`][get] para recuperar as dependências do seu package.
* Se o seu código Dart depende de uma biblioteca no package, importe a biblioteca.

## Criando um pubspec {:#creating-a-pubspec}

O pubspec é um arquivo chamado `pubspec.yaml`
que está no diretório superior do seu aplicativo.
O pubspec mais simples possível lista apenas o nome do package:

```yaml
name: my_app
```

Aqui está um exemplo de um pubspec que declara dependências de
dois packages (`intl` e `path`) que estão hospedados no site pub.dev:

```yaml
name: my_app

dependencies:
  intl: ^0.20.2
  path: ^1.9.1
```

Para atualizar o arquivo `pubspec.yaml`, sem edição manual,
você pode executar o comando `dart pub add`.
O exemplo a seguir adiciona uma dependência em `vector_math`.

```console
$ dart pub add vector_math
Resolving dependencies...
+ vector_math 2.1.3
Downloading vector_math 2.1.3...
Changed 1 dependency!
```

Para detalhes sobre a criação de um pubspec,
consulte a [documentação do pubspec](/tools/pub/pubspec)
e a documentação dos packages que você deseja usar.

## Obtendo packages {:#getting-packages}

Depois de ter um pubspec, você pode executar [`dart pub get`][get] do diretório
superior do seu aplicativo:

```console
$ cd <caminho-para-my_app>
$ dart pub get
```

Este processo é chamado de _obtenção das dependências_.

O comando `dart pub get`
determina de quais packages seu aplicativo depende
e os coloca em um [cache do sistema](/resources/glossary#pub-system-cache) central.
Se seu aplicativo depende de um package publicado, o pub baixa esse package do
[site pub.dev.]({{site.pub}})
Para uma [dependência Git](/tools/pub/dependencies#git-packages),
o pub clona o repositório Git.
Dependências transitivas também são incluídas.
Por exemplo, se o package `js` depende do package `test`, o `pub`
obtém tanto o package `js` quanto o package `test`.

O Pub cria um arquivo
`package_config.json` (no diretório `.dart_tool/`)
que mapeia cada nome de package do qual seu aplicativo depende
para o package correspondente no cache do sistema.


## Importando bibliotecas de packages {:#importing-libraries-from-packages}

Para importar bibliotecas encontradas em packages,
use o prefixo `package:`:

```dart
import 'package:js/js.dart' as js;
import 'package:intl/intl.dart';
```

O runtime Dart pega tudo depois de `package:`
e procura no arquivo `package_config.json` do
seu aplicativo.

Você também pode usar este estilo para importar bibliotecas de dentro do seu próprio package.
Digamos que o package `transmogrify` esteja organizado da seguinte forma:

```plaintext
transmogrify/
  lib/
    transmogrify.dart
    parser.dart
  test/
    parser/
      parser_test.dart
```

O arquivo `parser_test.dart` pode importar `parser.dart` assim:

```dart
import 'package:transmogrify/parser.dart';
```


## Atualizando uma dependência {:#upgrading-a-dependency}

A primeira vez que você obtém uma nova dependência para o seu package,
o pub baixa a versão mais recente que é compatível com
suas outras dependências.
Em seguida, ele trava seu package para *sempre* usar essa versão,
criando um **lockfile** (arquivo de bloqueio).
Este é um arquivo chamado `pubspec.lock` que o pub cria
e armazena próximo ao seu pubspec.
Ele lista as versões específicas de cada dependência (imediata e transitiva)
que seu package usa.

Se o seu package for um [package de aplicação](/resources/glossary#application-package),
você deve incluir este arquivo no
[controle de versão](/tools/pub/private-files).
Dessa forma, todos que trabalham no seu aplicativo usam as mesmas versões
de todas as suas dependências.
Incluir o lockfile também garante que seu aplicativo implantado
use as mesmas versões de código.

Quando você estiver pronto para atualizar suas dependências para as versões mais recentes,
use o comando [`dart pub upgrade`][upgrade]:

```console
$ dart pub upgrade
```

O comando `dart pub upgrade` diz ao pub para regenerar o lockfile,
usando as versões mais recentes disponíveis das dependências do seu package.
Se você deseja atualizar apenas uma dependência,
você pode especificar o package para atualizar:

```console
$ dart pub upgrade transmogrify
```

Esse comando atualiza `transmogrify` para a versão mais recente,
mas deixa todo o resto igual.

O comando `dart pub upgrade` nem sempre pode atualizar todos os packages
para sua versão mais recente,
devido a restrições de versão conflitantes no pubspec.
Para identificar packages desatualizados que exigem a edição do pubspec,
use [`dart pub outdated`][outdated].

## Obter dependências para produção {:#get-dependencies-for-production}

Em algumas situações, `dart pub get` não recupera
as versões exatas de package bloqueadas no arquivo `pubspec.lock`:

* Se novas dependências forem adicionadas ou removidas de `pubspec.yaml` depois que
  o arquivo `pubspec.lock` foi atualizado pela última vez.
* Se a versão bloqueada não existir mais no repositório de packages.
* Se você mudou para uma versão diferente do Dart SDK,
  e alguns packages não são mais compatíveis com essa nova versão.

Nesses casos, `dart pub get` irá:

* Desbloquear versões de dependência bloqueadas o suficiente para que
  uma resolução se torne possível.
* Notificá-lo sobre quaisquer alterações de dependência em relação a
  o `pubspec.lock` existente.

Por exemplo, depois de adicionar `retry: ^3.0.0` às suas dependências:

```console
$ dart pub get
Resolving dependencies... (1.0s)
Downloading packages...
+ retry 3.1.2
```

Além disso, se o [hash de conteúdo][] de uma versão de package publicada
diferir do hash no arquivo `pubspec.lock`, o pub irá
avisá-lo e atualizar o lockfile para refletir a versão publicada.

Por exemplo, se você alterar manualmente o hash de `retry` em `pubspec.lock`:

```console
$ dart pub get
Resolving dependencies...
Downloading packages...
~ retry 3.1.2 (was 3.1.2)
The existing content-hash from pubspec.lock doesn't match contents for:
 * retry-3.1.2 from "https://pub.dev"

This indicates one of:
 * The content has changed on the server since you created the pubspec.lock.
 * The pubspec.lock has been corrupted.

The content-hashes in pubspec.lock has been updated.

For more information see:
https://dartbrasil.dev/go/content-hashes
Changed 1 dependency!
```

Ao implantar seu projeto em produção,
use `dart pub get --enforce-lockfile` para recuperar as dependências.

Se as restrições de dependência do seu projeto não puderem ser
satisfeitas com as versões exatas e os hashes de conteúdo em `pubspec.lock`,
a recuperação do package e o comando falharão.
Isso ajuda a evitar a implantação de
dependências e versões de dependência não testadas em produção.

```console
$ dart pub get --enforce-lockfile
Resolving dependencies...
Downloading packages...
~ retry 3.1.2 (was 3.1.2)
The existing content-hash from pubspec.lock doesn't match contents for:
 * retry-3.1.2 from "https://pub.dev"

This indicates one of:
 * The content has changed on the server since you created the pubspec.lock.
 * The pubspec.lock has been corrupted.

For more information see:
https://dartbrasil.dev/go/content-hashes
Would change 1 dependency.
Unable to satisfy `pubspec.yaml` using `pubspec.lock`.

To update `pubspec.lock` run `dart pub get` without `--enforce-lockfile`.
```

[content hash]: /resources/glossary#pub-content-hash

## Mais informações {:#more-information}

As páginas a seguir têm mais informações sobre packages e
o gerenciador de packages pub.


### Como {:#how-to}

* [Criando packages](/tools/pub/create-packages)
* [Publicando packages](/tools/pub/publishing)
* [Workspaces Pub (suporte a monorepo)](/tools/pub/workspaces)

### Referência {:#reference}

* [Pub dependencies](/tools/pub/dependencies)
* [Pub environment variables](/tools/pub/environment-variables)
* [Pub package layout conventions](/tools/pub/package-layout)
* [Pub versioning philosophy](/tools/pub/versioning)
* [Pubspec format](/tools/pub/pubspec)
* [Glossary with pub terms](/resources/glossary)

### Subcomandos Pub {:#pub-subcommands}

A ferramenta `dart pub` fornece os seguintes subcomandos:

{% render 'pub-subcommands.md' %}

Para uma visão geral de todos os subcomandos `dart pub`,
consulte a [documentação da ferramenta pub](/tools/pub/cmd).

### Solução de problemas {:#troubleshooting}

[Solução de problemas do Pub](/tools/pub/troubleshoot) oferece soluções para problemas que
você pode encontrar ao usar o pub.

[IDEs com conhecimento de Dart]: /tools#editors
[get]: /tools/pub/cmd/pub-get
[upgrade]: /tools/pub/cmd/pub-upgrade
[outdated]: /tools/pub/cmd/pub-outdated