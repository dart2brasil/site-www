---
ia-translate: true
title: DartPad
description: A ferramenta que permite brincar interativamente com Dart em um navegador.
---

DartPad é uma [ferramenta open source]({{site.repo.dart.org}}/dart-pad)
que permite brincar com a linguagem Dart em qualquer navegador moderno.
Muitas páginas deste site têm [DartPads incorporados](#embedding).
Para abrir o DartPad como uma página web independente, visite
o [site do DartPad (dartpad.dev)][DartPad]{:target="_blank" rel="noopener"}.

:::tip
Se você está na China, tente [dartpad.cn.](https://dartpad.cn)

Se você tiver problemas ao usar o DartPad, confira as
[dicas de solução de problemas do DartPad](/tools/dartpad/troubleshoot).
:::

Veja como o DartPad se parece quando configurado para executar Dart:

<img src="/assets/img/dartpad-hello.png" alt="Showcases what a Hello World app looks like in DartPad"/>


## Suporte a bibliotecas {:#library-support}

O DartPad suporta as [bibliotecas principais](/libraries) `dart:*` marcadas
como [multi-platform][].
Ao escrever aplicativos Flutter, o DartPad também suporta
as bibliotecas `package:flutter` e `dart:ui`.

O DartPad não suporta [deferred loading][]
nem o uso de pacotes do repositório [pub.dev]({{site.pub}})
além dos [pacotes atualmente suportados][currently supported packages].

[multi-platform]: /libraries#multi-platform-libraries
[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

## Primeiros passos {:#getting-started}

Para se familiarizar com o DartPad,
tente executar alguns exemplos e criar um aplicativo de linha de comando simples.


### Abra o DartPad e execute um exemplo {:#step-1-open-and-run}

1. Acesse o [DartPad][]{:target="_blank" rel="noopener"}.

   O código Dart aparece à esquerda, e
   a área de saída aparece à direita.

2. Escolha um exemplo Flutter, como **Sunflower**,
   usando o botão **Samples** no menu superior.

   A saída renderizada aparece à direita.


### Crie um aplicativo de linha de comando {:#step-2-server}

Para criar um aplicativo de linha de comando simples,
comece criando um novo snippet:

1. Clique no botão **New**
   e confirme que você deseja descartar as alterações do pad atual.

2. Clique na entrada com o logo do Dart.

3. Altere o código. Por exemplo, altere a função `main()`
   para conter este código:

   ```dart
   for (final char in 'hello'.split('')) {
     print(char);
   }
   ```

   Conforme você digita, o DartPad mostra dicas, documentação
   e sugestões de preenchimento automático.

4. Clique no botão **Format**.

   O DartPad usa o [formatador Dart](/tools/dart-format)
   para garantir que seu código tenha indentação, espaçamento
   e quebras de linha adequados.

5. Execute seu aplicativo.

6. Se você não cometeu nenhum erro ao digitar o código,
   tente introduzir um bug.

   Por exemplo, se você trocar `split` por `spit`,
   verá avisos no canto inferior direito da janela.
   Se executar o aplicativo, um erro de compilação aparece no console.


## Verificando as informações da versão do Dart {:#checking-dart-version-info}

As funcionalidades da linguagem e as APIs que o DartPad suporta dependem da
versão do **Dart SDK** que o DartPad está usando.
Você pode encontrar essa versão do SDK no canto inferior direito do DartPad.

## Incorporando o DartPad em páginas web {:#embedding}

Você pode incorporar o DartPad em páginas web,
personalizando-o para o seu caso de uso.
Por exemplo, o [tutorial de futures][futures tutorial]
contém vários DartPads incorporados
rotulados como _examples_ e _exercises_.

Para detalhes técnicos sobre como incorporar DartPads, veja o
[guia de incorporação do DartPad][DartPad embedding guide.]

[DartPad]: {{site.dartpad}}
[DartPad embedding guide.]: {{site.repo.dart.org}}/dart-pad/wiki/Embedding-Guide
[deferred loading]: /language/libraries#lazily-loading-a-library
[futures tutorial]: /libraries/async/async-await
