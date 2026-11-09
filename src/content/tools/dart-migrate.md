---
ia-translate: true
title: dart migrate
description: >-
  Ferramenta de linha de comando para migrar projetos Dart para versões mais recentes do SDK.
---

:::version-note
O suporte a `dart migrate` foi introduzido no Dart 3.14.
:::

Para atualizar seu projeto Dart (aplicativo ou pacote)
para uma [versão da linguagem][language version] mais recente,
use o comando `dart migrate`.
Ele atualiza a restrição de versão mínima do SDK Dart (`environment.sdk`)
no arquivo `pubspec.yaml` e
aplica as correções automatizadas de código exigidas por essa mudança de versão.
O comando `dart migrate` oferece suporte a projetos cuja restrição mínima de SDK
exija o Dart 3.0 ou posterior.

O comando `dart migrate` atualiza apenas a restrição de SDK do projeto
e o código-fonte.
Ele não atualiza o Dart ou o Flutter SDK instalado na sua máquina.
Para atualizar o SDK instalado primeiro,
consulte [Obtenha o Dart SDK][Get the Dart SDK] ou o comando [`flutter upgrade`][].

## Migre um projeto {:#migrate-a-project}

Execute o comando `dart migrate` a partir do diretório raiz do seu projeto.
Visualize primeiro as alterações propostas usando a opção `--dry-run`
e, em seguida, aplique-as no seu arquivo `pubspec.yaml` e nos arquivos de código
usando a opção `--apply`:

```console
$ dart migrate --dry-run
$ dart migrate --apply
```

Como o comando `dart migrate` não verifica alterações não commitadas
no controle de versão, salve todos os arquivos abertos e faça commit ou stash de
qualquer trabalho não commitado antes de executar `dart migrate --apply`.

### Migre vários projetos {:#migrate-multiple-projects}

Por padrão, o comando `dart migrate` migra o projeto
no diretório de trabalho atual.
Para migrar vários projetos de uma vez,
passe os caminhos dos diretórios deles como argumentos:

```console
$ dart migrate --apply my_app packages/my_pkg
```

O comando `dart migrate` não expande automaticamente os [Pub workspaces][].
Para migrar pacotes em um workspace,
passe o caminho do diretório de cada pacote para o comando.

## Opções para `dart migrate` {:#options-for-dart-migrate}

As opções a seguir estão disponíveis para o comando `dart migrate`.

### `-h`, `--help` {:#h--help}

Exibe as informações de uso do comando `dart migrate`.

```console
$ dart migrate --help
```

### `-n`, `--dry-run` {:#n--dry-run}

Visualiza as alterações de migração propostas sem modificar nenhum arquivo.

```console
$ dart migrate --dry-run
```

### `--apply` {:#apply}

Aplica as alterações propostas diretamente no seu arquivo `pubspec.yaml`
e nos arquivos de código-fonte.

```console
$ dart migrate --apply
```

### `--target-sdk` {:#target-sdk}

Especifica a versão do Dart SDK de destino para a migração.
Sem essa opção, o comando `dart migrate` eleva a restrição inferior do SDK
no arquivo `pubspec.yaml` em uma versão menor
(por exemplo, de `^3.12.0` para `^3.13.0`).
A versão de destino não pode ser mais recente que a versão do Dart SDK
atualmente instalada na sua máquina.

Quando você especificar uma versão de `--target-sdk`
que esteja várias versões menores à frente,
o comando `dart migrate` executa a migração de forma incremental,
uma versão menor por vez, até chegar à versão de destino:

```console
$ dart migrate --apply --target-sdk=3.13.0
```

### `--step` {:#step}

Especifica quais etapas de migração executar:
`prepare`, `bump`, `cleanup` ou `all`.
Para detalhes sobre cada etapa,
consulte a seção [Como funciona a migração][How migration works] desta página.
Você pode passar uma única etapa ou uma lista de etapas separada por vírgulas.
Se você omitir esta opção,
o comando `dart migrate` executa `prepare,bump` por padrão.

Executar etapas específicas é útil em bases de código maiores
em que você quer revisar as correções antes ou depois de elevar a restrição do SDK:

```console
# Run only preparatory fixes without bumping the constraint
$ dart migrate --apply --step=prepare

# After applying preparatory fixes, bump the constraint and apply cleanups
$ dart migrate --apply --step=bump,cleanup
```

:::note
Todas as correções preparatórias para a versão de destino do SDK devem ser concluídas
antes de executar a etapa `bump`.
Se você executar `--step=bump` enquanto correções `prepare` obrigatórias
ainda não tiverem sido aplicadas, o comando `dart migrate` para
sem atualizar o seu arquivo `pubspec.yaml`.
:::

## Como funciona a migração {:#how-migration-works}

Quando você executa o comando `dart migrate`,
a ferramenta executa automaticamente as lints de migração relevantes e os quick fixes
para a versão de destino, mesmo que o seu arquivo [`analysis_options.yaml`][] não
habilite essas lints.
Ela executa as etapas a seguir, nesta ordem:

1. **Verificação de dependências.**
   Ela verifica se as dependências do seu projeto no arquivo `pubspec.yaml`
   oferecem suporte à versão de destino do Dart SDK.
   Se alguma dependência for incompatível,
   a ferramenta para e informa quais pacotes precisam ser atualizados primeiro.
1. **A etapa `prepare` (correções pré-bump).**
   Ela aplica correções automatizadas para código que quebra ou muda de comportamento
   na [versão da linguagem][language version] de destino, antes de alterar o arquivo `pubspec.yaml`.
