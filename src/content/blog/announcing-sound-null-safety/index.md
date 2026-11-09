---
ia-translate: true
title: "Anunciando o sound null safety"
description: "Deixe seus apps mais estáveis e performáticos com o null safety do Dart"
publishDate: 2020-06-10
author: filiph
image: images/1HKl1Jf0uBNP-gReYYcgC_g.webp
category: announcements
layout: blog
---


*Por: [Filip Hracek](https://medium.com/@filiph) & [Michael Thomsen](https://medium.com/@mit.mit)*

Hoje é um marco importante para a equipe do Dart com a prévia técnica do nosso trabalho em null safety. O null safety ajuda você a evitar uma classe de bugs que costuma ser difícil de identificar e, como bônus, permite uma série de melhorias de performance. Estamos liberando uma prévia técnica antecipada e aguardamos o seu feedback.

Este post descreve os planos da equipe do Dart para a adoção do null safety. Ele também explica o que queremos dizer com *sound* null safety e **por que isso é diferente da abordagem adotada por muitas outras linguagens.

## Por que null safety? {:#why-null-safety}

O Dart é uma linguagem type-safe. Isso significa que, quando você obtém uma variável de determinado tipo, o compilador pode *garantir* que ela é desse tipo. Mas a type safety, por si só, não garante que a variável não seja `null`.

Erros de null são muito comuns. Uma busca no GitHub retorna [milhares de issues](https://github.com/search?l=Dart&q=%22called+on+null%22&type=Issues) causadas por nulls em código Dart, e ainda mais [milhares de commits](https://github.com/search?l=Dart&q=%22called+on+null%22&type=Commits) tentando corrigir esses problemas.

Tente identificar os problemas de nullability no código de exemplo a seguir:

```
void printLengths(List<File> files) {
  for (var file in files) {
    print(file.lengthSync());
  }
}
```


Essa função certamente vai falhar se for chamada com `null`, mas há um segundo caso a considerar:

```
void main() {
  // Error case 1: passing a null to files.
  printLengths(null);

  // Error case 2: passing list of files, containing a null item.
  printLengths([File('filename1'), File('filename2'), null]);
}
```


O recurso de null safety faz esse problema desaparecer:

<DashImage src="images/1HKl1Jf0uBNP-gReYYcgC_g.webp" alt="DartPad with null safety showing errors for passing null to a list of files and including a null item in the list." />


Com null safety, você pode raciocinar sobre o seu código com mais confiança. Chega de erros de runtime chatos por desreferenciar null. Em vez disso, você recebe erros estáticos enquanto programa.

## Sound null safety {:#sound-null-safety}

O null safety do Dart é *sound*. Isso significa que o Dart tem 100% de certeza de que a lista `files` e os elementos dentro dela não podem ser `null` no exemplo acima. Quando o Dart analisa seu código e determina que uma variável é não anulável, essa variável é *sempre* não anulável: se você inspecionar seu código em execução no depurador, verá que a não nulidade é mantida em runtime. Já outras implementações são unsound e, em muitos casos, ainda precisam fazer verificações de null em runtime. O Dart compartilha o sound null safety com o Swift, mas não com muitas outras linguagens de programação.

A solidez do null safety do Dart tem outra consequência bem-vinda: seus programas podem ser menores e mais rápidos. Como o Dart tem *muita* certeza de que `files` nunca é `null`, ele pode otimizar. Por exemplo, o compilador Dart ahead-of-time (AOT) pode gerar código nativo menor e mais rápido, porque não precisa adicionar verificações de null quando *sabe* que uma variável não é `null`.

Já vimos resultados preliminares muito promissores. Por exemplo, observamos uma [melhoria de performance de 19%](https://gist.github.com/a-siva/07e8a5bfa8548a3041d44d5d1c6f3a40) em um microbenchmark que emula padrões típicos de renderização do framework Flutter.

## Princípios de design {:#design-principles}

Antes de começar o design detalhado do null safety, a equipe do Dart definiu três princípios fundamentais:

* **Não anulável por padrão.** A menos que você diga explicitamente ao Dart que uma variável pode ser `null`, ele vai considerá-la não anulável. Escolhemos esse padrão porque descobrimos que o não nulo era, de longe, a escolha mais comum nas APIs.

* **Adoção incremental.** Existe muito código Dart por aí. Deve ser possível migrar para o null safety de forma incremental, parte por parte. Também deve ser possível ter código com e sem null safety no mesmo projeto. Além disso, vamos fornecer ferramentas para ajudar na migração.

* **Totalmente sound.** Como mencionado acima, o null safety do Dart é sound. Depois que você migrar todo o seu projeto e suas dependências para o null safety, terá todos os benefícios da soundness.

## Declarando variáveis com null safety {:#declaring-variables-with-null-safety}

A sintaxe principal é simples. Aqui estão algumas variáveis não anuláveis, declaradas de diferentes maneiras. Lembre-se: não anulável é o padrão, então essas declarações parecem com as de hoje, mas o significado delas muda.

```
// In null-safe Dart, none of these can ever be null.
var i = 42;
final b = Foo();
String m = '';
```


O Dart vai garantir que você nunca atribua `null` a nenhuma das variáveis acima. Se você tentar fazer `i = null` mil linhas depois, receberá um erro de análise estática e sublinhados vermelhos, e seu programa se recusará a compilar.

Se você quiser que sua variável seja anulável, pode usar `?`, assim:

```
// These are all nullable variables.
int? j = 1;  // Can be null later.
final Foo? c = getFoo();  // Maybe the function returns null.
String? n;  // Is null at first. Can be null at any later time, too.
```


As variáveis acima se comportam da mesma forma que todas as variáveis se comportam hoje.

Você também pode usar a sintaxe `?` em outros lugares:

```
// In function parameters.
void boogie(int? count) {
  // It's possible that count is null.
}

// In function return values.
Foo? getFoo() {
  // Can return null instead of Foo.
}

// Also: generics, typedefs, type checks, etc.
// And any combination of the above.
```


Mas, mais uma vez, a ideia é que você quase nunca precise usar `?`. A grande maioria dos seus tipos será não anulável.

## Tornando o null safety mais fácil de usar {:#making-null-safety-easier-to-use}

A equipe do Dart está se esforçando ao máximo para tornar o null safety o mais fácil possível de usar. Por exemplo, veja este código, que usa `if` para verificar um valor null:

```
void honk(int? loudness) {
  if (loudness == null) {
    // No loudness specified, notify the developer
    // with maximum loudness.
    _playSound('error.wav', volume: 11);
    return;
  }

  // Loudness is non-null, let's just clamp it to acceptable levels.
  _playSound('honk.wav', volume: loudness.clamp(0, 11));
}
```


Repare como o Dart é inteligente o suficiente para perceber que, ao passar daquela instrução `if`, a variável `loudness` *não pode* ser `null`. Por isso, o Dart nos permite chamar o método `clamp()` sem precisar dar voltas. Essa conveniência é possível graças a algo chamado *análise de fluxo*: o analisador do Dart percorre seu código como se o estivesse executando, descobrindo automaticamente informações adicionais sobre ele.

Aqui está outro exemplo, que mostra um caso em que o Dart pode ter certeza de que uma variável é não nula porque sempre atribuímos a ela um valor não nulo:

```
int sign(int x) {
  // The result is non-nullable.
  int result;

  if (x >= 0) {
    result = 1;
  } else {
    result = -1;
  }

  // By this point, Dart knows the result cannot be null.
  return result;
}
```


Se você remover alguma das atribuições acima (por exemplo, apagando a linha `result = -1;`), o Dart não pode garantir que `result` será não nulo: você receberá um erro estático e seu código não vai compilar.

A análise de fluxo funciona apenas dentro de funções. Se você tiver uma variável global ou um campo de classe, o Dart não consegue garantir quando ela receberá cada valor. O Dart não consegue modelar o fluxo de toda a sua aplicação. Por esse motivo, você pode usar a nova palavra-chave `late` quando ***souber*** que uma variável será não nula antes de ser lida pela primeira vez, mas não puder inicializá-la imediatamente.

```
class Goo {
  late Viscosity v;

  Goo(Material m) {
    v = m.computeViscosity();
  }
}
```


Repare que `v` é não nulo, apesar de começar não inicializado. O Dart confia que você não tentará ler `v` antes de ela receber um valor não nulo, e seu código compila sem erros.

## Null safety é retrocompatível {:#null-safety-is-backwards-compatible}

A equipe do Dart vem trabalhando há mais de um ano para levar o null safety até a prévia técnica. É a maior adição à linguagem Dart desde que introduzimos o Dart 2. Mesmo assim, não é uma mudança que quebra compatibilidade. Código existente pode chamar código que usa null safety, e vice-versa. Mesmo depois que o null safety estiver disponível, ele será um recurso opcional, que você pode adotar quando estiver pronto. **Seu código existente continuará funcionando sem alterações**.

Recentemente, migramos as [bibliotecas principais do Dart para usar totalmente o null safety](https://api.dart.dev/dev/2.9.0-13.0.dev/index.html). Como exemplo da retrocompatibilidade do null safety, substituímos as bibliotecas principais existentes sem quebrar nenhum teste existente nem os apps de teste que rodam nos ambientes de teste do Dart e do Flutter. Chegamos até a implantar as novas bibliotecas principais em vários clientes internos do Google, diretamente nas bases de código de produção deles, sem nenhum problema. Planejamos migrar todos os nossos pacotes e apps para usar null safety quando o recurso for lançado, e esperamos que você faça o mesmo. Mas você poderá fazer isso no seu próprio ritmo, pacote por pacote, app por app.

## O roadmap do null safety {:#the-null-safety-roadmap}

Planejamos liberar o null safety gradualmente, em três etapas:

1. **Prévia técnica.** Isso está ***sendo lançado hoje*** e está disponível no [canal dev](https://dart.dev/get-dart#release-channels) do Dart. Veja a seção “Experimente agora” abaixo para mais detalhes. As coisas ainda estão sujeitas a mudanças, então **não use o null safety em código de produção** por enquanto. Mas teste e [nos dê feedback](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here)!

1. **Versão beta.** O null safety estará disponível no canal beta do Dart e não estará mais atrás de uma [flag experimental](https://github.com/dart-lang/sdk/blob/master/docs/process/experimental-flags.md). O recurso estará muito próximo da versão final esperada. Se você é dono de um pacote ou plugin do [pub.dev](https://pub.dev/), este é o momento de começar a migrar, mas você ainda não deve publicá-lo como versão estável.

1. **Lançamento estável.** Todos terão o null safety, e você será incentivado a publicar seus pacotes e plugins migrados como versões estáveis. Você também deve migrar seus apps de produção.

Se tudo correr bem, planejamos lançar o null safety como recurso estável antes do fim do ano. Até lá, vamos adicionar ferramentas para ajudar você a tornar seu código null safe, incluindo:

* Uma ferramenta de migração para ajudar você a automatizar muitas das etapas de atualização de pacotes e apps existentes

* Tags no [pub.dev](https://pub.dev), para que você saiba se um pacote oferece suporte a null safety ou não

* Uma extensão para o comando [`pub outdated`](https://dart.dev/tools/pub/cmd/pub-outdated), com suporte para encontrar as versões mais recentes das suas dependências que oferecem suporte a null safety

## Experimente agora {:#try-it-now}

A forma mais rápida de experimentar o null safety hoje é pelo [nullsafety.dartpad.dev](https://nullsafety.dartpad.dev/3d9c1769de7912c654bc5d132aff60ac), uma versão do DartPad com o null safety habilitado. Abra o menu suspenso **Learn with Snippets** para encontrar uma série de exercícios de aprendizado que apresentam a nova sintaxe e os fundamentos do null safety.

<DashImage src="images/07alHbKGJ1FoeNqII.webp" alt="DartPad with the null safety experiment enabled and interactive code snippets." />


Você também pode experimentar o null safety em pequenos apps de linha de comando. (Ainda não migramos frameworks maiores como o Flutter.) Comece baixando uma cópia do [Dart SDK do canal dev](https://github.com/dart-lang/samples/blob/master/null_safety/calculate_lix/README.md#dart-preview-sdk-installation) e depois obtenha uma cópia [deste app CLI de exemplo em Dart](https://github.com/dart-lang/samples/tree/master/null_safety/calculate_lix) ([repositório no GitHub](https://github.com/dart-lang/samples), [arquivo zip](https://github.com/dart-lang/samples/archive/master.zip)). O [arquivo README](https://github.com/dart-lang/samples/blob/master/null_safety/calculate_lix/README.md) do app de exemplo tem instruções para executar o app com a flag do experimento de null safety. Outros arquivos do exemplo fornecem configurações de lançamento que permitem depurar no VS Code e no Android Studio.

Também temos documentação e planejamos produzir mais:

* [Guia de null safety](https://dart.dev/null-safety)

* [Referência da API das bibliotecas principais com null safety](https://api.dart.dev/dev/2.9.0-13.0.dev/index.html)

Estamos muito felizes em trazer o null safety para o Dart. O sound null safety é um recurso distintivo do Dart que ajuda você a escrever código menos sujeito a erros e a obter melhor performance. Esperamos que você experimente o recurso na prévia técnica e [nos dê feedback](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here) pelo nosso rastreador de issues. Feliz programação!
