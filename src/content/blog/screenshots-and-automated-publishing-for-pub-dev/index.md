---
ia-translate: true
title: "Screenshots e publicação automatizada para o pub.dev"
description: "A partir de hoje, temos algumas novidades no pub.dev: agora você pode declarar screenshots para um pacote, permitindo uma busca mais visual…"
publishDate: 2023-01-18
author: jonasfj
image: images/169KfhhHmmvZ6BLvypXjx2A.webp
category: announcements
layout: blog
---


A partir de hoje, o pub.dev traz duas novidades: agora você pode declarar screenshots para um pacote, o que permite uma busca mais visual. E o fluxo de publicação pode ser totalmente automatizado, com a ajuda do GitHub Actions.

## Adicionando screenshots ao pub.dev {:#adding-screenshots-to-pub-dev}

Um dos principais objetivos do pub.dev é facilitar a busca pelo pacote certo para cada finalidade. Quando você procura widgets ou outros componentes visuais, as imagens têm um papel importante. Agora mostramos screenshots nos resultados de busca de pacotes, para tornar a descoberta de pacotes mais fácil do que nunca.

### Screenshots na busca de pacotes e na página do pacote {:#screenshots-in-package-search-and-on-the-package-page}

Miniaturas dos screenshots agora aparecem nos resultados de busca, e você também pode filtrar a busca para listar apenas pacotes com screenshots.

<DashImage src="images/1B2bqbwEtObMoGQTm8B-FVQ.webp" alt="Pub.dev search results filtered by has:screenshot, showing package screenshot thumbnails beside results." />


A miniatura do screenshot também aparece na página do pacote, e clicar nela abre um carrossel de imagens com todos os screenshots.

<DashImage src="images/169KfhhHmmvZ6BLvypXjx2A.webp" alt="Image carousel displaying screenshots on a package page." />


### Declarando screenshots no `pubspec.yaml` {:#declaring-screenshots-in-pubspec-yaml}

Adicionar screenshots a um pacote é bem simples. Declare os arquivos no `pubspec.yaml`, no campo `screenshots`, com uma `description` e um `path`. Abaixo está um exemplo do pacote `animations`.

```yaml
name: animations
...
screenshots:
 - description: 'Examples of the container transform pattern.'
   path: example/screenshots/container_transform_lineup.png
 - description: 'Examples of the fade pattern.'
   path: example/screenshots/fade_lineup.png
   ...
```


Para mais detalhes, veja [dart.dev/tools/pub/pubspec#screenshots](https://dart.dev/tools/pub/pubspec#screenshots).

## Publicação automatizada para o pub.dev {:#automated-publishing-for-pub-dev}

Milhares de membros da comunidade Dart publicam pacotes no pub.dev, em benefício de todos os desenvolvedores Dart e Flutter. Tradicionalmente, esses publishers de pacotes publicam no pub.dev executando um comando de terminal local, `dart pub publish`, e se autenticando com a conta Google. Nos bastidores, um *refresh token* era armazenado em um arquivo de configuração na máquina de desenvolvimento, o que permitia publicar uma nova versão sem autenticar novamente. Esse fluxo é simples e fácil de entender, mas exige uma série de passos manuais. Temos o prazer de apresentar um novo fluxo de publicação automatizada, que permite publicar novas versões no pub.dev diretamente por uma GitHub Action. Isso traz vários benefícios:

* Cada release é automaticamente marcada com tags de release consistentes no GitHub

* É fácil configurar um fluxo de revisão e aprovação para publicar novas versões.

* O processo de publicação é autenticado por um token assinado pelo GitHub, garantindo que nenhuma credencial precise ser armazenada em disco.

<DashImage src="images/1dqxBy1vvLW108xdpqLLZ5Q.webp" alt="GitHub Actions run for Publish to pub.dev showing a successful dart pub publish command for testpkg 1.1.5." />


### Tornando a publicação automatizada segura {:#making-automated-publishing-secure}

Atualmente, alguns usuários têm recorrido a armazenar o arquivo de configuração `pub-credentials.json`, que contém o *refresh token*, em uma variável de ambiente secreta no GitHub Actions. Assim, conseguiam escrever um workflow do GitHub Actions que recuperava o arquivo de configuração e o usava para publicar uma nova versão do pacote. Embora esse fluxo funcione tecnicamente, a ferramenta não foi projetada para isso, e ele tem várias desvantagens:

* Os arquivos `pub-credentials.json` podem ser usados para publicar qualquer pacote que o autor tenha permissão de publicar, não apenas o pacote publicado pelo fluxo configurado.

* Se vazado, o `pub-credentials.json` pode ser usado para publicar novas versões e novos pacotes, se passando pelo usuário que criou o arquivo `pub-credentials.json`.

* A [interface para revogar](https://myaccount.google.com/permissions) o *refresh token* no `pub-credentials.json` não é fácil de encontrar.

De fato, já aconteceu mais de uma vez de um pacote ser publicado e acidentalmente incluir o arquivo `pub-credentials.json` do autor, porque ele extraiu o arquivo dentro de um job de CI. Publicar um pacote junto com as credenciais necessárias para atualizá-lo é uma vulnerabilidade de segurança bastante grave, e por isso acabamos [implementando detecção de vazamentos](https://dart.dev/go/false-secrets) no `dart pub publish`.

Nosso novo suporte à publicação automatizada mitiga esses problemas, tornando possível autenticar no pub.dev usando um dos seguintes métodos:

* Um [token OIDC temporário assinado pelo GitHub Actions](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect).

* Uma service account do GCP, que pode ser usada a partir da maioria dos recursos do GCP, como o Google Cloud Build, ou outros ambientes de nuvem, como Azure ou AWS.

Esses fluxos permitem publicação automatizada sem depender de tokens secretos de longa duração, que podem ser facilmente abusados se vazarem por acidente. Se você implantar seu fluxo de publicação em uma máquina própria, pode, claro, usar chaves exportadas de service account, mas é preciso ter muito cuidado para protegê-las adequadamente.

### Habilitando publicação segura {:#enabling-secure-publishing}

Você pode habilitar a publicação automatizada a partir do GitHub com apenas alguns passos. Veja [dart.dev/go/automated-publishing](http://dart.dev/go/automated-publishing) para todos os detalhes.
