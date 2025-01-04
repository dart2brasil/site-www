---
ia-translate: true
title: DartPad
description: A ferramenta que permite interagir interativamente com Dart em um navegador.
---

DartPad é uma [ferramenta de código aberto]({{site.repo.dart.org}}/dart-pad)
que permite que você interaja com a linguagem Dart em qualquer navegador moderno.
Muitas páginas neste site—especialmente [tutoriais](/tutorials), têm
[DartPads embutidos](#embedding).
Para abrir o DartPad como uma página da web independente, visite
o [site do DartPad (dartpad.dev)][DartPad]{:target="_blank" rel="noopener"}.

:::tip
Se você estiver na China, tente [dartpad.cn](https://dartpad.cn).

Se você tiver problemas ao usar o DartPad, consulte as
[dicas de solução de problemas do DartPad](/tools/dartpad/troubleshoot).
:::

Veja como o DartPad se parece quando configurado para executar Dart:

<img
   src="/assets/img/dartpad-hello.png"
   alt="Mostra como um aplicativo Hello World se parece no DartPad">


## Suporte à biblioteca {:#library-support}

O DartPad suporta as `dart:*` [bibliotecas principais](/libraries) marcadas
como [multiplataforma][].
Ao escrever aplicativos Flutter, o DartPad também suporta
as bibliotecas `package:flutter` e `dart:ui`.

O DartPad não suporta [carregamento adiado][]
ou usar pacotes do repositório de pacotes [pub.dev]({{site.pub}})
além dos [pacotes atualmente suportados][].

[multi-platform]: /libraries#multi-platform-libraries
[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

## Começando {:#getting-started}

Para se familiarizar com o DartPad,
tente executar alguns exemplos e criar um aplicativo simples de linha de comando.


### Abrir o DartPad e executar um exemplo {:#step-1-open-and-run}

1. Vá para [DartPad][]{:target="_blank" rel="noopener"}.

   O código Dart aparece à esquerda, e
   um local para a saída aparece à direita.

2. Escolha um exemplo do Flutter como **Sunflower**,
   usando o botão **Samples** no menu superior.

   A saída renderizada aparece à direita.


### Criar um aplicativo de linha de comando {:#step-2-server}

Para criar um aplicativo simples de linha de comando,
comece criando um novo snippet (trecho):

1. Clique no botão **New** (Novo),
   e confirme que você deseja descartar as alterações no pad (bloco) atual.

2. Clique na entrada com o logo do Dart.

3. Altere o código. Por exemplo, altere a função `main()`
   para conter este código:

   ```dart
   for (final char in 'hello'.split('')) {
     print(char);
   }
   ```

   Enquanto você digita, o DartPad mostra dicas, documentação,
   e sugestões de preenchimento automático.

4. Clique no botão **Format** (Formatar).

   O DartPad usa o [formatador Dart](/tools/dart-format)
   para garantir que seu código tenha indentação adequada, espaço em branco,
   e quebra de linha.

5. Execute seu aplicativo.

6. Se você não teve nenhum bug (erro) enquanto inseria o código,
   tente introduzir um bug.

   Por exemplo, se você mudar `split` para `spit`,
   você obterá avisos na parte inferior direita da janela.
   Se você executar o aplicativo, um erro de compilação aparecerá no console.


## Verificando informações da versão do Dart {:#checking-dart-version-info}

Os recursos da linguagem e as APIs que o DartPad suporta dependem da
versão do **Dart SDK** que o DartPad está usando no momento.
Você pode encontrar esta versão do SDK na parte inferior direita do DartPad.

## Incorporando o DartPad em páginas da web {:#embedding}

Você pode incorporar o DartPad dentro de páginas da web,
personalizando-o para adequar ao seu caso de uso.
Por exemplo, o [tutorial de futures][]
contém vários DartPads incorporados
rotulados como _examples_ (exemplos) e _exercises_ (exercícios).

Para detalhes técnicos sobre como incorporar DartPads, consulte o
[guia de incorporação do DartPad.][]

[DartPad]: {{site.dartpad}}
[DartPad embedding guide.]: {{site.repo.dart.org}}/dart-pad/wiki/Embedding-Guide
[deferred loading]: /language/libraries#lazily-loading-a-library
[futures tutorial]: /libraries/async/async-await