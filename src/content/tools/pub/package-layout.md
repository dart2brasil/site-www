---
title: Convenções de layout de pacotes
breadcrumb: Layout de pacotes
description: >-
  Saiba mais sobre a estrutura de diretórios usada pela
  ferramenta de gerenciamento de pacotes do Dart, pub.
ia-translate: true
---

Quando você constrói um [pacote pub](/tools/pub/packages),
nós encorajamos você a seguir as convenções que esta página descreve.
Elas descrevem como você organiza os arquivos e diretórios dentro do seu
pacote, e como nomear as coisas.

:::flutter-note
Apps Flutter podem usar diretórios personalizados para seus assets.
Para detalhes, veja
[Adding assets and images]({{site.flutter-docs}}/development/ui/assets-and-images)
no [site Flutter.]({{site.flutter-docs}})
:::

Aqui está como um pacote completo (chamado `enchilada`)
que usa todos os aspectos dessas diretrizes
pode parecer:

```plaintext
enchilada/
  .dart_tool/ *
  pubspec.yaml
  pubspec_overrides.yaml **
  pubspec.lock ***
  LICENSE
  README.md
  CHANGELOG.md
  benchmark/
    make_lunch.dart
  bin/
    enchilada
  doc/
    api/ ****
    getting_started.md
  example/
    main.dart
  hook/
    build.dart
  integration_test/
    app_test.dart
  lib/
    enchilada.dart
    tortilla.dart
    guacamole.css
    src/
      beans.dart
      queso.dart
  test/
    enchilada_test.dart
    tortilla_test.dart
  tool/
    generate_docs.dart
  web/
    index.html
    main.dart
    style.css
```

