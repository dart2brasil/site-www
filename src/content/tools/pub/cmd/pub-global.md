---
ia-translate: true
title: dart pub global
description: Use dart pub global para executar scripts Dart hospedados no site pub.dev a partir da linha de comando.
---

_Global_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

A opção `global` do Pub permite executar scripts Dart a partir da
linha de comando quando você não está atualmente dentro de um pacote.
Após [ativar um pacote](#activating-a-package), você pode
[executar scripts](#running-a-script) do diretório `bin` desse pacote.
[Desativar um pacote](#desativando-um-pacote) remove-o da
sua lista de pacotes disponíveis globalmente.

Por exemplo, digamos que você queira usar o [webdev][] para servir
seu aplicativo web Dart a partir da linha de comando.

```console
$ dart pub global activate webdev
$ webdev serve
```

Se isso não funcionar, pode ser necessário
[configurar seu path](#running-a-script-from-your-path).

Para executar um script Dart de dentro de um pacote, ou de um
pacote do qual seu pacote depende, veja [dart run](/tools/dart-run).

## Ativando um pacote {:#activating-a-package}

```plaintext
dart pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <pacote> [constraint-de-versão]
```

Ative um pacote quando você quiser poder executar
um ou mais de seus arquivos executáveis a partir da linha de comando.
Você pode ativar pacotes que residem no
[site pub.dev]({{site.pub}}), um repositório Git,
ou sua máquina local.
Depois de ativar um pacote, veja [Executando um
script](#running-a-script) para executar scripts
do diretório `bin` do pacote.

Quando você ativa um pacote, pode especificar uma versão opcional
_constraint_ (restrição). Veja a flag [constraint](#options) para exemplos de uso.

### Ativando um pacote no site pub.dev {:#ativando-um-pacote-no-site-pub-dev}

```console
$ dart pub global activate <pacote pub.dev>
```

Especifique um pacote no site pub.dev para ativá-lo. Por exemplo:

```console
$ dart pub global activate markdown
```

### Ativando um pacote com Git {:#ativando-um-pacote-com-git}

```console
$ dart pub global activate --source git <URL Git>
$ dart pub global activate -sgit <URL Git>
```

Use `--source git` (ou `-sgit`, para abreviar) para ativar
um pacote em um repositório Git. Os exemplos a seguir,
que ativam o pacote `async_await` no
[GitHub](https://github.com/), são equivalentes:

```console
$ dart pub global activate --source git https://github.com/dart-lang/async_await.git
$ dart pub global activate -sgit https://github.com/dart-lang/async_await.git
```

O Pub espera encontrar o pacote na raiz do repositório Git.
Para especificar um local diferente,
use a opção `--git-path` com
um caminho relativo à raiz do repositório:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-path pkgs/http/
```

O Pub usa a branch (ramo) padrão do repositório Git. Para especificar um
ramo ou commit diferente, use a opção `--git-ref`:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-ref 36f98e900347335af2338a0e087538009b7de2f9
```

### Ativando um pacote em sua máquina local {:#ativando-um-pacote-em-sua-maquina-local}

```console
$ dart pub global activate --source path <caminho>
```

Use `activate --source path <caminho>` para ativar um pacote na sua máquina local.
O exemplo a seguir ativa o pacote `stopwatch` do
diretório `~/dart`:

```console
$ dart pub global activate --source path ~/dart/stopwatch
```

### Atualizando um pacote ativado {:#atualizando-um-pacote-ativado}

Uma vez que um pacote foi ativado, você pode atualizá-lo ativando o
pacote novamente.

## Executando um script {:#running-a-script}

Você pode executar diretamente um script de um pacote ativado a partir da
linha de comando. Se você não conseguir executar o script diretamente,
você também pode usar `dart pub global run`.

### Executando um script a partir do seu PATH {:#running-a-script-from-your-path}

Para executar um script diretamente a partir da linha de comando, adicione o diretório `bin` do [cache do sistema][]
à sua variável de ambiente `PATH`.

Por exemplo, digamos que você ativou o pacote webdev,
mas você ainda não consegue executar o comando:

```console
$ dart pub global activate webdev
$ webdev serve
-bash: webdev: comando não encontrado
```

Verifique se o diretório `bin` para o cache do sistema está no seu path.
A seguinte variável `PATH`, no macOS, inclui o cache do sistema:

```console
$ echo $PATH
/Users/<user>/homebrew/bin:/usr/local/bin:/usr/bin:/bin:[!/Users/<user>/.pub-cache/bin!]
```

Se esse diretório estiver faltando no seu `PATH`,
localize o arquivo para sua plataforma e adicione-o.

| Plataforma                             | Localização do cache              |
|--------------------------------------|---------------------------------|
| macOS ou Linux                       | `$HOME/.pub-cache/bin`          |
| Windows<sup><strong>*</strong></sup> | `%LOCALAPPDATA%\Pub\Cache\bin` |

{:.table .table-striped}

<sup><strong>*</strong></sup> A localização exata do cache do sistema
pode variar para diferentes versões do Windows.

Agora você pode invocar o comando diretamente:

```console
$ cd web_project
$ [!webdev serve!]
```

Se o script ainda falhar ao executar a partir da linha de comando, o
pacote pode não estar [configurado](#configurando-executaveis-de-pacotes) para
este recurso. Você ainda pode executar o script usando `dart pub global run`.

### Executando um script usando `dart pub global run` {:#running-a-script-using-dart-pub-global-run}

```plaintext
$ dart pub global run <pacote>:<executável> [args...]
```

Mesmo que um script não esteja configurado para ser executado a partir da linha de comando,
você ainda pode usar `dart pub global run`.
O comando a seguir executa o script `bin/bar.dart` do
pacote `foo`, passando dois argumentos.

```console
$ dart pub global run foo:bar arg1 arg2
```

### Configurando executáveis de pacotes {:#configurando-executaveis-de-pacotes}

Se você não é um desenvolvedor de pacotes, pode pular esta seção.

Um pacote pode expor alguns de seus scripts como executáveis
que podem ser executados diretamente a partir da linha de comando. O script ou scripts
devem ser listados na entrada
[`executables`](/tools/pub/pubspec#executables)
do arquivo pubspec. Por exemplo, o arquivo pubspec a seguir
identifica `bin/helloworld.dart` como um executável para o helloworld
pacote:

```yaml
name: helloworld

executables:
  helloworld:
```

Não listar um script sob a tag `executables` reduz a
usabilidade do script: scripts não listados podem ser executados usando `dart pub global run`, mas não
diretamente da linha de comando.

## Desativando um pacote {:#desativando-um-pacote}

```console
$ dart pub global deactivate <pacote>
```

Use `deactivate` para remover um pacote da lista de
pacotes globais disponíveis. Por exemplo:

```console
$ dart pub global deactivate markdown
```

Você não pode mais invocar os scripts do pacote usando `dart pub global run`,
ou na linha de comando.

## Listando pacotes ativos {:#listando-pacotes-ativos}

```console
$ dart pub global list
```

Use `list` para listar todos os pacotes atualmente ativos.

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `[constraint-de-versão]` {:#constraint-de-versao}

Use `dart pub global activate <pacote> [constraint-de-versão]`
para especificar uma versão específica do pacote.
Por exemplo, o seguinte comando busca
a versão 0.6.0 do pacote `markdown`:

```console
$ dart pub global activate markdown 0.6.0
```

Se você especificar um intervalo, o pub escolherá a melhor versão que atenda a essa
_constraint_ (restrição). Por exemplo:

```console
$ dart pub global activate foo <3.0.0
```

### `--no-executables` {:#no-executables}

Use `dart pub global activate <pacote> --no-executables`
para ativar globalmente o pacote especificado,
mas não colocar nenhum executável em `bin`.
Você tem que usar `dart pub global run` para executar quaisquer executáveis.

### `--executable=<name>` ou `-x <name>` {:#executable-name-ou-x-name}

Use com `dart pub global activate`
para adicionar o executável especificado ao seu PATH.
Você pode passar mais de uma dessas flags.

Por exemplo, o comando a seguir adiciona `bar` e `baz`,
(mas não quaisquer outros executáveis que `foo` possa definir)
ao seu PATH.

```console
$ dart pub global activate foo -x bar -x baz
```

### `--overwrite` {:#overwrite}

Use `dart pub global activate <pacote> --overwrite`
para sobrescrever quaisquer executáveis globais ativados anteriormente
com o mesmo nome. Se você não especificar esta flag,
o executável preexistente não será substituído.


{% render 'pub-problems.md' %}

[cache do sistema]: /tools/pub/glossary#system-cache
[webdev]: /tools/webdev