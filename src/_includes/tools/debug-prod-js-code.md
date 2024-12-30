<!-- ia-translate: true -->

## Depurando código de produção {:#debugging}

Esta seção oferece dicas para depurar código compilado para produção
no Chrome, Firefox e Safari. Você só pode depurar código JavaScript em
navegadores que suportam source maps, como o Chrome.

:::tip
Sempre que possível, em vez de depurar código de produção,
depure o código usando um servidor de desenvolvimento como o fornecido por [`webdev`][`webdev`].
:::

[`webdev`]: /tools/webdev

Qualquer que seja o navegador que você use, você deve habilitar a pausa em pelo menos
exceções não capturadas, e talvez em todas as exceções.
Para frameworks como `dart:async` que envolvem o código do usuário em try-catch,
recomendamos pausar em todas as exceções.

[debugging web apps]: /web/debugging

### Chrome {:#dart2js-debugging-chrome}

Para depurar no Chrome:

1. Abra a janela Developer Tools, conforme descrito na
   [documentação do Chrome DevTools.](https://developer.chrome.com/docs/devtools/)
2. Ative os source maps, conforme descrito no vídeo
   [SourceMaps in Chrome.](https://bit.ly/YugIUY)
3. Habilite a depuração, seja em todas as exceções ou apenas em exceções não capturadas,
   conforme descrito em
   [Como definir breakpoints.](https://developer.chrome.com/docs/devtools/javascript/breakpoints/)
4. Recarregue seu aplicativo.

### Edge {:#dart2js-debugging-ie}

Para depurar no Edge:

1. Atualize para a versão mais recente do Edge.
2. Carregue as **Ferramentas de Desenvolvedor** (**[F12](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide-chromium/landing/)**).
3. Recarregue o aplicativo. A aba **debugger** mostra os arquivos com source maps.
4. O comportamento de exceção pode ser controlado através de **Ctrl+Shift+E**;
   o padrão é **Interromper em exceções não tratadas**.

### Firefox {:#dart2js-debugging-firefox}

Para depurar no Firefox:

1. Abra a janela **Ferramentas de Desenvolvimento Web**, conforme descrito na
   [documentação de ferramentas de desenvolvedor do Firefox](https://firefox-source-docs.mozilla.org/devtools-user/index.html).
2. Habilite **Pausar em exceções**, conforme mostrado na figura a seguir:

   <img width="640px" src="/assets/img/ff-debug.png" alt="Habilitar Pausar em exceções no depurador do Firefox">

3. Recarregue o aplicativo. A aba **Debugger** mostra os arquivos com source maps.

### Safari {:#dart2js-debugging-safari}

Para depurar no Safari:

1. Ative o menu **Desenvolver**,
   conforme descrito no [Tutorial do Inspetor da Web do Safari.]({{site.apple-dev}}/library/archive/documentation/NetworkingInternetWeb/Conceptual/Web_Inspector_Tutorial/EnableWebInspector/EnableWebInspector.html)
2. Habilite interrupções, seja em todas as exceções ou apenas em exceções não capturadas.
   Veja [Adicionar um breakpoint JavaScript](https://support.apple.com/en-ca/guide/safari-developer/add-a-javascript-breakpoint-dev5e4caf347/mac) em [Ajuda para Desenvolvedores do Safari.](https://support.apple.com/en-ca/guide/safari-developer/welcome/mac)
3. Recarregue seu aplicativo.
