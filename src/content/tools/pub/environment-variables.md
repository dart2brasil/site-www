---
ia-translate: true
title: Configurando variáveis de ambiente do pub
shortTitle: Variáveis de ambiente do pub
description: >-
  Como configurar o seu ambiente para a ferramenta de gerenciamento de pacotes do Dart, o pub.
showToc: false
---

Variáveis de ambiente permitem que você personalize o pub de acordo com as suas necessidades.

`PUB_CACHE`
: Algumas das dependências do pub são baixadas para o cache do pub.
  Por padrão, esse diretório fica em
  `$HOME/.pub-cache` (no macOS e no Linux),
  ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows). (A localização exata do
  cache pode variar dependendo da versão do Windows.)
  Você pode usar a variável de ambiente `PUB_CACHE`
  para especificar outro local. Para mais informações, veja
  [O cache de pacotes do sistema](/tools/pub/cmd/pub-get#the-system-package-cache).

`PUB_HOSTED_URL`
: O pub baixa dependências do [site pub.dev.]({{site.pub}})
  Para especificar o local de um servidor espelho (mirror) específico,
  use a variável de ambiente `PUB_HOSTED_URL`. Por exemplo:

```bash
PUB_HOSTED_URL = https://pub.example.com
```

Para mais informações sobre o uso de um repositório de pacotes privado,
veja [Sobrescrever o repositório de pacotes padrão][Overriding the default package repository].

:::note
Se você estiver tentando usar `pub get` atrás de um firewall corporativo
e ele falhar,
veja [`pub get` fails from behind a corporate firewall][]
para informações sobre como configurar as variáveis de ambiente de proxy
para a sua plataforma.
:::

[`pub get` fails from behind a corporate firewall]: /tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall
[Overriding the default package repository]: /tools/pub/custom-package-repositories#default-override
