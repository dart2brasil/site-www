---
ia-translate: true
title: Convenções de layout de pacote
description: >-
  Aprenda mais sobre a estrutura de diretórios usada
  pela ferramenta de gerenciamento de pacotes do Dart, pub.
---

Ao construir um [pacote pub](/tools/pub/packages),
nós encorajamos você a seguir as convenções que esta página descreve.
Elas descrevem como você organiza os arquivos e diretórios dentro do seu
pacote, e como nomear as coisas.

:::flutter-note
Aplicativos Flutter podem usar diretórios personalizados para seus assets.
Para detalhes, veja
[Adicionando assets e imagens]({{site.flutter-docs}}/development/ui/assets-and-images)
no [site do Flutter.]({{site.flutter-docs}})
:::

Eis como um pacote completo (chamado `enchilada`)
que usa todos os aspectos dessas diretrizes
poderia se parecer:

```plaintext
enchilada/
  .dart_tool/ *
  pubspec.yaml
  pubspec.lock **
  LICENSE
  README.md
  CHANGELOG.md
  benchmark/
    make_lunch.dart
  bin/
    enchilada
  doc/
    api/ ***
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

\* O diretório `.dart_tool/` existe depois que você executa `dart pub get`.
   Não o adicione no controle de versão.
   Para saber mais, veja
   [Cache específico do projeto para ferramentas](#project-specific-caching-for-tools).

\** O arquivo `pubspec.lock` existe depois que você executa `dart pub get`.
    Deixe-o fora do controle de versão, a menos que seu pacote seja um
    [pacote de aplicação](/tools/pub/glossary#application-package).

\*** O diretório `doc/api` existe localmente depois que você executa
     [`dart doc`](/tools/dart-doc).
     Não adicione o diretório `api` no controle de versão.


## O pubspec {:#the-pubspec}

```plaintext
enchilada/
  pubspec.yaml
  pubspec.lock
```

Todo pacote tem um [_pubspec_](/tools/pub/pubspec), um arquivo chamado
`pubspec.yaml`, no diretório raiz do pacote. Isso é o que *o torna* um
pacote.

Executar [`dart pub get`](/tools/pub/cmd/pub-get),
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) ou
[`dart pub downgrade`](/tools/pub/cmd/pub-downgrade) no pacote
cria um **arquivo de lock**, chamado `pubspec.lock`.
Se o seu pacote for um
[pacote de aplicação](/tools/pub/glossary#application-package),
adicione o arquivo de lock no controle de versão. Caso contrário, não.

Para mais informações, veja a [página pubspec](/tools/pub/pubspec).

## LICENSE {:#license}

```plaintext
enchilada/
  LICENSE
```

Se você estiver publicando seu pacote, inclua um arquivo de licença chamado `LICENSE`.
Nós recomendamos usar uma [licença aprovada pela OSI](https://opensource.org/licenses)
como [BSD-3-Clause,](https://opensource.org/licenses/BSD-3-Clause)
para que outros possam reutilizar seu trabalho.

## README.md {:#readme-md}

```plaintext
enchilada/
  README.md
```

Um arquivo muito comum em código aberto é um arquivo _README_ que
descreve o projeto. Isso é especialmente importante no pub. Quando você faz o upload
para o [site pub.dev,]({{site.pub}}) seu arquivo `README.md`
é mostrado—renderizado como [Markdown][]—na página do seu pacote.
Este é o lugar perfeito para apresentar seu código às pessoas.

Para orientações sobre como escrever um ótimo README, veja
[Escrevendo páginas de pacote](/tools/pub/writing-package-pages).

<a id="changelogmd"></a>
## CHANGELOG.md {:#changelog}

```plaintext
enchilada/
  CHANGELOG.md
