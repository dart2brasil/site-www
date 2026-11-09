---
ia-translate: true
title: Convenções de layout de pacotes
breadcrumb: Layout do pacote
description: >-
  Saiba mais sobre a estrutura de diretórios usada pela
  ferramenta de gerenciamento de pacotes do Dart, o pub.
---

Ao criar um [pacote pub](/tools/pub/packages),
recomendamos seguir as convenções descritas nesta página.
Elas explicam como organizar os arquivos e diretórios
dentro do seu pacote e como nomear as coisas.

:::flutter-note
Apps Flutter podem usar diretórios personalizados para os seus assets.
Para detalhes, veja
[Adicionando assets e imagens]({{site.flutter-docs}}/development/ui/assets-and-images)
no [site do Flutter.]({{site.flutter-docs}})
:::

Veja como pode ser um pacote completo (chamado `enchilada`)
que usa todos os cantos destas diretrizes:

<FileTree>

- enchilada/
  - .dart_tool/ *
  - benchmark/
    - make_lunch.dart
  - bin/
    - enchilada
  - doc/
    - api/ ****
    - getting_started.md
  - example/
    - main.dart
  - hook/
    - build.dart
  - integration_test/
    - app_test.dart
  - lib/
    - fix_data.yaml
    - enchilada.dart
    - tortilla.dart
    - guacamole.css
    - src/
      - beans.dart
      - queso.dart
  - skills/
    - enchilada-cooking/
      - SKILL.md
  - test/
    - enchilada_test.dart
    - tortilla_test.dart
  - test_fixes/
    - enchilada_fix.dart
    - enchilada_fix.dart.expect
  - tool/
    - generate_docs.dart
  - web/
    - index.html
    - main.dart
    - style.css
  - CHANGELOG.md
  - LICENSE
  - pubspec.yaml
  - pubspec_overrides.yaml **
  - pubspec.lock ***
  - README.md

</FileTree>

