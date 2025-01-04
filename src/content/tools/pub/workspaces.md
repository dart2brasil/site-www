---
ia-translate: true
title: Workspaces do Pub (suporte a monorepo)
short-title: Workspaces
description: Saiba mais sobre os workspaces do pub, uma forma de gerenciar monorepos de pacotes.
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

Existem algumas desvantagens nessa configuração:

* Você precisa executar `dart pub get` uma vez para cada pacote.
* Você corre o risco de acabar com diferentes versões de dependências para cada
  pacote, levando à confusão ao alternar o contexto entre os pacotes.
* Se você abrir a pasta raiz em seu IDE, o analisador Dart criará
  contextos de análise separados para cada pacote, aumentando o uso de memória.

O Pub permite que você organize seu repositório como um _workspace_ usando uma
resolução compartilhada única para todos os seus pacotes.
Usar workspaces para grandes repositórios reduz a quantidade de memória
necessária para análise, melhorando assim o desempenho.

:::note
Usar uma única resolução de dependência compartilhada para todos os seus
pacotes aumenta os riscos de conflitos de dependência, porque o Dart não
permite várias versões do mesmo pacote.

Se os pacotes forem usados juntos (como é comum), esse risco é um recurso útil.
Ele força você a resolver as incompatibilidades entre seus pacotes quando elas
surgem, em vez de quando você começa a usar os pacotes.
:::

Para criar um workspace:

* Adicione um `pubspec.yaml` no diretório raiz do repositório com uma entrada
  `workspace` enumerando os caminhos para os pacotes do repositório (os pacotes do
  workspace):

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

* Para cada um dos arquivos `pubspec.yaml` existentes, certifique-se de que
  sua restrição de SDK seja pelo menos `^3.6.0` e adicione uma entrada `resolution`:

  ```yaml
  environment:
    sdk: ^3.6.0
  resolution: workspace
  ```

* Execute `dart pub get` em qualquer lugar no repositório. Isso irá:
  * Criar um único `pubspec.lock` ao lado do `pubspec.yaml` raiz que contém a
    resolução de todas as `dependencies` (dependências) e `dev_dependencies`
    (dependências de desenvolvimento) de todos os pacotes do workspace.
  * Criar um único `.dart_tool/package_config.json` compartilhado que mapeia
    nomes de pacotes para localizações de arquivos.
  * Excluir quaisquer outros arquivos `pubspec.lock` e
    `.dart_tool/package_config.json` existentes ao lado dos pacotes do workspace.

Agora a estrutura de arquivos se parece com isto:

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
O suporte para workspaces do pub foi introduzido no Dart 3.6.0.

Para usar workspaces do pub, todos os seus pacotes do workspace (mas não suas
dependências) devem ter uma restrição de versão do SDK de `^3.6.0` ou superior.
:::

## Interdependências entre pacotes do workspace {:#interdependencies-between-workspace-packages}

Se algum dos pacotes do workspace depender um do outro, eles serão resolvidos
automaticamente para o do workspace, independentemente da fonte.

Ex: `packages/client_package/pubspec.yaml` pode depender de `shared`:

```yaml
dependencies:
  shared: ^2.3.0
```

Quando resolvido dentro do workspace, a versão _local_ de `shared`
será usada.

A versão local de `shared` ainda teria que corresponder à restrição (`^2.3.0`),
no entanto.

Mas quando o pacote é consumido como uma dependência sem fazer parte do
workspace, a fonte original (aqui implicitamente `hosted`) é usada.

Portanto, se o `client_package` for publicado no pub.dev e alguém depender
dele, obterá a versão hospedada de `shared` como uma dependência transitiva.

## Substituições de dependência em um workspace {:#dependency-overrides-in-a-workspace}

Todas as seções `dependency_overrides` (substituições de dependência) nos pacotes
do workspace são respeitadas. Você também pode colocar um arquivo
`pubspec_overrides.yaml` ao lado de qualquer um dos arquivos `pubspec.yaml` do workspace.

Você só pode substituir um pacote uma vez no workspace. Para manter as
substituições organizadas, é preferível manter `dependency_overrides` no `pubspec.yaml` raiz.

## Executando um comando em um pacote específico do workspace {:#running-a-command-in-a-specific-workspace-package}

Alguns comandos do pub, como `dart pub add` e `dart pub publish`, operam em um
pacote "atual". Você pode alterar o diretório ou usar `-C` para apontar o pub
para um diretório:

```console
$ dart pub -C packages/client_package publish
# Igual a {:#same-as}
$ cd packages/client_package ; dart pub publish ; cd -
```

## Resolvendo temporariamente um pacote fora de seu workspace: {:#temporarily-resolving-a-package-outside-its-workspace}

Às vezes, você pode querer resolver um pacote do workspace sozinho, por exemplo,
para validar suas restrições de dependência.

Uma maneira de fazer isso é criar um arquivo `pubspec_overides.yaml` que
redefina a configuração `resolution`, assim:

```yaml
# packages/client_package/pubspec_overrides.yaml {:#packages-client-package-pubspec-overrides-yaml}
resolution:
```

Agora, executar `dart pub get` dentro de `packages/client_package` criará uma
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