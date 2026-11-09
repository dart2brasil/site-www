---
ia-translate: true
title: Workspaces do pub (suporte a monorepo)
shortTitle: Workspaces
description: Saiba mais sobre os workspaces do pub, uma forma de gerenciar monorepos de pacotes.
---

Ao trabalhar em um projeto, você pode desenvolver vários pacotes Dart no mesmo
repositório de controle de versão (um _monorepo_).

Por exemplo, você pode ter uma estrutura de diretórios assim:

<FileTree>

- /
  - packages/
    - shared/
      - pubspec.yaml
      - pubspec.lock
      - .dart_tool/
        - package_config.json
    - client_package/
      - pubspec.yaml
      - pubspec.lock
      - .dart_tool/
        - package_config.json
    - server_package/
      - pubspec.yaml
      - pubspec.lock
      - .dart_tool/
        - package_config.json

</FileTree>

Essa configuração tem algumas desvantagens:

* Você precisa executar `dart pub get` uma vez para cada pacote.
* Você corre o risco de acabar com versões diferentes das dependências para cada pacote,
  causando confusão ao alternar o contexto entre os pacotes.
* Se você abrir a pasta raiz na sua IDE, o analisador do Dart vai criar
  contextos de análise separados para cada pacote, aumentando o uso de memória.

O pub permite organizar seu repositório como um _workspace_, usando uma única
resolução compartilhada para todos os seus pacotes.
Usar workspaces em repositórios grandes reduz a quantidade de memória
necessária para a análise, melhorando assim o desempenho.

:::note
Usar uma única resolução de dependências compartilhada para todos os seus pacotes aumenta
o risco de conflitos de dependência, porque o Dart não permite várias versões
do mesmo pacote.

Se os pacotes forem usados em conjunto (como costuma acontecer), esse
risco é um recurso útil. Ele obriga você a resolver incompatibilidades entre
os seus pacotes quando elas surgem, e não quando você começa a usar os pacotes.
:::

Para criar um workspace:

* Adicione um `pubspec.yaml` no diretório raiz do repositório, com uma entrada `workspace`
  que enumere os caminhos dos pacotes do repositório (os pacotes do
  workspace):

  ```yaml
  name: _
  publish_to: none
  environment:
    sdk: ^3.6.0
  workspace:
    - packages/shared
    - packages/client_package
    - packages/server_package
  ```

* Para cada um dos arquivos `pubspec.yaml` existentes, verifique se a restrição de SDK
  é pelo menos `^3.6.0` e adicione uma entrada `resolution`:

  ```yaml
  environment:
    sdk: ^3.6.0
  resolution: workspace
  ```

* Execute `dart pub get` em qualquer lugar do repositório. Isso vai:
  * Criar um único `pubspec.lock` ao lado do `pubspec.yaml` raiz, contendo a
    resolução de todas as `dependencies` e `dev_dependencies` de todos os
    pacotes do workspace.
  * Criar um único `.dart_tool/package_config.json` compartilhado, que mapeia os
    nomes dos pacotes para as localizações dos arquivos.
  * Apagar quaisquer outros arquivos `pubspec.lock` e
    `.dart_tool/package_config.json` existentes ao lado dos pacotes do workspace.

Agora, a estrutura de arquivos fica assim:

<FileTree>

- /
  - packages/
    - shared/
      - pubspec.yaml
    - client_package/
      - pubspec.yaml
    - server_package/
      - pubspec.yaml
  - pubspec.yaml
  - pubspec.lock
  - .dart_tool/
    - package_config.json

</FileTree>

:::version-note
O suporte a workspaces do pub foi introduzido no Dart 3.6.0.

Para usar workspaces do pub, todos os seus pacotes do workspace (mas não as suas dependências)
precisam ter uma restrição de versão do SDK de `^3.6.0` ou superior.
:::

## Suporte a padrões glob {:#glob-pattern-support}

:::version-note
O suporte a padrões glob requer o Dart 3.11 ou superior.
Se você usar uma versão anterior, use caminhos explícitos.
:::

A entrada `workspace` aceita padrões glob para
incluir pacotes automaticamente:

```yaml
workspace:
  - packages/*
```

Isso inclui todos os subdiretórios de
`packages/` que contenham um arquivo `pubspec.yaml`,
eliminando a necessidade de listar cada pacote manualmente.
Isso é especialmente útil para monorepos grandes ou que crescem com frequência.

Em vez de:

```yaml
workspace:
  - packages/shared
  - packages/client_package
  - packages/server_package
```

você pode usar um padrão glob que pega automaticamente os novos pacotes.

## Workspaces aninhados {:#nested-workspaces}

Você pode aninhar workspaces para organizar pacotes
hierarquicamente em repositórios grandes.
Um membro do workspace pode declarar seu próprio campo `workspace`,
assim como o `pubspec.yaml` raiz.

Por exemplo, se um pacote `server` divide sua implementação
em sub-pacotes `auth` e `api`,
liste-os no campo `workspace` do pacote `server`:

