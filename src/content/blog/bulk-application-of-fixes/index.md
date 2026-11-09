---
ia-translate: true
title: "Aplicação em massa de correções"
description: "Corrigindo vários problemas de análise de uma só vez"
publishDate: 2022-05-05
author: bwilkerson
image: images/0URmNnWSjGRGOorjv.webp
category: other
layout: blog
---


Em [Correções rápidas para problemas de análise](/blog/quick-fixes-for-analysis-issues) vimos o suporte para corrigir automaticamente diagnósticos individuais enquanto você edita. Às vezes, nem isso é rápido o bastante, e você gostaria de corrigir vários diagnósticos de uma só vez. Felizmente, existe suporte para isso também, e é sobre ele que este artigo trata.

Há várias formas de corrigir vários diagnósticos, dependendo de quantos você quer corrigir, e vamos ver cada uma separadamente.

## Corrigindo várias ocorrências do mesmo diagnóstico {:#fixing-multiple-occurrences-of-the-same-diagnostics}

Você já refatorou seu código movendo uma classe para outro arquivo? Se sim, é bem provável que alguns imports só fossem necessários por causa de referências na classe que foi movida, o que deixa você com imports não utilizados:

<DashImage src="images/0URmNnWSjGRGOorjv.webp" alt="Um trecho de código no Visual Studio Code mostrando avisos de imports não utilizados." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/03QaE0FunXWpPp2Az.webp" alt="Um trecho de código no IntelliJ IDEA mostrando avisos de imports não utilizados." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Para qualquer correção que possa ser aplicada mais de uma vez no mesmo arquivo, a ferramenta oferece a opção de aplicá-la em todo o arquivo.

Essas correções aparecem nos mesmos lugares que as outras e geralmente têm rótulos parecidos com os das correções de um único local, mas com alguma frase como “no arquivo” acrescentada. Por exemplo, veja como essa correção aparece no seu IDE:

<DashImage src="images/0p2Pf06L6A4JSX7IS.webp" alt="Um menu de contexto no Visual Studio Code oferecendo a remoção de todos os imports não utilizados no arquivo." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0S4UnOqdx-h0U55jU.webp" alt="Um menu de contexto no IntelliJ IDEA oferecendo a remoção de todos os imports não utilizados no arquivo." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Escolher a correção “no arquivo” faz exatamente o que você espera: remove todos os imports não utilizados do arquivo:

<DashImage src="images/0dHw4rjdxTR0liZX8.webp" alt="O trecho de código no Visual Studio Code depois de remover os imports não utilizados." caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0Wk6qnyUlNr3qN0GQ.webp" alt="O trecho de código no IntelliJ IDEA depois de remover os imports não utilizados." caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


## Corrigindo todos os diagnósticos de um arquivo {:#fixing-all-the-diagnostics-in-a-file}

Isso é ótimo, mas só corrige um tipo de diagnóstico, e exige que você encontre o lugar onde o diagnóstico é reportado (no editor ou na view de problemas) para invocar a correção. Parece que a ferramenta poderia fazer mais.

