---
title: Pub workspaces (monorepo support)
shortTitle: Workspaces
description: Learn more about pub workspaces, a way to manage package monorepos.
ia-translate: true
---

Ao trabalhar em um projeto, você pode desenvolver vários pacotes Dart no mesmo
repositório de controle de versão (um _monorepo_).

Por exemplo, você pode ter um layout de diretório como:

```plaintext
/
  packages/
    shared/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
    client_package/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
    server_package/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
```

Existem algumas desvantagens nesta configuração:

* Você precisa executar `dart pub get` uma vez para cada pacote.
* Você corre o risco de acabar com versões diferentes de dependências para cada pacote,
  levando a confusão ao alternar o contexto entre os pacotes.
* Se você abrir a pasta raiz no seu IDE, o analisador dart criará
  contextos de análise separados para cada pacote, aumentando o uso de memória.

O Pub permite que você organize seu repositório como um _workspace_ usando uma única
resolução compartilhada para todos os seus pacotes.
Usar workspaces para repositórios grandes reduz a quantidade de memória
necessária para análise, melhorando assim o desempenho.

:::note
Usar uma única resolução de dependência compartilhada para todos os seus pacotes aumenta
os riscos de conflitos de dependências, porque o Dart não permite múltiplas versões
do mesmo pacote.

Se os pacotes forem usados juntos (como é comumente o caso),
esse risco é um recurso útil. Ele força você a resolver incompatibilidades entre
seus pacotes quando elas surgem, em vez de quando você começa a usar os pacotes.
:::

Para criar um workspace:

* Adicione um `pubspec.yaml` no diretório raiz do repositório com uma entrada `workspace`
  enumerando os caminhos para os pacotes do repositório (os pacotes
  do workspace):

  ```yaml
  name: _
  publish_to: none
  environment:
    sdk: ^3.6.0
  workspace:
    - packages/helper
    - packages/client_package
    - packages/server_package
  ```

* Para cada um dos arquivos `pubspec.yaml` existentes, certifique-se de que sua restrição de SDK
  seja pelo menos `^3.6.0` e adicione uma entrada `resolution`:

  ```yaml
  environment:
    sdk: ^3.6.0
  resolution: workspace
  ```

* Execute `dart pub get` em qualquer lugar do repositório. Isso irá:
  * Criar um único `pubspec.lock` ao lado do `pubspec.yaml` raiz que contém
    a resolução de todas as `dependencies` e `dev_dependencies` de todos os
    pacotes do workspace.
  * Criar um único `.dart_tool/package_config.json` compartilhado que mapeia nomes de
    pacotes para localizações de arquivos.
  * Excluir quaisquer outros arquivos `pubspec.lock` e
    `.dart_tool/package_config.json` existentes ao lado dos pacotes do workspace.

Agora a estrutura de arquivos fica assim:

```plaintext
/
  packages/
    shared/
      pubspec.yaml
    client_package/
      pubspec.yaml
    server_package/
      pubspec.yaml
  pubspec.yaml
  pubspec.lock
  .dart_tool/package_config.json
```

:::version-note
O suporte para pub workspaces foi introduzido no Dart 3.6.0.

Para usar pub workspaces, todos os seus pacotes do workspace (mas não suas dependências)
devem ter uma restrição de versão de SDK de `^3.6.0` ou superior.
:::

<a name='stray-files'></a>
## Arquivos perdidos

Quando você migra um monorepo existente para usar Pub workspaces, haverá
arquivos `pubspec.lock` e `.dart_tool/package_config.json` "perdidos" existentes
adjacentes a cada pubspec. Estes ofuscam os arquivos `pubspec.lock` e
`.dart_tool/package_config.json` colocados ao lado da raiz.

Portanto, `pub get` excluirá qualquer `pubspec.lock` e
`.dart_tool/package_config.json` localizados em diretórios entre a raiz e
(incluindo) qualquer pacote do workspace.

```plaintext
/
  pubspec.yaml                       # Root
  packages/
    pubspec.lock                     # Deleted by `pub get`
    .dart_tool/package_config.json   # Deleted by `pub get`
    foo/
      pubspec.yaml                   # Workspace member
      pubspec.lock                   # Deleted by `pub get`
      .dart_tool/package_config.json # Deleted by `pub get`
```

Se qualquer diretório entre a raiz do workspace e um pacote do workspace contiver um
arquivo `pubspec.yaml` "perdido" que não é membro do workspace, `pub get` irá
reportar um erro e falhará ao resolver. Isso ocorre porque resolver tal `pubspec.yaml` criaria
um arquivo `.dart_tool/package_config.json` que ofusca o da raiz.

Por exemplo:

```plaintext
/
  pubspec.yaml                      # Root `workspace: ['foo/']`
  packages/
    pubspec.yaml                    # Not workspace member => error
    foo/
      pubspec.yaml                  # Workspace member
```


## Interdependências entre pacotes do workspace

Se algum dos pacotes do workspace depender uns dos outros, eles automaticamente
resolverão para aquele no workspace, independentemente da fonte.

Por exemplo, `packages/client_package/pubspec.yaml` pode depender de `shared`:

```yaml
dependencies:
  shared: ^2.3.0
```

Quando resolvido dentro do workspace, a versão _local_ de `shared` será
usada.

A versão local de `shared` ainda teria que corresponder à restrição
(`^2.3.0`).

Mas quando o pacote é consumido como uma dependência sem fazer parte do
workspace, a fonte original (aqui implicitamente `hosted`) é usada.

Então, se `client_package` for publicado no pub.dev e alguém depender dele, eles
obterão a versão hospedada de `shared` como uma dependência transitiva.

## Sobrescritas de dependências em um workspace

Todas as seções `dependency_overrides` nos pacotes do workspace são respeitadas.
Você também pode colocar um arquivo `pubspec_overrides.yaml` ao lado de qualquer um dos
arquivos `pubspec.yaml` do workspace.

Você só pode sobrescrever um pacote uma vez no workspace. Para manter as sobrescritas organizadas,
é preferível manter `dependency_overrides` no `pubspec.yaml` raiz.

## Executando um comando em um pacote específico do workspace

Alguns comandos do pub, como `dart pub add` e `dart pub publish`, operam em um
pacote "atual". Você pode mudar o diretório ou usar `-C` para apontar o pub para
um diretório:

```console
$ dart pub -C packages/client_package publish
# Same as
$ cd packages/client_package ; dart pub publish ; cd -
```

## Resolvendo temporariamente um pacote fora de seu workspace:

Às vezes, você pode querer resolver um pacote do workspace por conta própria, por exemplo,
para validar suas restrições de dependência.

Uma maneira de fazer isso é criar um arquivo `pubspec_overrides.yaml` que redefine a
configuração `resolution`, assim:

```yaml
# packages/client_package/pubspec_overrides.yaml
resolution:
```

Agora, executar `dart pub get` dentro de `packages/client_package` criará uma
resolução independente.

## Listando todos os pacotes do workspace

Você pode executar `dart pub workspace list` para listar os pacotes de um workspace.

```console
$ dart pub workspace list
Package         Path
_               ./
client_package  packages/client_package/
server_package  packages/server_package/
shared          packages/shared/
```
