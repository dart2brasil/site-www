---
ia-translate: true
title: "Resultados do Google Summer of Code 2025"
description: "O programa Google Summer of Code (GSoC) busca engajar novos desenvolvedores do mundo todo no desenvolvimento de software open source. O Google…"
publishDate: 2025-10-20
author: dcharkes
image: images/1AWu8hJLDQzrZqv7BxH3byA.webp
category: other
layout: blog
---


O programa [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) busca engajar novos desenvolvedores do mundo todo no desenvolvimento de software open source. O Google patrocina colaboradores para trabalhar, junto com uma organização open source que faz a mentoria, em um projeto de programação de 12 semanas durante o verão. Nos últimos 20 anos, mais de 20.000 colaboradores participaram do Google Summer of Code.

<DashImage src="images/1AWu8hJLDQzrZqv7BxH3byA.webp" alt="O logo do Google Summer of Code ao lado do logo do Dart." />


Em 2025, o Dart participou como organização mentora no Google Summer of Code pelo sexto ano consecutivo. Neste ano, recebemos bem mais de 100 propostas de projeto de possíveis participantes de todo o mundo. Hoje, destacamos alguns dos projetos que orientamos neste verão. Os colaboradores descrevem seus projetos neste post.

## Itens de menu de contexto customizados no iOS {:#custom-ios-context-menu-items}

*Por Jing Shao*

Um objetivo fundamental no desenvolvimento de apps mobile é entregar uma experiência realmente nativa. Antes deste projeto, apps Flutter no iOS tinham uma limitação importante: os desenvolvedores não conseguiam adicionar ações customizadas ao menu de contexto nativo do iOS. Durante o GSoC 2025, implementei com sucesso o suporte a menus de contexto customizados para Flutter no iOS, o que melhorou bastante a capacidade de interação dos apps Flutter no iOS.

Este projeto criou a nova API `IOSSystemContextMenuItemCustom`, que permite aos desenvolvedores adicionar facilmente ações customizadas ao menu nativo do iOS por meio da propriedade `contextMenuBuilder` do `TextField`; os desenvolvedores podem adicionar itens de menu com títulos e callbacks customizados. A implementação faz a ponte entre o Flutter e o sistema UIMenu nativo do iOS, garantindo que os itens customizados se integrem de forma transparente às opções padrão do menu do iOS (copiar, colar), mantendo a aparência e a sensação nativas.

