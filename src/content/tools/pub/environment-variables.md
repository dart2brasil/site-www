---
title: Configuring pub environment variables
shortTitle: Pub environment variables
description: >-
  How to configure your environment for Dart's package management tool, pub.
showToc: false
ia-translate: true
---

Variáveis de ambiente permitem que você customize o pub para atender suas necessidades.

`PUB_CACHE`
: Algumas das dependências do pub são baixadas para o cache do pub.
  Por padrão, este diretório está localizado em
  `$HOME/.pub-cache` (no macOS e Linux),
  ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows). (A localização precisa do
  cache pode variar dependendo da versão do Windows.)
  Você pode usar a variável de ambiente `PUB_CACHE`
  para especificar outro local. Para mais informações, veja
  [The system package cache](/tools/pub/cmd/pub-get#the-system-package-cache).

`PUB_HOSTED_URL`
: Pub baixa dependências do [site pub.dev.]({{site.pub}})
  Para especificar a localização de um servidor mirror específico,
  use a variável de ambiente `PUB_HOSTED_URL`. Por exemplo:

```bash
PUB_HOSTED_URL = https://pub.example.com
```

Para mais informações sobre usar um repositório de pacotes privado,
veja [Overriding the default package repository][].

:::note
Se você está tentando usar `pub get` atrás de um firewall corporativo
e ele falha,
por favor veja [`pub get` fails from behind a corporate firewall][]
para informações sobre como configurar as variáveis de ambiente de proxy
para sua plataforma.
:::

[`pub get` fails from behind a corporate firewall]: /tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall
[Overriding the default package repository]: /tools/pub/custom-package-repositories#default-override
