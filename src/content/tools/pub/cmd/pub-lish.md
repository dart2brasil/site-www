---
ia-translate: true
title: dart pub publish
description: Use dart pub publish para publicar seu pacote Dart no site pub.dev.
---

_Publish_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub publish [options]
```

Este comando publica seu pacote no
[site pub.dev]({{site.pub}}) para que qualquer pessoa possa baixá-lo e depender
dele. Para informações sobre como preparar seu pacote para publicação
e quais arquivos você deve incluir ou excluir,
veja [Publicando pacotes](/tools/pub/publishing).

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--dry-run` ou `-n`

Com essa opção, o pub passa pelo processo de validação, mas não faz o upload do
pacote. Isso é útil se você quiser verificar se o seu pacote atende a todos os
requisitos de publicação antes de estar pronto para torná-lo público de fato.

### `--force` ou `-f`

Com essa opção, o pub não pede confirmação antes de publicar. Normalmente, ele
mostra o conteúdo do pacote e pede que você confirme o upload.

Se o seu pacote tiver erros, o pub não faz o upload e encerra com um erro.
Em caso de avisos, o seu pacote *é* enviado.
Para garantir que o seu pacote não tenha avisos antes do upload,
não use `--force` ou use `--dry-run` primeiro.

### `--skip-validation`

Publica sem passar pelo processo de validação do lado do cliente nem resolver dependências.
Isso é útil para usuários avançados que sabem por que a validação falha e querem contornar um problema específico.

**Exemplo:** ao publicar no pub.dev, pode levar alguns minutos para um pacote recém-publicado
ficar disponível.
Portanto, se você estiver publicando dois pacotes dependentes, em que o segundo depende do primeiro,
pode esperar alguns minutos entre a publicação do primeiro e a do segundo, ou
usar `--skip-validation` para publicar o segundo pacote imediatamente,
contornando a validação do lado do cliente.

{% render 'pub-problems.md' %}

## Em um workspace {:#in-a-workspace}

Em um [workspace do pub](/tools/pub/workspaces), `dart pub publish` publica
o pacote no diretório atual.
