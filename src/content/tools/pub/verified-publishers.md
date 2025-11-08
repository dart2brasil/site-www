---
ia-translate: true
title: Editores verificados
description: Saiba o que são editores verificados e como eles são verificados.
---

O selo de editor verificado do pub.dev <img src="/assets/img/verified-publisher.svg" class="text-icon" alt="logotipo de editor verificado do pub.dev">
permite que você saiba que o site pub.dev
verificou a identidade do editor de um pacote.
Por exemplo, [dartbrasil.dev]({{site.pub}}/publishers/dartbrasil.dev/)
é o editor verificado para pacotes que a equipe Dart
do Google suporta.

O selo aparece em vários locais no pub.dev,
ao lado de pacotes que editores verificados publicaram:

  * Resultados da pesquisa de pacotes
  * Páginas de detalhes do pacote
  * Páginas de perfil do editor
  * A página inicial do pub.dev

Cada editor tem uma página com uma lista de
todos os pacotes pertencentes a esse editor,
além de detalhes adicionais, como o e-mail de contato do editor.
Para visitar a página do editor, clique no link de identidade do editor
(por exemplo, `dartbrasil.dev`) ao lado do selo de editor verificado
<img
class="text-icon"
  src="/assets/img/verified-publisher.svg"
  alt="logotipo de editor verificado do pub.dev">.

## Processo de verificação {:#verification-process}

Para garantir que a criação de editores verificados seja de baixo custo e disponível para qualquer pessoa,
o pub.dev usa domínios DNS (sistema de nomes de domínio) como um token de identificação.
Escolhemos a verificação de DNS porque muitos autores de pacotes
já possuem um domínio confiável e uma página inicial para esse domínio.
Durante o [processo de criação de editor][publishing page],
o pub.dev verifica se o usuário que está criando o editor verificado tem
acesso de administrador à ["Propriedade do Domínio"][domain-prop] associada,
com base na lógica existente no [Google Search Console.][search-console]

:::note
Domain name ownership is verified only once when a publisher is created. After that:

- Losing control of a domain does not cause the original publisher owner to lose access to the publisher.
- Acquiring a domain does not grant the new owner any rights to a publisher that was previously associated with it.
- Publisher ownership must be explicitly transferred by the current publisher owner.
:::

## Creating a verified publisher account

Se você publica pacotes e deseja criar um novo editor verificado,
consulte as instruções na [página de publicação][publishing page].

[domain-prop]: https://support.google.com/webmasters/answer/34592
[publishing page]: /tools/pub/publishing#create-verified-publisher
[search-console]: https://search.google.com/search-console/about