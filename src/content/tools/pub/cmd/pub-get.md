---
ia-translate: true
title: dart pub get
description: >-
  Use dart pub get para recuperar as dependências usadas pelo seu aplicativo Dart.
---

_Get_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub get [options]
```

Este comando obtém todas as dependências listadas no
arquivo [`pubspec.yaml`](/tools/pub/pubspec) no diretório
de trabalho atual, além de suas
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
baixando as dependências se necessário.
Para mapear os pacotes de volta para o cache do sistema,
este comando cria um arquivo `package_config.json`
no diretório `.dart_tool/`.

Depois que as dependências forem obtidas, elas podem ser referenciadas no código Dart.
Por exemplo, se um pacote depende de `test`:

```dart
import 'package:test/test.dart';
```

Quando `dart pub get` obtém novas dependências, ele escreve um
[arquivo de bloqueio](/resources/glossary#lockfile) para garantir que as próximas
buscas usem as mesmas versões dessas dependências.
[Pacotes de aplicação][Application packages] devem fazer check-in do arquivo de bloqueio no controle de versão;
isso garante que o aplicativo use exatamente as mesmas versões
de todas as dependências para todos os desenvolvedores e quando for implantado em produção.
Pacotes comuns, porém, não devem fazer check-in do arquivo de bloqueio, já que
espera-se que funcionem com uma faixa de versões de dependências.

Se um arquivo de bloqueio já existir, `dart pub get` usa as versões das dependências
bloqueadas nele, se possível. Se uma dependência não estiver bloqueada, o pub obtém a
versão mais recente dessa dependência que satisfaz todas as [restrições de
versão](/resources/glossary#version-constraint).
Esta é a principal diferença entre `dart pub get` e
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), que sempre tenta
obter as versões mais recentes de todas as dependências.

[Application packages]: /resources/glossary#application-package

## Resolução de pacotes {:#package-resolution}

Por padrão, o pub cria um arquivo `package_config.json`
no diretório `.dart_tool/` que mapeia nomes de pacotes para URIs de localização.

:::note
Não faça check-in do diretório gerado `.dart_tool/` no seu repositório;
adicione-o ao arquivo `.gitignore` do repositório.
Para mais informações,
veja [O que não versionar](/tools/pub/private-files).
:::


## Obter uma nova dependência {:#getting-a-new-dependency}

Se uma dependência for adicionada ao pubspec e depois `dart pub get` for executado,
ele obtém a nova dependência e quaisquer das suas dependências transitivas.
No entanto, o pub não altera as versões de nenhuma dependência já obtida,
a menos que isso seja necessário para obter a nova dependência.


## Remover uma dependência {:#removing-a-dependency}

Se uma dependência for removida do pubspec e depois `dart pub get` for executado,
a dependência deixa de estar disponível para importação.
Quaisquer dependências transitivas da dependência removida também são removidas,
desde que nenhuma dependência imediata restante também dependa delas.
Remover uma dependência nunca altera as versões de nenhuma
dependência já obtida.


## O cache de pacotes do sistema {:#the-system-package-cache}

Dependências baixadas pela internet, como as do Git e do
[site pub.dev]({{site.pub}}), são armazenadas em um
[cache em todo o sistema](/resources/glossary#pub-system-cache).
Isso significa que, se vários pacotes usarem a mesma versão da
mesma dependência, ela só precisa ser
baixada e armazenada localmente uma vez.

Por padrão, o cache de pacotes do sistema fica no subdiretório `.pub-cache`
do seu diretório home (no macOS e no Linux),
ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows;
o local pode variar dependendo da versão do Windows).
Você pode configurar o local do cache definindo a
variável de ambiente [`PUB_CACHE`](/tools/pub/environment-variables)
antes de executar o pub.


## Obter enquanto offline {:#getting-while-offline}

Se você não tiver acesso à rede, ainda pode executar `dart pub get`.
Como o pub baixa pacotes para um cache central compartilhado por todos os pacotes
do seu sistema, ele muitas vezes consegue encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub get` tenta acessar a internet se você
tiver qualquer dependência hospedada,
para que o pub possa detectar versões mais recentes das dependências.
Se você não quiser que o pub faça isso, passe a flag `--offline`.
No modo offline, o pub procura apenas no cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com o seu pacote a partir do que já está
disponível.

Lembre-se de que o pub gera um arquivo de bloqueio. Se a
única versão de alguma dependência no seu cache for antiga,
o `dart pub get` offline prende seu aplicativo a essa versão antiga.
Na próxima vez que você estiver online, provavelmente vai querer
executar [`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) para atualizar para uma versão mais recente.


## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n`

Informa as dependências que seriam alteradas,
mas não faz as alterações. Isso é útil se você
quiser analisar as atualizações antes de fazê-las.

### `--[no-]precompile`

Por padrão, o pub pré-compila os executáveis
das dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

### `--[no-]example`

Por padrão, o pub também recupera as dependências do
[diretório `example/`][example-dir] do pacote (`--example`).
Para pular a recuperação das dependências de exemplo, use `--no-example`.

[example-dir]: /tools/pub/package-layout#examples

### `--enforce-lockfile`

Impõe a resolução do `pubspec.lock` atual.

Faz o `pub get` falhar com uma mensagem de erro se o `pubspec.lock` não especificar exatamente
uma resolução válida do `pubspec.yaml` ou se algum hash de conteúdo de um pacote
hospedado tiver mudado.

Útil para CI ou para implantação em produção.

Leia [Obter dependências para produção](/tools/pub/packages#get-dependencies-for-production)
para mais detalhes.

{% render 'pub-problems.md' %}
