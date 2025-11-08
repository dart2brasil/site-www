---
title: dart pub publish
description: Use dart pub publish para publicar seu pacote Dart no site pub.dev.
---

_Publish_ (publicar) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub publish [opções]
```

Este comando publica seu pacote no
[site pub.dev]({{site.pub}}) para qualquer pessoa baixar e usar como dependência.
Para obter informações sobre como preparar seu pacote para publicação e
quais arquivos você deve incluir ou excluir,
consulte [Publicando pacotes](/tools/pub/publishing).

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--dry-run` ou `-n` {:#dry-run-or-n}

Com isso, o pub passa pelo processo de validação, mas não faz o upload
do pacote. Isso é útil se você quiser verificar se o seu pacote atende a todos os
requisitos de publicação antes de realmente torná-lo público.

### `--force` ou `-f` {:#force-or-f}

Com isso, o pub não pede confirmação antes de publicar. Normalmente, ele
mostra o conteúdo do pacote e pede para você confirmar o upload.

Se o seu pacote tiver erros, o pub não faz o upload e sai com um erro.
No caso de avisos, seu pacote *é* enviado.
Para garantir que seu pacote não tenha avisos antes de enviar,
não use `--force` ou use `--dry-run` primeiro.

### `--skip-validation` {:#skip-validation}

Publica sem passar pelo processo de validação do lado do cliente ou resolver dependências.
Isso é útil para usuários avançados que sabem por que a validação falha e desejam contornar um problema específico.

**Exemplo:** Ao publicar no pub.dev, pode levar alguns minutos para que um pacote recém-publicado fique disponível.
Portanto, se você estiver publicando dois pacotes dependentes, onde o segundo depende do primeiro.
Você pode esperar alguns minutos entre a publicação do primeiro e do segundo, ou usar `--skip-validation`
para publicar o segundo pacote imediatamente, ignorando a validação do lado do cliente.

{% render 'pub-problems.md' %}

## Em um workspace (espaço de trabalho) {:#in-a-workspace}

Em um [workspace Pub](/tools/pub/workspaces), `dart pub publish` publica
o pacote no diretório atual.