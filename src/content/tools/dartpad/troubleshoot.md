---
ia-translate: true
title: Solução de problemas do DartPad
breadcrumb: Solução de problemas
description: Problemas comuns ao usar o DartPad
---

Esta página descreve soluções para problemas que podem ocorrer quando
você tenta usar o DartPad, seja em [dartpad.dev]({{site.dartpad}})
ou em uma página que tem DartPads incorporados.
Para uma visão geral do DartPad, veja a
[página do DartPad](/tools/dartpad).


## DartPads incorporados não aparecem {:#embedded-dartpads-dont-appear}

A página inicial do dart.dev e muitos tutoriais têm DartPads incorporados.
Se esses DartPads não aparecerem,
tente o seguinte:

* Certifique-se de que você está usando uma das duas versões mais recentes do Chrome,
  Edge, Firefox ou Safari.
  O DartPad pode não funcionar em outros navegadores e é conhecido por não funcionar na
  configuração padrão do navegador Brave.

* Se você estiver usando um bloqueador de anúncios, desative-o.

* Verifique se você desabilitou cookies de rastreamento de terceiros
  ([instruções do Chrome][chrome-cookies]).
  Se você desabilitou os cookies, altere suas configurações para
  **permitir cookies para dartpad.dev**.
  Se você estiver usando DartPads incorporados,
  como no [Dart cheatsheet](/resources/dart-cheatsheet) ou no
  [codelab de animações implícitas]({{site.flutter-docs}}/codelabs/implicit-animations),
  você também pode precisar permitir cookies para o domínio do site que os incorpora
  (nesses casos, **dart.dev** e **docs.flutter.dev**, respectivamente).

* Se você recarregar repetidamente uma página que contém DartPads incorporados,
  pode encontrar o [limite de requisições do GitHub][GitHub rate limiting.].
  Em até 60 minutos, você deve conseguir recarregar a página e
  ver o código nos DartPads incorporados.

Embora o DartPad não use cookies, ele depende de armazenamento local,
que os navegadores geralmente desabilitam quando os cookies estão desabilitados.


## O código não funciona fora do DartPad {:#code-doesnt-work-outside-dartpad}

Se você copiar código do DartPad para outro ambiente,
o código pode não ser executado com sucesso.
Aqui estão algumas possíveis causas e correções:

* Se o Dart não conseguir encontrar uma biblioteca importada,
  certifique-se de ter adicionado todas as dependências de pacotes necessárias.
  O DartPad inclui muitos pacotes integrados por padrão,
  mas o seu próprio projeto deve listar explicitamente os pacotes dos quais depende.
  Para ver os pacotes que o DartPad inclui,
  acesse [dartpad.dev]({{site.dartpad}})
  e clique no ícone **i** no canto inferior direito da janela.
  Para saber mais sobre como adicionar dependências de pacotes ao seu projeto,
  veja a documentação de [`dart pub add`](/tools/pub/cmd/pub-add).

* Se o Dart não conseguir encontrar certos métodos ou propriedades,
  verifique o código fornecido junto com o exercício.

* Se o código tiver outros erros de compilação,
  certifique-se de estar usando a versão estável mais recente do Dart SDK.
  O DartPad e os exemplos incorporados
  geralmente usam a versão estável mais recente do SDK,
  e versões mais antigas podem não ter funcionalidades de linguagem ou biblioteca necessárias.
  Para aprender a atualizar o Dart SDK,
  veja [Obter o Dart SDK](/get-dart).

* Se você estiver criando um aplicativo web,
  certifique-se de ter a configuração adequada do projeto.
  O DartPad não mostra toda a marcação necessária para executar código Dart.
  Para começar a criar aplicativos web com Dart,
  confira [Construa um aplicativo web com Dart](/web/get-started).

## Código que funcionava antes agora tem erros {:#previously-working-code-now-has-errors}

Se o código usa funcionalidades de linguagem ou biblioteca que não são mais suportadas
na versão estável mais recente do Dart,
ele pode não analisar nem executar sem erros.

* Se possível, atualize o código para funcionar com a versão mais recente do Dart,
  pois o DartPad suporta apenas os canais **stable** e **beta**.
* Se o código funcionou em uma versão anterior do Dart,
  você pode usar essa versão localmente.
  Para aprender a instalar uma versão específica do Dart,
  confira [Obter o Dart SDK](/get-dart).

## DartPad não funciona na China {:#dartpad-doesnt-work-in-china}

Tente [dartpad.cn.](https://dartpad.cn)

## Outros problemas {:#other-issues}

Se você tiver outros problemas ao usar o DartPad,
[crie uma issue no GitHub][new-issue].

[GitHub rate limiting.]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: {{site.repo.dart.org}}/dart-pad/issues/new