```

Inclua um arquivo `CHANGELOG.md` que tenha uma seção para
cada lançamento do seu pacote,
com notas para ajudar os usuários do seu pacote a atualizar.
Usuários do seu pacote frequentemente revisam o changelog
para descobrir correções de bugs e novos recursos,
ou para determinar o esforço que será necessário para atualizar
para a versão mais recente do seu pacote.

Para dar suporte a ferramentas que fazem o parse (análise) de `CHANGELOG.md`,
use o seguinte formato:

* Cada versão tem sua própria seção com um cabeçalho.
* Os cabeçalhos de versão são todos de nível 1 ou todos de nível 2.
* O texto do cabeçalho de versão contém um número de versão do pacote,
  opcionalmente prefixado com "v".

Quando você faz o upload do seu pacote para o [site pub.dev,]({{site.pub}})
o arquivo `CHANGELOG.md` do seu pacote (se houver)
aparece na aba **Changelog**, renderizado como [Markdown.][Markdown]

Aqui está um exemplo de um arquivo `CHANGELOG.md`.
Como o exemplo mostra, você pode adicionar subseções.

```markdown
# 1.0.1 {:#1-0-1}

* Corrigida a falta de ponto de exclamação no método `sayHi()`.

# 1.0.0 {:#1-0-0}

* **Mudança que quebra a compatibilidade:** Removido o método `sayHello()` obsoleto.
* Lançamento inicial estável.

## Atualizando de 0.1.x {:#upgrading-from-0-1-x}

Altere todas as chamadas para `sayHello()` para serem `sayHi()`.

# 0.1.1 {:#0-1-1}

* Método `sayHello()` obsoleto; use `sayHi()` em vez disso.

# 0.1.0 {:#0-1-0}

* Lançamento de desenvolvimento inicial.
```


## Diretórios públicos {:#public-directories}

Dois diretórios no seu pacote são públicos para outros pacotes: `lib` e
`bin`. Você coloca [bibliotecas públicas](#public-libraries) em `lib` e
[ferramentas públicas](#public-tools) em `bin`.

### Bibliotecas públicas {:#public-libraries}

A seguinte estrutura de diretório mostra a parte `lib` de enchilada:

```plaintext
enchilada/
  lib/
    enchilada.dart
    tortilla.dart
```

Muitos [pacotes](/tools/pub/glossary#package)
definem bibliotecas Dart que outros pacotes podem importar e usar.
Esses arquivos de biblioteca Dart públicos vão dentro de um diretório chamado `lib`.

A maioria dos pacotes define uma única biblioteca que os usuários podem importar. Nesse caso,
o nome geralmente deve ser o mesmo do nome do pacote, como
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
quando o importarem. Digamos que você tenha a seguinte hierarquia de arquivos:

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
*Entrypoints* (pontos de entrada) — scripts Dart com uma função `main()`—não podem
ir em `lib`. Se você colocar um script Dart dentro de `lib`,
você descobrirá que qualquer importação `package:` que ele contenha não
resolve. Em vez disso, seus entrypoints devem ir no apropriado
[diretório de entrypoint](/tools/pub/glossary#entrypoint-directory).

:::note Dica para web apps
Para o melhor desempenho ao desenvolver web apps,
coloque [arquivos de implementação](#implementation-files) sob `/lib/src`,
em vez de em outro lugar sob `/lib`.
Além disso, evite importações de <code>package:<em>nome_do_pacote</em>/src/...</code>.
:::

Para mais informações sobre pacotes, veja
[Criando pacotes](/tools/pub/create-packages).

### Ferramentas públicas {:#public-tools}

Scripts Dart colocados dentro do diretório `bin` são públicos. Se você está
dentro do diretório de um pacote, você pode usar
[`dart run`](/tools/dart-run) para executar scripts dos diretórios `bin`
de qualquer outro pacote do qual o pacote depende. De _qualquer_
diretório, você pode [executar scripts][]
de pacotes que você ativou usando
[`dart pub global activate`][activate].

[run scripts]: /tools/pub/cmd/pub-global#running-a-script
[activate]: /tools/pub/cmd/pub-global#activating-a-package

Se você pretende que seu pacote seja usado como dependência,
e você quer que seus scripts sejam privados para o seu pacote, coloque-os
no diretório `tool` de nível superior.
Se você não pretende que seu pacote seja usado como dependência, você pode deixar seus
scripts em `bin`.


## Assets públicos {:#public-assets}

```plaintext
enchilada/
  lib/
    guacamole.css
