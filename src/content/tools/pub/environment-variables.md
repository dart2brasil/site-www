---
ia-translate: true
title: "Configurando variáveis de ambiente do pub"
shortTitle: Variáveis de ambiente do Pub
description: >-
  Como configurar seu ambiente para a ferramenta de gerenciamento de pacotes do Dart, pub.
showToc: false
---

Variáveis de ambiente permitem que você personalize o pub para atender às suas necessidades.

`PUB_CACHE`
: Algumas dependências do pub são baixadas para o cache do pub.
  Por padrão, este diretório está localizado em
  `$HOME/.pub-cache` (no macOS e Linux),
  ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows). (A localização precisa do
  cache pode variar dependendo da versão do Windows.)
  Você pode usar a variável de ambiente `PUB_CACHE`
  para especificar outro local. Para mais informações, veja
  [O cache de pacotes do sistema](/tools/pub/cmd/pub-get#the-system-package-cache).

`PUB_HOSTED_URL`
: O Pub baixa dependências do [site pub.dev.]({{site.pub}})
  Para especificar a localização de um servidor espelho em particular,
  use a variável de ambiente `PUB_HOSTED_URL`. Por exemplo:

```bash
PUB_HOSTED_URL = https://pub.example.com
```

Para mais informações sobre como usar um repositório de pacotes privado,
veja [Substituindo o repositório de pacotes padrão][].

:::note
Se você está tentando usar `pub get` por trás de um firewall corporativo
e ele falha,
por favor veja [`pub get` falha por trás de um firewall corporativo][]
para informações sobre como configurar as variáveis de ambiente de proxy
para sua plataforma.
:::

[`pub get` falha por trás de um firewall corporativo]: /tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall
[Substituindo o repositório de pacotes padrão]: /tools/pub/custom-package-repositories#default-override