\* O diretório `.dart_tool/` existe após você executar `dart pub get`.
   Não faça check-in dele no controle de versão.
   Para saber mais, veja
   [Caching específico de projeto para ferramentas](#project-specific-caching-for-tools).

\** O arquivo [`pubspec_overrides.yaml`][],
    se presente, sobrescreve certos aspectos de `pubspec.yaml`.
    Geralmente você não quer fazer check-in dele no controle de versão.

\*** O arquivo `pubspec.lock` existe após você executar `dart pub get`.
    Deixe-o fora do controle de versão a menos que seu pacote seja um
    [pacote de aplicação](/resources/glossary#application-package).

\**** O diretório `doc/api` existe localmente após você executar
     [`dart doc`](/tools/dart-doc).
     Não faça check-in do diretório `api` no controle de versão.


[`pubspec_overrides.yaml`]: /tools/pub/dependencies#pubspec-overrides

## O pubspec

```plaintext
enchilada/
  pubspec.yaml
  pubspec.lock
```

Todo pacote tem um [_pubspec_](/tools/pub/pubspec), um arquivo chamado
`pubspec.yaml`, no diretório raiz do pacote. É isso que *faz* dele um
pacote.

Executar [`dart pub get`](/tools/pub/cmd/pub-get),
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), ou
[`dart pub downgrade`](/tools/pub/cmd/pub-downgrade) no pacote
cria um **lockfile**, chamado `pubspec.lock`.
Se o seu pacote é um
[pacote de aplicação](/resources/glossary#application-package),
faça check-in do lockfile no controle de versão. Caso contrário, não.

Para mais informações, veja a [página do pubspec](/tools/pub/pubspec).

## LICENSE

```plaintext
enchilada/
  LICENSE
```

Se você está publicando seu pacote, inclua um arquivo de licença chamado `LICENSE`.
Recomendamos usar uma [licença aprovada pela OSI](https://opensource.org/licenses)
como [BSD-3-Clause,](https://opensource.org/licenses/BSD-3-Clause)
para que outros possam reutilizar seu trabalho.

## README.md

```plaintext
enchilada/
  README.md
```

Um arquivo muito comum em código aberto é um arquivo _README_ que
descreve o projeto. Isso é especialmente importante no pub. Quando você faz upload
para o [site pub.dev,]({{site.pub}}) seu arquivo `README.md`
é mostrado—renderizado como [Markdown][]—na página do seu pacote.
Este é o lugar perfeito para apresentar as pessoas ao seu código.

Para orientação sobre como escrever um ótimo README, veja
[Escrevendo páginas de pacotes](/tools/pub/writing-package-pages).

<a id="changelogmd"></a>
## CHANGELOG.md {:#changelog}

```plaintext
enchilada/
  CHANGELOG.md
```

Inclua um arquivo `CHANGELOG.md` que tenha uma seção para
cada lançamento do seu pacote,
com notas para ajudar os usuários do seu pacote a atualizar.
Os usuários do seu pacote frequentemente revisam o changelog
para descobrir correções de bugs e novos recursos,
ou para determinar quanto esforço será necessário para atualizar
para a versão mais recente do seu pacote.

Para suportar ferramentas que analisam `CHANGELOG.md`,
use o seguinte formato:

* Cada versão tem sua própria seção com um cabeçalho.
* Os cabeçalhos de versão são todos de nível 1 ou todos de nível 2.
* O texto do cabeçalho de versão contém um número de versão do pacote,
  opcionalmente prefixado com "v".

Quando você faz upload do seu pacote para o [site pub.dev,]({{site.pub}})
o arquivo `CHANGELOG.md` do seu pacote (se houver)
aparece na aba **Changelog**, renderizado como [Markdown.][Markdown]

Aqui está um exemplo de um arquivo `CHANGELOG.md`.
Como o exemplo mostra, você pode adicionar subseções.

```markdown
# 1.0.1

* Fixed missing exclamation mark in `sayHi()` method.

# 1.0.0

* **Breaking change:** Removed deprecated `sayHello()` method.
* Initial stable release.

## Upgrading from 0.1.x

Change all calls to `sayHello()` to instead be to `sayHi()`.

# 0.1.1

* Deprecated the `sayHello()` method; use `sayHi()` instead.

# 0.1.0

* Initial development release.
```


## Diretórios públicos

Dois diretórios no seu pacote são públicos para outros pacotes: `lib` e
`bin`. Você coloca [bibliotecas públicas](#public-libraries) em `lib` e
[ferramentas públicas](#public-tools) em `bin`.

### Bibliotecas públicas

A seguinte estrutura de diretórios mostra a porção `lib` de enchilada:

```plaintext
enchilada/
  lib/
    enchilada.dart
    tortilla.dart
```

Muitos [pacotes](/resources/glossary#package)
definem bibliotecas Dart que outros pacotes podem importar e usar.
Esses arquivos de biblioteca Dart públicos vão dentro de um diretório chamado `lib`.

A maioria dos pacotes define uma única biblioteca que os usuários podem importar. Nesse caso,
seu nome geralmente deve ser o mesmo que o nome do pacote, como
`enchilada.dart` no exemplo aqui. Mas você também pode definir outras
bibliotecas com quaisquer nomes que façam sentido para o seu pacote.

Quando você faz isso, os usuários podem importar essas bibliotecas usando o nome do
pacote e o arquivo da biblioteca, assim:

```dart
import 'package:enchilada/enchilada.dart';
import 'package:enchilada/tortilla.dart';
```

Se você quiser organizar suas bibliotecas públicas, você também pode criar
subdiretórios dentro de `lib`. Se você fizer isso, os usuários especificarão esse caminho
quando importarem. Digamos que você tenha a seguinte hierarquia de arquivos:

```plaintext
enchilada/
  lib/
    some/
      path/
        olives.dart
```

Os usuários importam `olives.dart` da seguinte forma:

```dart
import 'package:enchilada/some/path/olives.dart';
```

Note que apenas *bibliotecas* devem estar em `lib`.
*Entrypoints*—scripts Dart com uma função `main()`—não podem
ir em `lib`. Se você colocar um script Dart dentro de `lib`,
você descobrirá que quaisquer importações `package:` que ele contém não
resolvem. Em vez disso, seus entrypoints devem ir no
[diretório de entrypoint](/resources/glossary#entrypoint-directory) apropriado.

:::note Dica para apps web
Para o melhor desempenho ao desenvolver apps web,
coloque [arquivos de implementação](#implementation-files) em `/lib/src`,
em vez de em outro lugar em `/lib`.
Além disso, evite importações de <code>package:<em>package_name</em>/src/...</code>.
:::

Para mais informações sobre pacotes, veja
[Criando pacotes](/tools/pub/create-packages).

### Ferramentas públicas

Scripts Dart colocados dentro do diretório `bin` são públicos. Se você está
dentro do diretório de um pacote, você pode usar
[`dart run`](/tools/dart-run) para executar scripts dos diretórios `bin`
de qualquer outro pacote do qual o pacote depende. De _qualquer_
diretório, você pode [executar scripts][run scripts]
de pacotes que você ativou usando
[`dart pub global activate`][activate].

[run scripts]: /tools/pub/cmd/pub-global#running-a-script
[activate]: /tools/pub/cmd/pub-global#activating-a-package

Se você pretende que seu pacote seja dependido,
e quer que seus scripts sejam privados ao seu pacote, coloque-os
no diretório de nível superior `tool`.
Se você não pretende que seu pacote seja dependido, você pode deixar seus
scripts em `bin`.


## Assets públicos

```plaintext
enchilada/
  lib/
    guacamole.css
```

Embora a maioria dos pacotes exista para permitir que você reutilize código Dart, você também pode
reutilizar outros tipos de conteúdo. Por exemplo, um pacote para
[Bootstrap](https://getbootstrap.com/) pode incluir vários arquivos CSS
para os consumidores do pacote usarem.

Esses vão no diretório de nível superior `lib`. Você pode colocar qualquer tipo de arquivo
lá e organizá-lo com subdiretórios como quiser.


## Arquivos de implementação

```plaintext
enchilada/
  lib/
    src/
      beans.dart
      queso.dart
```

As bibliotecas dentro de `lib` são publicamente visíveis: outros pacotes são livres para
importá-las. Mas muito do código de um pacote são bibliotecas de implementação internas
que devem ser importadas e usadas apenas pelo próprio pacote. Essas vão dentro de um
subdiretório de `lib` chamado `src`. Você pode criar subdiretórios lá se
isso ajudar a organizar as coisas.

Você é livre para importar bibliotecas que vivem em `lib/src` de dentro de outro código Dart
no *mesmo* pacote (como outras bibliotecas em `lib`, scripts em `bin`, e
testes) mas você nunca deve importar do diretório `lib/src` de outro pacote.
Esses arquivos não fazem parte da API pública do pacote, e eles podem mudar de
formas que poderiam quebrar seu código.

Como você importa bibliotecas de dentro do seu próprio pacote
depende das localizações das bibliotecas:

 * Quando [alcançando dentro ou fora de `lib/`][reaching inside or outside `lib/`]
   (lint: [_avoid_relative_lib_imports_][]),
   use `package:`.
 * Caso contrário, [prefira importações relativas][prefer relative imports].

 [reaching inside or outside `lib/`]: /effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib
 [_avoid_relative_lib_imports_]: /tools/linter-rules/avoid_relative_lib_imports
 [prefer relative imports]: /effective-dart/usage#prefer-relative-import-paths

Por exemplo:

```dart title="lib/beans.dart"
// When importing from within lib:
import 'src/beans.dart';
```

```dart title="test/beans_test.dart"
// When importing from outside lib:
import 'package:enchilada/src/beans.dart';
```

O nome que você usa aqui (neste caso `enchilada`) é o nome que você especifica para
seu pacote em seu [pubspec](/tools/pub/pubspec).

## Arquivos web

```plaintext
enchilada/
  web/
    index.html
    main.dart
    style.css
```

Para pacotes web, coloque código de entrypoint—scripts Dart que incluem
`main()` e arquivos de suporte, como CSS ou HTML—em `web`.
Você pode organizar o diretório `web` em subdiretórios se quiser.

Coloque [código de biblioteca](#public-libraries) em `lib`.
Se a biblioteca não for importada diretamente por código em `web`, ou por
outro pacote, coloque-a em `lib/src`.
Coloque [exemplos baseados em web](#examples) em `example`. Veja
[Assets públicos](#public-assets) para dicas sobre onde colocar assets,
como imagens.

## Apps de linha de comando

```plaintext
enchilada/
  bin/
    enchilada
```

Alguns pacotes definem programas que podem ser executados diretamente da linha
de comando. Estes podem ser scripts shell ou qualquer outra linguagem de script,
incluindo Dart.

Se o seu pacote define código assim, coloque-o em um diretório chamado `bin`.
Você pode executar esse script de qualquer lugar na linha de comando, se configurá-lo
usando
[`dart pub global`](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

## Testes e benchmarks

```plaintext
enchilada/
  test/
    enchilada_test.dart
    tortilla_test.dart
```

Todo pacote deve ter testes. Com pub, a convenção é
que a maioria deles vai em um diretório `test` (ou algum diretório dentro dele se você
quiser) e tem `_test` no final dos nomes dos arquivos.

Tipicamente, estes usam o pacote [test]({{site.pub-pkg}}/test).

```plaintext
enchilada/
  integration_test/
    app_test.dart
```

Pacotes de apps Flutter também podem ter testes de integração especiais, que usam o
pacote [integration_test]({{site.flutter-docs}}/cookbook/testing/integration/introduction).
Esses testes ficam em seu próprio diretório `integration_test`.

Outros pacotes podem escolher seguir um padrão similar, para separar seus testes de
integração mais lentos de seus testes unitários, mas note que por padrão `dart test`
não executará esses testes. Você terá que executá-los explicitamente com
`dart test integration_test`.

```plaintext
enchilada/
  benchmark/
    make_lunch.dart
```

Pacotes que têm código crítico de desempenho também podem incluir *benchmarks*.
Estes testam a API não por correção mas por velocidade (ou uso de memória, ou talvez
outras métricas empíricas).

## Documentação

```plaintext
enchilada/
  doc/
    api/
    getting_started.md
```

Se você tem código e testes, a próxima peça que você pode querer
é boa documentação. Essa vai dentro de um diretório chamado `doc`.

Quando você executa a ferramenta [`dart doc`](/tools/dart-doc),
ela coloca a documentação da API, por padrão, em `doc/api`.
Como a documentação da API é gerada do código-fonte,
você não deve colocá-la sob controle de versão.

Além do `api` gerado, não
temos diretrizes sobre formato ou organização da documentação
que você criar. Use qualquer formato de marcação que você preferir.

## Exemplos

```plaintext
enchilada/
  example/
    main.dart
```

Código, testes, docs, o que mais
seus usuários poderiam querer? Programas de exemplo independentes que usam seu pacote, é
claro! Esses vão dentro do diretório `example`. Se os exemplos são complexos
e usam vários arquivos, considere fazer um diretório para cada exemplo. Caso contrário,
você pode colocar cada um diretamente dentro de `example`.

Em seus exemplos, use `package:` para importar arquivos do seu próprio pacote.
Isso garante que o código de exemplo no seu pacote se pareça exatamente
como código fora do seu pacote se pareceria.

Se você pode publicar seu pacote,
considere criar um arquivo de exemplo com um dos seguintes nomes:

* <code>example/example[.md]</code>
* <code>example[/lib]/main.dart</code>
* <code>example[/lib]/<em>package_name</em>.dart</code>
* <code>example[/lib]/<em>package_name</em>_example.dart</code>
* <code>example[/lib]/example.dart</code>
* <code>example/README[.md]</code>

Quando você publica um pacote que contém um ou mais dos arquivos acima,
o site pub.dev cria uma aba **Example** para exibir o primeiro arquivo que encontrar
(pesquisando na ordem mostrada na lista acima).
Por exemplo, se o seu pacote tiver muitos arquivos em seu diretório `example`,
incluindo um arquivo chamado `README.md`,
então a aba Example do seu pacote exibe o conteúdo de `example/README.md`
(analisado como [Markdown.)][Markdown]

{% comment %}
To see how the example file is chosen,
search the dart-lang repos for exampleFileCandidates:
https://github.com/search?q=org%3Adart-lang+exampleFileCandidates&type=Code
{% endcomment %}

## Ferramentas internas e scripts

```plaintext
enchilada/
  tool/
    generate_docs.dart
```

Pacotes maduros frequentemente têm pequenos scripts e programas auxiliares que as pessoas
executam enquanto desenvolvem o próprio pacote. Pense em coisas como executores de teste,
geradores de documentação ou outros bits de automação.

Ao contrário dos scripts em `bin`, estes *não* são para usuários externos do pacote.
Se você tem algum deles, coloque-os em um diretório chamado `tool`.

## Hooks

```plaintext
enchilada/
  hook/
    build.dart
```

Pacotes podem definir hooks para serem invocados pelo Dart e Flutter SDK.
Esses hooks têm uma CLI predefinida, e serão invocados pelas ferramentas do SDK se presentes.

Porque esses hooks são invocados pelas
ferramentas `dart` e `flutter` em execuções e builds, as dependências
desses hooks devem ser dependências normais e não `dev_dependencies`.

:::experimental
O suporte para hooks de pacote é **experimental** e em desenvolvimento ativo.

Para saber mais sobre como definir hooks e seu status atual,
consulte a documentação de [build hooks][].
:::


[build hooks]: /tools/hooks

## Caching específico de projeto para ferramentas

:::note
Não faça check-in do diretório `.dart_tool/` no controle de versão.
Em vez disso, mantenha `.dart_tool/` no `.gitignore`.
:::

O diretório `.dart_tool/` é criado quando você executa `dart pub get`
e pode ser deletado a qualquer momento. Várias ferramentas usam este diretório
para fazer cache de arquivos específicos do seu projeto e/ou máquina local.
O diretório `.dart_tool/` nunca deve ser feito check-in no
controle de versão, ou copiado entre máquinas.

Também é geralmente seguro deletar o diretório `.dart_tool/`,
embora algumas ferramentas possam precisar recomputar a informação em cache.

**Exemplo:** A ferramenta [`dart pub get`](/tools/pub/cmd/pub-get)
vai baixar e extrair dependências para um diretório global `$PUB_CACHE`,
e então escrever um arquivo `.dart_tool/package_config.json` mapeando _nomes de pacotes_
para diretórios no diretório global `$PUB_CACHE`.
O arquivo `.dart_tool/package_config.json` é usado por outras ferramentas,
como o analisador e compiladores quando precisam resolver declarações
como `import 'package:foo/foo.dart'`.

Ao desenvolver uma ferramenta que precisa de caching específico de projeto,
você pode considerar usar o diretório `.dart_tool/`
porque a maioria dos usuários já o ignora com `.gitignore`.
Ao fazer cache de arquivos para sua ferramenta em um diretório `.dart_tool/` de um usuário,
você deve usar um subdiretório único. Para evitar colisões,
subdiretórios da forma `.dart_tool/<tool_package_name>/`
são reservados para o pacote chamado `<tool_package_name>`.
Se sua ferramenta não é distribuída através do [site pub.dev,]({{site.pub}})
você pode considerar publicar um pacote placeholder para
reservar o nome único.

**Exemplo:** [`package:build`]({{site.pub-pkg}}/build) fornece um
framework para escrever etapas de geração de código.
Ao executar essas etapas de build, arquivos são armazenados em cache em `.dart_tool/build/`.
Isso ajuda a acelerar futuras re-execuções das etapas de build.

:::warning
Ao desenvolver uma ferramenta que quer fazer cache de arquivos em `.dart_tool/`,
garanta o seguinte:

* Você está usando um subdiretório nomeado após um pacote que você possui
  (`.dart_tool/<my_tool_package_name>/`)
* Seus arquivos não pertencem ao controle de versão,
  já que `.dart_tool/` é geralmente listado em `.gitignore`
:::


[Markdown]: {{site.pub-pkg}}/markdown
