---
ia-translate: true
title: dart pub upgrade
description: Use dart pub upgrade para obter as versões mais recentes de todas as dependências usadas pelo seu aplicativo Dart.
---

_Upgrade_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub upgrade [options] [dependencies]
```

Assim como o [`dart pub get`](/tools/pub/cmd/pub-get),
o `dart pub upgrade` obtém dependências.
A diferença é que o `dart pub upgrade` ignora qualquer
[arquivo de bloqueio](/resources/glossary#lockfile) existente,
para que o pub possa obter as versões mais recentes de todas as dependências.
Um comando relacionado é o [`dart pub outdated`](/tools/pub/cmd/pub-outdated),
que você pode executar para descobrir dependências desatualizadas.

Sem argumentos adicionais, `dart pub upgrade` obtém as versões mais recentes de
todas as dependências listadas no arquivo [`pubspec.yaml`](/tools/pub/pubspec)
no diretório de trabalho atual, além de suas [dependências
transitivas](/resources/glossary#transitive-dependency).
Por exemplo:

```console
$ dart pub upgrade
Dependencies upgraded!
```

Quando `dart pub upgrade` atualiza as versões das dependências, ele escreve um arquivo de bloqueio para garantir que
[`dart pub get`](/tools/pub/cmd/pub-get) use as mesmas versões dessas
dependências. Para [pacotes de aplicação][application packages], faça check-in do arquivo de bloqueio no
controle de versão; isso garante que o aplicativo tenha exatamente as mesmas
versões de todas as dependências para todos os desenvolvedores e quando implantado em
produção. Para pacotes comuns, não faça check-in do arquivo de bloqueio,
porque espera-se que os pacotes funcionem com uma faixa de versões de dependências.

Se um arquivo de bloqueio já existir, `dart pub upgrade` o ignora e gera um novo
do zero, usando as versões mais recentes de todas as dependências.

Veja a [documentação de `dart pub get`](/tools/pub/cmd/pub-get) para mais informações
sobre resolução de pacotes e o cache de pacotes do sistema.

[application packages]: /resources/glossary#application-package

## Fazer upgrade de dependências específicas {:#upgrading-specific-dependencies}

Você pode dizer ao `dart pub upgrade` para fazer upgrade de dependências específicas para a
versão mais recente, mantendo as demais dependências o mais inalteradas possível. Por exemplo:

```console
$ dart pub upgrade test args
Dependencies upgraded!
```

Normalmente, nenhuma outra dependência é atualizada; elas permanecem nas
versões bloqueadas no arquivo de bloqueio. No entanto, se os upgrades solicitados
causarem incompatibilidades com essas versões bloqueadas, elas são desbloqueadas seletivamente
até que um conjunto compatível de versões seja encontrado.

Isso significa que fazer upgrade de uma dependência específica não faz upgrade das suas
dependências transitivas por padrão.

Para fazer upgrade de uma dependência específica e de todas as suas dependências transitivas para as
versões mais recentes, use a flag `--unlock-transitive`.

```console
$ dart pub upgrade --unlock-transitive test args
```


## Obter uma nova dependência {:#getting-a-new-dependency}

Se uma dependência for adicionada ao pubspec antes de `dart pub upgrade` ser executado,
ela obtém a nova dependência e quaisquer das suas dependências transitivas.
Isso tem o mesmo comportamento de `dart pub get`.


## Remover uma dependência {:#removing-a-dependency}

Se uma dependência for removida do pubspec antes de `dart pub upgrade` ser executado,
a dependência deixa de estar disponível para importação.
Quaisquer dependências transitivas da dependência removida também são removidas,
desde que nenhuma dependência imediata restante também dependa delas.
Este é o mesmo comportamento de `dart pub get`.

## Fazer upgrade offline {:#upgrading-while-offline}

Se você não tiver acesso à rede, ainda pode executar `dart pub upgrade`.
Como o pub baixa pacotes para um cache central compartilhado por todos os pacotes
do seu sistema, ele muitas vezes consegue encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub upgrade` tenta acessar a internet se você
tiver qualquer dependência hospedada,
para que o pub possa detectar versões mais recentes das dependências.
Se você não quiser que o pub faça isso, passe a flag `--offline`.
No modo offline, o pub procura apenas no cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com o seu pacote a partir do que já está
disponível.

Lembre-se de que o pub gera um arquivo de bloqueio. Se a
única versão de alguma dependência no seu cache for antiga,
o `dart pub upgrade` offline prende seu aplicativo a essa versão antiga.
Na próxima vez que você estiver online, provavelmente vai querer
executar `dart pub upgrade` novamente para atualizar para uma versão mais recente.

## Opções {:#options}

O comando `dart pub upgrade` oferece suporte às
[opções de `dart pub get`](/tools/pub/cmd/pub-get#options), e a outras mais.
Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n` {:#dry-run-or-n}

Informa as dependências que seriam alteradas,
mas não faz as alterações. Isso é útil se você
quiser analisar as atualizações antes de fazê-las.

### `--[no-]precompile`

Por padrão, o pub pré-compila os executáveis
das dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

### `--[no-]example`

Por padrão, o pub também faz upgrade das dependências do
[diretório `example/`][example-dir] do pacote (`--example`).
Para pular o upgrade das dependências de exemplo, use `--no-example`.

[example-dir]: /tools/pub/package-layout#examples

### `--major-versions`

Obtém os pacotes que o [`dart pub outdated`][] lista como _resolvable_,
ignorando qualquer restrição de limite superior no arquivo `pubspec.yaml`.
Também atualiza o `pubspec.yaml` com as novas restrições.

[`dart pub outdated`]: /tools/pub/cmd/pub-outdated

:::tip
Faça commit do arquivo `pubspec.yaml` antes de executar este comando,
para que você possa desfazer as alterações, se necessário.
:::

Para verificar quais dependências serão atualizadas,
você pode usar `dart pub upgrade --major-versions --dry-run`.

### `--tighten`

Atualiza os limites inferiores das dependências em `pubspec.yaml` para corresponder às
versões resolvidas e retorna uma lista das restrições alteradas.
Pode ser aplicada a [dependências específicas](#upgrading-specific-dependencies).

### `--unlock-transitive`

Quando usado com uma lista de pacotes para desbloquear, primeiro é calculado o fechamento transitivo das
dependências desses pacotes (na resolução atual),
e então todos esses pacotes são desbloqueados.

## Em um workspace {:#in-a-workspace}

Em um [workspace do pub](/tools/pub/workspaces), `dart pub upgrade` faz
upgrade de todas as dependências na resolução compartilhada entre todos os
pacotes do workspace.

`dart pub upgrade --major-versions` e `dart pub upgrade --tighten` atualizam
as restrições em todos os arquivos `pubspec.yaml` do workspace.

{% render 'pub-problems.md' %}
