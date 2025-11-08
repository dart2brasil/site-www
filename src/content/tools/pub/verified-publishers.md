---
title: Verified publishers
description: Learn what verified publishers are, and they're verified.
ia-translate: true
---

O badge de verified publisher do pub.dev <img src="/assets/img/verified-publisher.svg" class="text-icon" alt="pub.dev verified publisher logo">
informa que o site pub.dev
verificou a identidade do publisher de um pacote.
Por exemplo, [dart.dev]({{site.pub}}/publishers/dart.dev/)
é o verified publisher para pacotes que o time Dart do Google
suporta.

O badge aparece em vários lugares no pub.dev,
ao lado de pacotes que verified publishers publicaram:

  * Resultados de pesquisa de pacotes
  * Páginas de detalhes de pacotes
  * Páginas de perfil de publisher
  * A página inicial do pub.dev

Cada publisher tem uma página com uma lista de
todos os pacotes pertencentes àquele publisher,
além de detalhes adicionais como o email de contato do publisher.
Para visitar a página do publisher, clique no link de identidade do publisher
(por exemplo, `dart.dev`) ao lado do badge de verified publisher
<img
class="text-icon"
  src="/assets/img/verified-publisher.svg"
  alt="pub.dev verified publisher logo">.

## Verification process

Para garantir que criar verified publishers seja de baixo custo e disponível para qualquer um,
pub.dev depende de domínios DNS (domain name system) como um token de identificação.
Escolhemos verificação DNS porque muitos autores de pacotes
já têm um domínio confiável e uma homepage para aquele domínio.
Durante o [processo de criação de publisher][publishing page],
pub.dev verifica que o usuário criando o verified publisher tem
acesso admin à ["Domain Property"][domain-prop] associada,
baseado na lógica existente no [Google Search Console.][search-console]

:::note
A propriedade do nome de domínio é verificada apenas uma vez quando um publisher é criado. Depois disso:

- Perder o controle de um domínio não faz com que o dono original do publisher perca acesso ao publisher.
- Adquirir um domínio não concede ao novo dono nenhum direito a um publisher que foi previamente associado a ele.
- A propriedade do publisher deve ser explicitamente transferida pelo dono atual do publisher.
:::

## Creating a verified publisher account

Se você publica pacotes e quer criar um novo verified publisher,
veja as instruções na [página de publicação][publishing page].

[domain-prop]: https://support.google.com/webmasters/answer/34592
[publishing page]: /tools/pub/publishing#create-verified-publisher
[search-console]: https://search.google.com/search-console/about
