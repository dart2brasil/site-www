---
ia-translate: true
title: "Dart-on-LLVM"
description: "Esta é a história de um experimento para compilar a linguagem Dart usando o framework de compilador LLVM. À primeira vista isso parece totalmente inútil…"
publishDate: 2017-01-11
author: erikcorry
image: images/1DN03P0ofCSyHM6UwB42Nyg.webp
category: deep-dive
layout: blog
---


Esta é a história de um experimento para compilar a linguagem [Dart](https://www.dartlang.org/) usando o framework de compilador [LLVM](http://llvm.org/). À primeira vista isso parece totalmente inútil, já que

<DashImage src="images/1DN03P0ofCSyHM6UwB42Nyg.webp" alt="The Dart logo next to a metallic screw and a mechanical dragon (LLVM logo)." />


O Dart já tem uma [máquina virtual](https://www.dartlang.org/dart-vm/tools/dart-vm) excelente, que usa compilação [just-in-time](https://en.wikipedia.org/wiki/Just-in-time_compilation) para obter ótimo desempenho. Como o Dart é tipado dinamicamente (mais precisamente, é [opcionalmente tipado](https://www.dartlang.org/articles/language/optional-types)), um compilador JIT se encaixa naturalmente — ele pode usar os tipos disponíveis em tempo de execução para fazer otimizações que um compilador estático não consegue fazer.

Outro motivo pelo qual o Dart-on-LLVM parece uma missão sem sentido é que, apesar do nome, o LLVM não é uma máquina virtual, e até pouco tempo atrás não era adequado para linguagens com coleta de lixo. Por adequado, queremos dizer:

* GC com movimentação e precisão (sem vazamentos)

* Altamente otimizado

Isso acontece porque, depois que o otimizador transformava seu código, você não tinha mais como encontrar os ponteiros passíveis de coleta na pilha. Uma estratégia comum era mover todos os ponteiros para áreas especiais de memória, mas isso anula muitas das estratégias de otimização de um compilador moderno, que depende da alocação de registradores para variáveis locais para fazer sua mágica. Você podia ter um bom GC ou desempenho total, mas não os dois.

Porém, novos ventos estão soprando no mundo do LLVM. Recentemente, o LLVM ganhou suporte a GC na forma do recurso experimental [*Statepoint*](http://llvm.org/docs/Statepoints.html). Ele foi usado por vários grupos corajosos, incluindo as pessoas por trás do experimento [LLV8](https://github.com/ispras/llv8/wiki) e a [Azul](http://llvm.org/devmtg/2015-10/slides/DasReames-LLVMForAManagedLanguage.pdf), que o usa em um novo compilador de ponta para sua JVM.

<DashImage src="images/1g6p0yM6fD_UD3rfsOWGQ-A.webp" alt="The V8 engine logo next to a metallic screw and a mechanical dragon (LLVM logo)." />


Parece que construir uma VM real baseada em LLVM passou de “missão impossível” para apenas “[missão difícil](https://www.youtube.com/watch?v=gJGJMi-sUS8)”. Ao mesmo tempo, o [strong mode](https://github.com/dart-lang/dev_compiler/blob/master/STRONG_MODE.md) torna o Dart mais tipado estaticamente e menos dinâmico. Além disso, nós, do Google, estamos construindo o [Flutter](https://www.youtube.com/watch?v=Mx-AllVZ1VY&t=0m29s) para iOS, onde a compilação JIT é proibida. Esses dois desenvolvimentos alinham melhor o Dart com os objetivos e as escolhas de trade-off do projeto LLVM.

## Por que LLVM? {:#why-llvm}

O LLVM é um framework de compilador moderno, bem mantido e de código aberto, que nos dá muitas otimizações e plataformas “de graça”. Por exemplo, existe uma passagem completa de [inlining](http://llvm.org/docs/Passes.html#inline-function-integration-inlining) que pode embutir qualquer função em qualquer outra, e contém [heurísticas](https://bugs.chromium.org/p/v8/issues/detail?id=3354) para decidir quando fazer isso.

Também parece uma comunidade aberta e acolhedora, que recebe contribuições de bom grado.

## Objetivos do experimento {:#goals-of-the-experiment}

* O contexto é o Dart em strong mode em um cenário de compilação ahead-of-time

* Avaliar a viabilidade de usar o suporte a Statepoint para um GC preciso e com movimentação

* Avaliar o desempenho

## Metodologia {:#methodology}

Nós ([Erik Corry](https://twitter.com/erikcorry) e Dmitry Olshansky) baseamos nosso experimento no runtime “[Dartino](https://github.com/dartino/sdk)”, descontinuado. Era um runtime experimental do Dart otimizado para dispositivos pequenos. Ele tinha algumas vantagens para nós em relação a usar a DartVM como base:

* Já existia um backend experimental de LLVM para o Dartino, construído por [Martin Kustermann](https://medium.com/@kustermann.martin). Ele não tinha suporte a GC, então travava quando ficava sem memória.

* O Dartino usa muito da infraestrutura do [Dart2JS](https://webdev.dartlang.org/tools/dart2js), então não precisa de um parser completo, de front end etc. Os bytecodes do Dartino que usamos como entrada já têm muitos recursos difíceis do Dart reduzidos. Por exemplo, closures são objetos, e parâmetros opcionais foram transformados em diferentes versões de funções.

* Nós dois já conhecíamos bem o Dartino.

* O Dartino vem com um runtime relativamente completo e é capaz de rodar apps grandes, por exemplo hospedar o Dart2JS. Ele não tem muito suporte a IO de Unix e o modelo de threads é diferente, então não é um substituto direto.

## Coleta de lixo no Dartino {:#garbage-collection-in-dartino}

O experimento LLVM existente para o Dartino foi bifurcado do Dartino há algum tempo, quando o GC era muito simples (um [Cheney collector](https://en.wikipedia.org/wiki/Cheney's_algorithm) de semispace, sem gerações, pausas grandes, 2x de overhead de memória). Nós trouxemos, via cherry-pick, mudanças da branch principal do Dartino para ter um GC de duas gerações mais convencional, com write barriers. Não há read barriers, e a coleta é stop-the-world, sem GC concorrente (embora os Statepoints do LLVM pareçam ter suporte a esses recursos, e quase certamente a Azul os usa em sua VM de código fechado).

Não trouxemos via cherry-pick o suporte a compactação da geração antiga das versões mais novas do Dartino.

<DashImage src="images/1VqmfjhoN9cMWH0vz37zU6A.webp" alt="A miniature model of a street with two toy garbage trucks and toy people, symbolizing garbage collection." />


## Arquitetura {:#architecture}

<DashImage src="images/1pyM5bJo-_-i8Leum4yHPOQ.webp" alt="A flowchart diagram of the Dart-on-LLVM compilation pipeline from Dart source to Dartino bytecodes, LLVM bitcode, assembler, and machine code." />


O diagrama acima mostra o caminho do código-fonte Dart até o código de máquina. Em uma implementação real, as primeiras etapas seriam substituídas por algo baseado no formato ‘[kernel](https://github.com/dart-lang/sdk/tree/master/pkg/kernel)’ (front end de código-fonte Dart pré-parseado).

### Tradução para LLVM e otimização de alto nível {:#translation-to-llvm-and-high-level-optimization}

O llvm-codegen é linkado à nossa própria cópia do LLVM e faz otimizações de alto nível. Nesta etapa, o LLVM mantém a ficção de que os ponteiros são válidos através dos GCs, mas os ponteiros são marcados com um “address space” não padrão, que impede o LLVM de raciocinar sobre seus padrões de bits de maneiras que estariam incorretas na presença de um GC com movimentação. Vários intrinsics customizados do LLVM são usados para marcar os pontos onde o GC pode acontecer.

Por causa dos ponteiros marcados (tagged), o bitcode do LLVM fica muito feio, com muitos casts e adições. Por isso, este documento contém “pseudocódigo LLVM”, e não o arquivo .ll real. Se você está acostumado com arquivos .ll de verdade, isso vai parecer “os primeiros balbucios em .ll de um bebê”, desculpe! O código a seguir representa um dispatch dinâmico depois do mem2reg, a passagem que tira as variáveis locais da pilha e as coloca em registradores [SSA](https://en.wikipedia.org/wiki/Static_single_assignment_form):

```llvm
%class = load_class(%this)
%id = load_class_id(%class)
%offset = add 291, %id
%code = array_load(@dartino_vtable, %offset)
%method_result = call %code(%process, %16)
; We can still use “%this” here, even if there has been a GC in the call
```

Depois que o otimizador roda, a busca um tanto trabalhosa acima foi tirada do loop, restando apenas a instrução de chamada. Isso é possível porque os ponteiros de classe são imutáveis em Dart e nós anexamos vários metadados às instruções de load (não mostrados), incluindo `invariant.load` e `never.faults` (este último é uma adição à nossa [versão modificada do LLVM](https://github.com/ErikCorryGoogle/llvm)).

### Redução (lowering) {:#lowering}

Depois que as otimizações de alto nível rodam, reduzimos a maioria dos intrinsics para instruções normais do LLVM. Por exemplo, o write barrier é reduzido a uma série de stores (o Dartino usa um esquema de card marking que deve muito à [tese de PhD](http://hoelzle.org/publications/urs-thesis.pdf) de [Urs](https://medium.com/@urs.hoelzle), seção 6.2.3). Depois da redução, cada ponteiro de variável local é reescrito por um intrinsic opaco em cada possível ponto de GC (basicamente, em cada chamada). Isso inibe muitas otimizações (por isso precisamos rodar as passagens de otimização antes da redução), mas serve a dois propósitos:

* O intrinsic será usado depois para gerar stack maps, detalhando a localização dos ponteiros passíveis de coleta na pilha.

* Os valores SSA são divididos em valores antes-do-GC e depois-do-GC, o que torna o GC visível para o otimizador e evita geração de código inválida.

A chamada agora se parece mais com isto (o dispatch foi tirado de um loop, então `%code` contém o ponteiro de código — o loop não é mostrado)

```llvm
%statepoint_token = call token (…) @llvm.experimental.gc.statepoint(326, 0, %code, 3, 0, %process, %this, %16)
%method_result = call @llvm.experimental.gc.result(token %statepoint_token)
%this.relocated = call coldcc @llvm.experimental.gc.relocate(token %statepoint_token, 10, 10) ; (%this, %this)
%16.relocated = call coldcc @llvm.experimental.gc.relocate(token %statepoint_token, 11, 11) ; (%16, %16)
; We now have to use %this.relocated instead of %this,
; and %16.relocated instead of %16
```

A transformação é bem desajeitada: cria um token especial na chamada transformada e o usa como argumento nas chamadas a `gc.result` e `gc.relocate`. Os ponteiros passíveis de GC continuam marcados de forma especial (com um address space diferente de zero, não mostrado no pseudo-LLVM acima), o que inibe algumas otimizações na etapa seguinte.

### Geração de código {:#code-generation}

A etapa final é a geração de código, feita pelo programa LLVM `llc`. Essa etapa pode ser feita por um LLVM ToT totalmente sem modificações, com o comando `llc -O3`. O único backend com suporte aos intrinsics experimentais de GC é, atualmente, o x64, mas não vemos nenhuma barreira fundamental para adicionar e subir o suporte a ARM para o upstream. O call site do dispatch dinâmico agora fica assim:

```unix assembly
movq %rdx, (%rsp)
movq %rcx, 8(%rsp)
movq %rdx, 16(%rsp)
movq %rbx, %rdi
movq %rcx, %rsi
callq *%r14
```

Isso usa a convenção de chamada padrão do x64 (majoritariamente baseada em registradores). Antes de cada chamada, vários registradores são salvos na pilha, onde podem ser movidos pelo GC, se necessário. Não há suporte a valores passíveis de GC em registradores callee-saved (V8 e DartVM também não oferecem isso).

## Desempenho {:#performance}

O bytecode do Dartino é otimizado por simplicidade e compacidade em um ambiente muito dinâmico. Para esta análise, tentamos olhar para um cenário futuro em que o strong mode é usado e os tipos são conhecidos na compilação. Nesse cenário, o dispatch de métodos e o acesso a variáveis membro de objetos seriam mais simples e rápidos. Para nos aproximarmos desse cenário, estamos usando algumas análises de programa inteiro ao gerar código LLVM.

A consequência mais importante disso é que, se apenas algumas classes têm um método `foo()`, verificamos essas classes e chamamos o método `foo()` diretamente. Diferentemente de algum mecanismo de dispatch parecido com vtable, isso permite que o LLVM embuta o método onde faz sentido. Isso é uma grande vantagem, especialmente para [getters e setters](https://www.dartlang.org/resources/dart-tips/dart-tips-ep-10), que são um ótimo recurso do Dart.

O compilador ainda precisa lidar com muitos problemas de linguagens dinâmicas, o que ele faz quase sempre corretamente (veja a seção de status dos testes abaixo). Em particular, inteiros podem estourar e virar objetos numéricos alocados no heap a qualquer momento. Junto com a sobrecarga de operadores, isso torna até for-loops simples bem complicados. Mais análise estática provavelmente pode melhorar isso.

Uma diferença em relação à DartVM real é que não verificamos estouro de pilha nem interrupções de thread nos back edges dos loops. Com base na experiência do V8, estimamos que corrigir isso poderia custar cerca de 10% de desempenho.

<DashImage src="images/1_B_KUgeFwaeUxC97GBIHPw.webp" alt="A bar chart comparing DeltaBlue, Richards, and Mini-Splay benchmark results for LLVM AOT, Dart AOT, and DartVM JIT." />


Comparamos com a DartVM JIT tradicional e com o novo suporte ahead-of-time que foi adicionado à DartVM para o [Flutter](https://flutter.io/). Os benchmarks são [do Dartino](https://github.com/dartino/sdk/tree/master/benchmarks).

<DashImage src="images/1uB5TngqsrAvvzu_fr8KCdg.webp" alt="A bar chart comparing 'Hello World' total run time for LLVM AOT, Dart AOT, and DartVM JIT." />


Rodar um programa de vida curta como o Hello World mostra principalmente o tempo de inicialização. O sistema baseado em JIT gasta tempo compilando código, e as duas soluções não-LLVM aqui desserializam um heap de dados na inicialização.

## Conclusões de desempenho {:#performance-conclusions}

Temos desempenho comparável à tecnologia ahead-of-time já existente do Flutter (que é um alvo em movimento — essas medições foram feitas no fim de novembro de 2016, em uma estação de trabalho Linux 64 bits bem potente). O JIT ainda está muito à frente. O desempenho de GC do fork do Dartino que estamos usando não está no mesmo nível.

Também medimos o tempo de inicialização. O Dartino-LLVM gera dados estáticos para as classes, constantes e tabelas de dispatch. Eles são carregados pelo linker de runtime [ld.linux](https://www.cs.virginia.edu/~dww4s/articles/ld_linux.html), altamente otimizado, e carregam mais rápido do que o snapshot atual do heap de dados do Dart AOT, o que dá um ótimo desempenho na inicialização. Para os testes de inicialização, o CPU governor foi configurado para “performance”.

## Uma nota sobre compatibilidade {:#a-note-on-compatibility}

Neste estudo, não focamos em obter 100% de compatibilidade com o Dart. Basta fazer as “coisas difíceis”, isto é, GC e tratamento de exceções, para provar que são possíveis. Em alguns casos, usamos um atalho que mostrou que uma solução real era possível sem gastar tempo implementando de fato a solução real. Estes são alguns pontos em que fizemos concessões:

* Assim como o Dartino, não temos inteiros de precisão infinita. No entanto, verificamos todas as operações int em busca de estouro e mudamos dinamicamente para uma representação numérica encapsulada (boxed) (porém, a representação encapsulada tem apenas 64 bits, com wrapping).

* No no-such-method (basicamente, uma verificação de tipo que falhou), não seguimos a semântica completa do Dart, que inclui chamar o método no-such-method e verificar se existe um getter com o mesmo nome do método ausente que retorna um objeto com um método ‘call’. Porém, lançamos uma exceção em um ponto seguro (um ponto em que uma alocação pode acontecer).

* Não verificamos estouro de pilha em chamadas nem verificamos interrupções nos back edges dos loops. O LLVM tem suporte experimental para isso. As soluções com as quais estamos comparando dão suporte a isso. A experiência do V8 sugere que corrigir isso pode causar uma degradação de desempenho de cerca de 10%.

* Nosso compilador de front end é um Dart2JS modificado. Como o Dartino foi descontinuado, ele não acompanhou as mudanças mais recentes da linguagem, então há alguns testes que não conseguimos rodar.

* O tratamento de exceções do Dart está totalmente implementado, exceto as exceções relacionadas a no-such-method. Para isso, usamos o suporte a tratamento de exceções embutido no LLVM, que parece adequado para a tarefa e bem alinhado ao modelo de exceções do Dart (que, no fundo, não é tão diferente do C++, para o qual o LLVM foi projetado).

<DashImage src="images/14bthU0tgek2j09dJuKn-aQ.webp" alt="A pie chart showing that 88.4% of Dartino tests are passing." />


No total, passamos em quase 90% dos testes que o Dartino conseguia passar. Dos que falham, os maiores motivos são problemas com o front end do compilador e problemas no tratamento de eventos de no-such-method.

Dos cerca de 11,6% de testes que falham, aqui está a distribuição dos motivos:

<DashImage src="images/1f_vtnoVYGfdXXqPUaGrOGw.webp" alt="Pie chart of failing Dartino tests: Dart2JS at 40.1%, NoSuchMethod at 37.4%, Async at 15.4%, and smaller categories." />


## Conclusões {:#conclusions}

O suporte experimental do LLVM a GC parece totalmente funcional no x64.
O desempenho do protótipo ficou no mesmo nível da nossa solução ahead-of-time, mais madura, baseada na DartVM.

Para a análise de desempenho, não usamos o strong mode do Dart, que deve render oportunidades de otimização que favorecem os pontos fortes do LLVM. Porém, usamos algumas premissas de mundo fechado, que consideramos realistas.

Conseguimos compilar a última etapa, do bitcode LLVM para código de máquina, usando apenas um build ToT do LLVM sem modificações (marcado em azul no diagrama do pipeline acima). As otimizações feitas nesta etapa (-O3) não causaram miscompilações nem problemas de GC que tenhamos observado.

## Futuro {:#future}

Ainda não houve decisão sobre se e como usar essa abordagem para o Dart ou o Flutter, mas aqui vão algumas ideias aleatórias sobre caminhos interessantes que poderiam ser explorados.

* Ter uma linguagem própria, diferente de C++-com-handles, para escrever rotinas de runtime. O backend seria LLVM-com-Statepoints. (Há um pequeno experimento com Forth na branch atual, mas algo mais robusto seria necessário para escrever mais do que as rotinas nativas mais simples).

* Qual seria o impacto de encapsular inteiros de 64 bits com wrapping?

* Como podemos usar o conhecimento de programa inteiro para gerar código e ainda permitir a compilação paralela de projetos grandes?

## Referências {:#references}

Suporte a GC do LLVM [http://llvm.org/docs/Statepoints.html](http://llvm.org/docs/Statepoints.html)
Repositório do Dartino-LLVM [https://github.com/dartino/sdk/tree/llvm](https://github.com/dartino/sdk/tree/llvm)
Repositório do LLVM modificado [https://github.com/ErikCorryGoogle/llvm](https://github.com/ErikCorryGoogle/llvm)
Tese de PhD de Urs Hölzle: [http://hoelzle.org/publications/urs-thesis.pdf](http://hoelzle.org/publications/urs-thesis.pdf)
LLV8: [https://github.com/ispras/llv8](https://github.com/ispras/llv8)