```

Embora a maioria dos pacotes exista para permitir que você reutilize código Dart, você também pode
reutilizar outros tipos de conteúdo. Por exemplo, um pacote para
[Bootstrap](https://getbootstrap.com/) pode incluir um número de arquivos CSS
para os consumidores do pacote usarem.

Eles vão no diretório `lib` de nível superior. Você pode colocar qualquer tipo de arquivo
lá e organizá-lo com subdiretórios como quiser.


## Arquivos de implementação {:#implementation-files}

```plaintext
enchilada/
  lib/
    src/
      beans.dart
      queso.dart
```

As bibliotecas dentro de `lib` são publicamente visíveis: outros pacotes são livres para
importá-las. Mas grande parte do código de um pacote são bibliotecas de implementação
internas que só devem ser importadas e usadas pelo próprio pacote. Elas vão dentro de um
subdiretório de `lib` chamado `src`. Você pode criar subdiretórios lá dentro, se
isso te ajudar a organizar as coisas.

Você é livre para importar bibliotecas que vivem em `lib/src` de dentro de outro código
Dart no *mesmo* pacote (como outras bibliotecas em `lib`, scripts em `bin` e
testes), mas você nunca deve importar do diretório `lib/src` de outro pacote.
Esses arquivos não fazem parte da API pública do pacote e podem mudar de
maneiras que podem quebrar seu código.

Como você importa bibliotecas de dentro do seu próprio pacote
depende das localizações das bibliotecas:

 * Ao [alcançar dentro ou fora de `lib/`][]
   (lint: [_avoid_relative_lib_imports_][]),
   use `package:`.
 * Caso contrário, [prefira importações relativas][].
 
 [reaching inside or outside `lib/`]: /effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib
 [_avoid_relative_lib_imports_]: /tools/linter-rules/avoid_relative_lib_imports
 [prefer relative imports]: /effective-dart/usage#prefer-relative-import-paths

Por exemplo:

```dart title="lib/beans.dart"
// Ao importar de dentro de lib:
import 'src/beans.dart';
```

```dart title="test/beans_test.dart"
// Ao importar de fora de lib:
import 'package:enchilada/src/beans.dart';
```

O nome que você usa aqui (nesse caso `enchilada`) é o nome que você especifica
para seu pacote no seu [pubspec](/tools/pub/pubspec).

## Arquivos web {:#web-files}

```plaintext
enchilada/
  web/
    index.html
    main.dart
    style.css
```

Para pacotes web, coloque o código de entrypoint—scripts Dart que incluem
`main()` e arquivos de suporte, como CSS ou HTML—sob `web`.
Você pode organizar o diretório `web` em subdiretórios, se quiser.

Coloque [código de biblioteca](#public-libraries) sob `lib`.
Se a biblioteca não for importada diretamente pelo código sob `web`, ou por
outro pacote, coloque-a sob `lib/src`.
Coloque [exemplos baseados na web](#examples) sob `example`. Veja
[Assets públicos](#public-assets) para dicas sobre onde colocar assets,
como imagens.

## Aplicativos de linha de comando {:#command-line-apps}

```plaintext
enchilada/
  bin/
    enchilada
```

Alguns pacotes definem programas que podem ser executados diretamente da linha
de comando. Eles podem ser scripts shell ou qualquer outra linguagem de script,
incluindo Dart.

Se seu pacote define código como esse, coloque-o em um diretório chamado `bin`.
Você pode executar esse script de qualquer lugar na linha de comando, se você configurá-lo
usando
[`dart pub global`](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

## Testes e benchmarks {:#tests-and-benchmarks}

```plaintext
enchilada/
  test/
    enchilada_test.dart
    tortilla_test.dart
