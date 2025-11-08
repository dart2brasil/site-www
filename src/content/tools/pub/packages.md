---
title: Como usar pacotes
shortTitle: Pacotes
breadcrumb: Visão geral
description: Aprenda mais sobre o pub, a ferramenta do Dart para gerenciar pacotes.
ia-translate: true
---

O ecossistema Dart usa _pacotes_ para gerenciar software compartilhado
como bibliotecas e ferramentas.
Para obter pacotes Dart, você usa o **gerenciador de pacotes pub**.
Você pode encontrar pacotes disponíveis publicamente no
[**site pub.dev**,]({{site.pub}})
ou pode carregar pacotes do sistema de arquivos local ou de outros lugares,
como repositórios Git.
Independentemente da origem dos seus pacotes, o pub gerencia dependências de versão,
ajudando você a obter versões de pacotes que funcionam entre si e
com a sua versão do SDK.

A maioria das [IDEs com suporte Dart][Dart-savvy IDEs] oferece suporte para usar o pub que
inclui criar, baixar, atualizar e publicar pacotes.
Ou você pode usar [`dart pub` na linha de comando](/tools/pub/cmd).

No mínimo,
um pacote Dart é um diretório contendo um [arquivo pubspec](/tools/pub/pubspec).
O pubspec contém alguns metadados sobre o pacote.
Adicionalmente, um pacote pode conter dependências (listadas no pubspec),
bibliotecas Dart, apps, recursos, testes, imagens e exemplos.

Para usar um pacote, faça o seguinte:

* Crie um pubspec (um arquivo chamado `pubspec.yaml` que
  lista as dependências do pacote e inclui
  outros metadados, como um número de versão).
* Use [`dart pub get`][get] para recuperar as dependências do seu pacote.
* Se o seu código Dart depende de uma biblioteca no pacote, importe a biblioteca.

## Criando um pubspec

O pubspec é um arquivo chamado `pubspec.yaml`
que fica no diretório principal da sua aplicação.
O pubspec mais simples possível lista apenas o nome do pacote:

```yaml
name: my_app
```

Aqui está um exemplo de um pubspec que declara dependências em
dois pacotes (`intl` e `path`) que estão hospedados no site pub.dev:

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
veja a [documentação do pubspec](/tools/pub/pubspec)
e a documentação dos pacotes que você deseja usar.

## Obtendo pacotes

Uma vez que você tenha um pubspec, você pode executar [`dart pub get`][get] do
diretório principal da sua aplicação:

```console
$ cd <path-to-my_app>
$ dart pub get
```

Este processo é chamado de _obter as dependências_.

