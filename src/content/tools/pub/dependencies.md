---
ia-translate: true
title: "Dependências de pacotes"
breadcrumb: Dependências
description: "Adicione outros pacotes ao seu aplicativo. Especifique localizações de pacotes, restrições de versão e mais."
---

Dependências são um dos conceitos principais do [gerenciador de pacotes pub][pub package manager].
Uma _dependência_ é outro pacote que seu pacote precisa para funcionar.
As dependências são especificadas no seu [pubspec](/tools/pub/pubspec).
Você lista apenas as _dependências imediatas_: o
software que seu pacote usa diretamente. O Pub cuida das
[dependências transitivas](/resources/glossary#transitive-dependency) para você.

Esta página tem informações detalhadas sobre como especificar dependências.
No final, há uma lista de
[melhores práticas para dependências de pacotes](#best-practices).

## Visão geral {:#overview}

Para cada dependência, você especifica o _nome_ do pacote do qual você depende
e o _intervalo de versões_ desse pacote que você permite.
Você também pode especificar a [_fonte_][_source_].
A fonte diz ao pub como localizar o pacote.

[_source_]: /resources/glossary#dependency-source

Como exemplo, você especifica uma dependência no seguinte formato:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

Este código YAML cria uma dependência no pacote `transmogrify`
usando o repositório de pacotes padrão ([pub.dev]({{site.pub}})) e
permitindo qualquer versão de `1.0.0` até `2.0.0` (mas não incluindo `2.0.0`).
Para aprender sobre esta sintaxe, confira
[restrições de versão](#version-constraints).

Para especificar uma fonte diferente de pub.dev,
use `sdk`, `hosted`, `git` ou `path`.
Por exemplo, o seguinte código YAML usa `path`
para dizer ao pub para obter `transmogrify` de um diretório local:

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

A próxima seção descreve o formato para cada fonte de dependência.

## Fontes de dependência {:#dependency-sources}

O Pub pode usar as seguintes fontes para localizar pacotes:

* [SDK](#sdk)
* [Pacotes hospedados](#hosted-packages)
* [Pacotes Git](#git-packages)
* [Pacotes Path](#path-packages)

### Pacotes hospedados {:#hosted-packages}

Um pacote _hospedado_ é aquele que pode ser baixado do site pub.dev
(ou outro servidor HTTP que use a mesma API). Aqui está um exemplo
de como declarar uma dependência em um pacote hospedado:

```yaml
dependencies:
  transmogrify: ^1.4.0
```

Este exemplo especifica que seu pacote depende de um pacote hospedado chamado
`transmogrify` e funciona com qualquer versão de 1.4.0 a 2.0.0
(mas não o próprio 2.0.0).

Se você quiser usar seu [próprio repositório de pacotes][own package repository],
você pode usar `hosted` para especificar sua URL.
O seguinte código YAML cria uma dependência no pacote `transmogrify`
usando a fonte `hosted`:

[own package repository]: /tools/pub/custom-package-repositories (próprio repositório de pacotes)

```yaml
environment:
  sdk: '^[!2.19.0!]'

dependencies:
  transmogrify:
    [!hosted: https://some-package-server.com!]
    version: ^1.4.0
```

A restrição de versão é opcional, mas recomendada.
Se nenhuma restrição de versão for fornecida, `any` é assumido.

:::version-note
Se seu pacote tiver uma [restrição de SDK][SDK version] anterior a 2.19,
você deve usar o formato de limite inferior e superior para as versões do SDK.
O validador de restrição do SDK nessas versões não oferece suporte
à sintaxe de acento circunflexo.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]
```

Se seu pacote tiver uma [versão do SDK][SDK version] anterior a 2.15,
você deve usar um formato `hosted` mais detalhado.

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

[SDK version]: /resources/language/evolution#language-versioning (versão do SDK)

### Pacotes Git {:#git-packages}

Às vezes, você está na vanguarda e precisa usar pacotes que
ainda não foram lançados formalmente. Talvez seu próprio pacote ainda esteja em
desenvolvimento e esteja usando outros pacotes que estão sendo desenvolvidos ao
mesmo tempo. Para facilitar isso, você pode depender diretamente de um pacote
armazenado em um repositório [Git][git].

[git]: https://git-scm.com/

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

O `git` aqui diz que este pacote é encontrado usando o Git, e a URL depois disso é
a URL do Git que pode ser usada para clonar o pacote.

Mesmo que o repositório do pacote seja privado,
você pode configurar sua configuração `git` para acessar o repositório usando uma
[chave de acesso HTTPS][GitHub HTTPS] ou um [par de chaves SSH][GitHub SSH].
Então, você pode depender do pacote usando a URL correspondente do repositório:

```yaml
dependencies:
  kittens:
    # URL SSH:
    git: git@github.com:munificent/kittens.git
```

O comando `dart pub` chama `git clone` como um subprocesso, então tudo o que você precisa
fornecer é uma `<url>` que funcione quando `git clone <url>` é executado.

Se você quiser depender de um commit, branch ou tag específica,
adicione uma chave `ref` à descrição:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      ref: some-branch
```

O ref pode ser qualquer coisa que o Git permita para [identificar um commit.][commit]

[commit]: https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#naming-commits

Se o pacote do qual você depende marcou a
revisão de cada versão do pacote,
você pode usar `tag_pattern` em vez de `ref`,
junto com uma restrição de versão.

O Pub então consultará o Git para todas as tags correspondentes e
alimentará essas versões para o solucionador de versão.

```yaml highlightLines=5
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      tag_pattern: v{{version}} # Encontra tags de versão prefixadas com 'v'.
    version: ^2.0.1
```

:::version-note
O suporte para `tag_pattern` foi introduzido no Dart 3.9.

Para usar `tag_pattern`, o pubspec incluído (mas não a dependência)
deve ter uma restrição de versão do SDK de `^3.9.0` ou superior.
:::

O Pub assume que o pacote está na raiz do repositório Git. Para especificar uma
localização diferente no repositório, especifique um `path` relativo à raiz do
repositório:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/cats.git
      path: path/to/kittens
```

O path é relativo à raiz do repositório Git.

Dependências Git não são permitidas como dependências
para pacotes enviados para [pub.dev][pubsite].

### Pacotes Path {:#path-packages}

Às vezes, você se vê trabalhando em vários pacotes relacionados ao mesmo tempo.
Talvez você esteja criando um framework enquanto cria um aplicativo que o utiliza.
Nesses casos, durante o desenvolvimento, você realmente deseja depender da
versão _ativa_ desse pacote em seu sistema de arquivos local. Dessa forma, as
alterações em um pacote são captadas instantaneamente por aquele que depende dele.

Para lidar com isso, o pub oferece suporte a _dependências de path_ (caminho).

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

Isso diz que o diretório raiz para `transmogrify` é `/Users/me/transmogrify`.
Para esta dependência, o pub gera um link simbólico diretamente para o diretório
`lib` do diretório do pacote referenciado. Quaisquer alterações que você fizer no
pacote dependente são vistas imediatamente. Você não precisa executar o pub toda vez
que alterar o pacote dependente.

Paths relativos são permitidos e são considerados relativos ao diretório que
contém seu pubspec.

Dependências de path são úteis para desenvolvimento local, mas não funcionam ao
compartilhar código com o mundo exterior — nem todos podem acessar seu sistema
de arquivos. Por causa disso, você não pode enviar um pacote para o
[site pub.dev][pubsite] se ele tiver alguma dependência de path em seu pubspec.

Em vez disso, o fluxo de trabalho típico é:

1. Edite seu pubspec localmente para usar uma dependência de path.
2. Trabalhe no pacote principal e no pacote do qual ele depende.
3. Depois que ambos estiverem funcionando, publique o pacote dependente.
4. Altere seu pubspec para apontar para a versão agora hospedada de seu dependente.
5. Publique seu pacote principal também, se desejar.

### SDK {:#sdk}

A fonte SDK é usada para qualquer SDKs que são enviados junto com os pacotes,
que podem eles mesmos ser dependências.
Atualmente, o Flutter é o único SDK que é suportado.

A sintaxe se parece com isto:

```yaml
dependencies:
  flutter_driver:
    sdk: flutter
```

O identificador após `sdk:` indica de qual SDK o pacote vem.
Se for `flutter`, a dependência é satisfatória, desde que:

* O Pub esteja sendo executado no contexto do executável `flutter`
* O SDK do Flutter contenha um pacote com o nome fornecido

Se for um identificador desconhecido, a dependência é sempre considerada insatisfeita.

## Restrições de versão {:#version-constraints}

Digamos que seu Pacote A depende do Pacote B.
Como você pode comunicar a outros desenvolvedores qual versão do Pacote B
permanece compatível com uma determinada versão do Pacote A?

Para informar aos desenvolvedores a compatibilidade de versão, especifique as restrições de versão.
Você deseja permitir a maior variedade possível de versões
para dar flexibilidade aos usuários do seu pacote.
O intervalo deve excluir as versões que não funcionam ou não foram testadas.

A comunidade Dart usa versionamento semântico<sup id="fnref:semver"><a
href="#fn:semver">1</a></sup>.

Você pode expressar restrições de versão usando a _sintaxe tradicional_
ou _sintaxe de acento circunflexo_ a partir do Dart 2.19.
Ambas as sintaxes especificam um intervalo de versões compatíveis.

A sintaxe tradicional fornece um intervalo explícito como `'>=1.2.3 <2.0.0'`.
A sintaxe de acento circunflexo fornece uma versão inicial explícita `^1.2.3`

```yaml
environment:
  # Este pacote deve usar uma versão 3.x do Dart SDK começando com 3.2.
  sdk: ^3.2.0

dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: https://some-package-server.com
    # Este pacote deve usar uma versão 1.x do transmogrify começando com 1.4.
    version: ^1.4.0
```

Para saber mais sobre o sistema de versão do pub, consulte a [página de versionamento de pacote][package versioning page].

[package versioning page]: /tools/pub/versioning#semantic-versions (página de versionamento de pacote)

### Sintaxe tradicional {:#traditional-syntax}

Uma restrição de versão que usa a sintaxe tradicional pode usar qualquer
um dos seguintes valores:

| **Valor** |                **Permite**               | **Usar?** |                                                                        **Notas**                                                                        |
|:---------:|:----------------------------------------|:--------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
|   `any`   | Todas as versões                         |    Não   | Serve como uma declaração explícita de restrição de versão vazia.                                                                                         |
|  `1.2.3`  | Apenas a versão fornecida                |    Não   | Limita a adoção do seu pacote devido aos limites adicionais que ele impõe aos aplicativos que usam seu pacote.                                             |
| `>=1.2.3` | Versão fornecida ou posterior           |    Sim   |                                                                                                                                                         |
|  `>1.2.3` | Versões posteriores à versão fornecida |    Não   |                                                                                                                                                         |
| `<=1.2.3` | Versão fornecida ou anterior            |    Não   |                                                                                                                                                         |
|  `<1.2.3` | Versões anteriores à versão fornecida  |    Não   | Use isso quando você souber uma versão de limite superior que _não_ funciona com seu pacote. Esta versão pode ser a primeira a introduzir alguma alteração. |

{:.table}

Você pode especificar qualquer combinação de valores de versão conforme seus intervalos se cruzam.
Por exemplo, se você definir o valor da versão como `'>=1.2.3 <2.0.0'`,
isso combina ambas as limitações para que a dependência possa ser qualquer versão
de `1.2.3` a `2.0.0`, excluindo o próprio `2.0.0`.

:::warning
Se você incluir o caractere maior que (**>**) na restrição de versão,
**coloque toda a string de restrição entre aspas**.
Isso evita que o YAML interprete o caractere como sintaxe YAML.
Por exemplo: nunca use `>=1.2.3 <2.0.0`. Use `'>=1.2.3 <2.0.0'` ou `^1.2.3`.
:::

### Sintaxe de acento circunflexo {:#caret-syntax}

A sintaxe de acento circunflexo expressa a restrição de versão de forma compacta.
`^versão` significa _o intervalo de todas as versões que têm garantia de compatibilidade
com versões anteriores à versão fornecida_.
Este intervalo incluiria todas as versões até a próxima a introduzir uma
alteração incompatível. Como o Dart usa versionamento semântico, esta seria a próxima
versão principal para qualquer versão de pacote 1.0 ou posterior
ou a próxima versão secundária para qualquer versão de pacote anterior a 1.0.

| Valor da versão | Intervalo cobre até | Sintaxe de acento circunflexo | Sintaxe tradicional  |
|:---------------:|:------------------:|:----------------------------:|:-------------------:|
| >=1.0           | Próxima principal  | `^1.3.0`                     | `'>=1.3.0 <2.0.0'`  |
| <1.0            | Próxima secundária | `^0.1.2`                     | `'>=0.1.2 <0.2.0'`  |

{:.table}

O exemplo a seguir mostra a sintaxe de acento circunflexo:

```yaml
dependencies:
  # Abrange todas as versões de 1.3.0 a 1.y.z, não incluindo 2.0.0
  path: ^1.3.0
  # Abrange todas as versões de 1.1.0 a 1.y.z, não incluindo 2.0.0
  collection: ^1.1.0
  # Abrange todas as versões de 0.1.2 a 0.1.z, não incluindo 0.2.0
  string_scanner: ^0.1.2
```

## Dev dependencies {:#dev-dependencies}

O Pub oferece suporte a dois tipos de dependências: dependências regulares e _dev
dependencies_ (dependências de desenvolvimento). As dependências de desenvolvimento
diferem das dependências regulares no sentido de que _as dependências de desenvolvimento de pacotes dos quais você depende são ignoradas_. Veja um exemplo:

Digamos que o pacote `transmogrify` use o pacote `test` em seus testes e
apenas em seus testes. Se alguém só quiser usar `transmogrify`—importar suas
bibliotecas—ele não precisa realmente de `test`. Neste caso, ele especifica
`test` como uma dependência de desenvolvimento. Seu pubspec terá algo como:

```yaml
dev_dependencies:
  test: ^1.25.0
```

O Pub obtém todos os pacotes dos quais seu pacote depende e tudo o que _esses_
pacotes dependem, transitivamente. Ele também obtém as dependências de
desenvolvimento do seu pacote, mas _ignora_ as dependências de desenvolvimento de
qualquer pacote dependente. O Pub obtém apenas as dependências de desenvolvimento
_do seu_ pacote. Portanto, quando seu pacote depende de `transmogrify`, ele obterá `transmogrify`, mas não `test`.

A regra para decidir entre uma dependência regular ou de desenvolvimento é
simples: se a dependência for importada de algo em seus diretórios `lib` ou
`bin`, ela precisa ser uma dependência regular. Se for importada apenas de
`test`, `example` etc., pode e deve ser uma dependência de desenvolvimento.

O uso de dependências de desenvolvimento torna os gráficos de dependência menores.
Isso faz com que o `pub` seja executado mais rapidamente e torna mais fácil
encontrar um conjunto de versões de pacotes que satisfaça todas as restrições.

## Substituições de dependência {:#dependency-overrides}

Você pode usar `dependency_overrides` para substituir temporariamente todas as
referências a uma dependência.

Por exemplo, talvez você esteja atualizando uma cópia local do transmogrify, um
pacote publicado. O transmogrify é usado por outros pacotes em seu
gráfico de dependência, mas você não deseja clonar cada pacote localmente
e alterar cada pubspec para testar sua cópia local do transmogrify.

Nessa situação, você pode substituir a dependência usando
`dependency_overrides` para especificar o diretório que contém a cópia local
do pacote.

O pubspec seria algo como o seguinte:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify:
    path: ../transmogrify_patch/
```

Quando você executa [`dart pub get`][`dart pub get`] ou [`dart pub upgrade`][`dart pub upgrade`],
o lockfile do pubspec é atualizado para refletir o
novo path para sua dependência e, onde quer que o transmogrify seja usado, o pub
usa a versão local.

Você também pode usar `dependency_overrides` para especificar um
versão específica de um pacote:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify: '3.2.1'
```

:::warning
Usar uma substituição de dependência envolve algum risco. Por exemplo,
usar uma substituição para especificar uma versão fora do intervalo que o
pacote afirma oferecer suporte, ou usar uma substituição para especificar
uma cópia local de um pacote que tenha comportamentos inesperados,
pode quebrar seu aplicativo.
:::

Apenas as substituições de dependência no **próprio pubspec de um pacote**
são consideradas durante a resolução do pacote.
As substituições de dependência dentro de quaisquer pacotes dependentes são ignoradas.

Como resultado, se você publicar um pacote no pub.dev,
tenha em mente que as substituições de dependência do seu pacote
são ignoradas por todos os usuários do seu pacote.

Se você estiver usando um [workspace pub][workspaces],
você pode ter `dependency_overrides` em cada pacote do workspace, mas
um único pacote só pode ser substituído uma vez no workspace.

## `pubspec_overrides.yaml` {:#pubspec-overrides}

Se você quiser alterar certos aspectos da
resolução do seu arquivo `pubspec.yaml`, mas
não quiser alterar o arquivo real, você pode
colocar um arquivo chamado `pubspec_overrides.yaml` ao lado do `pubspec.yaml`.

Os atributos desse arquivo substituirão aqueles do `pubspec.yaml`.

As propriedades que podem ser substituídas são:

* `dependency_overrides`
* `workspace`
* `resolution`

Isso pode ser útil para evitar acidentalmente
incluir substituições temporárias no controle de versão.
Também pode facilitar a geração de substituições a partir de um script.

Em um [workspace pub][workspaces], cada pacote do workspace
pode ter um arquivo `pubspec_overrides.yaml`.

## Melhores práticas

Seja proativo no gerenciamento de suas dependências.
Certifique-se de que seus pacotes dependam das versões mais recentes dos pacotes
quando possível.
Se seu pacote depender de um pacote obsoleto,
esse pacote obsoleto pode depender de outros pacotes obsoletos em sua árvore de dependência.
Versões obsoletas de pacotes podem ter um impacto negativo na
estabilidade, desempenho e qualidade do seu aplicativo.

Recomendamos as seguintes práticas recomendadas para dependências de pacotes.

### Use a sintaxe de acento circunflexo {:#use-caret-syntax}

Especifique dependências usando a [sintaxe de acento circunflexo](#caret-syntax).
Isso permite que a ferramenta pub selecione versões mais recentes do pacote
quando elas estiverem disponíveis.
Além disso, ele coloca um limite superior na versão permitida.

### Dependa das versões de pacotes estáveis mais recentes {:#depend-on-the-latest-stable-package-versions}

Use [`dart pub upgrade`][`dart pub upgrade`] para atualizar para as versões de pacote mais recentes
que seu pubspec permite.
Para identificar as dependências em seu aplicativo ou pacote que
não estão nas versões estáveis mais recentes,
use [`dart pub outdated`][`dart pub outdated`].

### Aperte as restrições de versão para dev dependencies {:#tighten-version-constraints-for-dev-dependencies}

Uma dependência de desenvolvimento define um pacote que você precisa apenas durante o
desenvolvimento. Um aplicativo finalizado não precisará desses pacotes.
Exemplos desses pacotes incluem testes ou ferramentas de geração de código.
Defina as restrições de versão dos pacotes em [`dev_dependencies`][dev-dep]
para ter um limite inferior da versão mais recente da qual seu pacote depende.

O aperto das restrições de versão de suas dependências de desenvolvimento pode
se parecer com o seguinte:

```yaml
dev_dependencies:
  build_runner: ^2.8.0
  lints: ^6.0.0
  test: ^1.25.15
```

Este YAML define `dev_dependencies` para as versões de patch mais recentes.

[dev-dep]: /tools/pub/dependencies#dev-dependencies

### Teste sempre que atualizar as dependências de pacotes {:#test-whenever-you-update-package-dependencies}

Se você executar [`dart pub upgrade`][`dart pub upgrade`] sem atualizar seu pubspec,
a API deve permanecer a mesma
e seu código deve ser executado como antes — mas teste para ter certeza.
Se você modificar o pubspec e atualizar para uma nova versão principal,
então você pode encontrar alterações incompatíveis,
portanto, você precisa testar ainda mais minuciosamente.

### Teste com dependências rebaixadas {:#test-with-downgraded-dependencies}

Ao desenvolver pacotes para publicação, muitas vezes é preferível
permitir as restrições de dependência mais amplas possíveis.
Uma restrição de dependência ampla reduz a probabilidade de que
os consumidores de pacotes enfrentem um conflito de resolução de versão.

Por exemplo, se você tiver uma dependência em `foo: ^1.2.3` e
a versão `1.3.0` de `foo` for lançada, pode ser razoável
manter a restrição de dependência existente (`^1.2.3`).
Mas se seu pacote começar a usar recursos adicionados em `1.3.0`, então
você precisará aumentar sua restrição para `^1.3.0`.

No entanto, é fácil esquecer de aumentar uma
restrição de dependência quando ela se torna necessária.
Portanto, é uma prática recomendada testar seu pacote
com dependências rebaixadas antes de publicar.

Para testar com dependências rebaixadas, execute [`dart pub downgrade`][`dart pub downgrade`] e
verifique se seu pacote ainda é analisado sem erros e passa em todos os testes:

```console
dart pub downgrade
dart analyze
dart test
```

O teste com dependências rebaixadas deve
acontecer junto com os testes normais com as dependências mais recentes.
Se as restrições de dependência precisarem ser aumentadas, altere-as você mesmo ou
use `dart pub upgrade --tighten` para atualizar as dependências para as versões mais recentes.

:::note
O teste com `dart pub downgrade` permite que você encontre incompatibilidades que
você pode não ter descoberto de outra forma.
Mas isso não exclui a possibilidade de incompatibilidades.

Muitas vezes, existem tantas combinações diferentes de versões que
testá-las todas é inviável.
Também pode haver versões mais antigas permitidas por suas restrições de dependência que
não podem ser resolvidas devido a restrições de versão mutuamente incompatíveis de
próprios pacotes ou de suas `dev_dependencies`.
:::

[`dart pub downgrade`]: /tools/pub/cmd/pub-downgrade

### Verifique a integridade dos pacotes baixados {:#verify-the-integrity-of-downloaded-packages}

Ao recuperar novas dependências,
use a opção [`--enforce-lockfile`][enforce-lock] para garantir que
o conteúdo do pacote extraído corresponda ao conteúdo do arquivo original.
Sem modificar o [lockfile][lockfile],
esta flag apenas resolve novas dependências se:

* `pubspec.yaml` é satisfeito
* `pubspec.lock` não está faltando
* Os [hashes de conteúdo][content hashes] dos pacotes correspondem

[enforce-lock]: /tools/pub/cmd/pub-get#enforce-lockfile
[lockfile]: /resources/glossary#lockfile
[content hashes]: /resources/glossary#pub-content-hash

---

<aside id="fn:semver" class="footnote">

[1] O Pub segue a versão `2.0.0-rc.1` da
[especificação de versionamento semântico][semantic versioning specification]
porque essa versão permite que os pacotes usem identificadores de build (`+12345`)
para diferenciar as versões. <a href="#fnref:semver">↩</a>

</aside>

[GitHub HTTPS]: https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git
[GitHub SSH]: https://help.github.com/articles/connecting-to-github-with-ssh/
[pub package manager]: /tools/pub/packages (gerenciador de pacotes pub)
[`dart pub get`]: /tools/pub/cmd/pub-get
[`dart pub outdated`]: /tools/pub/cmd/pub-outdated
[`dart pub upgrade`]: /tools/pub/cmd/pub-upgrade
[pubsite]: {{site.pub}}
[semantic versioning specification]: https://semver.org/spec/v2.0.0-rc.1.html
[workspaces]: /tools/pub/workspaces