```

Todo pacote deve ter testes. Com pub, a convenção é
que a maioria deles vá em um diretório `test` (ou algum diretório dentro dele, se
você quiser) e tenha `_test` no final de seus nomes de arquivo.

Tipicamente, eles usam o pacote [test]({{site.pub-pkg}}/test).

```plaintext
enchilada/
  integration_test/
    app_test.dart
```

Pacotes de aplicativos Flutter também podem ter testes de integração especiais, que usam o
pacote [integration_test]({{site.flutter-docs}}/cookbook/testing/integration/introduction).
Esses testes vivem em seu próprio diretório `integration_test`.

Outros pacotes podem optar por seguir um padrão semelhante, para separar seus testes de
integração mais lentos de seus testes unitários, mas observe que, por padrão, `dart test`
não executará esses testes. Você terá que executá-los explicitamente com
`dart test integration_test`.

```plaintext
enchilada/
  benchmark/
    make_lunch.dart
```

Pacotes que têm código de desempenho crítico também podem incluir *benchmarks* (testes de desempenho).
Eles testam a API não quanto à correção, mas quanto à velocidade (ou uso de memória, ou talvez
outras métricas empíricas).

## Documentação {:#documentation}

```plaintext
enchilada/
  doc/
    api/
    getting_started.md
```

Se você tem código e testes, a próxima coisa que você pode querer
é uma boa documentação. Ela vai dentro de um diretório chamado `doc`.

Quando você executa a ferramenta [`dart doc`](/tools/dart-doc),
ela coloca a documentação da API, por padrão, sob `doc/api`.
Como a documentação da API é gerada a partir do código fonte,
você não deve colocá-la sob controle de versão.

Além da `api` gerada, nós não
temos quaisquer diretrizes sobre formato ou organização da documentação
que você cria. Use qualquer formato de marcação que você preferir.

## Exemplos {:#examples}

```plaintext
enchilada/
  example/
    main.dart
```

Código, testes, docs (documentação), o que mais
seus usuários poderiam querer? Programas de exemplo autônomos que usam seu pacote, é
claro! Eles vão dentro do diretório `example`. Se os exemplos são complexos
e usam vários arquivos, considere criar um diretório para cada exemplo. Caso contrário,
você pode colocar cada um diretamente dentro de `example`.

Nos seus exemplos, use `package:` para importar arquivos do seu próprio pacote.
Isso garante que o código de exemplo no seu pacote pareça exatamente
como o código fora do seu pacote pareceria.

Se você pode publicar seu pacote,
considere criar um arquivo de exemplo com um dos seguintes nomes:

* <code>example/example[.md]</code>
* <code>example[/lib]/main.dart</code>
* <code>example[/lib]/<em>nome_do_pacote</em>.dart</code>
* <code>example[/lib]/<em>nome_do_pacote</em>_example.dart</code>
* <code>example[/lib]/example.dart</code>
* <code>example/README[.md]</code>

Quando você publica um pacote que contém um ou mais dos arquivos acima,
o site pub.dev cria uma aba **Example** para exibir o primeiro arquivo que ele encontra
(pesquisando na ordem mostrada na lista acima).
Por exemplo, se seu pacote tem muitos arquivos sob seu diretório `example`,
incluindo um arquivo chamado `README.md`,
então a aba Example do seu pacote exibe o conteúdo de `example/README.md`
(analisado como [Markdown.)][Markdown]

{% comment %}
Para ver como o arquivo de exemplo é escolhido,
pesquise nos repositórios dart-lang por exampleFileCandidates:
https://github.com/search?q=org%3Adart-lang+exampleFileCandidates&type=Code
{% endcomment %}

## Ferramentas e scripts internos {:#internal-tools-and-scripts}

```plaintext
enchilada/
  tool/
    generate_docs.dart
