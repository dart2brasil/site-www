---
ia-translate: true
title: Solução de Problemas no DartPad
description: Problemas comuns ao usar o DartPad
---

Esta página descreve soluções para problemas que podem ocorrer quando você
está tentando usar o DartPad, seja em [dartpad.dev]({{site.dartpad}})
ou em uma página que tenha DartPads embutidos.
Para uma visão geral do DartPad, consulte a
[página do DartPad](/tools/dartpad).


## DartPads Embutidos não Aparecem {:#embedded-dartpads-dont-appear}

A página inicial do dartbrasil.dev e muitos tutoriais têm DartPads embutidos.
Se esses DartPads não aparecerem,
tente o seguinte:

* Certifique-se de que está usando uma das duas versões mais recentes do Chrome,
  Edge, Firefox ou Safari.
  O DartPad pode não funcionar em outros navegadores e é sabido que não funciona
  na configuração padrão do navegador Brave.

* Se você estiver usando um bloqueador de anúncios, desative-o.

* Verifique se você desabilitou o rastreamento de cookies de terceiros
  ([Instruções do Chrome][chrome-cookies]).
  Se você desabilitou os cookies, altere suas configurações para
  **permitir cookies para dartpad.dev**.
  Se você estiver usando DartPads embutidos,
  como na [folha de referência do Dart](/resources/dart-cheatsheet) ou no
  [codelab de animações implícitas]({{site.flutter-docs}}/codelabs/implicit-animations),
  você também pode precisar permitir cookies para o domínio do site de incorporação,
  (nesses casos, **dartbrasil.dev** e **docs.flutter.dev**, respectivamente).

* Se você recarregar repetidamente uma página que contém DartPads embutidos,
  você pode se deparar com a [limitação de taxa do GitHub][].
  Dentro de 60 minutos, você deverá conseguir recarregar a página e
  ver o código nos DartPads embutidos.

Embora o DartPad não use cookies, ele depende do armazenamento local (local storage),
que os navegadores geralmente desabilitam quando os cookies estão desabilitados.


## Código não Funciona Fora do DartPad {:#code-doesn-t-work-outside-dartpad}

Se você copiar código do DartPad para outro ambiente,
o código pode não ser executado com sucesso.
Aqui estão algumas possíveis causas e correções:

* Se o Dart não conseguir encontrar uma biblioteca importada,
  certifique-se de que você adicionou todas as dependências de pacote necessárias.
  O DartPad inclui muitos pacotes (packages) internos por padrão,
  mas seu próprio projeto deve listar explicitamente os pacotes dos quais depende.
  Para ver os pacotes que o DartPad inclui,
  vá para [dartpad.dev]({{site.dartpad}})
  e clique no ícone **i** no canto inferior direito da janela.
  Para saber mais sobre como adicionar dependências de pacote ao seu próprio projeto,
  consulte a documentação para [`dart pub add`](/tools/pub/cmd/pub-add).

* Se o Dart não conseguir encontrar certos métodos ou propriedades,
  verifique o código fornecido junto com o exercício.

* Se o código tiver outros erros de compilação,
  certifique-se de que está usando a versão estável mais recente do SDK Dart.
  O DartPad e exemplos embutidos
  geralmente usam a versão estável mais recente do SDK,
  e versões mais antigas podem estar faltando recursos de linguagem ou biblioteca necessários.
  Para saber como atualizar o SDK Dart,
  consulte [Obtenha o SDK Dart](/get-dart).

* Se você estiver criando um aplicativo web,
  certifique-se de que tem a configuração de projeto correta.
  O DartPad não mostra toda a marcação (markup) necessária para executar o código Dart.
  Para começar a criar aplicativos web com Dart,
  confira [Crie um aplicativo web com Dart](/web/get-started).

## Código que Funcionava Anteriormente Agora tem Erros {:#previously-working-code-now-has-errors}

Se o código estiver usando recursos de linguagem ou biblioteca que não são mais suportados
na versão estável mais recente do Dart,
o código pode não ser mais analisado ou executado sem erros.

* Se possível, atualize o código para funcionar com a versão mais recente do Dart,
  já que o DartPad só suporta os canais **stable** e **beta**.
* Se o código funcionou em uma versão anterior do Dart,
  você pode usar essa versão do Dart localmente.
  Para saber como instalar uma versão específica do Dart,
  confira [Obtenha o SDK Dart](/get-dart).

## DartPad não Funciona na China {:#dartpad-doesn-t-work-in-china}

Tente [dartpad.cn.](https://dartpad.cn)

## Outras Questões {:#other-issues}

Se você tiver outros problemas ao usar o DartPad,
[crie uma issue no GitHub.][new-issue]

[GitHub rate limiting.]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
[browser]: /resources/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: {{site.repo.dart.org}}/dart-pad/issues/new