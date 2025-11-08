---
title: dart pub get
description: >-
  Use dart pub get para recuperar as dependências usadas pelo seu aplicativo Dart.
ia-translate: true
---

_Get_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub get [options]
```

Este comando obtém todas as dependências listadas no
arquivo [`pubspec.yaml`](/tools/pub/pubspec) no diretório
de trabalho atual, bem como suas
[dependências transitivas](/resources/glossary#transitive-dependency).
Por exemplo:

```console
$ dart pub get
Resolving dependencies...
Got dependencies!
```

Se o [cache do sistema](/resources/glossary#pub-system-cache)
ainda não contiver as dependências, `dart pub get`
atualiza o cache,
baixando dependências se necessário.
Para mapear pacotes de volta para o cache do sistema,
este comando cria um arquivo `package_config.json`
no diretório `.dart_tool/`.

Depois que as dependências são adquiridas, elas podem ser referenciadas no código Dart.
Por exemplo, se um pacote depende de `test`:

```dart
import 'package:test/test.dart';
```

Quando `dart pub get` obtém novas dependências, ele escreve um
[arquivo de bloqueio](/resources/glossary#lockfile) para garantir que futuras
buscas usem as mesmas versões dessas dependências.
[Pacotes de aplicação][] devem fazer check-in do arquivo de bloqueio no controle de origem;
isso garante que o aplicativo use as mesmas versões
de todas as dependências para todos os desenvolvedores e quando implantado em produção.
Pacotes normais não devem fazer check-in do arquivo de bloqueio, porém, já que se espera
que funcionem com uma variedade de versões de dependência.

Se um arquivo de bloqueio já existir, `dart pub get` usa as versões de dependências
bloqueadas nele, se possível. Se uma dependência não estiver bloqueada, pub obtém a
versão mais recente dessa dependência que satisfaz todas as [restrições de
versão](/resources/glossary#version-constraint).
Esta é a diferença principal entre `dart pub get` e
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), que sempre tenta
obter as versões mais recentes de todas as dependências.

[Pacotes de aplicação]: /resources/glossary#application-package

## Resolução de pacotes

Por padrão, pub cria um arquivo `package_config.json`
no diretório `.dart_tool/` que mapeia nomes de pacotes para URIs de localização.

:::note
Não faça check-in do diretório gerado `.dart_tool/` em seu repositório;
adicione-o ao arquivo `.gitignore` do seu repositório.
Para mais informações,
consulte [O que não fazer commit](/tools/pub/private-files).
:::


## Obter uma nova dependência

Se uma dependência for adicionada ao pubspec e depois `dart pub get` for executado,
ela obtém a nova dependência e qualquer uma de suas dependências transitivas.
No entanto, pub não alterará as versões de nenhuma dependência já adquirida
a menos que seja necessário para obter a nova dependência.


## Remover uma dependência

Se uma dependência for removida do pubspec e depois `dart pub get` for executado,
a dependência não estará mais disponível para importação.
Qualquer dependência transitiva da dependência removida também será removida,
desde que nenhuma dependência imediata restante também dependa delas.
Remover uma dependência nunca altera as versões de nenhuma
dependência já adquirida.


## O cache do pacote do sistema

Dependências baixadas pela internet, como as do Git e do
[site pub.dev]({{site.pub}}), são armazenadas em um
[cache em todo o sistema](/resources/glossary#pub-system-cache).
Isso significa que se vários pacotes usarem a mesma versão da
mesma dependência, ela só precisa ser
baixada e armazenada localmente uma vez.

Por padrão, o cache do pacote do sistema está localizado no subdiretório `.pub-cache`
do seu diretório home (no macOS e Linux),
ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows;
a localização pode variar dependendo da versão do Windows).
Você pode configurar a localização do cache configurando a
variável de ambiente [`PUB_CACHE`](/tools/pub/environment-variables)
antes de executar pub.


## Obter enquanto offline

Se você não tiver acesso à rede, ainda poderá executar `dart pub get`.
Como pub baixa pacotes para um cache central compartilhado por todos os pacotes
em seu sistema, muitas vezes pode encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub get` tenta ficar online se você
tiver qualquer dependência hospedada,
para que pub possa detectar versões mais recentes de dependências.
Se você não quiser que pub faça isso, passe o sinalizador `--offline`.
No modo offline, pub procura apenas em seu cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com seu pacote a partir do que já está
disponível.

Tenha em mente que pub gera um arquivo de bloqueio. Se a
única versão de alguma dependência em seu cache for antiga,
`dart pub get` offline bloqueia seu aplicativo nessa versão antiga.
Na próxima vez que você estiver online, você provavelmente desejará
executar [`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) para atualizar para uma versão mais recente.


## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n`

Relata as dependências que seriam alteradas,
mas não faz as alterações. Isso é útil se você
deseja analisar atualizações antes de fazê-las.

### `--[no-]precompile`

Por padrão, pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para evitar pré-compilação, use `--no-precompile`.

### `--enforce-lockfile`

Impor a resolução do `pubspec.lock` atual.

Falha no `pub get` com uma mensagem de erro se o `pubspec.lock` não especificar exatamente
uma resolução válida de `pubspec.yaml` ou se algum hash de conteúdo de um pacote
hospedado mudou.

Útil para CI ou implantação em produção.

Leia [Obter dependências para produção](/tools/pub/packages#get-dependencies-for-production)
para mais detalhes.

{% render 'pub-problems.md' %}