```

Pacotes maduros frequentemente têm pequenos scripts e programas auxiliares que as pessoas
executam enquanto desenvolvem o próprio pacote. Pense em coisas como executores de teste,
geradores de documentação ou outros bits de automação.

Ao contrário dos scripts em `bin`, estes *não* são para usuários externos do pacote.
Se você tem algum desses, coloque-os em um diretório chamado `tool`.

## Hooks (Ganchos) {:#hooks}

```plaintext
enchilada/
  hook/
    build.dart
```

Pacotes podem definir hooks (ganchos) para serem invocados pelo SDK do Dart e do Flutter.
Esses hooks têm uma CLI predefinida e serão invocados pelas ferramentas do SDK se estiverem presentes.

Como esses hooks são invocados pelas
ferramentas `dart` e `flutter` em execuções e builds, as dependências
desses hooks devem ser dependências normais e não `dev_dependencies`.

:::note
O suporte a hook (gancho) é **experimental** e está em desenvolvimento ativo.

Para saber mais sobre como definir hooks e seu status atual,
consulte a [documentação do hook `build.dart`][].
:::


[`build.dart` hook documentation]: {{site.repo.dart.org}}/native/blob/main/pkgs/native_assets_cli/README.md

## Cache específico do projeto para ferramentas {:#project-specific-caching-for-tools}

:::note
Não adicione o diretório `.dart_tool/` no controle de versão.
Em vez disso, mantenha `.dart_tool/` em `.gitignore`.
:::

O diretório `.dart_tool/` é criado quando você executa `dart pub get`
e pode ser excluído a qualquer momento. Várias ferramentas usam este diretório
para armazenar em cache arquivos específicos para o seu projeto e/ou máquina local.
O diretório `.dart_tool/` nunca deve ser adicionado no
controle de versão, ou copiado entre máquinas.

Também é geralmente seguro excluir o diretório `.dart_tool/`,
embora algumas ferramentas possam precisar recalcular as informações em cache.

**Exemplo:** A ferramenta [`dart pub get`](/tools/pub/cmd/pub-get)
fará o download e extrairá as dependências para um diretório global `$PUB_CACHE`,
e então escreverá um arquivo `.dart_tool/package_config.json` mapeando _nomes de pacotes_
para diretórios no diretório global `$PUB_CACHE`.
O arquivo `.dart_tool/package_config.json` é usado por outras ferramentas,
como o analisador e os compiladores quando eles precisam resolver declarações
como `import 'package:foo/foo.dart'`.

Ao desenvolver uma ferramenta que precisa de cache específico do projeto,
você pode considerar usar o diretório `.dart_tool/`
porque a maioria dos usuários já o ignora com `.gitignore`.
Ao armazenar arquivos em cache para sua ferramenta no diretório `.dart_tool/` de um usuário,
você deve usar um subdiretório único. Para evitar colisões,
subdiretórios da forma `.dart_tool/<nome_do_pacote_da_ferramenta>/`
são reservados para o pacote chamado `<nome_do_pacote_da_ferramenta>`.
Se sua ferramenta não for distribuída através do [site pub.dev,]({{site.pub}})
você pode considerar publicar um pacote de espaço reservado para
reservar o nome único.

**Exemplo:** [`package:build`]({{site.pub-pkg}}/build) fornece um
framework (estrutura) para escrever passos de geração de código.
Ao executar esses passos de build, os arquivos são armazenados em cache em `.dart_tool/build/`.
Isso ajuda a acelerar futuras reexecuções dos passos de build.

:::warning
Ao desenvolver uma ferramenta que deseja armazenar arquivos em cache em `.dart_tool/`,
garanta o seguinte:

* Você está usando um subdiretório com o nome de um pacote que você possui
  (`.dart_tool/<meu_nome_do_pacote_da_ferramenta>/`)
* Seus arquivos não pertencem ao controle de versão,
  já que `.dart_tool/` está geralmente listado em `.gitignore`
:::


[Markdown]: {{site.pub-pkg}}/markdown