```yaml title="packages/server/pubspec.yaml" highlightLines=7-9
name: server

resolution: workspace
environment:
  sdk: ^3.6.0

workspace:
  - auth
  - api
```

Em seguida, marque cada sub-pacote como usando a resolução de workspace:

```yaml title="packages/server/auth/pubspec.yaml" highlightLines=3
name: auth

resolution: workspace
environment:
  sdk: ^3.6.0
```

O `pubspec.yaml` raiz só precisa listar `packages/server`.
O pub descobre `auth` e `api` pela entrada `workspace` do
pacote `server` e os inclui na
única resolução de dependências compartilhada.

## Arquivos perdidos {:#stray-files}

Quando você migra um monorepo existente para usar workspaces do pub, haverá
arquivos "perdidos" `pubspec.lock` e `.dart_tool/package_config.json` ao lado de
cada pubspec. Eles fazem sombra sobre os arquivos `pubspec.lock` e
`.dart_tool/package_config.json` colocados ao lado da raiz.

Por isso, o `pub get` vai apagar qualquer `pubspec.lock` e
`.dart_tool/package_config.json` localizados nos diretórios entre a raiz e
(incluindo) qualquer pacote do workspace.

<FileTree>

- /                    
  - packages/
    - foo/
      - pubspec.yaml   # Workspace member
      - pubspec.lock   # Deleted by `pub get`
      - .dart_tool/package_config.json # Deleted by `pub get`
    - pubspec.lock     # Deleted by `pub get`
    - .dart_tool/package_config.json # Deleted by `pub get`
  - pubspec.yaml       # Root

</FileTree>

Se algum diretório entre a raiz do workspace e um pacote do workspace contiver um
arquivo `pubspec.yaml` "perdido" que não é membro do workspace, o `pub get` vai
reportar um erro e falhar ao resolver. Isso acontece porque resolver esse `pubspec.yaml`
criaria um arquivo `.dart_tool/package_config.json` que faria sombra sobre o da raiz.

Por exemplo:

<FileTree>

- /
  - packages/
    - foo/
      - pubspec.yaml    # Workspace member
    - pubspec.yaml      # Not workspace member => error
  - pubspec.yaml        # Root `workspace: ['packages/foo']`

</FileTree>

## Dependências entre pacotes do workspace {:#interdependencies-between-workspace-packages}

Se algum dos pacotes do workspace depender um do outro, eles vão resolver automaticamente
para o pacote que está no workspace, independentemente da origem.

Por exemplo, `packages/client_package/pubspec.yaml` pode depender de `shared`:

```yaml
dependencies:
  shared: ^2.3.0
```

Quando resolvido dentro do workspace, a versão _local_ de `shared` será
usada.

A versão local de `shared` ainda terá que corresponder à restrição
(`^2.3.0`), no entanto.

Mas, quando o pacote é consumido como dependência sem fazer parte do
workspace, a origem original (aqui, implicitamente `hosted`) é usada.

Então, se `client_package` for publicado no pub.dev e alguém depender dele, essa
pessoa vai receber a versão hospedada de `shared` como dependência transitiva.

## Sobrescrita de dependências em um workspace {:#dependency-overrides-in-a-workspace}

Todas as seções `dependency_overrides` dos pacotes do workspace são respeitadas.
Você também pode colocar um arquivo `pubspec_overrides.yaml` ao lado de qualquer
um dos arquivos `pubspec.yaml` do workspace.

Você só pode sobrescrever um pacote uma vez no workspace. Para manter as sobrescritas organizadas,
é preferível manter os `dependency_overrides` no `pubspec.yaml` raiz.

## Executando um comando em um pacote específico do workspace {:#running-a-command-in-a-specific-workspace-package}

Alguns comandos do pub, como `dart pub add` e `dart pub publish`, operam sobre um
pacote "atual". Você pode mudar de diretório ou usar `-C` para apontar o pub para
um diretório:

```console
$ dart pub -C packages/client_package publish
# Same as
$ cd packages/client_package ; dart pub publish ; cd -
```

## Resolvendo temporariamente um pacote fora do seu workspace: {:#temporarily-resolving-a-package-outside-its-workspace}

Às vezes, você pode querer resolver um pacote do workspace isoladamente, por exemplo
para validar as restrições de dependência dele.

Uma forma de fazer isso é criar um arquivo `pubspec_overrides.yaml` que redefine a
configuração `resolution`, assim:

```yaml
# packages/client_package/pubspec_overrides.yaml
resolution:
```

Agora, executar `dart pub get` dentro de `packages/client_package` vai criar uma
resolução independente.

## Listando todos os pacotes do workspace {:#listing-all-workspace-packages}

Você pode executar `dart pub workspace list` para listar os pacotes de um workspace.

```console
$ dart pub workspace list
Package         Path                      
_               ./                        
client_package  packages/client_package/  
server_package  packages/server_package/  
shared          packages/shared/
```
