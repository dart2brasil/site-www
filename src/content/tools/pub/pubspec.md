---
ia-translate: true
title: O arquivo pubspec
shortTitle: Arquivo pubspec
description: Guia de referência para os campos do pubspec.yaml.
---

Todo [pacote pub](/tools/pub/packages) precisa de alguns metadados para poder especificar suas
[dependências](/resources/glossary#dependency). Os pacotes pub compartilhados com
outras pessoas também precisam fornecer outras informações para que os usuários possam encontrá-los.
Todos esses metadados ficam no _pubspec_ do pacote:
um arquivo chamado `pubspec.yaml`, escrito na linguagem
[YAML](https://yaml.org/).

{% comment %}
PENDING: acknowledge the existence of pubspec.lock files.
{% endcomment %}


## Campos suportados {:#supported-fields}

Um pubspec pode ter os seguintes campos:

`name`
: Obrigatório para todos os pacotes.
  [_Saiba mais._](#name)

`version`
: Obrigatório para pacotes hospedados no site pub.dev.
  [_Saiba mais._](#version)

`description`
: Obrigatório para pacotes hospedados no site pub.dev.
  [_Saiba mais._](#description)

`homepage`
: Opcional. URL que aponta para a homepage do pacote (ou para o repositório de código-fonte).
  [_Saiba mais._](#homepage)

`repository`
: Opcional. URL que aponta para o repositório de código-fonte do pacote.
  [_Saiba mais._](#repository)

`issue_tracker`
: Opcional. URL que aponta para um rastreador de issues do pacote.
  [_Saiba mais._](#issue-tracker)

`documentation`
: Opcional. URL que aponta para a documentação do pacote.
  [_Saiba mais._](#documentation)

`dependencies`
: Pode ser omitido se o seu pacote não tiver dependências.
  [_Saiba mais._](#dependencies)

`dev_dependencies`
: Pode ser omitido se o seu pacote não tiver dependências de desenvolvimento.
  [_Saiba mais._](#dependencies)

`dependency_overrides`
: Pode ser omitido se você não precisar sobrescrever nenhuma dependência.
  [_Saiba mais._](#dependencies)

`environment`
: Obrigatório a partir do Dart 2.
  [_Saiba mais._](#sdk-constraints)

`executables`
: Opcional. Usado para colocar os executáveis de um pacote no seu PATH.
  [_Saiba mais._](#executables)

`platforms`
: Opcional. Usado para declarar explicitamente as plataformas suportadas
  no site pub.dev.
  [_Saiba mais._](#platforms)

`publish_to`
: Opcional. Especifica onde publicar um pacote.
  [_Saiba mais._](#publish_to)

`funding`
: Opcional. Lista de URLs onde os usuários podem patrocinar o desenvolvimento do pacote.
  [_Saiba mais._](#funding)

`false_secrets`
: Opcional. Especifica arquivos a serem ignorados durante a busca prévia à publicação
  por possíveis vazamentos de segredos.
  [_Saiba mais._](#false_secrets)
  
`screenshots`
: Opcional. Especifica uma lista de arquivos de captura de tela para exibir
  no [site pub.dev]({{site.pub}}).
  [_Saiba mais._](#screenshots)

`topics`
: Opcional. Lista de tópicos do pacote.
  [_Saiba mais._](#topics)

`ignored_advisories`
: Opcional. Lista de alertas de segurança ignorados.
  [_Saiba mais._](#ignored_advisories)

`hooks`
: Opcional. Configura hooks específicos do pacote, como hooks de build nativo ou de link.
  [_Saiba mais._](#hooks)

O pub ignora todos os outros campos.

:::flutter-note
Os pubspecs de [aplicativos Flutter]({{site.flutter}}) podem ter
[campos adicionais]({{site.flutter-docs}}/development/tools/pubspec)
para configurar o ambiente e gerenciar assets.
:::

Se você adicionar um campo personalizado, dê a ele um nome único
que não entre em conflito com futuros campos do pubspec.
Por exemplo, em vez de adicionar `bugs`,
você pode adicionar um campo chamado `my_pkg_bugs`.


## Exemplo {:#example}

Um pubspec simples, mas completo, fica mais ou menos assim:

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


## Detalhes {:#details}

Esta seção traz mais informações sobre cada um dos campos do pubspec.

### Nome {:#name}

Todo pacote precisa de um nome. É assim que outros pacotes se referem ao seu,
e é como ele aparece para o mundo, caso você o publique.

O nome deve estar todo em minúsculas, com underlines para separar as palavras,
`assim_mesmo`. Use apenas letras latinas básicas e dígitos arábicos:
`[a-z0-9_]`. Além disso, garanta que o nome seja um identificador Dart válido, ou seja, que
não comece com dígitos e não seja uma
[palavra reservada](/language/keywords).

Tente escolher um nome claro, curto e que ainda não esteja em uso.
Recomenda-se fazer uma busca rápida de pacotes no
[site pub.dev]({{site.pub-pkg}})
para garantir que nenhum outro pacote esteja usando o seu nome.

### Versão {:#version}

Todo pacote tem uma versão. Um número de versão é obrigatório para hospedar seu pacote
no site pub.dev, mas pode ser omitido em pacotes apenas locais. Se você omiti-lo,
seu pacote é versionado implicitamente como `0.0.0`.

O versionamento é necessário para reutilizar código enquanto ele evolui rapidamente. Um
número de versão é formado por três números separados por pontos, como `0.2.43`. Ele também pode
ter, opcionalmente, um sufixo de build (`+1`, `+2`, `+hotfix.oopsie`) ou de prerelease
(`-dev.4`, `-alpha.12`, `-beta.7`, `-rc.5`).

Cada vez que você publica seu pacote, você o publica em uma versão específica.
Depois disso, considere-a hermeticamente selada: você não pode mais alterá-la.
Para fazer mais mudanças, você precisará de uma nova versão.

Ao escolher uma versão, siga o [versionamento semântico.][semantic versioning]

[semantic versioning]: https://semver.org/spec/v2.0.0-rc.1.html

### Descrição {:#description}

Isso é opcional para seus pacotes pessoais, mas, se você pretende
publicar seu pacote, deve fornecer uma descrição, que deve estar em inglês.
A descrição deve ser relativamente curta, entre 60 e 180 caracteres, e
dizer a um leitor casual o que ele pode querer saber sobre o seu pacote.

Pense na descrição como o discurso de vendas do seu pacote. Os usuários a veem
quando [navegam pelos pacotes.]({{site.pub-pkg}})
A descrição é texto puro: sem markdown ou HTML.

### Homepage {:#homepage}

Deve ser uma URL que aponte para o site do seu pacote.
Para [pacotes hospedados](/tools/pub/dependencies#hosted-packages),
essa URL é linkada a partir da página do pacote.
Embora fornecer uma `homepage` seja opcional, *por favor, forneça-a* ou `repository`
(ou ambos). Isso ajuda os usuários a entender de onde o seu pacote vem.

### Repositório {:#repository}

O campo opcional `repository` deve conter a URL do repositório de código-fonte do seu pacote,
por exemplo, `https://github.com/<user>/<repository>`.
Se você publicar seu pacote no site pub.dev, a página do pacote
exibe a URL do repositório.
Embora fornecer um `repository` seja opcional, *por favor, forneça-o* ou `homepage`
(ou ambos). Isso ajuda os usuários a entender de onde o seu pacote vem.

### Rastreador de issues {:#issue-tracker}

O campo opcional `issue_tracker` deve conter uma URL para o rastreador de issues do pacote,
onde os bugs existentes podem ser vistos e novos bugs podem ser reportados.
O site pub.dev tenta exibir um link para o rastreador de issues de cada pacote,
usando o valor desse campo. Se `issue_tracker` estiver ausente, mas
`repository` estiver presente e apontar para o GitHub, então o site pub.dev usa o
rastreador de issues padrão (`https://github.com/<user>/<repository>/issues`).

### Documentação {:#documentation}

Alguns pacotes têm um site que hospeda a documentação, separado da homepage principal
e da referência da API gerada pelo Pub.
Se o seu pacote tiver documentação adicional, adicione um campo `documentation:`
com essa URL; o pub mostra um link para essa documentação na página do seu pacote.

### Dependências {:#dependencies}

As [dependências](/resources/glossary#dependency) são a razão de ser do pubspec.
Nesta seção, você lista cada pacote de que o seu pacote precisa para funcionar.

As dependências se dividem em dois tipos. _Dependências regulares_ são listadas
em `dependencies:` — são pacotes de que qualquer pessoa que use o seu pacote
também vai precisar. Dependências necessárias apenas na fase de desenvolvimento do
próprio pacote são listadas em `dev_dependencies`.

Durante o processo de desenvolvimento, você pode precisar sobrescrever temporariamente
uma dependência. Você pode fazer isso usando `dependency_overrides`.

Para mais informações, consulte [Dependências de pacotes](/tools/pub/dependencies).

### Executáveis {:#executables}

Um pacote pode expor um ou mais de seus scripts como executáveis que
podem ser executados diretamente pela linha de comando. Para tornar um script
disponível publicamente, liste-o no campo `executables`.
As entradas são listadas como pares chave/valor:

```plaintext
<name-of-executable>: <Dart-script-from-bin>
```

Por exemplo, a entrada a seguir do pubspec lista dois scripts:

```yaml
executables:
  slidy: main
  fvm:
```

Depois que o pacote for ativado com `dart pub global activate`,
digitar `slidy` executa `bin/main.dart`.
Digitar `fvm` executa `bin/fvm.dart`.
Se você não especificar o valor, ele é inferido a partir da chave.

Para mais informações, consulte
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).


### Plataformas {:#platforms}

Quando você [publica um pacote][publish a package], o pub.dev detecta automaticamente
as plataformas que o pacote suporta.
Se essa lista de suporte a plataformas estiver incorreta,
use `platforms` para declarar explicitamente
quais plataformas o seu pacote suporta.

Por exemplo, a entrada `platforms` a seguir faz com que o pub.dev
liste o pacote como compatível com
Android, iOS, Linux, macOS, Web e Windows:

```yaml
# This package supports all platforms listed below.
platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

Veja um exemplo de declaração de que o pacote suporta
apenas Linux e macOS (e não, por exemplo, Windows):

```yaml
# This package supports only Linux and macOS.
platforms:
  linux:
  macos:
```

:::note Se você usa Flutter
O suporte a plataformas dos plugins Flutter é derivado, por padrão, das
[declarações do plugin][plugin declarations].

Se houver uma discrepância entre a declaração do plugin e o suporte real
às plataformas, ainda é possível usar uma declaração `platforms` no nível superior, que
tem precedência sobre a declaração do plugin Flutter na decisão do suporte a plataformas.
:::

:::version-note
O suporte à entrada `platforms` foi adicionado no Dart 2.16.
:::

[publish a package]: /tools/pub/publishing
[plugin declarations]: {{site.flutter-docs}}/development/packages-and-plugins/developing-packages#plugin-platforms


### Publish_to {:#publish_to}

O padrão usa o [site pub.dev.]({{site.pub}}) Especifique `none` para impedir
que um pacote seja publicado. Essa configuração pode ser usada para especificar um
[servidor de pacotes pub personalizado](/tools/pub/custom-package-repositories)
para publicação.

```yaml
publish_to: none
```


### Funding {:#funding}

Os autores de pacotes podem usar a propriedade `funding` para especificar uma lista de URLs que
fornecem informações sobre como os usuários podem ajudar a financiar o desenvolvimento do pacote.
Por exemplo:

```yaml
funding:
 - https://www.buymeacoffee.com/example_user
 - https://www.patreon.com/some-account
```

Se publicados no [pub.dev]({{site.pub}}), os links são exibidos na
página do pacote. O objetivo é ajudar os usuários a financiar o desenvolvimento
de suas dependências.


### False_secrets {:#false_secrets}

Quando você tenta [publicar um pacote][publish a package],
o pub faz uma busca por possíveis vazamentos de
credenciais secretas, chaves de API ou chaves criptográficas.
Se o pub detectar um possível vazamento em um arquivo que seria publicado,
ele avisa você e se recusa a publicar o pacote.

A detecção de vazamentos não é perfeita.
Para evitar falsos positivos,
você pode dizer ao pub para não procurar vazamentos em determinados arquivos,
criando uma lista de permissão
usando [padrões `gitignore`][`gitignore` patterns] em
`false_secrets` no pubspec.

[`gitignore` patterns]: https://git-scm.com/docs/gitignore#_pattern_format

Por exemplo, a entrada a seguir faz com que o pub não procure vazamentos no
arquivo `lib/src/hardcoded_api_key.dart`
e em todos os arquivos `.pem` do diretório `test/localhost_certificates/`:

[publish a package]: /tools/pub/publishing

```yaml
false_secrets:
 - /lib/src/hardcoded_api_key.dart
 - /test/localhost_certificates/*.pem
```

Começar um padrão `gitignore` com barra (`/`) garante que o
padrão seja considerado relativo ao diretório raiz do pacote.

:::warning
**Não dependa da detecção de vazamentos.**
Ela usa um conjunto limitado de padrões
para detectar erros comuns.
Você é responsável por gerenciar suas credenciais,
evitar vazamentos acidentais e
revogar as credenciais que vazarem por acidente.
:::

:::version-note
O Dart 2.15 adicionou suporte ao campo `false_secrets`.
:::

### Screenshots {:#screenshots}

Os pacotes podem mostrar seus widgets ou outros elementos visuais
usando capturas de tela exibidas na página deles no pub.dev.
Para especificar as capturas de tela que o pacote vai exibir,
use o campo `screenshots`.

Um pacote pode listar até 10 capturas de tela no campo `screenshots`.
Não inclua logos ou outras imagens de marca nesta seção.
Cada captura de tela inclui uma `description` e um `path`.
A `description` explica o que a captura de tela mostra em
no máximo 160 caracteres.
Por exemplo:

```yaml
screenshots:
  - description: 'This screenshot shows the transformation of a number of bytes 
  to a human-readable expression.'
    path: path/to/image/in/package/500x500.webp
  - description: 'This screenshot shows a stack trace returning a human-readable
  representation.'
    path: path/to/image/in/package.png
```

O pub.dev limita as capturas de tela às seguintes especificações:

- Tamanho do arquivo: máximo de 4 MB por imagem.
- Tipos de arquivo: `png`, `jpg`, `gif` ou `webp`.
- Imagens estáticas e animadas são permitidas.

Mantenha os arquivos de captura de tela pequenos.
Cada download do pacote inclui todos os arquivos de captura de tela.

O pub.dev gera a miniatura do pacote a partir da primeira captura de tela. Se
essa captura usar animação, o pub.dev usa o primeiro quadro dela.

### Tópicos {:#topics}

Os autores de pacotes podem usar o campo `topics` para categorizar o pacote. Os tópicos
podem ser usados para facilitar a descoberta durante a busca, com filtros no pub.dev.
O pub.dev exibe os tópicos na página do pacote, bem como nos
resultados de busca.

O campo consiste em uma lista de nomes. Por exemplo:

```yaml
topics:
  - network
  - http
```

O pub.dev exige que os tópicos sigam estas especificações:

- Marque cada pacote com no máximo 5 tópicos.
- Escreva o nome do tópico seguindo estes requisitos:
  - Use entre 2 e 32 caracteres.
  - Use apenas caracteres alfanuméricos minúsculos ou hífens (`a-z`, `0-9`, `-`).
  - Não use dois hífens consecutivos (`--`).
  - Comece o nome com letras minúsculas (`a-z`).
  - Termine com caracteres alfanuméricos (`a-z` ou `0-9`).

Ao escolher tópicos, veja se os [tópicos existentes]({{site.pub}}/topics)
são relevantes. Marcar com tópicos existentes ajuda os usuários a descobrir o seu pacote.

:::note
O pub.dev unifica grafias diferentes de um tópico em um tópico canônico para
evitar duplicação e melhorar a descoberta por tópico.

Você pode contribuir com a lista de tópicos canônicos e seus aliases
abrindo um pull request que edite o [arquivo `topics.yaml`][`topics.yaml` file] no GitHub.
:::

[`topics.yaml` file]: {{site.repo.dart.org}}/pub-dev/blob/master/doc/topics.yaml

### Ignored_advisories {:#ignored_advisories}

Se um pacote tiver uma dependência afetada por um alerta de segurança,
o pub avisa sobre o alerta durante a resolução de dependências.
Os autores de pacotes podem usar o campo `ignored_advisories` como uma lista de permissão
de alertas disparados que não são relevantes para o pacote.

Para suprimir o aviso sobre um alerta,
adicione o identificador do alerta à lista `ignored_advisories`.
Por exemplo:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

Para mais informações, confira
[Alertas de segurança](/tools/pub/security-advisories).

### Hooks {:#hooks}

Para configurar hooks específicos do pacote, como hooks de build nativo ou de link,
use o campo `hooks`.
Em `hooks`, configure os parâmetros que personalizam como os hooks são executados.

Por exemplo:

```yaml
hooks:
  user_defines:
    my_package:
      enable_experimental: true
```

Para saber mais sobre como configurar hooks,
confira [Configuração de hooks][Hook configuration].

[Hook configuration]: /tools/hooks#hook-configuration

### Restrições do SDK {:#sdk-constraints}

Um pacote pode indicar quais versões de suas dependências ele suporta, mas
pacotes têm outra dependência implícita: a própria plataforma Dart.
A plataforma Dart evolui com o tempo, e um pacote pode funcionar apenas com
certas versões da plataforma.

Um pacote pode especificar essas versões usando uma *restrição de SDK*. Essa
restrição fica dentro de um campo `environment` separado, no nível superior do pubspec,
e usa a mesma sintaxe de
[restrição de versão](/tools/pub/dependencies#version-constraints) das
dependências.

:::version-note
Para que um pacote use um recurso introduzido após a versão 2.0,
o pubspec dele deve ter um limite inferior que seja pelo menos
a versão em que o recurso foi introduzido.
Para detalhes, confira [Versionamento da linguagem][Language versioning].
:::

[Language versioning]: /language/versioning

Por exemplo, a restrição a seguir diz que este pacote
funciona com qualquer Dart SDK na versão 3.0.0 ou superior:

```yaml
environment:
  sdk: ^3.0.0
```

O pub tenta encontrar a versão mais recente de um pacote cuja restrição de SDK
funcione com a versão do Dart SDK que você tem instalada.

Omitir a restrição de SDK é um erro.
Quando o pubspec não tem restrição de SDK,
`dart pub get` falha com uma mensagem como a seguinte:

```plaintext
pubspec.yaml has no lower-bound SDK constraint.
You should edit pubspec.yaml to contain an SDK constraint:

environment:
  sdk: '^3.2.0'
  
See https://dart.dev/go/sdk-constraint
```

:::version-note
Antes do Dart 2.19, o pub não permitia a sintaxe caret nas restrições de SDK.
Em versões anteriores, forneça um intervalo completo,
como `'>=2.12.0 <3.0.0'`.
Para mais informações, confira
a documentação sobre [sintaxe caret](/tools/pub/dependencies#caret-syntax).
:::


#### Restrições do SDK do Flutter {:#flutter-sdk-constraints}

O pub oferece suporte à especificação de restrições do SDK do Flutter
no campo `environment:`:

```yaml
environment:
  sdk: ^3.2.0
  flutter: '>=3.22.0'
```

Uma restrição do SDK do Flutter só é satisfeita se o pub estiver sendo executado no
contexto do executável `flutter`, e o arquivo `version` do SDK do Flutter
atender ao limite inferior da restrição de versão. Caso contrário,
o pacote não será selecionado.

:::note
O SDK do Flutter só aplica o limite inferior da restrição flutter.
Para saber mais, confira
a [issue #95472](https://github.com/flutter/flutter/issues/95472)
no repositório `flutter/flutter`.
:::

Para publicar um pacote com uma restrição do SDK do Flutter,
você deve especificar uma restrição do Dart SDK com uma versão mínima de
pelo menos 1.19.0, para garantir que versões mais antigas do pub não
instalem pacotes que precisam do Flutter por acidente.

[pubsite]: {{site.pub}}