\* O diretório `.dart_tool/` existe depois que você executa `dart pub get`.
   Não o inclua no controle de versão.
   Para saber mais, veja
   [Cache específico do projeto para ferramentas](#project-specific-caching-for-tools).

\** O arquivo [`pubspec_overrides.yaml`][], se presente, sobrescreve certos aspectos do `pubspec.yaml`.
    Normalmente, você não quer incluí-lo no controle de versão.

\*** O arquivo `pubspec.lock` existe depois que você executa `dart pub get`.
    Deixe-o fora do controle de versão, a menos que o seu pacote seja um
    [pacote de aplicação](/resources/glossary#application-package).

\**** O diretório `doc/api` existe localmente depois que você executa
     [`dart doc`](/tools/dart-doc).
     Não inclua o diretório `api` no controle de versão.


[`pubspec_overrides.yaml`]: /tools/pub/dependencies#pubspec-overrides

## O pubspec {:#the-pubspec}

<FileTree>

- enchilada/
  - pubspec.yaml
  - pubspec.lock

</FileTree>

Todo pacote tem um [_pubspec_](/tools/pub/pubspec), um arquivo chamado
`pubspec.yaml`, na raiz do diretório do pacote. É isso que *torna* o diretório um pacote.

Executar [`dart pub get`](/tools/pub/cmd/pub-get),
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) ou
[`dart pub downgrade`](/tools/pub/cmd/pub-downgrade) no pacote
cria um **arquivo de bloqueio**, chamado `pubspec.lock`.
Se o seu pacote for um
[pacote de aplicação](/resources/glossary#application-package),
inclua o arquivo de bloqueio no controle de versão. Caso contrário, não inclua.

Para mais informações, veja a [página do pubspec](/tools/pub/pubspec).

## LICENSE {:#license}

<FileTree>

- enchilada/
  - LICENSE

</FileTree>

Se você for publicar o seu pacote, inclua um arquivo de licença chamado `LICENSE`.
Recomendamos usar uma [licença aprovada pela OSI](https://opensource.org/licenses),
como a [BSD-3-Clause,](https://opensource.org/licenses/BSD-3-Clause)
para que outras pessoas possam reutilizar o seu trabalho.

## README.md {:#readmemd}

<FileTree>

- enchilada/
  - README.md

</FileTree>

Um arquivo muito comum em projetos open source é o arquivo _README_, que
descreve o projeto. Isso é especialmente importante no pub. Quando você envia
um pacote ao [site pub.dev,]({{site.pub}}) o seu arquivo `README.md` é
exibido — renderizado como [Markdown][Markdown] — na página do seu pacote.
É o lugar perfeito para apresentar o seu código às pessoas.

Para orientações sobre como escrever um bom README, veja
[Escrevendo páginas de pacote](/tools/pub/writing-package-pages).

<a id="changelogmd" aria-hidden="true"></a>

## CHANGELOG.md {:#changelog}

<FileTree>

- enchilada/
  - CHANGELOG.md

</FileTree>

Inclua um arquivo `CHANGELOG.md` com uma seção para
cada versão do seu pacote,
com notas que ajudem os usuários do pacote a atualizar.
Os usuários do seu pacote costumam revisar o changelog
para descobrir correções de bugs e novos recursos,
ou para determinar o esforço necessário para atualizar
para a versão mais recente do pacote.

Para dar suporte às ferramentas que analisam o `CHANGELOG.md`,
use o formato a seguir:

* Cada versão tem a sua própria seção com um cabeçalho.
* Os cabeçalhos de versão são todos de nível 1 ou todos de nível 2.
* O texto do cabeçalho de versão contém um número de versão do pacote,
  opcionalmente precedido por "v".

Quando você envia o seu pacote ao [site pub.dev,]({{site.pub}})
o arquivo `CHANGELOG.md` do pacote (se houver)
aparece na aba **Changelog**, renderizado como [Markdown.][Markdown]

Aqui está um exemplo de arquivo `CHANGELOG.md`.
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


## Diretórios públicos {:#public-directories}

Dois diretórios do seu pacote são públicos para outros pacotes: `lib` e
`bin`. Você coloca as [bibliotecas públicas](#public-libraries) em `lib` e
as [ferramentas públicas](#public-tools) em `bin`.

### Bibliotecas públicas {:#public-libraries}

A estrutura de diretórios a seguir mostra a parte `lib` do enchilada:

<FileTree>

- enchilada/
  - lib/
    - enchilada.dart
    - tortilla.dart

</FileTree>

Muitos [pacotes](/resources/glossary#package)
definem bibliotecas Dart que outros pacotes podem importar e usar.
Esses arquivos de biblioteca pública ficam dentro de um diretório chamado `lib`.

A maioria dos pacotes define uma única biblioteca que os usuários podem importar. Nesse caso,
o nome dela normalmente deve ser o mesmo do pacote, como
`enchilada.dart` no exemplo. Mas você também pode definir outras
bibliotecas com os nomes que façam sentido para o seu pacote.

Quando fizer isso, os usuários podem importar essas bibliotecas usando o nome do
pacote e o arquivo da biblioteca, assim:

```dart
import 'package:enchilada/enchilada.dart';
import 'package:enchilada/tortilla.dart';
```

Se quiser organizar as suas bibliotecas públicas, você também pode criar
subdiretórios dentro de `lib`. Se fizer isso, os usuários especificarão esse caminho
ao importar. Imagine que você tenha a seguinte hierarquia de arquivos:

<FileTree>

- enchilada/
  - lib/
    - some/
      - path/
        - olives.dart

</FileTree>

Os usuários importam `olives.dart` da seguinte forma:

```dart
import 'package:enchilada/some/path/olives.dart';
```

Observe que somente *bibliotecas* devem estar em `lib`.
*Pontos de entrada* — scripts Dart com uma função `main()` — não
podem ficar em `lib`. Se você colocar um script Dart dentro de `lib`,
verá que quaisquer imports `package:` que ele contenha não
são resolvidos. Em vez disso, seus pontos de entrada devem ficar no
[diretório de ponto de entrada](/resources/glossary#entrypoint-directory) apropriado.

:::note Dica para apps web
Para a melhor performance ao desenvolver apps web,
coloque os [arquivos de implementação](#implementation-files) em `/lib/src`,
em vez de em outro lugar dentro de `/lib`.
Além disso, evite imports de <code>package:<em>nome_do_pacote</em>/src/...</code>.
:::

Para mais informações sobre pacotes, veja
[Criando pacotes](/tools/pub/create-packages).

### Correções orientadas a dados {:#data-driven-fixes}

<FileTree>

- enchilada/
  - lib/
    - fix_data.yaml

</FileTree>

Se você atualizar ou descontinuar APIs do seu pacote,
pode fornecer migrações automatizadas para os seus usuários
colocando um arquivo `fix_data.yaml` no diretório `lib`.
Quando os usuários executam o [`dart fix`](/tools/dart-fix) ou usam as correções rápidas da IDE,
o analisador do Dart usa esse arquivo para atualizar o código automaticamente.

Para detalhes sobre como escrever e testar as correções, veja
[Correções orientadas a dados](/tools/pub/data-driven-fixes).

### Ferramentas públicas {:#public-tools}

Scripts Dart colocados dentro do diretório `bin` são públicos. Se você estiver
dentro do diretório de um pacote, pode usar o
[`dart run`](/tools/dart-run) para executar scripts dos diretórios
`bin` de qualquer outro pacote do qual o pacote depende. De _qualquer_
diretório, você pode [executar scripts][run scripts]
de pacotes que tenha ativado usando o
[`dart pub global activate`][activate].

[run scripts]: /tools/pub/cmd/pub-global#running-a-script
[activate]: /tools/pub/cmd/pub-global#activating-a-package

Se a intenção é que o seu pacote seja uma dependência de outros, e você quer que os seus scripts
sejam privados ao pacote, coloque-os
no diretório `tool` de nível superior.
Se você não pretende que o seu pacote seja usado como dependência, pode deixar os
scripts em `bin`.


## Assets públicos {:#public-assets}

<FileTree>

- enchilada/
  - lib/
    - guacamole.css

</FileTree>

Embora a maioria dos pacotes exista para permitir que você reutilize código Dart, você também pode
reutilizar outros tipos de conteúdo. Por exemplo, um pacote para
[Bootstrap](https://getbootstrap.com/) pode incluir vários arquivos CSS
para os consumidores do pacote usarem.

Esses arquivos ficam no diretório `lib` de nível superior. Você pode colocar qualquer tipo de arquivo
ali e organizá-lo com subdiretórios como preferir.


## Arquivos de implementação {:#implementation-files}

<FileTree>

- enchilada/
  - lib/
    - src/
      - beans.dart
      - queso.dart

</FileTree>

As bibliotecas dentro de `lib` são publicamente visíveis: outros pacotes podem
importá-las livremente. Mas grande parte do código de um pacote são bibliotecas internas de implementação
que devem ser importadas e usadas somente pelo próprio pacote. Elas ficam dentro de um
subdiretório de `lib` chamado `src`. Você pode criar subdiretórios ali
se isso ajudar a organizar as coisas.

Você pode importar livremente bibliotecas que estão em `lib/src` a partir de outros códigos Dart
do *mesmo* pacote (como outras bibliotecas em `lib`, scripts em `bin` e
testes), mas nunca deve importar do diretório `lib/src` de outro pacote.
Esses arquivos não fazem parte da API pública do pacote e podem mudar
de maneiras que quebrem o seu código.

A forma como você importa bibliotecas dentro do próprio pacote
depende da localização das bibliotecas:

 * Ao [acessar o interior ou o exterior de `lib/`][reaching inside or outside `lib/`]
   (lint: [_avoid_relative_lib_imports_][]),
   use `package:`.
 * Caso contrário, [prefira imports relativos][prefer relative imports].

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

O nome que você usa aqui (neste caso, `enchilada`) é o nome que você especifica para
o seu pacote no [pubspec](/tools/pub/pubspec).

## Arquivos web {:#web-files}

<FileTree>

- enchilada/
  - web/
    - index.html
    - main.dart
    - style.css

</FileTree>

Para pacotes web, coloque o código de ponto de entrada — scripts Dart que incluem
`main()` e arquivos de apoio, como CSS ou HTML — em `web`.
Você pode organizar o diretório `web` em subdiretórios, se quiser.

Coloque o [código de biblioteca](#public-libraries) em `lib`.
Se a biblioteca não for importada diretamente por código em `web`, nem
por outro pacote, coloque-a em `lib/src`.
Coloque os [exemplos baseados na web](#examples) em `example`. Veja
[Assets públicos](#public-assets) para dicas sobre onde colocar assets,
como imagens.

## Apps de linha de comando {:#command-line-apps}

<FileTree>

- enchilada/
  - bin/
    - enchilada

</FileTree>

Alguns pacotes definem programas que podem ser executados diretamente pela linha de comando.
Eles podem ser scripts de shell ou de qualquer outra linguagem de script,
inclusive Dart.

Se o seu pacote define código desse tipo, coloque-o em um diretório chamado `bin`.
Você pode executar esse script de qualquer lugar na linha de comando, se configurá-lo
usando o
[`dart pub global`](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

## Testes e benchmarks {:#tests-and-benchmarks}

<FileTree>

- enchilada/
  - test/
    - enchilada_test.dart
    - tortilla_test.dart

</FileTree>

Todo pacote deve ter testes. Com o pub, a convenção é
que a maioria deles fique em um diretório `test` (ou em algum diretório dentro dele,
se preferir) e que tenham `_test` no final dos nomes dos arquivos.

Normalmente, eles usam o pacote [test]({{site.pub-pkg}}/test).

<FileTree>

- enchilada/
  - integration_test/
    - app_test.dart

</FileTree>

Pacotes de apps Flutter também podem ter testes de integração especiais, que usam o
pacote [integration_test]({{site.flutter-docs}}/cookbook/testing/integration/introduction).
Esses testes ficam no próprio diretório `integration_test`.

Outros pacotes podem optar por seguir um padrão semelhante, para separar os seus
testes de integração, mais lentos, dos testes unitários, mas observe que, por padrão, o `dart test`
não executa esses testes. Você terá que executá-los explicitamente com
`dart test integration_test`.

<FileTree>

- enchilada/
  - benchmark/
    - make_lunch.dart

</FileTree>

Pacotes que têm código crítico para performance também podem incluir *benchmarks*.
Eles testam a API não para verificar a corretude, mas para medir a velocidade (ou o uso de memória, ou
outras métricas empíricas).

<FileTree>

- enchilada/
  - test_fixes/
    - enchilada_fix.dart
    - enchilada_fix.dart.expect

</FileTree>

Se o seu pacote fornece [correções orientadas a dados][data-driven fixes],
teste-as usando pares de arquivos Dart e arquivos golden
em um diretório `test_fixes`.
Os arquivos golden contêm o código esperado depois de aplicar as correções.
Para verificar esses testes,
execute `dart fix --compare-to-golden`.
Para aprender a configurar e executar os testes, veja [Testar suas correções][Test your fixes].

[data-driven fixes]: #data-driven-fixes
[Test your fixes]: /tools/pub/data-driven-fixes#test-your-fixes

## Documentação {:#documentation}

<FileTree>

- enchilada/
  - doc/
    - api/
    - getting_started.md

</FileTree>

Se você já tem código e testes, a próxima peça que talvez queira é uma boa documentação. Ela vai dentro de um
diretório chamado `doc`.

Quando você executa a ferramenta [`dart doc`](/tools/dart-doc),
ela coloca a documentação da API, por padrão, em `doc/api`.
Como a documentação da API é gerada a partir do código-fonte,
você não deve colocá-la no controle de versão.

Além do `api` gerado, não temos
diretrizes sobre o formato ou a organização da documentação
que você escreve. Use o formato de marcação que preferir.

## Exemplos {:#examples}

<FileTree>

- enchilada/
  - example/
    - main.dart

</FileTree>

Código, testes, documentação, o que mais os seus usuários poderiam querer? Programas de exemplo independentes que usam o seu pacote, é claro! Eles vão dentro do diretório `example`. Se os exemplos forem complexos
e usarem vários arquivos, considere criar um diretório para cada exemplo. Caso contrário,
você pode colocar cada um diretamente dentro de `example`.

Nos seus exemplos, use `package:` para importar arquivos do seu próprio pacote.
Assim, o código de exemplo do seu pacote fica exatamente
igual ao código que estaria fora dele.

Se você pretende publicar o seu pacote,
considere criar um arquivo de exemplo com um dos seguintes nomes:

* <code>example/example[.md]</code>
* <code>example[/lib]/main.dart</code>
* <code>example[/lib]/<em>nome_do_pacote</em>.dart</code>
* <code>example[/lib]/<em>nome_do_pacote</em>_example.dart</code>
* <code>example[/lib]/example.dart</code>
* <code>example/README[.md]</code>

Quando você publica um pacote que contém um ou mais dos arquivos acima,
o site pub.dev cria uma aba **Example** para exibir o primeiro arquivo que encontrar
(pesquisando na ordem mostrada na lista acima).
Por exemplo, se o seu pacote tiver muitos arquivos no diretório `example`,
incluindo um arquivo chamado `README.md`,
então a aba Example do seu pacote exibe o conteúdo de `example/README.md`
(interpretado como [Markdown][Markdown]).

{% comment %}
To see how the example file is chosen,
search the dart-lang repos for exampleFileCandidates:
https://github.com/search?q=org%3Adart-lang+exampleFileCandidates&type=Code
{% endcomment %}

## Ferramentas e scripts internos {:#internal-tools-and-scripts}

<FileTree>

- enchilada/
  - tool/
    - generate_docs.dart

</FileTree>

Pacotes maduros costumam ter pequenos scripts e programas auxiliares que as pessoas
executam enquanto desenvolvem o próprio pacote. Pense em coisas como executores de testes,
geradores de documentação ou outros trechos de automação.

Diferentemente dos scripts em `bin`, estes *não* são para usuários externos do pacote.
Se você tiver algum deles, coloque-o em um diretório chamado `tool`.

## Hooks {:#hooks}

<FileTree>

- enchilada/
  - hook/
    - build.dart

</FileTree>

Pacotes podem definir hooks para serem invocados pelo SDK do Dart e do Flutter.
Esses hooks têm uma CLI predefinida e serão invocados pelas ferramentas do SDK, se estiverem presentes.

Como esses hooks são invocados pelas
ferramentas `dart` e `flutter` nas execuções e nos builds, as dependências
desses hooks precisam ser dependências normais, e não `dev_dependencies`.

Para saber mais sobre como definir hooks, consulte a documentação de [hooks de build][build hooks].

[build hooks]: /tools/hooks

## Skills {:#skills}

<FileTree>

- enchilada/
  - skills/
    - enchilada-cooking/
      - SKILL.md

</FileTree>

Pacotes podem fornecer [skills para agentes de IA][AI agent skills] para ensinar agentes de código com IA
a usar as APIs, a arquitetura e as melhores práticas do pacote.

Cada skill fica em um subdiretório de `skills/`
e contém um arquivo `SKILL.md` que segue a [especificação de Agent Skills][agentskills].
Para evitar colisões de nomes nos projetos dos consumidores,
o nome de cada subdiretório de skill deve começar com o nome do pacote
(ou o nome do pacote com os underscores trocados por hífens),
seguido de um hífen (como `enchilada-cooking`).

Quando os consumidores dependem do seu pacote,
eles podem instalar e atualizar as suas skills usando a ferramenta `package:skills`
(`dart run skills@ get`).

Para aprender a criar, testar e publicar skills com o seu pacote,
veja [Distribua skills com pacotes][Ship skills with packages].

[AI agent skills]: /ai/package-skills
[Ship skills with packages]: /tools/pub/package-skills
[agentskills]: https://agentskills.io

## Cache específico do projeto para ferramentas {:#project-specific-caching-for-tools}

:::note
Não inclua o diretório `.dart_tool/` no controle de versão.
Em vez disso, mantenha `.dart_tool/` no `.gitignore`.
:::

O diretório `.dart_tool/` é criado quando você executa `dart pub get`
e pode ser apagado a qualquer momento. Várias ferramentas usam esse diretório
para armazenar em cache arquivos específicos do seu projeto e/ou da sua máquina local.
O diretório `.dart_tool/` nunca deve ser incluído no
controle de versão, nem copiado entre máquinas.

Também é geralmente seguro apagar o diretório `.dart_tool/`,
embora algumas ferramentas possam precisar recalcular as informações armazenadas em cache.

**Exemplo:** a ferramenta [`dart pub get`](/tools/pub/cmd/pub-get)
baixa e extrai as dependências para um diretório global `$PUB_CACHE`
e, em seguida, grava um arquivo `.dart_tool/package_config.json` que mapeia _nomes de pacotes_
para diretórios no diretório global `$PUB_CACHE`.
O arquivo `.dart_tool/package_config.json` é usado por outras ferramentas,
como o analisador e os compiladores, quando precisam resolver instruções
como `import 'package:foo/foo.dart'`.

Ao desenvolver uma ferramenta que precisa de cache específico do projeto,
você pode considerar usar o diretório `.dart_tool/`,
porque a maioria dos usuários já o ignora com o `.gitignore`.
Ao armazenar em cache arquivos da sua ferramenta no diretório `.dart_tool/` do usuário,
use um subdiretório exclusivo. Para evitar colisões,
os subdiretórios no formato `.dart_tool/<nome_do_pacote_da_ferramenta>/`
são reservados para o pacote chamado `<nome_do_pacote_da_ferramenta>`.
Se a sua ferramenta não for distribuída pelo [site pub.dev,]({{site.pub}})
você pode considerar publicar um pacote de placeholder para reservar o nome exclusivo.

**Exemplo:** o [`package:build`]({{site.pub-pkg}}/build) oferece uma
estrutura para escrever etapas de geração de código.
Ao executar essas etapas de build, os arquivos são armazenados em cache em `.dart_tool/build/`.
Isso ajuda a acelerar as próximas execuções das etapas de build.

:::warning
Ao desenvolver uma ferramenta que quer armazenar arquivos em cache em `.dart_tool/`,
garanta o seguinte:

* Você está usando um subdiretório com o nome de um pacote que você mantém
  (`.dart_tool/<nome_do_pacote_da_minha_ferramenta>/`)
* Os seus arquivos não devem ir para o controle de versão,
  já que `.dart_tool/` geralmente está listado no `.gitignore`
:::


[Markdown]: {{site.pub-pkg}}/markdown
