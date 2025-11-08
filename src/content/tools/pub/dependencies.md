---
title: Dependências de pacotes
breadcrumb: Dependências
description: >-
  Adicione outros pacotes ao seu app.
  Especifique localizações de pacotes, restrições de versão e muito mais.
ia-translate: true
---

Dependências são um dos conceitos centrais do [gerenciador de pacotes pub][pub package manager].
Uma _dependência_ é outro pacote que o seu pacote precisa para funcionar.
Dependências são especificadas no seu [pubspec](/tools/pub/pubspec).
Você lista apenas _dependências imediatas_: o
software que o seu pacote usa diretamente. O pub lida com
[dependências transitivas](/resources/glossary#transitive-dependency) para você.

Esta página tem informações detalhadas sobre como especificar dependências.
No final há uma lista de
[melhores práticas para dependências de pacotes](#best-practices).

## Visão geral

Para cada dependência, você especifica o _nome_ do pacote do qual você depende
e a _faixa de versões_ desse pacote que você permite.
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
permitindo qualquer versão de `1.0.0` a `2.0.0` (mas não incluindo `2.0.0`).
Para aprender sobre essa sintaxe, confira
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

## Fontes de dependências

O pub pode usar as seguintes fontes para localizar pacotes:

* [SDK](#sdk)
* [Pacotes hospedados](#hosted-packages)
* [Pacotes Git](#git-packages)
* [Pacotes de caminho](#path-packages)

### Pacotes hospedados

Um pacote _hospedado_ é aquele que pode ser baixado do site pub.dev
(ou outro servidor HTTP que fala a mesma API). Aqui está um exemplo
de declaração de uma dependência em um pacote hospedado:

```yaml
dependencies:
  transmogrify: ^1.4.0
```

Este exemplo especifica que o seu pacote depende de um pacote hospedado chamado
`transmogrify` e funciona com qualquer versão de 1.4.0 a 2.0.0
(mas não o 2.0.0 em si).

Se você quiser usar seu [próprio repositório de pacotes][own package repository],
você pode usar `hosted` para especificar sua URL.
O seguinte código YAML cria uma dependência no pacote `transmogrify`
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
Se nenhuma restrição de versão for fornecida, `any` é assumido.

:::version-note
Se o seu pacote tem [restrições de SDK][SDK version] anteriores a 2.19,
você deve usar o formato de limite inferior e superior para versões do SDK.
O validador de restrição de SDK nessas versões não suporta
a sintaxe de circunflexo.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]
```

Se o seu pacote tem uma [versão do SDK][SDK version] anterior a 2.15,
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

[SDK version]: /resources/language/evolution#language-versioning

### Pacotes Git

Às vezes você está na vanguarda e precisa usar pacotes que
ainda não foram formalmente lançados. Talvez o seu próprio pacote ainda esteja em
desenvolvimento e esteja usando outros pacotes que estão sendo desenvolvidos ao
mesmo tempo. Para facilitar isso, você pode depender diretamente de um pacote
armazenado em um repositório [Git][].

[git]: https://git-scm.com/

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

O `git` aqui diz que este pacote é encontrado usando Git, e a URL após isso é
a URL Git que pode ser usada para clonar o pacote.

Mesmo se o repositório do pacote for privado,
você pode configurar seu `git` para acessar o repositório usando uma
[chave de acesso HTTPS][GitHub HTTPS] ou um [par de chaves SSH][GitHub SSH].
Então você pode depender do pacote usando a URL correspondente do repositório:

```yaml
dependencies:
  kittens:
    # SSH URL:
    git: git@github.com:munificent/kittens.git
```

O comando `dart pub` chama `git clone` como um subprocesso, então tudo que você precisa fornecer
é uma `<url>` que funciona quando `git clone <url>` é executado.

Se você quiser depender de um commit, branch ou tag específico,
adicione uma chave `ref` à descrição:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      ref: some-branch
```

O ref pode ser qualquer coisa que o Git permite para [identificar um commit.][commit]

[commit]: https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#naming-commits

Se o pacote do qual você depende marcou a
revisão de cada versão do pacote,
você pode usar `tag_pattern` em vez de `ref`,
junto com uma restrição de versão.

O pub então consultará o Git por todas as tags correspondentes e
alimentará essas versões para o resolvedor de versões.

```yaml highlightLines=5
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      tag_pattern: v{{version}} # Find version-tag prefixed by 'v'.
    version: ^2.0.1
```

:::version-note
O suporte para `tag_pattern` foi introduzido no Dart 3.9.

Para usar `tag_pattern`, o pubspec incluído (mas não a dependência)
deve ter uma restrição de versão do SDK de `^3.9.0` ou superior.
:::

O pub assume que o pacote está na raiz do repositório Git. Para especificar um
local diferente no repositório, especifique um `path` relativo à raiz do
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
para pacotes enviados para [pub.dev][pubsite].

### Pacotes de caminho

Às vezes você se encontra trabalhando em vários pacotes relacionados ao mesmo
tempo. Talvez você esteja criando um framework enquanto constrói um app que o usa.
Nesses casos, durante o desenvolvimento você realmente quer depender da versão _live_
desse pacote no seu sistema de arquivos local. Dessa forma, mudanças em um
pacote são instantaneamente captadas pelo que depende dele.

Para lidar com isso, o pub suporta _dependências de caminho_.

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

Isso diz que o diretório raiz para `transmogrify` é `/Users/me/transmogrify`.
Para esta dependência, o pub gera um symlink diretamente para o diretório `lib`
do diretório do pacote referenciado. Quaisquer mudanças que você fizer no pacote
dependente são vistas imediatamente. Você não precisa executar o pub toda vez que
mudar o pacote dependente.

Caminhos relativos são permitidos e são considerados relativos ao diretório
contendo o seu pubspec.

Dependências de caminho são úteis para desenvolvimento local, mas não funcionam ao
compartilhar código com o mundo exterior—nem todos podem acessar
o seu sistema de arquivos. Por isso, você não pode enviar um pacote para o
[site pub.dev][pubsite] se ele tiver alguma dependência de caminho no seu pubspec.

Em vez disso, o fluxo de trabalho típico é:

1. Edite o seu pubspec localmente para usar uma dependência de caminho.
2. Trabalhe no pacote principal e no pacote do qual ele depende.
3. Uma vez que ambos estejam funcionando, publique o pacote dependente.
4. Mude o seu pubspec para apontar para a versão agora hospedada de seu dependente.
5. Publique o seu pacote principal também, se quiser.

### SDK

A fonte SDK é usada para quaisquer SDKs que são fornecidos junto com pacotes,
que podem ser dependências.
Atualmente, o Flutter é o único SDK que é suportado.

A sintaxe se parece com isso:

```yaml
dependencies:
  flutter_driver:
    sdk: flutter
```

O identificador após `sdk:` indica de qual SDK o pacote vem.
Se for `flutter`, a dependência é satisfatória desde que:

* O pub esteja sendo executado no contexto do executável `flutter`
* O Flutter SDK contenha um pacote com o nome fornecido

Se for um identificador desconhecido, a dependência é sempre considerada não satisfeita.

## Restrições de versão

Digamos que o seu Pacote A depende do Pacote B.
Como você pode comunicar a outros desenvolvedores qual versão do Pacote B
permanece compatível com uma determinada versão do Pacote A?

Para informar aos desenvolvedores a compatibilidade de versão, especifique restrições de versão.
Você quer permitir a maior faixa de versões possível
para dar aos usuários do seu pacote flexibilidade.
A faixa deve excluir versões que não funcionam ou não foram testadas.

A comunidade Dart usa versionamento semântico<sup id="fnref:semver"><a
href="#fn:semver">1</a></sup>.

Você pode expressar restrições de versão usando _sintaxe tradicional_
ou _sintaxe de circunflexo_ a partir do Dart 2.19.
Ambas as sintaxes especificam uma faixa de versões compatíveis.

A sintaxe tradicional fornece uma faixa explícita como `'>=1.2.3 <2.0.0'`.
A sintaxe de circunflexo fornece uma versão inicial explícita `^1.2.3`

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

Para saber mais sobre o sistema de versionamento do pub, veja a [página de versionamento de pacotes][package versioning page].

[package versioning page]: /tools/pub/versioning#semantic-versions

### Sintaxe tradicional

Uma restrição de versão que usa a sintaxe tradicional pode usar qualquer
um dos seguintes valores:

| **Valor** |                **Permite**               | **Usar?** |                                                                        **Notas**                                                                        |
|:---------:|:----------------------------------------|:--------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
|   `any`   | Todas as versões                        |    Não    | Serve como uma declaração explícita de restrição de versão vazia.                                                                                           |
|  `1.2.3`  | Apenas a versão fornecida              |    Não    | Limita a adoção do seu pacote devido aos limites adicionais que impõe em apps que usam seu pacote.                                                      |
| `>=1.2.3` | Versão fornecida ou posterior          |    Sim   |                                                                                                                                                         |
|  `>1.2.3` | Versões posteriores à versão fornecida |    Não    |                                                                                                                                                         |
| `<=1.2.3` | Versão fornecida ou anterior           |    Não    |                                                                                                                                                         |
|  `<1.2.3` | Versões anteriores à versão fornecida  |    Não    | Use isso quando você sabe que uma versão de limite superior _não_ funciona com seu pacote. Esta versão pode ser a primeira a introduzir alguma mudança incompatível. |

{:.table}

Você pode especificar qualquer combinação de valores de versão conforme suas faixas se cruzam.
Por exemplo, se você definir o valor da versão como `'>=1.2.3 <2.0.0'`,
isso combina ambas as limitações para que a dependência possa ser qualquer versão
de `1.2.3` a `2.0.0` excluindo `2.0.0` em si.

:::warning
Se você incluir o caractere maior que (**>**) na restrição de versão,
**coloque aspas em toda a string de restrição**.
Isso evita que o YAML interprete o caractere como sintaxe YAML.
Por exemplo: nunca use `>=1.2.3 <2.0.0`. Use `'>=1.2.3 <2.0.0'` ou `^1.2.3`.
:::

### Sintaxe de circunflexo

A sintaxe de circunflexo expressa a restrição de versão de forma compacta.
`^version` significa _a faixa de todas as versões garantidas de serem retrocompatíveis
com a versão fornecida_.
Esta faixa incluiria todas as versões até a próxima a introduzir uma
mudança incompatível. Como Dart usa versionamento semântico, esta seria a próxima
versão principal para qualquer versão de pacote 1.0 ou posterior
ou a próxima versão menor para qualquer versão de pacote anterior a 1.0.

| Valor da versão | Faixa cobre até | Sintaxe de Circunflexo | Sintaxe Tradicional  |
|:-------------:|:---------------:|:------------:|:-------------------:|
| >=1.0         | Próxima principal      | `^1.3.0`     | `'>=1.3.0 <2.0.0'`  |
| <1.0          | Próxima menor      | `^0.1.2`     | `'>=0.1.2 <0.2.0'`  |

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

## Dependências de desenvolvimento

O pub suporta dois tipos de dependências: dependências regulares e _dependências
de desenvolvimento._ Dependências de desenvolvimento diferem de dependências regulares no fato de que _dependências
de desenvolvimento de pacotes dos quais você depende são ignoradas_. Aqui está um exemplo:

Digamos que o pacote `transmogrify` usa o pacote `test` em seus testes e apenas
em seus testes. Se alguém só quer usar `transmogrify`—importar suas
bibliotecas—ele na verdade não precisa de `test`. Neste caso, ele especifica
`test` como uma dependência de desenvolvimento. Seu pubspec terá algo como:

```yaml
dev_dependencies:
  test: ^1.25.0
```

O pub obtém todos os pacotes dos quais seu pacote depende, e tudo de que _esses_
pacotes dependem, transitivamente. Ele também obtém as dependências de desenvolvimento do seu pacote,
mas _ignora_ as dependências de desenvolvimento de quaisquer pacotes dependentes. O pub apenas obtém
as dependências de desenvolvimento do _seu_ pacote. Então, quando seu pacote depende de
`transmogrify`, ele obterá `transmogrify` mas não `test`.

A regra para decidir entre uma dependência regular ou de desenvolvimento é simples: Se
a dependência é importada de algo nos seus diretórios `lib` ou `bin`,
ela precisa ser uma dependência regular. Se ela é apenas importada de `test`,
`example`, etc., ela pode e deve ser uma dependência de desenvolvimento.

Usar dependências de desenvolvimento torna os grafos de dependências menores. Isso faz o `pub` executar
mais rápido, e torna mais fácil encontrar um conjunto de versões de pacotes que satisfaz todas
as restrições.

## Sobrescrição de dependências

Você pode usar `dependency_overrides` para sobrescrever temporariamente todas as referências
a uma dependência.

Por exemplo, talvez você esteja atualizando uma cópia local de transmogrify, um
pacote publicado. Transmogrify é usado por outros pacotes no seu
grafo de dependências, mas você não quer clonar cada pacote localmente
e alterar cada pubspec para testar sua cópia local de transmogrify.

Nesta situação, você pode sobrescrever a dependência usando
`dependency_overrides` para especificar o diretório que contém a cópia local
do pacote.

O pubspec ficaria algo parecido com o seguinte:

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
novo caminho para sua dependência e, onde quer que transmogrify seja usado, o pub
usa a versão local em vez disso.

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
Usar uma sobrescrição de dependência envolve algum risco. Por exemplo,
usar uma sobrescrição para especificar uma versão fora da faixa que o
pacote afirma suportar, ou usar uma sobrescrição para especificar
uma cópia local de um pacote que tem comportamentos inesperados,
pode quebrar sua aplicação.
:::

Apenas as sobrescrições de dependência no **pubspec do próprio pacote**
são consideradas durante a resolução de pacotes.
Sobrescrições de dependência dentro de quaisquer pacotes dependentes são ignoradas.

Como resultado, se você publicar um pacote para pub.dev,
lembre-se de que as sobrescrições de dependência do seu pacote
são ignoradas por todos os usuários do seu pacote.

Se você estiver usando um [workspace do pub][workspaces],
você pode ter `dependency_overrides` em cada pacote do workspace, mas
um único pacote pode ser sobrescrito apenas uma vez no workspace.

## `pubspec_overrides.yaml` {:#pubspec-overrides}

Se você quiser mudar certos aspectos da
resolução do seu arquivo `pubspec.yaml`, mas
não quiser alterar o arquivo em si, você pode
colocar um arquivo chamado `pubspec_overrides.yaml` ao lado do `pubspec.yaml`.

Atributos desse arquivo sobrescreverão aqueles de `pubspec.yaml`.

As propriedades que podem ser sobrescritas são:

* `dependency_overrides`
* `workspace`
* `resolution`

Isso pode ser útil para evitar acidentalmente
fazer check-in de sobrescrições temporárias no controle de versão.
Também pode facilitar a geração de sobrescrições a partir de um script.

Em um [workspace do pub][workspaces], cada pacote do workspace
pode ter um arquivo `pubspec_overrides.yaml`.

## Melhores práticas

Seja proativo no gerenciamento de suas dependências.
Certifique-se de que seus pacotes dependam das versões mais recentes de pacotes
quando possível.
Se o seu pacote depende de um pacote desatualizado,
esse pacote desatualizado pode depender de outros pacotes desatualizados em sua árvore de dependências.
Versões desatualizadas de pacotes podem ter um impacto negativo na
estabilidade, desempenho e qualidade do seu app.

Recomendamos as seguintes melhores práticas para dependências de pacotes.

### Use a sintaxe de circunflexo

Especifique dependências usando a [sintaxe de circunflexo](#caret-syntax).
Isso permite que a ferramenta pub selecione versões mais recentes do pacote
quando ficarem disponíveis.
Além disso, coloca um limite superior na versão permitida.

### Dependa das versões de pacotes estáveis mais recentes

Use [`dart pub upgrade`][] para atualizar para as versões de pacotes mais recentes
que seu pubspec permite.
Para identificar dependências no seu app ou pacote que
não estão nas versões estáveis mais recentes,
use [`dart pub outdated`][].

### Restrinja as restrições de versão para dependências de desenvolvimento

Uma dependência de desenvolvimento define um pacote que você precisa apenas ao desenvolver.
Um app finalizado não precisará desses pacotes.
Exemplos desses pacotes incluem testes ou ferramentas de geração de código.
Defina as restrições de versão de pacotes em [`dev_dependencies`][dev-dep]
para ter um limite inferior da versão mais recente da qual seu pacote depende.

Restringir as restrições de versão de suas dependências de desenvolvimento pode
se parecer com o seguinte:

```yaml
dev_dependencies:
  build_runner: ^2.8.0
  lints: ^6.0.0
  test: ^1.25.15
```

Este YAML define as `dev_dependencies` para as versões de patch mais recentes.

[dev-dep]: /tools/pub/dependencies#dev-dependencies

### Teste sempre que atualizar dependências de pacotes

Se você executar [`dart pub upgrade`][] sem atualizar seu pubspec,
a API deve permanecer a mesma
e seu código deve executar como antes—mas teste para ter certeza.
Se você modificar o pubspec e atualizar para uma nova versão principal,
então você pode encontrar mudanças incompatíveis,
então você precisa testar ainda mais completamente.

### Teste com dependências rebaixadas

Ao desenvolver pacotes para publicação, geralmente é preferível
permitir as restrições de dependência mais amplas possíveis.
Uma restrição de dependência ampla reduz a probabilidade de que
os consumidores do pacote enfrentem um conflito de resolução de versão.

Por exemplo, se você tem uma dependência em `foo: ^1.2.3` e
a versão `1.3.0` de `foo` é lançada, pode ser razoável
manter a restrição de dependência existente (`^1.2.3`).
Mas se o seu pacote começar a usar recursos que foram adicionados em `1.3.0`, então
você precisará aumentar sua restrição para `^1.3.0`.

No entanto, é fácil esquecer de aumentar uma
restrição de dependência quando se torna necessário.
Portanto, é uma melhor prática testar seu pacote
contra dependências rebaixadas antes de publicar.

Para testar contra dependências rebaixadas, execute [`dart pub downgrade`][] e
verifique se seu pacote ainda analisa sem erros e passa em todos os testes:

```console
dart pub downgrade
dart analyze
dart test
```

Testar com dependências rebaixadas deve
acontecer junto com testes normais com dependências mais recentes.
Se as restrições de dependência precisarem ser aumentadas, altere-as você mesmo ou
use `dart pub upgrade --tighten` para atualizar dependências para as versões mais recentes.

:::note
Testar com `dart pub downgrade` permite que você encontre incompatibilidades que
você poderia não ter descoberto de outra forma.
Mas não exclui a possibilidade de incompatibilidades.

Muitas vezes há tantas combinações diferentes de versões que
testá-las todas é inviável.
Também pode haver versões mais antigas permitidas pelas suas restrições de dependência que
não podem ser resolvidas devido a restrições de versão mutuamente incompatíveis de
pacotes em si ou de suas `dev_dependencies`.
:::

[`dart pub downgrade`]: /tools/pub/cmd/pub-downgrade

### Verifique a integridade dos pacotes baixados

Ao recuperar novas dependências,
use a opção [`--enforce-lockfile`][enforce-lock] para garantir
que o conteúdo do pacote extraído corresponda ao conteúdo do arquivo original.
Sem modificar o [lockfile][],
esta flag apenas resolve novas dependências se:

* `pubspec.yaml` estiver satisfeito
* `pubspec.lock` não estiver ausente
* Os [hashes de conteúdo][content hashes] dos pacotes coincidirem

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
