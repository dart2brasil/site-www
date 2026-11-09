---
ia-translate: true
title: Como usar pacotes
shortTitle: Pacotes
breadcrumb: Visão geral
description: Saiba mais sobre o pub, a ferramenta do Dart para gerenciar pacotes.
---

O ecossistema Dart usa _pacotes_ para gerenciar software compartilhado,
como bibliotecas e ferramentas.
Para obter pacotes Dart, você usa o **gerenciador de pacotes pub**.
Você pode encontrar pacotes disponíveis publicamente no
[**site pub.dev**,]({{site.pub}})
ou pode carregar pacotes do sistema de arquivos local ou de outros lugares,
como repositórios Git.
Independentemente de onde os pacotes venham, o pub gerencia as dependências de versão,
ajudando você a obter versões de pacotes que funcionem entre si e
com a versão do seu SDK.

A maioria das [IDEs com suporte a Dart][Dart-savvy IDEs] oferece suporte para usar o pub,
o que inclui criar, baixar, atualizar e publicar pacotes.
Ou você pode usar o [`dart pub` na linha de comando](/tools/pub/cmd).

No mínimo,
um pacote Dart é um diretório que contém um [arquivo pubspec](/tools/pub/pubspec).
O pubspec contém alguns metadados sobre o pacote.
Além disso, um pacote pode conter dependências (listadas no pubspec),
bibliotecas Dart, apps, recursos, testes, imagens e exemplos.

Para usar um pacote, faça o seguinte:

* Crie um pubspec (um arquivo chamado `pubspec.yaml` que
  lista as dependências do pacote e inclui
  outros metadados, como um número de versão).
* Use [`dart pub get`][get] para obter as dependências do seu pacote.
* Se o seu código Dart depende de uma biblioteca do pacote, importe a biblioteca.

## Criando um pubspec {:#creating-a-pubspec}

O pubspec é um arquivo chamado `pubspec.yaml`
que fica no diretório de nível superior da sua aplicação.
O pubspec mais simples possível lista apenas o nome do pacote:

```yaml
name: my_app
```

Veja um exemplo de pubspec que declara dependências em
dois pacotes (`intl` e `path`) hospedados no site pub.dev:

```yaml
name: my_app

dependencies:
  intl: ^0.20.3
  path: ^1.9.1
```

Para atualizar o arquivo `pubspec.yaml` sem editá-lo manualmente,
você pode executar o comando `dart pub add`.
O exemplo a seguir adiciona uma dependência em `vector_math`.

```console
$ dart pub add vector_math
Resolving dependencies... 
+ vector_math 2.1.3
Downloading vector_math 2.1.3...
Changed 1 dependency!
```

Para detalhes sobre como criar um pubspec,
veja a [documentação do pubspec](/tools/pub/pubspec)
e a documentação dos pacotes que você quer usar.

## Obtendo pacotes {:#getting-packages}

Quando tiver um pubspec, você pode executar [`dart pub get`][get] no diretório
de nível superior da sua aplicação:

```console
$ cd <path-to-my_app>
$ dart pub get
```

Esse processo é chamado de _obter as dependências_.

