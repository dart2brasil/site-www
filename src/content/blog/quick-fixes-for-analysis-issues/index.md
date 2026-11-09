---
ia-translate: true
title: "Quick fixes para problemas de análise"
description: "Resolvendo diagnósticos com um único clique"
publishDate: 2022-03-04
author: bwilkerson
image: images/0PHnbrlzf5BzJAyp8.webp
category: other
layout: blog
---


Se você é como eu, passa tempo demais no desenvolvimento corrigindo problemas (diagnósticos) que o analyzer encontra. Se você já desejou que isso fosse mais fácil, tenho boas notícias. Muitos dos diagnósticos produzidos pelo analyzer podem ser corrigidos automaticamente com quick fixes.

Um *quick fix* é uma edição automática voltada para corrigir o problema reportado por um diagnóstico específico. No artigo [Mensagens de diagnóstico do Dart](/blog/dart-diagnostic-messages), vimos o seguinte código:

<DashImage src="images/0PHnbrlzf5BzJAyp8.webp" alt="Code snippet showing an error with quick fix suggestions." />


A mensagem de correção sugere duas formas de resolver o problema: “Try making the access conditional (using ‘?.’) or adding a null check to the target (‘!’).”

Se você clicar na região destacada (a área com o sublinhado vermelho ondulado), verá um ícone de lâmpada perto da borda esquerda do editor. Se passar o mouse sobre ele, pode clicar para abrir um menu com os quick fixes disponíveis.

As duas correções sugeridas estão disponíveis no menu. Selecionar uma delas aplica a mudança ao seu código. Por exemplo, se você selecionar a primeira correção, o código será atualizado para o seguinte:

<DashImage src="images/0kv6ByFzA_oUH-1J-.webp" alt="Dart code after applying a quick fix, replacing values.length with values?.length inside a null check." />


Vamos primeiro dar uma olhada rápida em como aplicar uma correção no [IntelliJ IDEA](https://www.jetbrains.com/idea/) e no [Visual Studio Code](https://code.visualstudio.com/), e depois ver um exemplo mais poderoso do que os quick fixes podem fazer.

## IntelliJ IDEA {:#intellij-idea}

O menu de ações de contexto no editor fica assim:

<DashImage src="images/0SSy3gV3OrvEOjqyY.webp" alt="IntelliJ IDEA context actions menu offering to replace '.' with '?.' or add a null check for values.length." />


Você pode acessar a mesma lista selecionando “Show Context Actions” no menu de contexto do editor ou usando o atalho equivalente (**Alt+Enter** no Windows e Linux, ou **Option+Enter** no macOS).

Você também pode invocar essas correções diretamente pelo texto de hover ao passar o mouse sobre a região destacada. Se houver correções demais, há um item **More Actions** que também abre o menu:

<DashImage src="images/09fUhfo7YYZeSkbwJ.webp" alt="IntelliJ IDEA hover text explaining that values.length can't be unconditionally accessed and offering the ?. quick fix." />


Se isso não bastar, você também pode invocar as correções disponíveis pelo menu de contexto na view Dart Analysis:

<DashImage src="images/0KOFAwRRqF1nxP-X4.webp" alt="Dart Analysis context menu in IntelliJ IDEA offering quick fixes for the nullable values.length diagnostic." />


## Visual Studio Code {:#visual-studio-code}

O menu de code actions no editor fica assim:

<DashImage src="images/06MrUQEB2aHocDDXS.webp" alt="Visual Studio Code actions menu offering to replace '.' with '?.' or add a null check for values.length." />


Os dois primeiros itens são os quick fixes; os outros são refatorações. Você pode acessar a mesma lista pelo atalho equivalente (**Control+.** no Windows e Linux, ou **Command+.** no macOS), ou selecionando **Quick Fix …** no texto de hover do editor:

<DashImage src="images/0t9j1bNBN9t_H_vGm.webp" alt="An IDE showing the Problems panel in Visual Studio Code with a quick fix menu open offering to replace '.' with '?.'." />


Você também pode invocá-las pelo menu de contexto no painel Problems:

<DashImage src="images/0rD7c_L6FPLusv6lm.webp" alt="The Visual Studio Code context menu for a problem entry showing 'Quick Fix' and 'Copy' options." />


## Outro exemplo {:#another-example}

Embora a correção acima poupe o tempo e o esforço de encontrar a mensagem de correção e fazer a edição manualmente, adicionar um único caractere admitidamente não economiza muito tempo. No entanto, algumas correções proporcionam um ganho de produtividade maior. Considere o seguinte código:

<DashImage src="images/0JudcB_TM8lvc32Ld.webp" alt="An IDE showing the code 'await file.readAsString();' with a red squiggly line under 'await' and an error about using await in a non-async function." />


O diagnóstico informa que “the await expression can only be used in an async function”. Supondo que você não queira usar I/O síncrono, a correção é marcar o corpo da função com a keyword `async`. Ao fazer isso, surge outro erro dizendo que o tipo de retorno do método precisa ser `Future`, então você também acabará atualizando o tipo de retorno.

Felizmente, existe um quick fix para o problema original:

<DashImage src="images/0sgdKZfY_KVOLiIJU.webp" alt="An IDE showing the quick fix menu with 'Add async modifier' highlighted to fix the 'await' error." />


Selecionar essa correção não apenas adiciona o modificador, mas também atualiza o tipo de retorno, permitindo resolver o problema em um único passo:

<DashImage src="images/0WW-9wW23CnKxWZO2.webp" alt="An IDE showing the code after the quick fix, now with the 'async' keyword and the return type updated to a Future of String." />


## Resumo {:#summary}

Nem todo problema pode ser corrigido automaticamente, e nem todo problema que poderia ter um quick fix o tem. Ainda assim, vale a pena verificar se há um quick fix disponível na próxima vez que você tiver um diagnóstico para corrigir. E se você não encontrar uma correção para um diagnóstico que deveria ter uma, por favor nos avise [criando uma issue no dart-lang/sdk](https://github.com/dart-lang/sdk/issues/new).
