---
ia-translate: true
title: "Hospedando um repositório privado de pacotes Dart"
description: "Melhorias no Dart 2.15 para hospedagem segura de pacotes em ambientes corporativos"
publishDate: 2022-03-16
author: jonasfj
image: images/1hv1Nujq4-g2-y2uLuLYVqA.webp
category: other
layout: blog
---


Nossa versão recente, o Dart 2.15, adicionou suporte a repositórios privados de pacotes. Um repositório de pacotes é um servidor que hospeda pacotes Dart para consumo pelo cliente `dart pub`. Este post discute como usar repositórios privados de pacotes junto com o [pub.dev](https://pub.dev), aproveitando o novo mecanismo de autenticação por token introduzido no Dart 2.15.

Esse recurso já foi adotado pela [Cloudsmith](https://help.cloudsmith.io/docs/dart-repository) e pela [JFrog Artifactory](https://jfrog.com/blog/how-to-use-pub-repositories-in-artifactory/), que oferecem repositórios de pacotes personalizados como serviço:

<DashImage src="images/1-xVF9afKxXP0_RTKs1pyxA.webp" alt="Logos da Cloudsmith e do JFrog Artifactory." caption="Repositórios privados de Dart agora são oferecidos pela Cloudsmith e pela JFrog Artifactory." />


## Por que usar um repositório de pacotes personalizado? {:#why-use-a-custom-package-repository}

O repositório de pacotes padrão, o [pub.dev](https://pub.dev), é operado pela equipe do Dart. Ele facilita a publicação de pacotes Dart para uso público e permite que qualquer desenvolvedor Dart consuma esses pacotes simplesmente adicionando o nome do pacote ao seu arquivo pubspec. Isso permite que um rico conjunto de pacotes Dart seja criado por um ecossistema ativo. No entanto, um repositório de pacotes personalizado pode ser útil nos seguintes cenários:

1. Compartilhar pacotes privados dentro de uma organização. Pode ser o caso de uma organização que quer compartilhar pacotes internos e proprietários entre os seus membros, e não com o público geral.

1. Controle rígido de dependências em ambientes corporativos. Algumas empresas querem criar listas de permissão (allow-lists) para *versões específicas de pacotes* aprovadas para uso. Isso pode ser feito para aplicar políticas de revisão de código ou de conformidade de licenças.

1. Ambientes seguros sem acesso à internet pública. Algumas organizações atuam em um ambiente regulado, em que conexões com a internet pública e, por extensão, com o [pub.dev](https://pub.dev), não são permitidas. Isso normalmente se aplica a agências governamentais e seus prestadores de serviço, além de alguns provedores de serviços bancários.

Organizações que só precisam compartilhar alguns pacotes proprietários (cenário 1) podem usar [dependências git](https://dart.dev/tools/pub/dependencies#git-packages). Esse é um mecanismo poderoso, porque o comando `dart pub` invoca o cliente `git` para clonar as dependências git. Assim, você pode autenticar o clone de uma dependência usando sua chave SSH e gerenciar permissões com equipes do GitHub/GitLab. Com o [suporte do GitHub a SSH usando Yubikeys](https://www.yubico.com/blog/github-now-supports-ssh-security-keys/), essa configuração funciona bem em alguns casos.

No entanto, as dependências git no `dart pub` têm algumas limitações quando se trata de resolução de versões. Ao usar uma dependência git, o `dart pub` apenas clona a tag, o branch ou a ref especificada no `pubspec.yaml`, porque não há um mecanismo para tentar múltiplas versões da dependência. Por isso, usar um repositório de pacotes personalizado privado pode ser atraente: ele pode fornecer ao cliente `dart pub` uma lista de versões, permitindo que o [resolvedor de versões](https://nex3.medium.com/pubgrub-2fb6470504f') escolha uma versão compatível e evite conflitos. Também facilita atualizar dependências privadas e públicas usando `dart pub outdated` e `dart pub upgrade --major-versions`.

As dependências git não atendem organizações que precisam de *controle mais rígido sobre as dependências* (cenário 2) ou que usam *um ambiente seguro sem acesso à internet* (cenário 3), já que muitos pacotes precisariam ser espelhados. Nesses cenários, quase sempre é preferível ter simplesmente um repositório de pacotes personalizado que espelhe um subconjunto da lista de permissão do [pub.dev](https://pub.dev).

## Usando um repositório de pacotes personalizado {:#using-a-custom-package-repository}

A partir do Dart 2.15, você pode depender de um pacote de um repositório de pacotes personalizado usando a sintaxe de *dependência hospedada na forma curta*:

```
dependencies:
  foo:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
environment: 
  sdk: >=2.15.0 <3.0.0
```


A sintaxe curta exige uma restrição de SDK `&gt;=2.15.0,` porque versões mais antigas do Dart SDK não suportam essa sintaxe. Se você não quiser se preocupar com a sintaxe, também pode usar o comando `dart pub add` para adicionar uma dependência de um repositório de pacotes personalizado:

```
$ dart pub add foo --hosted https://dart-packages.example.com
Resolving dependencies... 
+ foo 1.4.0
Changed 1 dependency!
```


Usando a sintaxe de dependência hospedada, é possível misturar dependências de repositórios de pacotes personalizados com dependências do repositório oficial. O exemplo a seguir depende do pacote `foo` do repositório `dart-packages.example.com` e do pacote `retry` do pub.dev:

```
dependencies:
  retry: ^3.0.0
  foo:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
environment: 
  sdk: >=2.15.0 <3.0.0
```


Isso é útil ao compartilhar pacotes privados por meio de um repositório de pacotes personalizado (cenário 1). Mas, para um *controle mais rígido das dependências* (cenário 2) ou para trabalhar em *um ambiente seguro sem acesso à internet* (cenário 3), pode ser preferível substituir o repositório de pacotes padrão.

### Substituindo o repositório de pacotes padrão {:#overriding-the-default-package-repository}

Por padrão, o `dart pub get` busca dependências no `pub.dev`, a menos que a sintaxe de dependência hospedada seja usada para especificar um repositório de pacotes personalizado. No entanto, é possível substituir o *repositório de pacotes padrão* usando a variável de ambiente `PUB_HOSTED_URL`. Essa abordagem é especialmente útil ao espelhar um subconjunto do pub.dev (cenário 2 ou 3), pois não é preciso atualizar o `pubspec.yaml` para referenciar a URL do repositório personalizado. Por exemplo, basta escrever o seguinte:

```
dependencies:
  retry: ^3.0.0
  foo: ^1.0.0
```


Se versões da lista de permissão dos pacotes `retry` e `foo` forem copiadas para o repositório de pacotes personalizado, e a variável de ambiente `PUB_HOSTED_URL` apontar para a URL desse repositório, o `pub get` pode funcionar assim:

```
$ export PUB_HOSTED_URL=https://dart-packages.example.com
$ dart pub get
Resolving dependencies... 
+ retry 3.1.0
+ foo 1.4.0
Changed 2 dependencies!
```


Isso funciona melhor quando o servidor de build fica atrás de um firewall corporativo que bloqueia conexões de saída, para evitar ataques de injeção acidentais quando alguém esquece de definir `PUB_HOSTED_URL`. Da mesma forma, também é recomendável definir `publish_to: &lt;hosted-url&gt;` no `pubspec.yaml`, para evitar publicações acidentais no pub.dev (quando `PUB_HOSTED_URL` não estiver definida).

### Autenticação em repositórios de pacotes personalizados {:#authentication-against-custom-package-repositories}

A maioria dos repositórios de pacotes personalizados provavelmente será de repositórios privados que exigem autenticação. O Dart 2.15 introduziu o comando [`dart pub token`](https://dart.dev/tools/pub/cmd/pub-token) para gerenciar tokens de autenticação. As requisições a um repositório de pacotes personalizado são autenticadas com um token secreto. Você obtém o token secreto no seu repositório de pacotes personalizado e o passa para `dart pub token add &lt;hosted-url&gt;`, que solicita o token, como mostrado abaixo:

```
$ dart pub token add https://dart-packages.example.com
Enter secret token: [enter secret token]
Requests to "dart-packages.example.com" will now be authenticated using the secret token.
```


### Autenticação em ambientes de CI {:#authentication-from-ci-environments}

Ao executar em CI, muitas vezes é possível [armazenar segredos em variáveis de ambiente](https://docs.github.com/en/actions/security-guides/encrypted-secrets#about-encrypted-secrets). Embora seja possível passar segredos usando `echo $TOKEN | dart pub token add &lt;hosted-url&gt;`, também é possível dizer ao `dart pub` para ler um segredo de uma variável de ambiente ao se comunicar com um repositório personalizado específico:

```
$ dart pub token add https://dart-packages.example.com --env-var MY_SECRET_TOKEN
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token stored in the environment variable "MY_SECRET_TOKEN".
```


Isso garante que o `dart pub` não armazene o segredo no arquivo de configuração; ele apenas guarda a informação de que deve ler o segredo da variável de ambiente `$MY_SECRET_TOKEN`. Assim, os segredos só ficam em variáveis de ambiente quando se opera em um ambiente de CI, e isso reduz o risco de vazamento acidental caso o ambiente de execução seja compartilhado entre jobs de CI.

## Publicando em repositórios de pacotes personalizados {:#publishing-to-custom-package-repositories}

Para publicar um pacote em um repositório de pacotes personalizado, você especifica `publish_to: &lt;hosted-url&gt;` no `pubspec.yaml,` e executa `dart pub publish`. Isso usa o mesmo token para autenticação que o `dart pub get`. No mínimo, seu arquivo `pubspec.yaml` deve ficar parecido com o seguinte:

```
name: mypkg
version: 1.0.0
publish_to: https://dart-packages.example.com
dependencies:
  meta: ^1.7.0
environment:
  sdk: >=2.15.0 <3.0.0
```


Ao executar `dart pub publish`, é importante revisar as informações exibidas. Antes de confirmar a publicação, você deve sempre fazer o seguinte:

* Verificar a URL onde o pacote será publicado.

* Revisar a lista de arquivos que serão incluídos no pacote.

* Considerar as recomendações de validação do pacote. Por exemplo:

```
$ dart pub publish
Publishing mypkg 1.0.0 to https://dart-packages.example.com
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- lib
|   '-- mypkg.dart
'-- pubspec.yaml
Package validation found the following potential issue:
* It's strongly recommended to include a "homepage" or "repository" field in your pubspec.yaml
...
```


Para publicações em repositórios personalizados, as recomendações *podem não* ser importantes, mas fornecer metadados para o pacote costuma ser útil. No pub.dev, pacotes com metadados e documentação adequados ganham mais [pub points](https://pub.dev/help/scoring).

É possível publicar em repositórios personalizados substituindo o *repositório de pacotes padrão* pela variável de ambiente `PUB_HOSTED_URL`, mas, se você fizer isso, é fortemente recomendável especificar `publish_to: &lt;hosted-url&gt;` no seu arquivo `pubspec.yaml`; isso impede que você publique acidentalmente seus pacotes proprietários no repositório público. E se você não quiser publicar seus pacotes proprietários em *nenhum* repositório de pacotes, especifique `publish_to: none` para evitar publicações acidentais.

## Obtenha um repositório de pacotes personalizado {:#get-a-custom-package-repository}

Como mencionado antes, repositórios de pacotes personalizados estão disponíveis como serviço de vários fornecedores comerciais, poupando você do trabalho de hospedar e manter o seu próprio repositório.

### Autenticação por token na Cloudsmith {:#token-authentication-in-cloudsmith}

A Cloudsmith oferece repositórios privados e públicos de pacotes Dart desde 2020. A [Cloudsmith anunciou recentemente](https://cloudsmith.com/resources/blog/improvements-to-dart-package-support) o suporte à autenticação por token em sua oferta de repositórios de pacotes Dart. Para mais informações, confira a [documentação da Cloudsmith](https://help.cloudsmith.io/docs/dart-repository).

<DashImage src="images/1hv1Nujq4-g2-y2uLuLYVqA.webp" alt="A interface web da Cloudsmith mostrando um repositório privado de pacotes Dart." caption="Um repositório privado de pacotes Dart hospedado pela Cloudsmith." />


### Suporte ao Dart no JFrog Artifactory {:#dart-support-in-jfrog-artifactory}

A JFrog Artifactory [anunciou recentemente suporte a repositórios de pacotes Dart personalizados](https://jfrog.com/blog/how-to-use-pub-repositories-in-artifactory), incluindo suporte a repositórios em camadas e ao espelhamento de pacotes do repositório público no [pub.dev](https://pub.com). Para mais informações, confira a [documentação da JFrog Artifactory](https://www.jfrog.com/confluence/display/JFROG/Pub+Repositories).

<DashImage src="images/1JeK8mYxYCn-XoeHUCJlPEg.webp" alt="A interface web da JFrog Artifactory mostrando um repositório de pacotes Dart personalizado." caption="Um repositório de pacotes Dart personalizado gerenciado pela JFrog." />


### Comentários finais {:#closing-comments}

Para quem quiser escrever o próprio repositório de pacotes personalizado, publicamos uma [especificação para servir repositórios de pacotes Dart](https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md). Ela é bastante simples, mas sinta-se à vontade para abrir issues no [repositório do pub.dev](https://github.com/dart-lang/pub-dev/issues) caso algum aspecto não esteja claro ou se tiver sugestões de melhorias.
