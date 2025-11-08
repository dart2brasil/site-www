---
ia-translate: true
title: O arquivo pubspec
shortTitle: Arquivo Pubspec
description: "Guia de referência para os campos em pubspec.yaml."
---

Todo [pacote pub](/tools/pub/packages) precisa de alguns metadados para que possa especificar suas
[dependências](/resources/glossary#dependency). Pacotes Pub que são compartilhados com
outros também precisam fornecer algumas outras informações para que os usuários possam descobri-los.
Todos esses metadados vão no _pubspec_ do pacote:
um arquivo chamado `pubspec.yaml` que é escrito na
linguagem [YAML](https://yaml.org/).

{% comment %}
PENDENTE: reconhecer a existência de arquivos pubspec.lock.
{% endcomment %}


## Campos suportados {:#supported-fields}

Um pubspec pode ter os seguintes campos:

`name` (nome)
: Obrigatório para todo pacote.
  [_Saiba mais._](#name)

`version` (versão)
: Obrigatório para pacotes hospedados no site pub.dev.
  [_Saiba mais._](#version)

`description` (descrição)
: Obrigatório para pacotes hospedados no site pub.dev.
  [_Saiba mais._](#description)

`homepage` (página inicial)
: Opcional. URL apontando para a página inicial do pacote (ou repositório de código-fonte).
  [_Saiba mais._](#homepage)

`repository` (repositório)
: Opcional. URL apontando para o repositório de código-fonte do pacote.
  [_Saiba mais._](#repository)

`issue_tracker` (rastreador de problemas)
: Opcional. URL apontando para um rastreador de problemas para o pacote.
  [_Saiba mais._](#issue-tracker)

`documentation` (documentação)
: Opcional. URL apontando para a documentação do pacote.
  [_Saiba mais._](#documentation)

`dependencies` (dependências)
: Pode ser omitido se o seu pacote não tiver dependências.
  [_Saiba mais._](#dependencies)

`dev_dependencies` (dependências de desenvolvimento)
: Pode ser omitido se o seu pacote não tiver dependências de desenvolvimento.
  [_Saiba mais._](#dependencies)

`dependency_overrides` (substituições de dependências)
: Pode ser omitido se você não precisar substituir nenhuma dependência.
  [_Saiba mais._](#dependencies)

`environment` (ambiente)
: Obrigatório a partir do Dart 2.
  [_Saiba mais._](#sdk-constraints)

`executables` (executáveis)
: Opcional. Usado para colocar os executáveis de um pacote no seu PATH.
  [_Saiba mais._](#executables)

`platforms` (plataformas)
: Opcional. Usado para declarar explicitamente as plataformas suportadas
  no site pub.dev.
  [_Saiba mais._](#platforms)

`publish_to` (publicar para)
: Opcional. Especifique onde publicar um pacote.
  [_Saiba mais._](#publish-to)

`funding` (financiamento)
: Opcional. Lista de URLs onde os usuários podem patrocinar o desenvolvimento do pacote.
  [_Saiba mais._](#funding)

`false_secrets` (falsos segredos)
: Opcional. Especifique os arquivos a serem ignorados ao realizar uma busca
  pré-publicação por possíveis vazamentos de segredos.
  [_Saiba mais._](#false_secrets)

`screenshots` (capturas de tela)
: Opcional. Especifique uma lista de arquivos de captura de tela para exibir
  no [site pub.dev]({{site.pub}}).
  [_Saiba mais._](#screenshots)

`topics` (tópicos)
: Opcional. Lista de tópicos para o pacote.
  [_Saiba mais._](#topics)

`ignored_advisories` (avisos ignorados)
: Opcional. Lista de avisos de segurança ignorados.
  [_Saiba mais._](#ignored_advisories)

Pub ignora todos os outros campos.

:::flutter-note
Pubspecs para [aplicativos Flutter]({{site.flutter}}) podem ter
[campos adicionais]({{site.flutter-docs}}/development/tools/pubspec)
para configurar o ambiente e gerenciar assets (recursos).
:::

Se você adicionar um campo personalizado, dê a ele um nome único que
não entre em conflito com futuros campos pubspec.
Por exemplo, em vez de adicionar `bugs`, você pode adicionar um campo
chamado `my_pkg_bugs`.


## Exemplo {:#example}

Um pubspec simples, mas completo, se parece com o seguinte:

```yaml
name: newtify
description: >-
  Você foi transformado em um tritão? Gostaria de ser?
  Este pacote pode ajudar. Ele tem toda a
  funcionalidade de transmogrificação de tritão que você
  tem procurado.
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


## Detalhes {:#details}

Esta seção tem mais informações sobre cada um dos campos pubspec.

### Name {:#name}

Todo pacote precisa de um nome. É assim que outros pacotes se referem ao seu,
e como ele aparece para o mundo, caso você o publique.

O nome deve ser todo em minúsculas, com underscores para separar palavras,
`assim_como_este`. Use apenas letras latinas básicas e dígitos arábicos:
`[a-z0-9_]`. Além disso, certifique-se de que o nome seja um identificador
Dart válido—que não comece com dígitos e não seja uma
[palavra reservada](/language/keywords).

Tente escolher um nome que seja claro, conciso e que não esteja em uso.
Uma pesquisa rápida de pacotes no
[site pub.dev]({{site.pub-pkg}})
para garantir que nada mais esteja usando seu nome é recomendada.

### Version {:#version}

Todo pacote tem uma versão. Um número de versão é necessário para hospedar
seu pacote no site pub.dev, mas pode ser omitido para pacotes apenas locais.
Se você omiti-lo, seu pacote será implicitamente versionado como `0.0.0`.

O versionamento é necessário para reutilizar o código, permitindo que ele
evolua rapidamente. Um número de versão são três números separados por pontos,
como `0.2.43`. Ele também pode opcionalmente ter um build (`+1`, `+2`,
`+hotfix.oopsie`) ou um sufixo de pré-lançamento (`-dev.4`, `-alpha.12`, `-beta.7`, `-rc.5`).

Cada vez que você publica seu pacote, você o publica em uma versão específica.
Depois que isso é feito, considere-o hermeticamente lacrado: você não pode
mais tocá-lo. Para fazer mais alterações, você precisará de uma nova versão.

Ao selecionar uma versão, siga o [versionamento semântico.][semantic versioning]

[semantic versioning]: https://semver.org/spec/v2.0.0-rc.1.html

### Description {:#description}

Isso é opcional para seus próprios pacotes pessoais, mas se você pretende
publicar seu pacote, deve fornecer uma descrição, que deve ser em inglês.
A descrição deve ser relativamente curta—de 60 a 180 caracteres—e dizer a um
leitor casual o que ele pode querer saber sobre seu pacote.

Pense na descrição como o argumento de venda do seu pacote. Os usuários o
veem quando [procuram pacotes.]({{site.pub-pkg}})
A descrição é texto simples: sem markdown ou HTML.

### Homepage {:#homepage}

Esta deve ser uma URL apontando para o site do seu pacote.
Para [pacotes hospedados](/tools/pub/dependencies#hosted-packages),
essa URL é vinculada na página do pacote.
Embora fornecer uma `homepage` seja opcional, *por favor, forneça* ela ou
`repository` (ou ambos). Isso ajuda os usuários a entenderem de onde seu pacote está vindo.

### Repository {:#repository}

O campo opcional `repository` deve conter a URL para o repositório de
código-fonte do seu pacote — por exemplo, `https://github.com/<user>/<repository>`.
Se você publicar seu pacote no site pub.dev, a página do seu pacote exibirá
a URL do repositório. Embora fornecer um `repository` seja opcional, *por favor,
forneça* ele ou `homepage` (ou ambos). Isso ajuda os usuários a entenderem
de onde seu pacote está vindo.

### Issue tracker {:#issue-tracker}

O campo opcional `issue_tracker` deve conter uma URL para o rastreador de
problemas do pacote, onde bugs existentes podem ser visualizados e novos
bugs podem ser relatados. O site pub.dev tenta exibir um link para o
rastreador de problemas de cada pacote, usando o valor deste campo. Se
`issue_tracker` estiver faltando, mas `repository` estiver presente e apontar
para o GitHub, o site pub.dev usa o rastreador de problemas padrão (`https://github.com/<user>/<repository>/issues`).

### Documentation {:#documentation}

Alguns pacotes têm um site que hospeda documentação, separado da página
inicial principal e da referência da API gerada pelo Pub. Se o seu pacote
tiver documentação adicional, adicione um campo `documentation:` com essa
URL; o pub mostra um link para esta documentação na página do seu pacote.

### Dependencies {:#dependencies}

[Dependencies](/resources/glossary#dependency) are the pubspec's *raison d'être*.
In this section you list each package that your package needs in order to work.

As dependências se enquadram em um de dois tipos. _Dependências regulares_ são
listadas em `dependencies:` — esses são pacotes que qualquer pessoa que usar seu
pacote também precisará. Dependências que são necessárias apenas na fase de
desenvolvimento do próprio pacote são listadas em `dev_dependencies`.

Durante o processo de desenvolvimento, você pode precisar substituir
temporariamente uma dependência. Você pode fazer isso usando `dependency_overrides`.

Para mais informações, consulte [Dependências de pacote](/tools/pub/dependencies).

### Executables {:#executables}

Um pacote pode expor um ou mais de seus scripts como executáveis que podem
ser executados diretamente da linha de comando. Para disponibilizar um
script publicamente, liste-o no campo `executables`. As entradas são
listadas como pares chave/valor:

```plaintext
<nome-do-executavel>: <script-Dart-de-bin>
```

Por exemplo, a seguinte entrada pubspec lista dois scripts:

```yaml
executables:
  slidy: main
  fvm:
```

Depois que o pacote é ativado usando `dart pub global activate`, digitar
`slidy` executa `bin/main.dart`.
Digitar `fvm` executa `bin/fvm.dart`.
Se você não especificar o valor, ele é inferido da chave.

Para mais informações, consulte
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).


### Platforms {:#platforms}

Quando você [publica um pacote][publish a package], o pub.dev detecta automaticamente as
plataformas que o pacote suporta. Se esta lista de suporte à plataforma estiver
incorreta,
use `platforms` para declarar explicitamente quais plataformas seu
pacote suporta.

Por exemplo, a seguinte entrada `platforms`
faz com que o pub.dev liste o
pacote como compatível com Android, iOS, Linux, macOS, Web e Windows:

```yaml
# Este pacote suporta todas as plataformas listadas abaixo. {:#this-package-supports-all-platforms-listed-below}
platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

Aqui está um exemplo de declaração de que o pacote suporta apenas Linux e
macOS (e não, por exemplo, Windows):

```yaml
# Este pacote suporta apenas Linux e macOS. {:#this-package-supports-only-linux-and-macos}
platforms:
  linux:
  macos:
```

:::note Se você usa Flutter
O suporte à plataforma de plugins Flutter é derivado por padrão das
[declarações de plugin][plugin declarations].

Se houver uma discrepância entre a declaração do plugin e o suporte real
da plataforma, uma declaração `platforms` de nível superior ainda pode ser
usada e tem precedência sobre a declaração do plugin Flutter ao decidir o suporte da plataforma.
:::

:::version-note
O suporte para a entrada `platforms` foi adicionado no Dart 2.16.
:::

[publish a package]: /tools/pub/publishing
[plugin declarations]: {{site.flutter-docs}}/development/packages-and-plugins/developing-packages#plugin-platforms


### Publish_to {:#publish-to}

O padrão usa o [site pub.dev.]({{site.pub}}) Especifique `none` para impedir
que um pacote seja publicado. Esta configuração pode ser usada para
especificar um [servidor de pacotes pub personalizado](/tools/pub/custom-package-repositories)
para publicar.

```yaml
publish_to: none
```


### Funding {:#funding}

Os autores de pacotes podem usar a propriedade `funding` para especificar
uma lista de URLs que fornecem informações sobre como os usuários podem ajudar
a financiar o desenvolvimento do pacote. Por exemplo:

```yaml
funding:
 - https://www.buymeacoffee.com/example_user
 - https://www.patreon.com/some-account
```

Se publicado em [pub.dev]({{site.pub}}), os links são exibidos na página do
pacote. Isso tem como objetivo ajudar os usuários a financiar o
desenvolvimento de suas dependências.


### False_secrets {:#false_secrets}

Quando você tenta [publicar um pacote][publish a package], o pub realiza uma pesquisa por
possíveis vazamentos de credenciais secretas,
chaves de API ou chaves
criptográficas. Se o pub detectar um possível vazamento em um arquivo que
seria publicado, o pub avisa você e se recusa a publicar o pacote.

A detecção de vazamentos não é perfeita.
Para evitar falsos positivos, você
pode dizer ao pub para não procurar
vazamentos em determinados arquivos,
criando uma lista de permissões usando [padrões `gitignore`][`gitignore` patterns] em
`false_secrets` no pubspec.

[`gitignore` patterns]: https://git-scm.com/docs/gitignore#_pattern_format

Por exemplo, a seguinte entrada faz com que o pub não procure por vazamentos
no arquivo `lib/src/hardcoded_api_key.dart` e em todos os arquivos `.pem` no
diretório `test/localhost_certificates/`:

[publish a package]: /tools/pub/publishing

```yaml
false_secrets:
 - /lib/src/hardcoded_api_key.dart
 - /test/localhost_certificates/*.pem
```

Começar um padrão `gitignore` com barra (`/`) garante que o padrão seja
considerado relativo ao diretório raiz do pacote.

:::warning
**Não confie na detecção de vazamentos.**
Ele usa um conjunto limitado de
padrões para detectar erros comuns.
Você é responsável por gerenciar suas
credenciais, evitar vazamentos acidentais e revogar credenciais que são
vazadas acidentalmente.
:::

:::version-note
O Dart 2.15 adicionou suporte para o campo `false_secrets`.
:::

### Screenshots {:#screenshots}

Os pacotes podem exibir seus widgets ou outros elementos visuais usando
capturas de tela exibidas em sua página pub.dev.
Para especificar capturas de
tela para o pacote exibir, use o campo `screenshots`.

Um pacote pode listar até 10 capturas de tela no campo `screenshots`. Não
inclua logotipos ou outras imagens de marca nesta seção.
Cada captura de tela inclui uma `description` e um `path`.
A `description` explica o que a
captura de tela retrata em não mais de 160 caracteres.
Por exemplo:

```yaml
screenshots:
  - description: 'Esta captura de tela mostra a transformação de um número de bytes
  em uma expressão legível por humanos.'
    path: path/to/image/in/package/500x500.webp
  - description: 'Esta captura de tela mostra um stack trace retornando uma
  representação legível por humanos.'
    path: path/to/image/in/package.png
```

O Pub.dev limita as capturas de tela às seguintes especificações:

- Tamanho do arquivo: máximo de 4 MB por imagem.
- Tipos de arquivo: `png`, `jpg`, `gif` ou `webp`.
- Imagens estáticas e animadas são permitidas.

Mantenha os arquivos de captura de tela pequenos. Cada download do pacote
inclui todos os arquivos de captura de tela.

O Pub.dev gera a imagem em miniatura do pacote a partir da primeira captura
de tela. Se esta captura de tela usar animação, o pub.dev usa seu primeiro frame.

### Topics {:#topics}

Os autores de pacotes podem usar o campo `topics` para categorizar seu pacote.
Os tópicos podem ser usados para auxiliar a descoberta durante a pesquisa
com filtros no pub.dev. O Pub.dev exibe os tópicos na página do pacote, bem
como nos resultados da pesquisa.

O campo consiste em uma lista de nomes. Por exemplo:

```yaml
topics:
  - network
  - http
```

O Pub.dev exige que os tópicos sigam estas especificações:

- Marque cada pacote com no máximo 5 tópicos.
- Escreva o nome do tópico seguindo estes requisitos:
  - Use entre 2 e 32 caracteres.
  - Use apenas caracteres alfanuméricos minúsculos ou hífens (`a-z`, `0-9`, `-`).
  - Não use dois hífens consecutivos (`--`).
  - Comece o nome com caracteres alfabéticos minúsculos (`a-z`).
  - Termine com caracteres alfanuméricos (`a-z` ou `0-9`).

Ao escolher tópicos, considere se os [tópicos existentes]({{site.pub}}/topics)
são relevantes. Marcar com tópicos existentes ajuda os usuários a descobrirem seu pacote.

:::note
O Pub.dev mescla diferentes grafias de um tópico em um tópico canônico para
evitar duplicação e melhorar a descoberta por tópico.

Você pode contribuir para a lista de tópicos canônicos e seus aliases
abrindo um pull request que edita o arquivo [`topics.yaml`][`topics.yaml` file] no GitHub.
:::

[`topics.yaml` file]: {{site.repo.dart.org}}/pub-dev/blob/master/doc/topics.yaml

### Ignored_advisories {:#ignored_advisories}

Se um pacote tiver uma dependência que é afetada por um aviso de segurança,
o pub avisa sobre o aviso durante a resolução de dependências. Os autores
de pacotes podem usar o campo `ignored_advisories` como uma lista de
permissões de avisos acionados que não são relevantes para o pacote.

Para suprimir o aviso sobre um aviso,
adicione o identificador do aviso à
lista `ignored_advisories`. Por exemplo:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

Para mais informações, consulte
[Avisos de segurança](/tools/pub/security-advisories).

### SDK constraints {:#sdk-constraints}

Um pacote pode indicar quais versões de suas dependências ele suporta, mas
os pacotes têm outra dependência implícita: a própria plataforma Dart. A
plataforma Dart evolui com o tempo, e um pacote pode funcionar apenas com
certas versões da plataforma.

Um pacote pode especificar essas versões usando uma *restrição de SDK*
(Software Development Kit). Esta restrição vai dentro de um campo
`environment` de nível superior separado no pubspec e usa a mesma sintaxe de
[restrição de versão](/tools/pub/dependencies#version-constraints) que as
dependências.

:::version-note
Para um pacote usar um recurso introduzido após 2.0, seu pubspec deve ter
uma restrição inferior que seja pelo
menos a versão em que o recurso foi
introduzido. Para mais detalhes, confira [Versionamento de linguagem][Language versioning].
:::

[Language versioning]: /resources/language/evolution#language-versioning

Por exemplo, a seguinte restrição diz que este pacote funciona com
qualquer SDK Dart que seja a versão 3.0.0 ou superior:

```yaml
environment:
  sdk: ^3.0.0
```

O pub tenta encontrar a versão mais recente de um pacote cuja restrição de
SDK funcione com a versão do SDK Dart que você tem instalada.

Omitir a restrição de SDK é um erro.
Quando o pubspec não tem restrição
de SDK, `dart pub get` falha com uma mensagem como a seguinte:

```plaintext
pubspec.yaml não tem restrição de SDK de limite inferior.
Você deve editar pubspec.yaml para conter uma restrição de SDK:

environment:
  sdk: '^3.2.0'
  
Veja https://dartbrasil.dev/go/sdk-constraint
```

:::version-note
Antes do Dart 2.19, o pub não permitia a sintaxe de circunflexo nas
restrições de SDK. Em versões anteriores, forneça um intervalo completo,
como `'>=2.12.0 <3.0.0'`. Para mais informações,
confira a documentação
[Sintaxe de circunflexo](/tools/pub/dependencies#caret-syntax).
:::


#### Flutter SDK constraints {:#flutter-sdk-constraints}

O Pub suporta a especificação de restrições de SDK Flutter no campo
`environment:`:

```yaml
environment:
  sdk: ^3.2.0
  flutter: '>=3.22.0'
```

Uma restrição de SDK Flutter é satisfeita somente se o pub estiver
executando no contexto do executável `flutter` e o arquivo `version` do
Flutter SDK atender ao limite inferior da restrição de versão. Caso
contrário, o pacote não será selecionado.

:::note
O SDK Flutter apenas impõe o limite inferior da
restrição flutter. Para
saber mais, confira a [issue #95472](https://github.com/flutter/flutter/issues/95472)
no repositório `flutter/flutter`.
:::

Para publicar um pacote com uma restrição de SDK Flutter, você deve
especificar uma restrição de SDK Dart com uma versão mínima de pelo menos
1.19.0, para garantir que versões mais antigas do pub não instalem
acidentalmente pacotes que precisam do Flutter.

[pubsite]: {{site.pub}}