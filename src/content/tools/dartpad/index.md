---
ia-translate: true
title: DartPad
description: A ferramenta que permite você brincar interativamente com Dart em um navegador.
---

DartPad é uma [ferramenta open source]({{site.repo.dart.org}}/dart-pad)
que permite você brincar com a linguagem Dart em qualquer navegador moderno.
Muitas páginas neste site—especialmente [tutoriais](/tutorials), têm
[DartPads embutidos](#embedding).
Para abrir o DartPad como uma página web independente, visite
o [site do DartPad (dartpad.dev)][DartPad]{:target="_blank" rel="noopener"}.

:::tip
Se você está na China, tente [dartpad.cn.](https://dartpad.cn)

Se você tiver problemas ao usar o DartPad, confira as
[dicas de solução de problemas do DartPad](/tools/dartpad/troubleshoot).
:::

Veja como o DartPad se parece quando configurado para executar Dart:

<img src="/assets/img/dartpad-hello.png" alt="Showcases what a Hello World app looks like in DartPad"/>


## Suporte a bibliotecas

O DartPad suporta as [bibliotecas principais](/libraries) `dart:*` marcadas
como [multi-platform][].
Ao escrever aplicativos Flutter, o DartPad também suporta
as bibliotecas `package:flutter` e `dart:ui`.

O DartPad não suporta [deferred loading][]
ou usar pacotes do repositório de pacotes [pub.dev]({{site.pub}})
além dos [pacotes atualmente suportados][currently supported packages].

[multi-platform]: /libraries#multi-platform-libraries
[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

## Primeiros passos

Para se familiarizar com o DartPad,
tente executar alguns exemplos e criar um aplicativo de linha de comando simples.


### Abra o DartPad e execute um exemplo {:#step-1-open-and-run}

1. Vá para [DartPad][]{:target="_blank" rel="noopener"}.

   O código Dart aparece à esquerda, e
   um local para a saída aparece à direita.

2. Escolha um exemplo Flutter como **Sunflower**,
   usando o botão **Samples** no menu superior.

   A saída renderizada aparece à direita.


### Crie um aplicativo de linha de comando {:#step-2-server}

Para criar um aplicativo de linha de comando simples,
comece criando um novo snippet:

1. Clique no botão **New**,
   e confirme que você deseja descartar as alterações no pad atual.

2. Clique na entrada com o logo do Dart.

3. Altere o código. Por exemplo, altere a função `main()`
   para conter este código:

   ```dart
   for (final char in 'hello'.split('')) {
     print(char);
   }
   ```

   Conforme você digita, o DartPad mostra dicas, documentação,
   e sugestões de autocompletar.

4. Clique no botão **Format**.

   O DartPad usa o [formatador Dart](/tools/dart-format)
   para garantir que seu código tenha indentação adequada, espaço em branco,
   e quebra de linha.

5. Execute seu aplicativo.

6. Se você não teve bugs ao digitar o código,
   tente introduzir um bug.

   Por exemplo, se você alterar `split` para `spit`,
   você receberá avisos no canto inferior direito da janela.
   Se você executar o aplicativo, um erro de compilação aparece no console.


## Verificando informações da versão do Dart

As funcionalidades da linguagem e APIs que o DartPad suporta dependem da
versão do **Dart SDK** que o DartPad está usando atualmente.
Você pode encontrar esta versão do SDK no canto inferior direito do DartPad.

## Incorporando DartPad em páginas web {:#embedding}

Você pode incorporar o DartPad dentro de páginas web,
personalizando-o para atender ao seu caso de uso.
Por exemplo, o [tutorial de futures][futures tutorial]
contém múltiplos DartPads incorporados
rotulados como _examples_ e _exercises_.

Para detalhes técnicos sobre incorporar DartPads, veja o
[guia de incorporação do DartPad][DartPad embedding guide.].

[DartPad]: {{site.dartpad}}
[DartPad embedding guide.]: {{site.repo.dart.org}}/dart-pad/wiki/Embedding-Guide
[deferred loading]: /language/libraries#lazily-loading-a-library
[futures tutorial]: /libraries/async/async-await