1. **A etapa `bump` (atualização da restrição do SDK).**
   Ela eleva a restrição inferior `environment.sdk` no arquivo `pubspec.yaml`
   e reanalisa o seu projeto sob a nova versão da linguagem.
1. **A etapa `cleanup` (correções opcionais pós-bump).**
   Ela aplica correções opcionais que ajudam seu código a adotar novos recursos de linguagem
   introduzidos na versão de destino.
   Por padrão, o comando `dart migrate` não aplica as correções de `cleanup`
   automaticamente.
   Em vez disso, ele lista as limpezas disponíveis no resumo de saída
   para que você possa escolher se quer aplicá-las
   usando a opção `--step=cleanup` ou `--step=all`.

Se qualquer etapa falhar, o comando `dart migrate` deixa inalterados
os seus arquivos de código-fonte e o arquivo `pubspec.yaml`.
Em vez disso, ele exibe um resumo das dependências incompatíveis
ou dos arquivos com erros, para que você possa resolvê-los manualmente
e executar o comando `dart migrate` novamente.

### Exemplo {:#example}

Suponha que o seu projeto (`my_pkg`) tenha um arquivo `pubspec.yaml`
com uma restrição mínima de SDK de `3.12.0`:

```yaml title="pubspec.yaml"
name: my_pkg
environment:
  sdk: ^3.12.0
```

Suponha também que o seu arquivo `lib/greeter.dart` defina uma classe de exceção vazia
e use o modificador `final` em parâmetros de função que não declaram nada
(o que se tornou um erro de compilação no Dart 3.13,
quando os [construtores primários][primary constructors] reservaram `final` e `var`
para declarar parâmetros):

```dart title="lib/greeter.dart"
class EmptyNameException implements Exception {}

void greet(final String greeting, final String name) {
  if (name.isEmpty) {
    throw EmptyNameException();
  }
  print('$greeting, $name!');
}
```

Primeiro, visualize a migração executando `dart migrate --dry-run`:

```console
$ dart migrate --dry-run
```

O comando `dart migrate` exibe um resumo das alterações propostas nas etapas `prepare`
e `bump`, junto com quaisquer correções opcionais de `cleanup` disponíveis
para a versão de destino:

```text
my_pkg:
  3.12.0 -> 3.13.0:
    Preparatory changes:
      2 changes would be made in 1 file.

      my_pkg/lib/greeter.dart
        avoid_final_parameters • 2 changes

    SDK constraint:
      Would bump ^3.12.0 -> ^3.13.0

Optional cleanup fixes can modernize your code further:

  my_pkg: 1 change in 1 file
    empty_container_bodies • 1 change

To preview them, apply this migration, run 'dart pub get', and then run 'dart migrate --dry-run --step=cleanup' on the same packages.

To apply the proposed changes, run:
  dart migrate --apply
```

Quando estiver satisfeito com a prévia, você pode executar `dart migrate --apply`
(e incluir `--step=all` ou `--step=prepare,bump,cleanup` se também quiser
aplicar as correções opcionais de `cleanup` mostradas no resumo):

```console
$ dart migrate --apply --step=all
```

O comando `dart migrate` faz as seguintes alterações:

1. Ele executa a etapa `prepare`,
   que remove os modificadores `final` dos parâmetros
   no arquivo `lib/greeter.dart` ([`avoid_final_parameters`][]).
1. Ele executa a etapa `bump`,
   que atualiza o arquivo `pubspec.yaml` para exigir o Dart 3.13:

   ```yaml title="pubspec.yaml"
   name: my_pkg
   environment:
     sdk: ^3.13.0
   ```

1. Ele executa a etapa `cleanup`,
   que substitui o corpo vazio `{}` da classe por `;`
   ([`empty_container_bodies`][]), resultando no arquivo
   `lib/greeter.dart` atualizado:

   ```dart title="lib/greeter.dart"
   class EmptyNameException implements Exception;

   void greet(String greeting, String name) {
     if (name.isEmpty) {
       throw EmptyNameException();
     }
     print('$greeting, $name!');
   }
   ```

## Quando usar `dart migrate` ou `dart fix` {:#when-to-use-dart-migrate-versus-dart-fix}

Embora as duas ferramentas apliquem correções automatizadas ao seu código,
elas têm finalidades diferentes:

* O comando **`dart migrate`** atualiza a restrição mínima do Dart SDK do seu projeto
  no arquivo `pubspec.yaml` e migra seu código para uma
  [versão da linguagem][language version] mais recente.
  Ele executa seu próprio conjunto de migrações obrigatórias e recomendadas
  para cada versão do SDK, independentemente de quais regras de lint estão habilitadas
  no seu arquivo [`analysis_options.yaml`][].
* O comando **[`dart fix`][]** corrige diagnósticos do analyzer, avisos de lint
  e usos desatualizados de API de pacotes ([correções orientadas a dados][data-driven fixes])
  no seu código existente, sem alterar a restrição de versão do SDK do projeto.
  Para regras de lint, o `dart fix` aplica correções apenas para as lints que estão
  habilitadas no arquivo [`analysis_options.yaml`][] do seu projeto.

[language version]: /language/versioning
[Get the Dart SDK]: /get-dart
[`flutter upgrade`]: {{site.flutter-docs}}/release/upgrade
[Pub workspaces]: /tools/pub/workspaces
[How migration works]: #how-migration-works
[`analysis_options.yaml`]: /tools/analysis
[primary constructors]: /language/primary-constructors
[`avoid_final_parameters`]: /tools/linter-rules/avoid_final_parameters
[`empty_container_bodies`]: /tools/linter-rules/empty_container_bodies
[`dart fix`]: /tools/dart-fix
[data-driven fixes]: /tools/pub/data-driven-fixes