Com essa melhoria, os desenvolvedores Flutter agora podem criar aplicações mais expressivas e ricas em recursos. Este trabalho marca um passo importante para o Flutter na entrega de excelentes experiências nativas multiplataforma, dando aos desenvolvedores ferramentas poderosas para criar apps excepcionais. Para mais detalhes, confira meus posts técnicos e PRs no [GitHub](https://gist.github.com/jingshao-code/f489d263bcd97a489896afafe0c99ccd). Fique à vontade para entrar em contato se tiver dúvidas! Gostaria de agradecer aos meus mentores [Justin ](https://github.com/justinmc) e [Huan](https://github.com/hellohuanlin) pela orientação e pelo apoio inestimáveis ao longo do projeto.

A seguir, um exemplo mostrando itens de menu customizados, como **Limpar texto**, **Adicionar coração ❤️** e **Maiúsculas**, ao lado dos itens padrão do iOS no menu de contexto nativo.

<DashImage src="images/1kkXQy4enw3Pr2or4OVlLtw.webp" alt="Uma animação mostrando um menu de contexto customizado do iOS em um app Flutter, com itens como 'Limpar texto', 'Adicionar coração' e 'Maiúsculas'." />


## Framework de TUI em Dart {:#dart-tui-framework}

*Por Gedion Ezra*

Antes deste projeto, desenvolvedores Dart que quisessem criar aplicações de terminal interativas muitas vezes precisavam migrar para Rust, Go ou Python. Não havia um framework de interface de usuário baseada em texto (TUI) maduro em Dart, o que limitava os desenvolvedores a GUIs ou ferramentas de CLI estáticas. Como parte do GSoC 2025, criamos o [Pixel Prompt](https://github.com/primequantuM4/pixel_prompt), um framework de TUI inspirado na abordagem declarativa e baseada em componentes do Flutter. O Pixel Prompt permite criar aplicações interativas dinâmicas inteiramente em Dart.

O Pixel Prompt introduz um modelo de Component para ComponentInstance, inspirado na arquitetura em camadas do Flutter, que mapeia um widget (na camada de widgets) para uma camada de elements e, por sua vez, para a camada de RenderObject. Os componentes descrevem a UI de forma declarativa, enquanto as `ComponentInstances` gerenciam o estado, o layout e a renderização. Confira uma versão simplificada da arquitetura:

<DashImage src="images/1mDFQO27q9khSRlpThxmcKw.webp" alt="Um diagrama da arquitetura do framework de TUI Pixel Prompt, mostrando o Input System, o Render System, a Component Tree e o Layout Engine." />


O framework oferece suporte a componentes com e sem estado, tratamento de entrada e renderização otimizada com double buffering e diff de ANSI. Isso melhora o desempenho ao minimizar as redesenhagens do terminal e possibilita testes golden confiáveis com um interpretador de terminal virtual.

Para dar uma noção visual do que o Pixel Prompt pode fazer, há abaixo capturas de tela de algumas demos. Elas demonstram o layout declarativo, os componentes interativos e as atualizações em tempo real que o framework suporta, mostrando que o Dart agora pode alimentar aplicações de terminal totalmente interativas sem sair do seu ecossistema.

<DashImage src="images/185MHC2CehYCqjIIb_FDQIQ.webp" alt="App de lista de tarefas (TODO) para terminal, construído com o Pixel Prompt." />


<DashImage src="images/1dTEQLLG7c6yfSbceRRc8pQ.webp" alt="App de cronômetro para terminal, construído com o Pixel Prompt." />


Embora o Pixel Prompt já permita construir aplicações de terminal essenciais, ainda há mais por vir: o suporte a componentes complexos como `TextArea` e `Tables`, um sistema de layout no estilo flex, uma API de animação dedicada e um depurador visual estão previstos para contribuições futuras. Desenvolvedores interessados podem explorar as issues abertas e contribuir no repositório do [pixel_prompt](https://github.com/primequantuM4/pixel_prompt).

## TestGen: ferramenta de geração de testes com LLM {:#testgen-llm-based-test-generation-tool}

*Por Amr Ahmed*

O principal objetivo do **TestGen**, um projeto experimental que automatiza a geração de testes unitários para Dart, é melhorar a cobertura de testes gerando casos de teste que especificamente **têm como alvo linhas não cobertas** no código. Ao usar modelos de linguagem grandes (LLMs) para produzir testes significativos, o TestGen reduz o esforço manual necessário para escrever testes, ajudando os desenvolvedores a alcançar maior cobertura e melhorar a qualidade do código.

Um dos principais desafios ao usar LLMs para geração automatizada de testes é decidir quanto contexto de código dar ao modelo. Por exemplo, se uma função precisa ser testada e fornecemos o arquivo inteiro como contexto, o LLM pode ficar sobrecarregado e produzir testes irrelevantes ou imprecisos. Se fornecermos apenas a própria função, o modelo pode deixar de lado dependências importantes dentro dela, levando a testes incompletos ou quebrados. Para resolver isso, o TestGen usa o analyzer do Dart para analisar todo o código e transformá-lo em **Declarations**, que são classes que representam uma construção de código, como uma função, variável, classe ou mixin. Depois da análise, ele constrói um **grafo de dependências** entre essas declarações, que mostra exatamente quais trechos de código uma determinada declaração depende. Isso é feito percorrendo a **Abstract Syntax Tree (AST)** de uma determinada declaração e registrando suas dependências durante a visita. Usando esse grafo, o TestGen pode fornecer ao LLM apenas o **contexto relevante** *(prompting sensível ao contexto)* em uma profundidade configurável, ajudando-o a gerar testes precisos e focados, sem ruído extra.

<DashImage src="images/1ucv5C_h_O3tF8s5DKxKzGQ.webp" alt="Código Dart da função toBeTestedFunction ao lado de um grafo de dependências que a liga a getEmployee, globalVar, globalFunc, Employee, employees e Person." caption="*A figura mostra o grafo de dependências gerado para o arquivo Dart dado. Ao testar a toBeTestedFunction, o grafo nos ajuda a recuperar facilmente todo o contexto relevante para incluir no prompt. Agora, o LLM consegue entender melhor a função e o que está ao redor dela, o que leva a um processo de geração de testes mais eficaz e preciso.*" />


Para tornar a geração de testes eficaz, o TestGen integra-se ao **`package:coverage`** para detectar automaticamente quais partes do código ainda não estão testadas e mirar nelas. A ferramenta se conecta aos **modelos Gemini** por meio do `package:google_generative_ai`, *usando variantes como gemini-2.5-pro, gemini-2.5-flash e gemini-2.5-flash-lite* para gerar casos de teste. Esses testes passam então por um ciclo de validação e feedback, em que são executados e verificados quanto a erros. Se forem encontrados problemas, os erros são devolvidos ao LLM para que ele refine a saída, deixando os testes finais mais precisos e confiáveis.

Ainda há mais por vir para este pacote, incluindo novos recursos, testes aprimorados e suporte a projetos Flutter. Você pode conferir a lista atual de issues no [repositório dart_testgen](https://github.com/AmrAhmed119/dart-testgen/issues). Para ver um exemplo de como os prompts gerados ficam, veja o exemplo [default-prompt](https://github.com/AmrAhmed119/dart-testgen/blob/main/example/default_prompt.md). Mais detalhes sobre o projeto estão disponíveis no [relatório completo do GSoC](https://github.com/AmrAhmed119/GSoC-2025-Report/blob/main/README.md).

## Tradução com LLM de documentação Android (Java/Kotlin) para Dart usando bindings do JNIgen {:#llm-powered-translation-of-android-javakotlin-docs-into-dart-using-jnigen-bindings}

*Por Marshelino Maged*

Bibliotecas e utilitários Android costumam ser documentados com trechos de código em Java/Kotlin. Embora o JNIgen permita gerar bindings em Dart para essas bibliotecas, escrever código Dart em cima dos bindings pode ser um desafio, por causa das diferenças de sintaxe e de estrutura entre as linguagens. Isso significa que os desenvolvedores não conseguem reaproveitar diretamente os muitos exemplos em Java/Kotlin encontrados na documentação e nos tutoriais oficiais do Android. O projeto native_doc_dartifier foi criado para preencher essa lacuna, traduzindo automaticamente os trechos de Java e Kotlin da documentação do Android para os equivalentes em Dart.

<DashImage src="images/1iC6YYhsTRRz1Cps07v5NIg.webp" alt="Trecho em Java chamando ImageCapture.takePicture com opções de arquivo de saída e callbacks de sucesso e de erro." caption="Exemplo de trecho em Java." />


<DashImage src="images/1Yalahis692k6SIKP4-N9JA.webp" alt="Trecho de código em Dart mostrando o código Java traduzido." caption="Exemplo de tradução do trecho." />


O projeto se baseia no JNIgen, que gera bindings em Dart para APIs de Java e Kotlin por meio de foreign function interface (FFI). Como Java e Dart diferem tanto em sintaxe quanto em semântica, uma tradução direta não é suficiente. Por exemplo, Java suporta sobrecarga de métodos, mas Dart não, então o JNIgen desambigua os bindings com métodos renomeados, como `add$1` e `add$2`. Para gerar código Dart preciso, o modelo de tradução precisa levar essas convenções dos bindings em consideração, em vez de depender de uma conversão superficial.

Um grande desafio técnico foi a escala: os bindings para bibliotecas Android costumam incluir centenas de milhares de linhas de código boilerplate, **muito acima dos limites de entrada** até mesmo dos maiores modelos de linguagem (atualmente, 1M de tokens). Para lidar com isso, o projeto introduziu a **extração de Abstract Syntax Tree (AST)**, que reduz os bindings à superfície da API pública — resultando em cerca de **6%** do tamanho original — preservando as informações críticas. Isso foi combinado com **geração aumentada por recuperação (RAG)**, em que a AST de cada classe é armazenada separadamente e apenas as classes mais relevantes são recuperadas com base no trecho que está sendo traduzido.

Ao combinar a **extração de AST com a seleção de contexto baseada em recuperação**, o `native_doc_dartifier` consegue produzir traduções em Dart que são precisas e alinhadas com os bindings gerados, mantendo-se eficiente dentro das limitações de contexto dos LLMs. O resultado é uma solução prática que reduz o atrito para desenvolvedores Dart que trabalham com a documentação do Android e fortalece a interoperabilidade entre os ecossistemas Java/Kotlin e Flutter.

Como as traduções são geradas por um LLM, erros ocasionais podem acontecer ao compilar o código Dart produzido. Para melhorar a confiabilidade, o sistema incorpora um ciclo de feedback: os erros de compilação são devolvidos ao LLM por várias iterações, permitindo que ele refine e corrija a tradução até que uma versão funcional seja produzida. Essa abordagem iterativa aumenta ainda mais a robustez dos exemplos gerados.

Para mais informações, visite o repositório do [native_doc_dartifier](https://github.com/dart-lang/native/tree/main/pkgs/native_doc_dartifier).

## Traduzindo declarações TS para interfaces de interop JS em Dart {:#translate-ts-declarations-to-dart-js-interop-interfaces}

*Por Nikechukwu Okoronkwo*

<DashImage src="images/1dljRp-oi3pUFHHsdX6gYdQ.webp" alt="Comparação lado a lado de declarações de interface TypeScript e das extension types de Dart geradas." />


O Dart oferece uma interop poderosa com JavaScript por meio do `dart:js_interop`, que pode ser usado para fazer interface com código escrito em JavaScript. No entanto, escrever bindings para bibliotecas e pacotes grandes pode consumir muito tempo e ser sujeito a erros. Para resolver isso, criamos o JS Interop Generator. Ele gera automaticamente wrappers em Dart a partir de um [arquivo de declaração TypeScript](https://www.typescriptlang.org/docs/handbook/declaration-files/by-example.html) (`.d.ts`). Isso ajuda na adoção do Dart na web e permite que desenvolvedores Dart e Flutter aproveitem com mais facilidade o vasto ecossistema de bibliotecas JS do NPM e de outros lugares.

O gerador funciona analisando um arquivo `.d.ts` e transformando suas declarações TypeScript nos equivalentes em Dart. As declarações são geradas com base em como o Dart faz interop com JS, garantindo a corretude da implementação de interop em relação ao código JS representado pela declaração TS, além de uma representação o mais fiel possível da declaração TS sempre que for viável.

Ele oferece suporte a uma ampla gama de recursos do TS, incluindo variáveis, funções, enums, classes, interfaces, namespaces e type aliases. O gerador produz representações equivalentes em Dart dos tipos TS e aproveita os tipos existentes de `dart:js_interop` e do `package:web` quando possível. Isso inclui suporte a recursos avançados do TypeScript, como objetos anônimos, closures anônimas, uniões, tipos mesclados e `typeof` / `keyof`.

Você pode ver muitos exemplos na [suíte de testes de integração](https://github.com/dart-lang/web/tree/main/web_generator/test/integration/interop_gen). Já usamos o gerador para criar, com sucesso, bindings para pacotes populares como [nanoid](https://www.npmjs.com/package/nanoid) e [uuid](https://www.npmjs.com/package/uuid). Para mais detalhes, veja os [resultados dos testes do gerador](https://gist.github.com/nikeokoronkwo/dd83becbb6cee4d98f63556ba108e14b).

O projeto está disponível no pacote `web_generator`, no [repositório web](https://github.com/dart-lang/web). Você pode experimentá-lo executando o script `bin/gen_interop_bindings.dart`. Se encontrar problemas ou bugs, fique à vontade para abrir uma issue e/ou contribuir!