E no [Visual Studio Code](https://code.visualstudio.com/), ela pode. Você pode aplicar correções para todos os diagnósticos de um único arquivo. Para ver como, vamos usar o mesmo exemplo de antes:

<DashImage src="images/0mr1A2XnnRCaamU22.webp" alt="Um editor de código mostrando vários avisos de imports não utilizados marcados com sublinhados azuis ondulados." />


Se você clicar com o botão direito para abrir o menu de contexto, verá o seguinte:

<DashImage src="images/03klKEJk5p40lCPbO.webp" alt="O menu de contexto do botão direito no Visual Studio Code com 'Source Action...' destacado." />


Se você selecionar **Source Action…**, ele abre um segundo menu:

<DashImage src="images/0iRZIzPrwKl7jEYNY.webp" alt="O menu 'Source Action...' no Visual Studio Code exibindo as opções 'Sort Members', 'Organize Imports' e 'Fix All'." />


Selecionar **Fix All** faz com que as correções sejam aplicadas a todos os diagnósticos do editor, produzindo o seguinte resultado:

<DashImage src="images/0FDf16dDPwfPg_dET.webp" alt="O editor de código depois de selecionar 'Fix All', mostrando que os imports não utilizados foram removidos com sucesso." />


Você também pode invocar o comando **Fix All** pela paleta de comandos, que pode ser aberta selecionando **Command Palette…** no menu **View** ou usando o atalho de teclado (`F1` em qualquer plataforma, `Control+Shift+P` no Windows e no Linux, ou `Command+Shift+P` no macOS). Você pode filtrar a lista digitando o nome do comando. A paleta de comandos fica mais ou menos assim:

<DashImage src="images/0Jrz3MRfYVtcXrb9C.webp" alt="A paleta de comandos do Visual Studio Code com 'fix' digitado na barra de busca, mostrando o comando 'Fix All'." />


## Corrigindo todos os diagnósticos de um diretório {:#fixing-all-the-diagnostics-in-a-directory}

A ferramenta mais completa que temos para corrigir diagnósticos é o comando de linha de comando [`dart fix`](https://dart.dev/tools/dart-fix). Ele pode corrigir todos os diagnósticos de um diretório, o que significa que você pode usá-lo para corrigir tudo no seu pacote ou aplicativo.

Claro, há algumas ressalvas. Ele não corrige todos os diagnósticos, porque aplica as mesmas correções rápidas disponíveis no IDE, e nem todo diagnóstico tem uma correção rápida. Ele também não aplica correções rápidas para diagnósticos quando há várias formas igualmente válidas de resolver o problema, porque não tem como saber qual correção você prefere. Essas ressalvas também valem para o comando **Fix All** descrito na seção anterior.

Embora a necessidade dessa ferramenta não surja com frequência (o que é um dos motivos para você talvez não a conhecer), há algumas situações em que ela é especialmente útil.

Primeiro, considere o caso em que você quer habilitar uma nova lint, ou até um conjunto de lints, como um dos conjuntos de regras [`core`](https://github.com/dart-lang/lints/blob/main/lib/core.yaml), [`recommended`](https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml) ou [`flutter`](https://github.com/flutter/packages/blob/master/packages/flutter_lints/lib/flutter.yaml). As chances são boas de que haja pelo menos algumas violações dessas regras no seu pacote. Se houver uma correção associada à lint, é conveniente aplicá-la em todos os lugares de uma só vez, em vez de corrigir cada violação individualmente.

Segundo, considere o caso em que você está atualizando de uma versão do Flutter para outra. Se houve mudanças de API entre as duas versões, há uma boa chance de existir uma correção para atualizar seu código e adequá-lo à versão mais recente. De novo, é conveniente que todas essas mudanças sejam aplicadas em uma única operação.

É aí que entra o comando [`dart fix`](https://dart.dev/tools/dart-fix). Ele pode aplicar correções rápidas para vários diagnósticos em vários arquivos.

O comando tem dois modos. O modo *dry-run* informa quantas mudanças ele pode aplicar e quais diagnósticos pode corrigir, mas sem modificar nenhum arquivo. O modo *apply* aplica as mudanças.

Você pode informar o caminho do diretório que contém os arquivos a serem corrigidos. Se omitir o diretório, ele corrige recursivamente todos os arquivos do diretório atual e dos seus subdiretórios.

Vamos supor que você tenha habilitado a lint `prefer_single_quotes` e que tenha um arquivo com o seguinte conteúdo:

```
import 'package:logging/logging.dart';

void main() {
  var logger = Logger("myApp");
  logger.info("Entering myApp");
  // Do stuff.
  logger.info("Exiting myApp");
}
```


Executar o comando [`dart fix`](https://dart.dev/tools/dart-fix) com a opção `--dry-run` a partir do diretório que contém esse arquivo produz a seguinte saída:

```
$ dart fix --dry-run
Computing fixes in __bin__ (dry run)... 4.3s

3 proposed fixes in 1 file.

demo.dart
  prefer_single_quotes • 3 fixes
```


A ferramenta encontrou três violações da lint e informa que consegue corrigir todas as três, mas não modifica o arquivo.

Executando a ferramenta [`dart fix`](https://dart.dev/tools/dart-fix) novamente, mas desta vez com a opção `--apply`, a saída é quase a mesma:

```
$ dart fix --apply
Computing fixes in __bin__... 5.3s
Applying fixes...         0.0s

3 proposed fixes in 1 file.

demo.dart
  prefer_single_quotes • 3 fixes

3 fixes made in 1 file.
```


Mas desta vez o arquivo é atualizado para conter o seguinte:

```
import 'package:logging/logging.dart';

void main() {
  var logger = Logger('myApp');
  logger.info('Entering myApp');
  // Do stuff.
  logger.info('Exiting myApp');
}
```


Como o modo dry-run não produz nenhum tipo de saída de diff que permita ver as mudanças propostas, **considere fazer commit das suas alterações antes de executar a ferramenta com a opção `--apply`**. Assim fica mais fácil ver quais mudanças a ferramenta realmente fez e reverter as que você não gostar.

Se você não quiser fazer commit antes de executar a ferramenta, e estiver usando o IntelliJ IDEA, pode usar o recurso **File-&gt;Local History** para comparar o estado antes e depois de aplicar as correções. (Para mais informações, veja [Adicionar rótulos a estados específicos do Local History](https://www.jetbrains.com/help/idea/local-history.html#label-local-history-revisions).)

O comando [`dart fix`](https://dart.dev/tools/dart-fix) não consegue corrigir todos os problemas, mas, quando consegue, é muito mais fácil do que aplicar a correção manualmente em todos os lugares.

## Resumo {:#summary}

Poder aplicar várias correções em uma única operação não só aumenta o poder das correções rápidas, como também pode facilitar mudanças em larga escala, como habilitar uma nova regra de lint ou atualizar para a versão mais recente do Flutter.

Como sempre, se você tiver ideias de como melhorar essas ferramentas, por favor nos avise [criando uma issue no dart-lang/sdk](https://github.com/dart-lang/sdk/issues/new).
