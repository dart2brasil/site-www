---
ia-translate: true
title: "Quick assists para edição"
description: "Usando refatorações localizadas para ser mais produtivo"
publishDate: 2022-07-13
author: bwilkerson
image: images/0V2JRi49yUj_MkFjS.webp
category: other
layout: blog
---


Você passa tempo demais fazendo tarefas repetitivas enquanto programa? Se sim, tenho boas notícias para você. Muitas dessas tarefas repetitivas podem ser feitas automaticamente com um recurso que chamamos de quick assists.

Um *quick assist* é uma edição automática voltada para fazer uma mudança comum no código. Diferente de um quick fix, que vimos em [Quick fixes para problemas de análise](/blog/quick-fixes-for-analysis-issues) e [Aplicação em lote de correções](/blog/bulk-application-of-fixes), a presença de um quick assist não é uma sugestão de que você deve mudar seu código; ele está ali simplesmente para facilitar o seu trabalho.

Vamos ver alguns exemplos.

## Declarando variáveis locais {:#declaring-local-variables}

Você provavelmente passa um bom tempo declarando e inicializando variáveis locais. As ferramentas podem ajudar com parte disso. Se você digitar a expressão de inicialização, pode usar um quick assist para criar uma variável local que captura o valor da expressão.

Se você começar com o código abaixo e posicionar o cursor em qualquer lugar da expressão, o ícone da lâmpada aparece perto da borda esquerda do editor. Se passar o mouse sobre ele, pode clicar para abrir um menu com os quick assists disponíveis.

<DashImage src="images/0V2JRi49yUj_MkFjS.webp" alt="Visual Studio Code showing the quick assist menu to extract a local variable." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0SH7NIMTeCdgyE2Uf.webp" alt="IntelliJ IDEA showing the quick assist menu to extract a local variable." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Escolher o assist insere uma declaração de variável, usando a expressão como inicializador, e seleciona o nome da variável para que você possa escolher um dos nomes sugeridos ou digitar o seu próprio:

<DashImage src="images/0zkIBfG56juJk2AuT.webp" alt="Visual Studio Code after extracting a local variable." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0jfAvjus6m7-TCP4S.webp" alt="IntelliJ IDEA after extracting a local variable." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Pressionar a tecla enter/return aceita o nome digitado.

## Estilos de corpo de função {:#function-body-styles}

Se você usa com frequência funções com corpo de expressão, provavelmente já precisou convertê-las em uma função com corpo de bloco em algum momento. Há um assist para isso também. Por exemplo, se você tiver um código como o seguinte e posicionar o cursor dentro da seta, verá as opções a seguir:

<DashImage src="images/0hp1u0YSRQsoNMaJl.webp" alt="Visual Studio Code showing the quick assist to convert an expression body to a block body." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0Ca5bRUzZ-Y4dHkw2.webp" alt="IntelliJ IDEA showing the quick assist to convert an expression body to a block body." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecionar “Convert to block body” reescreve o corpo da função para ficar assim:

<DashImage src="images/0mU7Y97eTeCILB1sr.webp" alt="Visual Studio Code after converting to a block body." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0miez1wvKHge96Ggl.webp" alt="IntelliJ IDEA after converting to a block body." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


E, sim, existe outro assist que converte de corpo de bloco para corpo de expressão.

## Reescrevendo instruções if {:#rewriting-if-statements}

Assists também podem ajudar em reestruturações maiores. Se você já escreveu código estruturado assim:

```
void f(int a, int b, int c, int d) {
  if (a == b) {
    if (a == c || a == d) {
      print(0);
    }
  }
}
```


e percebeu que poderia combinar as duas condições, existe um assist para isso. Coloque o cursor no `if` interno e abra o menu:

<DashImage src="images/06C745jOIAaB-k0f-.webp" alt="Visual Studio Code showing the quick assist to join an if statement with an outer if statement." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/09mRjNGVqm82qAeg0.webp" alt="IntelliJ IDEA showing the quick assist to join an if statement with an outer if statement." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecionar “Join ‘if’ statement with outer ‘if’ statement” reescreve o código para ficar assim:

```
void f(int a, int b, int c, int d) {
  if (a == b && (a == c || a == d)) {
    print(0);
  }
}
```


O assist também aparece se você colocar o cursor no `if` externo, embora, nesse caso, o menu diga “Join ‘if’ statement with inner ‘if’ statement”.

## Usando recursos mais novos da linguagem {:#using-newer-language-features}

Também há assists para ajudar a converter para recursos mais novos da linguagem. Por exemplo, se você tiver uma classe assim:

```
class A {
  A({int? x, int? y});
}

class B extends A {
  B({int? x, int? y}) : super(x: x, y: y);
}
```


em que o construtor da subclasse passa alguns parâmetros para a superclasse sem modificá-los, existe uma forma mais limpa de escrever o código. Coloque o cursor no nome do construtor `B` e abra o menu:

<DashImage src="images/0PGLOLXQPGGTZFTCE.webp" alt="Visual Studio Code showing the quick assist to convert to using super parameters." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0pfrf--11lE_B1oTf.webp" alt="IntelliJ IDEA showing the quick assist to convert to using super parameters." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecionar “Convert to using super parameters” reescreve o código para ficar assim:

<DashImage src="images/0Lr2HLGu31CqL5JLd.webp" alt="Visual Studio Code after converting to super parameters." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0nHsQKP9Wtm1UZn6-.webp" alt="IntelliJ IDEA after converting to super parameters." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Há mais assists disponíveis do que conseguimos cobrir em um único artigo. Da próxima vez que você for fazer uma edição que faz o tempo todo, confira as ações de contexto para ver se existe um assist que facilite a tarefa.