O comando `dart pub get`
determina de quais pacotes seu app depende,
e os coloca em um [cache do sistema](/resources/glossary#pub-system-cache) central.
Se o seu app depende de um pacote publicado, o pub baixa esse pacote do
[site pub.dev.]({{site.pub}})
Para uma [dependência Git](/tools/pub/dependencies#git-packages),
o pub clona o repositório Git.
Dependências transitivas também são incluídas.
Por exemplo, se o pacote `js` depende do pacote `test`, o `pub`
obtém tanto o pacote `js` quanto o pacote `test`.

O pub cria um
arquivo `package_config.json` (sob o diretório `.dart_tool/`)
que mapeia cada nome de pacote do qual seu app depende
para o pacote correspondente no cache do sistema.


## Importando bibliotecas de pacotes

Para importar bibliotecas encontradas em pacotes,
use o prefixo `package:`:

```dart
import 'package:js/js.dart' as js;
import 'package:intl/intl.dart';
```

O runtime do Dart pega tudo após `package:`
e procura isso dentro do arquivo `package_config.json` para
o seu app.

Você também pode usar este estilo para importar bibliotecas de dentro do seu próprio pacote.
Vamos dizer que o pacote `transmogrify` está organizado da seguinte forma:

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


## Atualizando uma dependência

Na primeira vez que você obtém uma nova dependência para o seu pacote,
o pub baixa a versão mais recente que seja compatível com
suas outras dependências.
Ele então trava o seu pacote para *sempre* usar essa versão
criando um **lockfile**.
Este é um arquivo chamado `pubspec.lock` que o pub cria
e armazena ao lado do seu pubspec.
Ele lista as versões específicas de cada dependência (imediata e transitiva)
que o seu pacote usa.

Se o seu pacote é um [pacote de aplicação](/resources/glossary#application-package),
você deve fazer check-in deste arquivo no
[controle de versão](/tools/pub/private-files).
Dessa forma, todos trabalhando no seu app usam as mesmas versões
de todas as suas dependências.
Fazer check-in do lockfile também garante que o seu app implantado
use as mesmas versões de código.

Quando estiver pronto para atualizar suas dependências para as versões mais recentes,
use o comando [`dart pub upgrade`][upgrade]:

```console
$ dart pub upgrade
```

O comando `dart pub upgrade` diz ao pub para regenerar o lockfile,
usando as versões mais recentes disponíveis das dependências do seu pacote.
Se você quiser atualizar apenas uma dependência,
você pode especificar o pacote a atualizar:

```console
$ dart pub upgrade transmogrify
```

Esse comando atualiza `transmogrify` para a versão mais recente
mas deixa todo o resto igual.

O comando `dart pub upgrade` nem sempre pode atualizar todos os pacotes
para suas versões mais recentes,
devido a restrições de versão conflitantes no pubspec.
Para identificar pacotes desatualizados que requerem edição do pubspec,
use [`dart pub outdated`][outdated].

## Obter dependências para produção

Em algumas situações, `dart pub get` não recupera
as versões exatas de pacotes travadas no arquivo `pubspec.lock`:

* Se novas dependências forem adicionadas ou removidas do `pubspec.yaml` após
  a última atualização do arquivo `pubspec.lock`.
* Se a versão travada não existir mais no repositório de pacotes.
* Se você mudou para uma versão diferente do Dart SDK,
  e alguns pacotes não são mais compatíveis com essa nova versão.

Nesses casos, `dart pub get` vai:

* Destravar o suficiente das versões de dependências travadas para que
  uma resolução se torne possível.
* Notificar você sobre quaisquer mudanças de dependência em relação ao
  `pubspec.lock` existente.

Por exemplo, após adicionar `retry: ^3.0.0` às suas dependências:

```console
$ dart pub get
Resolving dependencies... (1.0s)
Downloading packages...
+ retry 3.1.2
```

Além disso, se o [hash de conteúdo][content hash] de uma versão de pacote publicada
diferir do hash no arquivo `pubspec.lock`, o pub irá
avisar você e atualizar o lockfile para refletir a versão publicada.

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
https://dart.dev/go/content-hashes
Changed 1 dependency!
```

Ao implantar seu projeto em produção,
use `dart pub get --enforce-lockfile` para recuperar dependências.

Se as restrições de dependência do seu projeto não puderem ser
satisfeitas com as versões exatas e hashes de conteúdo em `pubspec.lock`,
a recuperação de pacotes e o comando irão falhar.
Isso ajuda a evitar implantar dependências e versões de dependências
não testadas em produção.

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

## Mais informações

As páginas a seguir têm mais informações sobre pacotes e
o gerenciador de pacotes pub.


### Como fazer

* [Criando pacotes](/tools/pub/create-packages)
* [Publicando pacotes](/tools/pub/publishing)
* [Workspaces do pub (suporte a monorepo)](/tools/pub/workspaces)

### Referência

* [Dependências do pub](/tools/pub/dependencies)
* [Variáveis de ambiente do pub](/tools/pub/environment-variables)
* [Convenções de layout de pacotes do pub](/tools/pub/package-layout)
* [Filosofia de versionamento do pub](/tools/pub/versioning)
* [Formato do pubspec](/tools/pub/pubspec)
* [Glossário com termos do pub](/resources/glossary)

### Subcomandos do pub

A ferramenta `dart pub` fornece os seguintes subcomandos:

{% render 'pub-subcommands.md' %}

Para uma visão geral de todos os subcomandos do `dart pub`,
veja a [documentação da ferramenta pub](/tools/pub/cmd).

### Solução de problemas

[Solução de problemas do pub](/tools/pub/troubleshoot) fornece soluções para problemas que
você pode encontrar ao usar o pub.

[Dart-savvy IDEs]: /tools#editors
[get]: /tools/pub/cmd/pub-get
[upgrade]: /tools/pub/cmd/pub-upgrade
[outdated]: /tools/pub/cmd/pub-outdated
