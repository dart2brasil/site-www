---
title: dart pub publish
description: Use dart pub publish to publish your Dart package to the pub.dev site.
ia-translate: true
---

_Publish_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub publish [options]
```

Este comando publica seu pacote no
[site pub.dev]({{site.pub}}) para qualquer pessoa baixar e depender
dele. Para informações sobre como preparar seu pacote para publicação,
e quais arquivos você deve incluir ou excluir,
veja [Publishing packages](/tools/pub/publishing).

## Opções

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--dry-run` ou `-n`

Com isso, o pub passa pelo processo de validação mas não faz upload do
pacote. Isso é útil se você quiser ver se seu pacote atende a todos os
requisitos de publicação antes de estar pronto para realmente torná-lo público.

### `--force` ou `-f`

Com isso, o pub não pede confirmação antes de publicar. Normalmente, ele
mostra o conteúdo do pacote e pede para você confirmar o upload.

Se o seu pacote tiver erros, o pub não faz upload dele e sai com um erro.
No caso de avisos, seu pacote *é* enviado.
Para garantir que seu pacote não tenha avisos antes do upload,
não use `--force`, ou use `--dry-run` primeiro.

### `--skip-validation`

Publica sem passar pelo processo de validação do lado do cliente ou resolver dependências.
Isso é útil para usuários avançados que sabem por que a validação falha e desejam contornar um problema específico.

**Exemplo:** Ao publicar no pub.dev, pode levar alguns minutos para um pacote recém-publicado ficar disponível.
Portanto, se você estiver publicando dois pacotes dependentes, onde o segundo depende do primeiro.
Você pode esperar alguns minutos entre a publicação do primeiro e do segundo, ou usar `--skip-validation`
para publicar o segundo pacote imediatamente, contornando a validação do lado do cliente.

{% render 'pub-problems.md' %}

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces) `dart pub publish` publica
o pacote no diretório atual.
