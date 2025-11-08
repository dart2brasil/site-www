---
title: dart pub upgrade
description: Use dart pub upgrade para obter as versões mais recentes de todas as dependências usadas pelo seu aplicativo Dart.
ia-translate: true
---

_Upgrade_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub upgrade [options] [dependencies]
```

Como [`dart pub get`](/tools/pub/cmd/pub-get),
`dart pub upgrade` obtém dependências.
A diferença é que `dart pub upgrade` ignora qualquer
[arquivo de bloqueio](/resources/glossary#lockfile) existente,
para que pub possa obter as versões mais recentes de todas as dependências.
Um comando relacionado é [`dart pub outdated`](/tools/pub/cmd/pub-outdated),
que você pode executar para encontrar dependências desatualizadas.

Sem argumentos adicionais, `dart pub upgrade` obtém as versões mais recentes
de todas as dependências listadas no
arquivo [`pubspec.yaml`](/tools/pub/pubspec) no diretório
de trabalho atual, bem como suas [dependências
transitivas](/resources/glossary#transitive-dependency).
Por exemplo:

```console
$ dart pub upgrade
Dependencies upgraded!
```

Quando `dart pub upgrade` atualiza versões de dependências, ele escreve um arquivo de bloqueio para garantir que
[`dart pub get`](/tools/pub/cmd/pub-get) usará as mesmas versões dessas
dependências. Para [pacotes de aplicação][], faça check-in do arquivo de bloqueio no
controle de origem; isso garante que o aplicativo tenha as mesmas
versões de todas as dependências para todos os desenvolvedores e quando implantado em
produção. Para pacotes normais, não faça check-in do arquivo de bloqueio,
porque espera-se que os pacotes funcionem com uma variedade de versões de dependência.

Se um arquivo de bloqueio já existir, `dart pub upgrade` o ignora e gera um novo
do zero, usando as versões mais recentes de todas as dependências.

Consulte a [documentação de `dart pub get`](/tools/pub/cmd/pub-get) para mais informações
sobre resolução de pacotes e o cache do pacote do sistema.

[pacotes de aplicação]: /resources/glossary#application-package

## Fazer upgrade de dependências específicas

Você pode dizer ao `dart pub upgrade` para fazer upgrade de dependências específicas para a
versão mais recente, deixando o resto das dependências sem alteração o máximo
possível. Por exemplo:

```console
$ dart pub upgrade test args
Dependencies upgraded!
```

Geralmente, nenhuma outra dependência é atualizada; elas permanecem nas
versões que estão bloqueadas no arquivo de bloqueio. No entanto, se os upgrades solicitados
causarem incompatibilidades com essas versões bloqueadas, elas serão seletivamente
desbloqueadas até que um conjunto compatível de versões seja encontrado.

Isso significa que fazer upgrade de uma dependência específica não faz upgrade de suas
dependências transitivas por padrão.

Para fazer upgrade de uma dependência específica e de todas as suas dependências transitivas para suas
versões mais recentes, use o sinalizador `--unlock-transitive`.

```console
$ dart pub upgrade --unlock-transitive test args
```


## Obter uma nova dependência

Se uma dependência for adicionada ao pubspec antes de `dart pub upgrade` ser executado,
ela obtém a nova dependência e qualquer uma de suas dependências transitivas.
Isso compartilha o mesmo comportamento de `dart pub get`.


## Remover uma dependência

Se uma dependência for removida do pubspec antes de `dart pub upgrade` ser executado,
a dependência não estará mais disponível para importação.
Qualquer dependência transitiva da dependência removida também será removida,
desde que nenhuma dependência imediata restante também dependa delas.
Este é o mesmo comportamento de `dart pub get`.

## Fazer upgrade enquanto offline

Se você não tiver acesso à rede, ainda poderá executar `dart pub upgrade`.
Como pub baixa pacotes para um cache central compartilhado por todos os pacotes
em seu sistema, muitas vezes pode encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub upgrade` tenta ficar online se você
tiver qualquer dependência hospedada,
para que pub possa detectar versões mais recentes de dependências.
Se você não quiser que pub faça isso, passe o sinalizador `--offline`.
No modo offline, pub procura apenas em seu cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com seu pacote a partir do que já está
disponível.

Tenha em mente que pub gera um arquivo de bloqueio. Se a
única versão de alguma dependência em seu cache for antiga,
`dart pub upgrade` offline bloqueia seu aplicativo nessa versão antiga.
Na próxima vez que você estiver online, você provavelmente desejará
executar `dart pub upgrade` novamente para atualizar para uma versão mais recente.

## Opções

O comando `dart pub upgrade` oferece suporte às
[opções de `dart pub get`](/tools/pub/cmd/pub-get#options), e mais.
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

### `--major-versions`

Obtém os pacotes que [`dart pub outdated`][] lista como _resolvíveis_,
ignorando qualquer restrição de limite superior no arquivo `pubspec.yaml`.
Também atualiza `pubspec.yaml` com as novas restrições.

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
Pode ser aplicado a [dependências específicas](#fazer-upgrade-de-dependências-específicas).

### `--unlock-transitive`

Quando usado com uma lista de pacotes para desbloquear, primeiro o fechamento transitivo de
dependências desses pacotes (na resolução atual) é computado,
e então todos esses pacotes são desbloqueados.

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces), `dart pub upgrade` fará
upgrade de todas as dependências na resolução compartilhada em todos os
pacotes do workspace.

`dart pub upgrade --major-versions` e `dart pub upgrade --tighten` atualizarão
restrições em todos os arquivos `pubspec.yaml` do workspace.

{% render 'pub-problems.md' %}
