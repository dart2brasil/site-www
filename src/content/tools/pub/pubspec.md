---
title: The pubspec file
shortTitle: Pubspec file
description: Reference guide for the fields in pubspec.yaml.
ia-translate: true
---

<!--
ia-translate: true
-->

Todo [pub package](/tools/pub/packages) precisa de alguns metadados para poder especificar suas
[dependencies](/resources/glossary#dependency). Pacotes Pub que são compartilhados com
outros também precisam fornecer algumas outras informações para que os usuários possam descobri-los.
Todos esses metadados vão no _pubspec_ do pacote:
um arquivo chamado `pubspec.yaml` que é escrito na
linguagem [YAML](https://yaml.org/).

{% comment %}
PENDING: acknowledge the existence of pubspec.lock files.
{% endcomment %}


## Campos suportados

Um pubspec pode ter os seguintes campos:

`name`
: Obrigatório para todo pacote.
  [_Saiba mais._](#name)

`version`
: Obrigatório para pacotes que são hospedados no site pub.dev.
  [_Saiba mais._](#version)

`description`
: Obrigatório para pacotes que são hospedados no site pub.dev.
  [_Saiba mais._](#description)

`homepage`
: Opcional. URL apontando para a homepage do pacote (ou repositório de código-fonte).
  [_Saiba mais._](#homepage)

`repository`
: Opcional. URL apontando para o repositório de código-fonte do pacote.
  [_Saiba mais._](#repository)

`issue_tracker`
: Opcional. URL apontando para um rastreador de issues do pacote.
  [_Saiba mais._](#issue-tracker)

`documentation`
: Opcional. URL apontando para a documentação do pacote.
  [_Saiba mais._](#documentation)

`dependencies`
: Pode ser omitido se seu pacote não tem dependências.
  [_Saiba mais._](#dependencies)

`dev_dependencies`
: Pode ser omitido se seu pacote não tem dev dependencies.
  [_Saiba mais._](#dependencies)

`dependency_overrides`
: Pode ser omitido se você não precisa sobrescrever nenhuma dependência.
  [_Saiba mais._](#dependencies)

`environment`
: Obrigatório desde o Dart 2.
  [_Saiba mais._](#sdk-constraints)

`executables`
: Opcional. Usado para colocar os executáveis de um pacote no seu PATH.
  [_Saiba mais._](#executables)

`platforms`
: Opcional. Usado para declarar explicitamente plataformas suportadas
  no site pub.dev.
  [_Saiba mais._](#platforms)

`publish_to`
: Opcional. Especifica onde publicar um pacote.
  [_Saiba mais._](#publish_to)

`funding`
: Opcional. Lista de URLs onde os usuários podem patrocinar o desenvolvimento do pacote.
  [_Saiba mais._](#funding)

`false_secrets`
: Opcional. Especifica arquivos a serem ignorados ao conduzir uma busca pré-publicação
  por possíveis vazamentos de secrets.
  [_Saiba mais._](#false_secrets)

`screenshots`
: Opcional. Especifica uma lista de arquivos de screenshot para exibir
  no [site pub.dev]({{site.pub}}).
  [_Saiba mais._](#screenshots)

`topics`
: Opcional. Lista de tópicos para o pacote.
  [_Saiba mais._](#topics)

`ignored_advisories`
: Opcional. Lista de security advisories ignorados.
  [_Saiba mais._](#ignored_advisories)

Pub ignora todos os outros campos.

:::flutter-note
Pubspecs para [Flutter apps]({{site.flutter}}) podem ter
[campos adicionais]({{site.flutter-docs}}/development/tools/pubspec)
para configurar o ambiente e gerenciar assets.
:::

Se você adicionar um campo personalizado, dê a ele um nome único
que não entre em conflito com futuros campos pubspec.
Por exemplo, em vez de adicionar `bugs`,
você pode adicionar um campo chamado `my_pkg_bugs`.


## Exemplo

Um pubspec simples mas completo se parece com o seguinte:

```yaml
name: newtify
description: >-
  Have you been turned into a newt?  Would you like to be?
  This package can help. It has all of the
  newt-transmogrification functionality you have been looking
  for.
version: 1.2.3
homepage: https://example-pet-store.com/newtify
documentation: https://example-pet-store.com/newtify/docs

environment:
  sdk: '^3.2.0'
  
dependencies:
  efts: ^2.0.4
  transmogrify: ^0.4.0
  
dev_dependencies:
  test: '>=1.15.0 <2.0.0'
```


## Detalhes

Esta seção tem mais informações sobre cada um dos campos do pubspec.

### Name

Todo pacote precisa de um nome. É como outros pacotes se referem ao seu,
e como ele aparece para o mundo, caso você o publique.

O nome deve ser todo em minúsculas, com underscores para separar palavras,
`assim_como_isso`. Use apenas letras latinas básicas e dígitos arábicos:
`[a-z0-9_]`. Além disso, certifique-se de que o nome seja um identificador Dart válido—que
não comece com dígitos e não seja uma
[palavra reservada](/language/keywords).

Tente escolher um nome que seja claro, conciso e que ainda não esteja em uso.
É recomendável fazer uma busca rápida de pacotes no
[site pub.dev]({{site.pub-pkg}})
para garantir que nada mais esteja usando seu nome.

### Version

Todo pacote tem uma versão. Um número de versão é obrigatório para hospedar seu pacote
no site pub.dev, mas pode ser omitido para pacotes apenas locais. Se você omitir,
seu pacote é implicitamente versionado como `0.0.0`.

Versionamento é necessário para reutilizar código enquanto permite que ele evolua rapidamente. Um
número de versão são três números separados por pontos, como `0.2.43`. Também pode
opcionalmente ter um sufixo de build (`+1`, `+2`, `+hotfix.oopsie`) ou prerelease
(`-dev.4`, `-alpha.12`, `-beta.7`, `-rc.5`).

Cada vez que você publica seu pacote, você o publica em uma versão específica.
Uma vez feito isso, considere-o hermeticamente selado: você não pode mais tocá-lo.
Para fazer mais alterações, você precisará de uma nova versão.

Ao selecionar uma versão, siga o [versionamento semântico.][semantic versioning]

[semantic versioning]: https://semver.org/spec/v2.0.0-rc.1.html

### Description

Isto é opcional para seus próprios pacotes pessoais, mas se você pretende
publicar seu pacote, deve fornecer uma descrição, que deve estar em inglês.
A descrição deve ser relativamente curta—60 a 180 caracteres—e
informar a um leitor casual o que ele pode querer saber sobre seu pacote.

Pense na descrição como o argumento de venda para seu pacote. Os usuários a veem
quando eles [navegam por pacotes.]({{site.pub-pkg}})
A descrição é texto simples: sem markdown ou HTML.

### Homepage

Esta deve ser uma URL apontando para o site do seu pacote.
Para [hosted packages](/tools/pub/dependencies#hosted-packages),
esta URL é linkada a partir da página do pacote.
Embora fornecer uma `homepage` seja opcional, *por favor forneça* ela ou `repository`
(ou ambos). Isso ajuda os usuários a entender de onde seu pacote vem.

### Repository

O campo opcional `repository` deve conter a URL do repositório de código-fonte
do seu pacote—por exemplo, `https://github.com/<user>/<repository>`.
Se você publicar seu pacote no site pub.dev, então a página do seu pacote
exibirá a URL do repositório.
Embora fornecer um `repository` seja opcional, *por favor forneça* ele ou `homepage`
(ou ambos). Isso ajuda os usuários a entender de onde seu pacote vem.

### Issue tracker

O campo opcional `issue_tracker` deve conter uma URL para o rastreador de
issues do pacote, onde bugs existentes podem ser visualizados e novos bugs podem ser reportados.
O site pub.dev tenta exibir um link para o rastreador de issues de cada pacote,
usando o valor deste campo. Se `issue_tracker` estiver faltando mas
`repository` estiver presente e apontar para o GitHub, então o site pub.dev usa o
rastreador de issues padrão (`https://github.com/<user>/<repository>/issues`).

### Documentation

Alguns pacotes têm um site que hospeda documentação, separada da
homepage principal e da referência de API gerada pelo Pub.
Se seu pacote tiver documentação adicional, adicione um campo `documentation:`
com essa URL; pub mostra um link para esta documentação na página do seu pacote.

### Dependencies

[Dependencies](/resources/glossary#dependency) são a *raison d'être* do pubspec.
Nesta seção você lista cada pacote que seu pacote precisa para funcionar.

Dependencies se enquadram em um de dois tipos. _Regular dependencies_ são listadas
sob `dependencies:`—estes são pacotes que qualquer pessoa usando seu pacote
também precisará. Dependencies que são necessárias apenas na fase de desenvolvimento do
próprio pacote são listadas sob `dev_dependencies`.

Durante o processo de desenvolvimento, você pode precisar sobrescrever temporariamente
uma dependência. Você pode fazer isso usando `dependency_overrides`.

Para mais informações, consulte [Package dependencies](/tools/pub/dependencies).

### Executables

Um pacote pode expor um ou mais de seus scripts como executáveis que
podem ser executados diretamente da linha de comando. Para tornar um script publicamente
disponível, liste-o sob o campo `executables`.
Entradas são listadas como pares de chave/valor:

```plaintext
<nome-do-executável>: <script-Dart-do-bin>
```

Por exemplo, a seguinte entrada pubspec lista dois scripts:

```yaml
executables:
  slidy: main
  fvm:
```

Uma vez que o pacote é ativado usando `dart pub global activate`,
digitar `slidy` executa `bin/main.dart`.
Digitar `fvm` executa `bin/fvm.dart`.
Se você não especificar o valor, ele é inferido da chave.

Para mais informações, consulte
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).


### Platforms

Quando você [publica um pacote][publish a package], pub.dev automaticamente
detecta as plataformas que o pacote suporta.
Se esta lista de suporte de plataforma estiver incorreta,
use `platforms` para declarar explicitamente
quais plataformas seu pacote suporta.

Por exemplo, a seguinte entrada `platforms` faz com que pub.dev
liste o pacote como suportando
Android, iOS, Linux, macOS, Web e Windows:

```yaml
# Este pacote suporta todas as plataformas listadas abaixo.
platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

Aqui está um exemplo de declarar que o pacote suporta
apenas Linux e macOS (e não, por exemplo, Windows):

```yaml
# Este pacote suporta apenas Linux e macOS.
platforms:
  linux:
  macos:
```

:::note Se você usa Flutter
O suporte de plataforma de plugins Flutter é por padrão derivado das
[plugin declarations][].

Se houver uma discrepância entre a declaração do plugin e o suporte de plataforma real,
uma declaração `platforms` de nível superior ainda pode ser usada e tem
precedência sobre a declaração do plugin Flutter ao decidir o suporte de plataforma.
:::

:::version-note
O suporte para a entrada `platforms` foi adicionado no Dart 2.16.
:::

[publish a package]: /tools/pub/publishing
[plugin declarations]: {{site.flutter-docs}}/development/packages-and-plugins/developing-packages#plugin-platforms


### Publish_to

O padrão usa o [site pub.dev.]({{site.pub}}) Especifique `none` para evitar
que um pacote seja publicado. Esta configuração pode ser usada para especificar um
[servidor de pacotes pub personalizado](/tools/pub/custom-package-repositories)
para publicar.

```yaml
publish_to: none
```


### Funding

Autores de pacotes podem usar a propriedade `funding` para especificar uma lista de URLs que
fornecem informações sobre como os usuários podem ajudar a financiar o desenvolvimento do pacote.
Por exemplo:

```yaml
funding:
 - https://www.buymeacoffee.com/example_user
 - https://www.patreon.com/some-account
```

Se publicado no [pub.dev]({{site.pub}}), os links são exibidos na
página do pacote. Isso visa ajudar os usuários a financiar o desenvolvimento
de suas dependências.


### False_secrets

Quando você tenta [publicar um pacote][publish a package],
pub conduz uma busca por possíveis vazamentos de
credenciais secretas, chaves de API ou chaves criptográficas.
Se pub detecta um possível vazamento em um arquivo que seria publicado,
então pub avisa você e se recusa a publicar o pacote.

A detecção de vazamento não é perfeita.
Para evitar falsos positivos,
você pode dizer ao pub para não procurar vazamentos em certos arquivos,
criando uma allowlist
usando [padrões `gitignore`][`gitignore` patterns] sob
`false_secrets` no pubspec.

[`gitignore` patterns]: https://git-scm.com/docs/gitignore#_pattern_format

Por exemplo, a seguinte entrada faz com que pub não procure vazamentos no
arquivo `lib/src/hardcoded_api_key.dart`
e em todos os arquivos `.pem` no diretório `test/localhost_certificates/`:

[publish a package]: /tools/pub/publishing

```yaml
false_secrets:
 - /lib/src/hardcoded_api_key.dart
 - /test/localhost_certificates/*.pem
```

Iniciar um padrão `gitignore` com barra (`/`) garante que
o padrão seja considerado relativo ao diretório raiz do pacote.

:::warning
**Não confie na detecção de vazamento.**
Ela usa um conjunto limitado de padrões
para detectar erros comuns.
Você é responsável por gerenciar suas credenciais,
prevenir vazamentos acidentais e
revogar credenciais que são acidentalmente vazadas.
:::

:::version-note
Dart 2.15 adicionou suporte para o campo `false_secrets`.
:::

### Screenshots

Pacotes podem mostrar seus widgets ou outros elementos visuais
usando screenshots exibidos em sua página pub.dev.
Para especificar screenshots para o pacote exibir,
use o campo `screenshots`.

Um pacote pode listar até 10 screenshots sob o campo `screenshots`.
Não inclua logos ou outras imagens de marca nesta seção.
Cada screenshot inclui uma `description` e um `path`.
A `description` explica o que o screenshot mostra em
não mais que 160 caracteres.
Por exemplo:

```yaml
screenshots:
  - description: 'Este screenshot mostra a transformação de um número de bytes
  para uma expressão legível por humanos.'
    path: path/to/image/in/package/500x500.webp
  - description: 'Este screenshot mostra um stack trace retornando uma representação
  legível por humanos.'
    path: path/to/image/in/package.png
```

Pub.dev limita screenshots às seguintes especificações:

- Tamanho do arquivo: máximo de 4 MB por imagem.
- Tipos de arquivo: `png`, `jpg`, `gif` ou `webp`.
- Imagens estáticas e animadas são ambas permitidas.

Mantenha os arquivos de screenshot pequenos.
Cada download do pacote inclui todos os arquivos de screenshot.

Pub.dev gera a imagem em miniatura do pacote a partir do primeiro screenshot. Se
este screenshot usa animação, pub.dev usa seu primeiro frame.

### Topics

Autores de pacotes podem usar o campo `topics` para categorizar seu pacote. Topics
podem ser usados para auxiliar a descoberta durante a pesquisa com filtros no pub.dev.
Pub.dev exibe os topics na página do pacote, bem como nos resultados de
pesquisa.

O campo consiste em uma lista de nomes. Por exemplo:

```yaml
topics:
  - network
  - http
```

Pub.dev requer que os topics sigam estas especificações:

- Marque cada pacote com no máximo 5 topics.
- Escreva o nome do topic seguindo estes requisitos:
  - Use entre 2 e 32 caracteres.
  - Use apenas caracteres alfanuméricos minúsculos ou hífens (`a-z`, `0-9`, `-`).
  - Não use dois hífens consecutivos (`--`).
  - Comece o nome com caracteres alfabéticos minúsculos (`a-z`).
  - Termine com caracteres alfanuméricos (`a-z` ou `0-9`).

Ao escolher topics, considere se [topics existentes]({{site.pub}}/topics)
são relevantes. Marcar com topics existentes ajuda os usuários a descobrir seu pacote.

:::note
Pub.dev mescla diferentes ortografias de um topic em um topic canônico para
evitar duplicação e melhorar a descoberta por topic.

Você pode contribuir para a lista de topics canônicos e seus aliases
abrindo um pull request que edita o [arquivo `topics.yaml`][`topics.yaml` file] no GitHub.
:::

[`topics.yaml` file]: {{site.repo.dart.org}}/pub-dev/blob/master/doc/topics.yaml

### Ignored_advisories

Se um pacote tem uma dependência que é afetada por um security advisory,
pub avisa sobre o advisory durante a resolução de dependências.
Autores de pacotes podem usar o campo `ignored_advisories` como uma allowlist
de advisories disparados que não são relevantes para o pacote.

Para suprimir o aviso sobre um advisory,
adicione o identificador do advisory à lista `ignored_advisories`.
Por exemplo:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

Para mais informações, confira
[Security advisories](/tools/pub/security-advisories).

### SDK constraints

Um pacote pode indicar quais versões de suas dependências ele suporta, mas
pacotes têm outra dependência implícita: a própria plataforma Dart.
A plataforma Dart evolui ao longo do tempo, e um pacote pode funcionar apenas com certas
versões da plataforma.

Um pacote pode especificar essas versões usando uma *SDK constraint*. Esta
constraint vai dentro de um campo `environment` separado de nível superior no pubspec
e usa a mesma sintaxe de
[version constraint](/tools/pub/dependencies#version-constraints) que as
dependencies.

:::version-note
Para que um pacote use um recurso introduzido após 2.0,
seu pubspec deve ter uma constraint inferior que seja pelo menos
a versão quando o recurso foi introduzido.
Para detalhes, confira [Language versioning][].
:::

[Language versioning]: /resources/language/evolution#language-versioning

Por exemplo, a seguinte constraint diz que este pacote
funciona com qualquer Dart SDK que seja versão 3.0.0 ou superior:

```yaml
environment:
  sdk: ^3.0.0
```

Pub tenta encontrar a versão mais recente de um pacote cuja SDK constraint funcione
com a versão do Dart SDK que você tem instalado.

Omitir a SDK constraint é um erro.
Quando o pubspec não tem SDK constraint,
`dart pub get` falha com uma mensagem como a seguinte:

```plaintext
pubspec.yaml has no lower-bound SDK constraint.
You should edit pubspec.yaml to contain an SDK constraint:

environment:
  sdk: '^3.2.0'

See https://dart.dev/go/sdk-constraint
```

:::version-note
Antes do Dart 2.19, pub não permitia sintaxe caret em SDK constraints.
Em versões anteriores, forneça um intervalo completo,
como `'>=2.12.0 <3.0.0'`.
Para mais informações, confira
a documentação de [sintaxe Caret](/tools/pub/dependencies#caret-syntax).
:::


#### Flutter SDK constraints

Pub suporta especificação de Flutter SDK constraints
sob o campo `environment:`:

```yaml
environment:
  sdk: ^3.2.0
  flutter: '>=3.22.0'
```

Uma Flutter SDK constraint é satisfeita apenas se pub está sendo executado no
contexto do executável `flutter`, e o arquivo `version` do Flutter SDK
atende ao limite inferior da constraint de versão. Caso contrário,
o pacote não será selecionado.

:::note
O Flutter SDK apenas impõe o limite inferior da constraint flutter.
Para saber mais, confira
[issue #95472](https://github.com/flutter/flutter/issues/95472)
no repositório `flutter/flutter`.
:::

Para publicar um pacote com uma Flutter SDK constraint,
você deve especificar uma Dart SDK constraint com uma versão mínima de
pelo menos 1.19.0, para garantir que versões mais antigas do pub não
instalem acidentalmente pacotes que precisam do Flutter.

[pubsite]: {{site.pub}}
