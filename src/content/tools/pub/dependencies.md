---
ia-translate: true
title: Dependências de pacotes
breadcrumb: Dependências
description: >-
  Adicione outros pacotes ao seu app.
  Especifique localizações de pacotes, restrições de versão e muito mais.
---

Dependências são um dos conceitos centrais do [gerenciador de pacotes pub][pub package manager].
Uma _dependência_ é outro pacote de que o seu pacote precisa para funcionar.
As dependências são especificadas no seu [pubspec](/tools/pub/pubspec).
Você lista apenas as _dependências imediatas_: o
software que o seu pacote usa diretamente. O pub cuida das
[dependências transitivas](/resources/glossary#transitive-dependency) para você.

Esta página traz informações detalhadas sobre como especificar dependências.
No final, há uma lista de
[boas práticas para dependências de pacotes](#best-practices).

## Visão geral {:#overview}

Para cada dependência, você especifica o _nome_ do pacote do qual depende
e a _faixa de versões_ desse pacote que você aceita.
Você também pode especificar a [_fonte_][_source_].
A fonte diz ao pub como localizar o pacote.

[_source_]: /resources/glossary#dependency-source

Como exemplo, você especifica uma dependência no formato a seguir:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

Este código YAML cria uma dependência do pacote `transmogrify`
usando o repositório de pacotes padrão ([pub.dev]({{site.pub}})) e
permitindo qualquer versão de `1.0.0` a `2.0.0` (sem incluir `2.0.0`).
Para aprender essa sintaxe, veja
[restrições de versão](#version-constraints).

Para especificar uma fonte diferente do pub.dev,
use `sdk`, `hosted`, `git` ou `path`.
Por exemplo, o código YAML a seguir usa `path`
para dizer ao pub que obtenha o `transmogrify` de um diretório local:

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

A próxima seção descreve o formato de cada fonte de dependência.

## Fontes de dependências {:#dependency-sources}

O pub pode usar as fontes a seguir para localizar pacotes:

* [Pacotes hospedados](#hosted-packages)
* [Pacotes Git](#git-packages)
* [Pacotes de caminho](#path-packages)
* [SDK](#sdk-packages)

Vários comandos da [ferramenta `dart`][`dart` tool] também permitem especificar fontes de dependência
diretamente na linha de comando, usando [descritores de pacote](#package-descriptors).

[`dart` tool]: /tools/dart-tool

### Pacotes hospedados {:#hosted-packages}

Um pacote _hospedado_ é aquele que pode ser baixado do site pub.dev
(ou de outro servidor HTTP que fale a mesma API). Aqui está um exemplo
de declaração de dependência de um pacote hospedado:

```yaml
dependencies:
  transmogrify: ^1.4.0
```

Este exemplo especifica que o seu pacote depende de um pacote hospedado chamado
`transmogrify` e funciona com qualquer versão de 1.4.0 até 2.0.0
(sem incluir a 2.0.0 em si).

Se você quiser usar o seu [próprio repositório de pacotes][own package repository],
pode usar `hosted` para especificar a URL dele.
O código YAML a seguir cria uma dependência do pacote `transmogrify`
usando a fonte `hosted`:

[own package repository]: /tools/pub/custom-package-repositories

```yaml
environment:
  sdk: '^[!2.19.0!]'

dependencies:
  transmogrify:
    [!hosted: https://some-package-server.com!]
    version: ^1.4.0
```

A restrição de versão é opcional, mas recomendada.
Se nenhuma restrição de versão for informada, assume-se `any`.

:::version-note
Se o seu pacote tiver [restrições de SDK][SDK version] anteriores à 2.19,
você deve usar o formato de limite inferior e superior para as versões do SDK.
O validador de restrição de SDK dessas versões não oferece suporte
à sintaxe de circunflexo.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]
```

Se o seu pacote tiver uma [versão do SDK][SDK version] anterior à 2.15,
você deve usar um formato `hosted` mais verboso.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]

dependencies:
  transmogrify:
    [!hosted:!]
      [!name: transmogrify!]
      [!url: https://some-package-server.com!]
    version: ^1.4.0
```
:::

[SDK version]: /language/versioning

### Pacotes Git {:#git-packages}

Às vezes você quer estar na vanguarda e precisa usar pacotes que
ainda não foram lançados formalmente. Talvez o seu próprio pacote ainda esteja em
desenvolvimento e use outros pacotes que estão sendo desenvolvidos ao
mesmo tempo. Para facilitar isso, você pode depender diretamente de um pacote
armazenado em um repositório [Git][].

[git]: https://git-scm.com/

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

O `git` aqui indica que este pacote é encontrado usando Git, e a URL depois disso é
a URL Git que pode ser usada para clonar o pacote.

Mesmo que o repositório do pacote seja privado,
você pode configurar o seu `git` para acessar o repositório usando uma
[chave de acesso HTTPS][GitHub HTTPS] ou um [par de chaves SSH][GitHub SSH].
Depois disso, você pode depender do pacote usando a URL correspondente do repositório:

```yaml
dependencies:
  kittens:
    # SSH URL:
    git: git@github.com:munificent/kittens.git
```

O comando `dart pub` chama `git clone` como um subprocesso, então tudo o que você precisa fornecer
é uma `<url>` que funcione quando `git clone <url>` for executado.

Se você quiser depender de um commit, branch ou tag específico,
adicione uma chave `ref` à descrição:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      ref: some-branch
```

O `ref` pode ser qualquer coisa que o Git permita para [identificar um commit.][commit]

[commit]: https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#naming-commits

Se o pacote do qual você depende tiver marcado a
revisão de cada versão do pacote com tags,
você pode usar `tag_pattern` em vez de `ref`,
junto com uma restrição de versão.

O pub, então, consulta o Git por todas as tags correspondentes e
envia essas versões para o resolvedor de versões.

```yaml highlightLines=5
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      tag_pattern: v{% raw %}{{version}}{% endraw %} # Find version-tag prefixed by 'v'.
    version: ^2.0.1
```

:::version-note
O suporte a `tag_pattern` foi introduzido no Dart 3.9.

Para usar `tag_pattern`, o pubspec que inclui a dependência (mas não a própria dependência)
deve ter uma restrição de versão do SDK igual a `^3.9.0` ou superior.
:::

O pub assume que o pacote está na raiz do repositório Git. Para especificar um
local diferente dentro do repositório, informe um `path` relativo à raiz do
repositório:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/cats.git
      path: path/to/kittens
```

O caminho é relativo à raiz do repositório Git.

Dependências Git não são permitidas como dependências
de pacotes enviados ao [pub.dev][pubsite].

### Pacotes de caminho {:#path-packages}

Às vezes você se vê trabalhando em vários pacotes relacionados ao mesmo
tempo. Talvez esteja criando um framework enquanto desenvolve um app que o usa.
Nesses casos, durante o desenvolvimento, você realmente quer depender da versão _ao vivo_
desse pacote no seu sistema de arquivos local. Assim, as mudanças feitas em um
pacote são captadas imediatamente pelo que depende dele.

Para lidar com isso, o pub oferece suporte a _dependências de caminho_.

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

Isso diz que o diretório raiz do `transmogrify` é `/Users/me/transmogrify`.
Para essa dependência, o pub gera um link simbólico diretamente para o diretório `lib`
do diretório do pacote referenciado. Quaisquer mudanças que você fizer no pacote
dependente são vistas imediatamente. Você não precisa executar o pub toda vez que
mudar o pacote dependente.

Caminhos relativos são permitidos e são considerados relativos ao diretório
que contém o seu pubspec.

Dependências de caminho são úteis para o desenvolvimento local, mas não funcionam ao
compartilhar código com o mundo externo — nem todo mundo consegue acessar
o seu sistema de arquivos. Por isso, você não pode enviar um pacote para o
[site pub.dev][pubsite] se ele tiver alguma dependência de caminho no pubspec.

Em vez disso, o fluxo de trabalho típico é:

1. Edite o seu pubspec localmente para usar uma dependência de caminho.
2. Trabalhe no pacote principal e no pacote do qual ele depende.
3. Quando ambos estiverem funcionando, publique o pacote dependente.
4. Altere o seu pubspec para apontar para a versão, agora hospedada, do dependente.
5. Publique também o seu pacote principal, se quiser.

<a id="sdk" aria-hidden="true"></a>

### Pacotes SDK {:#sdk-packages}

A fonte SDK é usada para quaisquer SDKs distribuídos junto com pacotes,
que podem ser dependências deles.
Atualmente, o Flutter é o único SDK suportado.

A sintaxe é esta:

```yaml
dependencies:
  flutter_driver:
    sdk: flutter
```

O identificador depois de `sdk:` indica de qual SDK o pacote vem.
Se for `flutter`, a dependência é satisfeita desde que:

* O pub esteja sendo executado no contexto do executável `flutter`
* O SDK do Flutter contenha um pacote com o nome informado

Se for um identificador desconhecido, a dependência é sempre considerada não satisfeita.

<a id="source-descriptors" aria-hidden="true"></a>

## Descritores de pacote {:#package-descriptors}

Vários comandos da [ferramenta `dart`][dart-tool], como
[`dart pub add`][pub-add] e [`dart pub unpack`][pub-unpack],
aceitam um _descritor de pacote_ depois do nome do pacote
para especificar a versão ou a fonte da dependência de um pacote.

A forma mais simples de um descritor de pacote é
uma [restrição de versão](#version-constraints),
assumindo a fonte padrão do [site pub.dev][pubsite].
Por exemplo, o comando a seguir usa um descritor `^1.2.3`
para [adicionar uma dependência][pub-add] do `package:foo` com a restrição `^1.2.3`.

```console
dart pub add foo:^1.2.3
```

Para especificar uma [fonte de dependência](#dependency-sources) personalizada,
use a mesma estrutura do `pubspec.yaml`,
mas usando [YAML em estilo flow][flow-style]:

```plaintext
{<source>: <descriptor>, [version: <constraint>]}
```

As subseções a seguir mostram a sintaxe do descritor de pacote
para cada tipo de [fonte de dependência](#dependency-sources) do pub.

[dart-tool]: /tools/dart-tool
[pub-add]: /tools/pub/cmd/pub-add
[pub-unpack]: /tools/pub/cmd/pub-unpack
[flow-style]: https://yaml.org/spec/1.2.2/#chapter-7-flow-style-productions

### Descritor de dependência hospedada {:#hosted-dependency-descriptor}

Para especificar um [pacote hospedado](#hosted-packages):

```plaintext
{hosted: my-pub.dev}
```

Você também pode especificar uma [restrição de versão](#version-constraints):

```plaintext
{hosted: my-pub.dev, version: ^1.2.3}
```

### Descritor de dependência Git {:#git-dependency-descriptor}

Para especificar um [pacote Git](#git-packages):

```plaintext
{git: https://github.com/foo/foo}
```

Você pode especificar a URL do repositório, uma referência de branch ou commit,
e o caminho do pacote dentro do repositório:

```plaintext
{git: {url: ../foo.git, ref: branch, path: subdir}}
```

### Descritor de pacote de caminho {:#path-package-descriptor}

Para especificar um [pacote de caminho](#path-packages):

```plaintext
{path: ../foo}
```

### Descritor de pacote SDK {:#sdk-package-descriptor}

Para especificar um [pacote SDK](#sdk-packages):

```plaintext
{sdk: flutter}
```

## Restrições de versão {:#version-constraints}

Imagine que o seu Pacote A depende do Pacote B.
Como você pode comunicar a outros desenvolvedores qual versão do Pacote B
continua compatível com uma determinada versão do Pacote A?

Para que os desenvolvedores saibam a compatibilidade de versões, especifique restrições de versão.
Você quer permitir a maior faixa de versões possível
para dar flexibilidade aos usuários do seu pacote.
A faixa deve excluir versões que não funcionam ou que não foram testadas.

A comunidade Dart usa o versionamento semântico<sup id="fnref:semver"><a
href="#fn:semver">1</a></sup>.

Você pode expressar restrições de versão usando a _sintaxe tradicional_
ou a _sintaxe de circunflexo_, a partir do Dart 2.19.
As duas sintaxes especificam uma faixa de versões compatíveis.

A sintaxe tradicional fornece uma faixa explícita, como `'>=1.2.3 <2.0.0'`.
A sintaxe de circunflexo fornece uma versão inicial explícita, `^1.2.3`.

```yaml
environment:
  # This package must use a 3.x version of the Dart SDK starting with 3.2.
  sdk: ^3.2.0

dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: https://some-package-server.com
    # This package must use a 1.x version of transmogrify starting with 1.4.
    version: ^1.4.0
```

Para saber mais sobre o sistema de versões do pub, veja a [página de versionamento de pacotes][package versioning page].

[package versioning page]: /tools/pub/versioning#semantic-versions

### Sintaxe tradicional {:#traditional-syntax}

Uma restrição de versão que usa a sintaxe tradicional pode usar qualquer
um dos valores a seguir:

| **Valor** |                **Permite**                  | **Usar?** |                                                                        **Notas**                                                                        |
|:---------:|:----------------------------------------|:--------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
|   `any`   | Todas as versões                        |    Não   | Serve como declaração explícita de uma restrição de versão vazia.                                                                                       |
|  `1.2.3`  | Somente a versão informada              |    Não   | Limita a adoção do seu pacote, por causa dos limites adicionais que impõe aos apps que usam o seu pacote.                                               |
| `>=1.2.3` | Versão informada ou posterior           |    Sim   |                                                                                                                                                         |
|  `>1.2.3` | Versões posteriores à versão informada  |    Não   |                                                                                                                                                         |
| `<=1.2.3` | Versão informada ou anterior            |    Não   |                                                                                                                                                         |
|  `<1.2.3` | Versões anteriores à versão informada   |    Não   | Use isso quando você souber de uma versão de limite superior que _não_ funciona com o seu pacote. Essa versão pode ser a primeira a introduzir alguma mudança incompatível. |

{:.table}

Você pode especificar qualquer combinação de valores de versão, já que as faixas se intersectam.
Por exemplo, se você definir o valor de versão como `'>=1.2.3 <2.0.0'`,
as duas limitações se combinam, de modo que a dependência pode ser qualquer versão
de `1.2.3` até `2.0.0`, excluindo a própria `2.0.0`.

:::warning
Se você incluir o caractere de maior que (**>**) na restrição de versão,
**coloque a string inteira da restrição entre aspas**.
Isso impede que o YAML interprete o caractere como sintaxe YAML.
Por exemplo: nunca use `>=1.2.3 <2.0.0`. Use `'>=1.2.3 <2.0.0'` ou `^1.2.3`.
:::

### Sintaxe de circunflexo {:#caret-syntax}

A sintaxe de circunflexo expressa a restrição de versão de forma compacta.
`^version` significa _a faixa de todas as versões que têm garantia de compatibilidade
retroativa com a versão informada_.
Essa faixa inclui todas as versões até a próxima que introduza uma
mudança incompatível. Como o Dart usa versionamento semântico, essa seria a próxima
versão major para qualquer pacote na versão 1.0 ou posterior,
ou a próxima versão minor para qualquer pacote em versão anterior à 1.0.

| Valor de versão | A faixa vai até | Sintaxe de circunflexo | Sintaxe tradicional |
|:---------------:|:---------------:|:----------------------:|:-------------------:|
| >=1.0           | Próxima major   | `^1.3.0`               | `'>=1.3.0 <2.0.0'`  |
| <1.0            | Próxima minor   | `^0.1.2`               | `'>=0.1.2 <0.2.0'`  |

{:.table}

O exemplo a seguir mostra a sintaxe de circunflexo:

```yaml
dependencies:
  # Covers all versions from 1.3.0 to 1.y.z, not including 2.0.0
  path: ^1.3.0
  # Covers all versions from 1.1.0 to 1.y.z, not including 2.0.0
  collection: ^1.1.0
  # Covers all versions from 0.1.2 to 0.1.z, not including 0.2.0
  string_scanner: ^0.1.2
```

## Dependências de desenvolvimento {:#dev-dependencies}

O pub oferece dois tipos de dependências: as dependências regulares e as _dependências
de desenvolvimento_ (_dev dependencies_). Elas diferem porque as _dependências de desenvolvimento
dos pacotes dos quais você depende são ignoradas_. Veja um exemplo:

Digamos que o pacote `transmogrify` use o pacote `test` em seus testes e somente
neles. Se alguém só quiser usar o `transmogrify` — importar as suas
bibliotecas —, essa pessoa não precisa de fato do `test`. Nesse caso, o `transmogrify` declara
o `test` como dependência de desenvolvimento. O pubspec dele terá algo como:

```yaml
dev_dependencies:
  test: ^1.25.0
```

O pub obtém todos os pacotes dos quais o seu pacote depende, e tudo o que _esses_
pacotes dependem, de forma transitiva. Ele também obtém as dependências de desenvolvimento
do seu pacote, mas _ignora_ as dependências de desenvolvimento de quaisquer pacotes dependentes.
O pub só obtém as dependências de desenvolvimento do _seu_ pacote. Assim, quando o seu pacote depende de
`transmogrify`, ele obtém o `transmogrify`, mas não o `test`.

A regra para decidir entre dependência regular ou de desenvolvimento é simples: se
a dependência é importada por algo nos seus diretórios `lib` ou `bin`,
ela precisa ser uma dependência regular. Se ela é importada apenas em `test`,
`example` etc., pode e deve ser uma dependência de desenvolvimento.

Usar dependências de desenvolvimento deixa os grafos de dependências menores. Isso faz o `pub` rodar
mais rápido e facilita encontrar um conjunto de versões de pacotes que satisfaça todas as
restrições.

## Sobreposições de dependências {:#dependency-overrides}

Você pode usar `dependency_overrides` para sobrepor temporariamente todas as referências
a uma dependência.

Por exemplo, talvez você esteja atualizando uma cópia local do transmogrify, um
pacote publicado. O transmogrify é usado por outros pacotes do seu
grafo de dependências, mas você não quer clonar cada pacote localmente
e alterar cada pubspec para testar a sua cópia local do transmogrify.

Nessa situação, você pode sobrepor a dependência usando
`dependency_overrides` para especificar o diretório que contém a
cópia local do pacote.

O pubspec ficaria mais ou menos assim:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify:
    path: ../transmogrify_patch/
```

Quando você executa [`dart pub get`][] ou [`dart pub upgrade`][],
o lockfile do pubspec é atualizado para refletir o
novo caminho da sua dependência e, onde quer que o transmogrify seja usado, o pub
usa a versão local.

Você também pode usar `dependency_overrides` para especificar uma versão
específica de um pacote:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify: '3.2.1'
```

:::warning
Usar uma sobreposição de dependência envolve algum risco. Por exemplo,
usar uma sobreposição para especificar uma versão fora da faixa que o
pacote declara suportar, ou usar uma sobreposição para especificar
uma cópia local de um pacote com comportamentos inesperados,
pode quebrar a sua aplicação.
:::

Somente as sobreposições de dependências no **pubspec do próprio pacote** são
consideradas durante a resolução de pacotes.
As sobreposições de dependências dentro de quaisquer pacotes dos quais você depende são ignoradas.

Por isso, se você publicar um pacote no pub.dev,
lembre-se de que as sobreposições de dependências do seu pacote
são ignoradas por todos os usuários dele.

Se você estiver usando um [workspace do pub][workspaces],
pode ter `dependency_overrides` em cada pacote do workspace, mas
um único pacote só pode ser sobreposto uma vez no workspace.

## `pubspec_overrides.yaml` {:#pubspec-overrides}

Se você quiser alterar certos aspectos da
resolução do seu arquivo `pubspec.yaml`, mas
não quiser mudar o arquivo em si, pode
colocar um arquivo chamado `pubspec_overrides.yaml` ao lado do `pubspec.yaml`.

Os atributos desse arquivo sobrescrevem os do `pubspec.yaml`.

As propriedades que podem ser sobrescritas são:

* `dependency_overrides`
* `workspace`
* `resolution`

Isso pode ser útil para evitar o acidente de versionar sobreposições temporárias.
Também pode facilitar a geração de sobreposições a partir de um script.

Em um [workspace do pub][workspaces], cada pacote do workspace
pode ter um arquivo `pubspec_overrides.yaml`.

## Boas práticas {:#best-practices}

Seja proativo na gestão das suas dependências.
Sempre que possível, garanta que os seus pacotes dependam das versões mais recentes dos pacotes.
Se o seu pacote depender de um pacote desatualizado,
esse pacote desatualizado pode depender de outros pacotes desatualizados na árvore de dependências.
Versões desatualizadas de pacotes podem afetar negativamente a
estabilidade, a performance e a qualidade do seu app.

Recomendamos as seguintes boas práticas para dependências de pacotes.

### Use a sintaxe de circunflexo {:#use-caret-syntax}

Especifique as dependências usando a [sintaxe de circunflexo](#caret-syntax).
Isso permite que a ferramenta pub selecione versões mais novas do pacote
quando elas estiverem disponíveis. Além disso, define um limite superior para a versão permitida.

### Dependa das versões estáveis mais recentes dos pacotes {:#depend-on-the-latest-stable-package-versions}

Use o [`dart pub upgrade`][] para atualizar para as versões mais recentes dos pacotes
que o seu pubspec permite.
Para identificar dependências do seu app ou pacote que
não estão nas versões estáveis mais recentes,
use o [`dart pub outdated`][].

### Restrinja as versões das dependências de desenvolvimento {:#tighten-version-constraints-for-dev-dependencies}

Uma dependência de desenvolvimento define um pacote de que você precisa apenas durante o desenvolvimento.
Um app finalizado não precisa desses pacotes.
Exemplos desses pacotes são ferramentas de testes ou de geração de código.
Defina as restrições de versão dos pacotes em [`dev_dependencies`][dev-dep]
com um limite inferior igual à versão mais recente de que o seu pacote depende.

Restringir as versões das dependências de desenvolvimento pode ficar parecido com isto:

```yaml
dev_dependencies:
  build_runner: ^2.15.1
  lints: ^6.1.0
  test: ^1.31.1
```

Esse YAML define as `dev_dependencies` nas versões de patch mais recentes.

[dev-dep]: /tools/pub/dependencies#dev-dependencies

### Teste sempre que atualizar as dependências do pacote {:#test-whenever-you-update-package-dependencies}

Se você executar o [`dart pub upgrade`][] sem atualizar o seu pubspec,
a API deve continuar a mesma
e o seu código deve rodar como antes — mas teste para ter certeza. 
Se você modificar o pubspec e atualizar para uma nova versão major,
pode encontrar mudanças incompatíveis, então precisa testar ainda mais a fundo.

### Teste com dependências rebaixadas {:#test-with-downgraded-dependencies}

Ao desenvolver pacotes para publicação, geralmente é preferível
permitir as restrições de dependência mais amplas possíveis.
Uma restrição de dependência ampla reduz a probabilidade de que os
consumidores do pacote enfrentem um conflito na resolução de versões.

Por exemplo, se você depende de `foo: ^1.2.3` e a
versão `1.3.0` do `foo` é lançada, pode ser razoável
manter a restrição de dependência existente (`^1.2.3`).
Mas se o seu pacote começar a usar recursos adicionados na `1.3.0`, então
você precisará elevar a restrição para `^1.3.0`.

No entanto, é fácil esquecer de elevar uma
restrição de dependência quando isso se torna necessário.
Por isso, é uma boa prática testar o seu pacote
com dependências rebaixadas antes de publicar.

Para testar com dependências rebaixadas, execute o [`dart pub downgrade`][] e
verifique se o seu pacote continua sem erros na análise e passa em todos os testes:

```console
dart pub downgrade
dart analyze
dart test
```

Os testes com dependências rebaixadas devem
acontecer junto dos testes normais, com as dependências mais recentes.
Se as restrições de dependência precisarem ser elevadas, altere-as você mesmo ou
use `dart pub upgrade --tighten` para atualizar as dependências para as versões mais recentes.

:::note
Testar com `dart pub downgrade` permite encontrar incompatibilidades que
você talvez não descobrisse de outra forma.
Mas isso não exclui a possibilidade de incompatibilidades.

Muitas vezes há tantas combinações diferentes de versões que
testar todas é inviável.
Também podem existir versões mais antigas permitidas pelas suas restrições de dependência que
não conseguem ser resolvidas por causa de restrições de versão mutuamente incompatíveis
vindas dos próprios pacotes ou do seu `dev_dependencies`.
:::

[`dart pub downgrade`]: /tools/pub/cmd/pub-downgrade

### Verifique a integridade dos pacotes baixados {:#verify-the-integrity-of-downloaded-packages}

Ao obter novas dependências,
use a opção [`--enforce-lockfile`][enforce-lock] para garantir que
o conteúdo extraído do pacote corresponda ao conteúdo do arquivo original.
Sem modificar o [arquivo de bloqueio][lockfile],
essa flag só resolve novas dependências se:

* O `pubspec.yaml` for satisfeito
* O `pubspec.lock` não estiver ausente
* Os [hashes de conteúdo][content hashes] dos pacotes corresponderem

[enforce-lock]: /tools/pub/cmd/pub-get#enforce-lockfile
[lockfile]: /resources/glossary#lockfile
[content hashes]: /resources/glossary#pub-content-hash

---

<aside id="fn:semver" class="footnote">

[1] O pub segue a versão `2.0.0-rc.1` da
[especificação de versionamento semântico][semantic versioning specification]
porque essa versão permite que pacotes usem identificadores de build (`+12345`)
para diferenciar versões. <a href="#fnref:semver">↩</a>

</aside>

[GitHub HTTPS]: https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git
[GitHub SSH]: https://help.github.com/articles/connecting-to-github-with-ssh/
[pub package manager]: /tools/pub/packages
[`dart pub get`]: /tools/pub/cmd/pub-get
[`dart pub outdated`]: /tools/pub/cmd/pub-outdated
[`dart pub upgrade`]: /tools/pub/cmd/pub-upgrade
[pubsite]: {{site.pub}}
[semantic versioning specification]: https://semver.org/spec/v2.0.0-rc.1.html
[workspaces]: /tools/pub/workspaces