O comando `dart pub get`
determina de quais pacotes seu app depende
e os coloca em um [cache do sistema](/resources/glossary#pub-system-cache) central.
Se o seu app depende de um pacote publicado, o pub baixa esse pacote do
[site pub.dev.]({{site.pub}})
Para uma [dependência Git](/tools/pub/dependencies#git-packages),
o pub clona o repositório Git.
Dependências transitivas também são incluídas.
Por exemplo, se o pacote `web` depende do pacote `test`, o `pub`
obtém tanto o pacote `web` quanto o pacote `test`.

O pub cria um
arquivo `package_config.json` (no diretório `.dart_tool/`)
que mapeia cada nome de pacote do qual seu app depende
para o pacote correspondente no cache do sistema.


## Importando bibliotecas de pacotes {:#importing-libraries-from-packages}

Para importar bibliotecas encontradas em pacotes,
use o prefixo `package:`:

```dart
import 'package:web/web.dart' as web;
import 'package:intl/intl.dart';
```

O runtime do Dart pega tudo o que vem depois de `package:`
e procura no arquivo `package_config.json` do seu app.

Você também pode usar esse estilo para importar bibliotecas de dentro do seu próprio pacote.
Suponha que o pacote `transmogrify` esteja organizado da seguinte forma:

<FileTree>

- transmogrify/
  - lib/
    - transmogrify.dart
    - parser.dart
  - test/
    - parser/
      - parser_test.dart

</FileTree>

O arquivo `parser_test.dart` pode importar `parser.dart` assim:

```dart
import 'package:transmogrify/parser.dart';
```


## Atualizando uma dependência {:#upgrading-a-dependency}

Na primeira vez que você obtém uma nova dependência para o seu pacote,
o pub baixa a versão mais recente dela que seja compatível com
suas outras dependências.
Em seguida, ele trava o seu pacote para *sempre* usar essa versão,
criando um **lockfile**.
É um arquivo chamado `pubspec.lock` que o pub cria
e armazena ao lado do seu pubspec.
Ele lista as versões específicas de cada dependência (imediata e transitiva)
que o seu pacote usa.

Se o seu pacote é um [pacote de aplicação](/resources/glossary#application-package),
você deve versionar este arquivo no
[controle de código-fonte](/tools/pub/private-files).
Assim, todos que trabalham no seu app usam as mesmas versões
de todas as dependências.
Versionar o lockfile também garante que o seu app implantado
use as mesmas versões de código.

Quando estiver pronto para atualizar suas dependências para as versões mais recentes,
use o comando [`dart pub upgrade`][upgrade]:

```console
$ dart pub upgrade
```

O comando `dart pub upgrade` manda o pub regenerar o lockfile,
usando as versões mais recentes disponíveis das dependências do seu pacote.
Se você quiser atualizar apenas uma dependência,
pode especificar o pacote a ser atualizado:

```console
$ dart pub upgrade transmogrify
```

Esse comando atualiza `transmogrify` para a versão mais recente,
mas mantém todo o resto igual.

O comando `dart pub upgrade` nem sempre consegue atualizar todos os pacotes
para a versão mais recente,
por causa de restrições de versão conflitantes no pubspec.
Para identificar pacotes desatualizados que exigem edição do pubspec,
use [`dart pub outdated`][outdated].

## Obter dependências para produção {:#get-dependencies-for-production}

Em algumas situações, `dart pub get` não recupera
as versões exatas dos pacotes travadas no arquivo `pubspec.lock`:

* Se novas dependências forem adicionadas ou removidas do `pubspec.yaml` depois que
  o arquivo `pubspec.lock` foi atualizado pela última vez.
* Se a versão travada não existir mais no repositório de pacotes.
* Se você mudou para uma versão diferente do Dart SDK
  e alguns pacotes não são mais compatíveis com essa nova versão.

Nesses casos, `dart pub get` vai:

* Destravar o suficiente das versões de dependências travadas para que
  uma resolução se torne possível.
* Notificar você sobre quaisquer mudanças de dependência em relação ao
  `pubspec.lock` existente.

Por exemplo, depois de adicionar `retry: ^3.0.0` às suas dependências:

```console
$ dart pub get
Resolving dependencies... (1.0s)
Downloading packages... 
+ retry 3.1.2
```

Além disso, se o [hash de conteúdo][content hash] de uma versão publicada de pacote
for diferente do hash no arquivo `pubspec.lock`, o pub vai
avisar você e atualizar o lockfile para refletir a versão publicada.

Por exemplo, se você alterar manualmente o hash de `retry` no `pubspec.lock`:

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
https://dart.dev/go/content-hashes
Changed 1 dependency!
```

Ao implantar seu projeto em produção,
use `dart pub get --enforce-lockfile` para obter as dependências.

Se as restrições de dependência do seu projeto não puderem ser
satisfeitas com as versões exatas e os hashes de conteúdo em `pubspec.lock`,
a obtenção dos pacotes e o comando vão falhar.
Isso ajuda a evitar que dependências e versões de dependências
não testadas sejam implantadas em produção.

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
https://dart.dev/go/content-hashes
Would change 1 dependency.
Unable to satisfy `pubspec.yaml` using `pubspec.lock`.

To update `pubspec.lock` run `dart pub get` without `--enforce-lockfile`.
```

[content hash]: /resources/glossary#pub-content-hash

## Mais informações {:#more-information}

As páginas a seguir trazem mais informações sobre pacotes e
o gerenciador de pacotes pub.


### Como fazer {:#how-to}

* [Criando pacotes](/tools/pub/create-packages)
* [Publicando pacotes](/tools/pub/publishing)
* [Workspaces do pub (suporte a monorepo)](/tools/pub/workspaces)

### Referência {:#reference}

* [Dependências do pub](/tools/pub/dependencies)
* [Variáveis de ambiente do pub](/tools/pub/environment-variables)
* [Convenções de layout de pacotes do pub](/tools/pub/package-layout)
* [Filosofia de versionamento do pub](/tools/pub/versioning)
* [Formato do pubspec](/tools/pub/pubspec)
* [Glossário com termos do pub](/resources/glossary)

### Subcomandos do pub {:#pub-subcommands}

A ferramenta `dart pub` oferece os seguintes subcomandos:

{% render 'pub-subcommands.md' %}

Para uma visão geral de todos os subcomandos do `dart pub`,
veja a [documentação da ferramenta pub](/tools/pub/cmd).

### Solução de problemas {:#troubleshooting}

[Solução de problemas do pub](/tools/pub/troubleshoot) traz soluções para problemas que
você pode encontrar ao usar o pub.

[Dart-savvy IDEs]: /tools#editors
[get]: /tools/pub/cmd/pub-get
[upgrade]: /tools/pub/cmd/pub-upgrade
[outdated]: /tools/pub/cmd/pub-outdated
