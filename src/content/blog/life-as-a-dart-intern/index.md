---
ia-translate: true
title: "A vida de estagiário no Dart"
description: "Neste post complementar a “Variância no nível de declaração do Dart”, conheça a experiência de um estagiário na equipe Dart do Google."
publishDate: 2019-12-19
author: kallentu
image: images/06Ct-NyRGmYp_bmgp.webp
category: other
layout: blog
---


*Eu não sei.*

Essas três palavras passam pela mente dos engenheiros de software todos os dias. O trabalho de engenharia consiste em quebra-cabeças e problemas, então não saber algo é apenas mais um indicador de que o engenheiro tem capacidade de crescer. Ainda assim, a falta de conhecimento também pode gerar autodúvida.

Antes de começar meu estágio neste outono, eu não sabia muito sobre linguagens de programação, sistemas de tipos ou nem mesmo sobre variância (que era todo o meu projeto). Até onde eu sabia, variância era apenas um valor do qual eu precisava calcular a raiz quadrada para obter um desvio padrão. Linguagens de programação e compiladores me pareciam uma feitiçaria negra que deixava a maioria dos desenvolvedores perplexa.

Felizmente, meu gerente, que era um leitor de mentes, entendeu como eu me sentia e aliviou meu nervosismo.

*“Então, vou ser completamente honesto: este projeto vai jogar você direto no fundo do poço. Você ainda não sabe nada, mas tudo bem, porque quero que você faça perguntas, muitas delas”,* ele explicou.

Foi assustador mergulhar de cabeça em um projeto novo, com pouco ou nenhum conhecimento prévio sobre o trabalho, mas eu sabia que tinha o apoio do meu gerente. Ele me deu a liberdade de *tentar*, a liberdade de *cometer erros*. Isso significou muito para mim.

Aquela conversa rápida com meu gerente deu o pontapé inicial no primeiro mês do meu tempo aqui: conheci minha equipe em Fremont, Seattle, e estava pronto para me jogar nesse mundo desconhecido chamado *variância*, sobre o qual você pode ler no artigo [Variância no nível de declaração do Dart](/blog/dart-declaration-site-variance).

Tive boot camps semanais de variância com meu gerente, que me forneciam a teoria que eu precisava traduzir em código. Lembro de ler a proposta da [funcionalidade de variância](https://github.com/dart-lang/language/issues/524) que eu iria implementar e de me sentir sobrecarregado com os sete marcos necessários para concluir o projeto: (1) escanear e depois analisar as novas palavras-chave, (2) modificar a AST do kernel, (3) suportar variância no algoritmo de subtipagem, (4) adicionar erros e avisos, (5) alterar o cálculo dos limites superior e inferior, (6) alterar as regras de inferência de tipos e (7) trabalhar nas mudanças de comportamento em tempo de execução.

Entre mudar o kernel (a representação intermediária do compilador) e a lógica de subtipagem, eu precisava serializar e desserializar as anotações de variância. O comportamento em tempo de execução era considerado uma meta opcional, mas eu mal conseguia entender as seis tarefas que vinham antes dele. Não sabia por onde nem como começar.

Mas as coisas melhoraram.

Eu começava cada dia de trabalho às 9h. Ovos mexidos, linguiça, couve e suco de laranja eram tudo de que eu precisava. Estava pronto para encarar o código, me perguntando como diabos alguém tinha feito o primeiro compilador.

Muitas vezes eu trabalhava em componentes diferentes ao mesmo tempo. Isso me mantinha ocupado, e eu gostava de organizar as metas. Todas as manhãs, eu criava um novo documento que listava o que queria realizar, dividindo os objetivos em tarefas gerenciáveis.

<DashImage src="images/06Ct-NyRGmYp_bmgp.webp" alt="Lista de tarefas de 31 de outubro para o trabalho de variância, com muitas tarefas riscadas e links para as mudanças incorporadas." caption="Uma lista de tarefas típica" />


À noite, o escritório do Google em Aarhus, na Dinamarca, estava movimentado. Sabendo que eu precisaria trabalhar com alguns engenheiros da Dinamarca, muitas vezes escrevia minhas perguntas, finalizava-as e as enviava tarde da noite, em Seattle. Os horários de revisão de código se deslocavam nove horas para a frente, mas, felizmente, a diferença de fuso também me dava mais tempo para revisar meu próprio trabalho antes de ele ser criticado.

As críticas da equipe melhoraram minha capacidade de avaliar o meu próprio código e de ponderar as trocas (trade-offs) entre diferentes implementações. Meus revisores apontavam áreas que eu tinha deixado passar e faziam perguntas sobre o que é variância e como usá-la. Eu corrigia meu código, respondia às perguntas deles e tratava de ficar atento aos mesmos problemas no futuro. Mais importante ainda, eu aprofundava: *Como eles chegaram a essa melhoria? Que conhecimento posso levar daqui, além da versão corrigida do código?* Era importante para mim aprender com cada comentário, em vez de clicar, sem pensar, no botão **Done** tão conveniente.

Eu aprendia fazendo perguntas. Há sempre um equilíbrio frágil entre ser um engenheiro de software teimoso, que cerra os dentes e se arrasta por um código sem sentido, e cutucar relutantemente o especialista da base de código para pedir ajuda. Esta última opção quase sempre economizava mais tempo. Eu preferia dedicar um bom tempo a trabalhar de forma independente, anotando e escrevendo perguntas à medida que encontrava novas áreas, e então recorrer a outro engenheiro quando tivesse 2 ou 3 perguntas e um bloqueio sólido. Percebi que era muito mais produtivo perguntar sobre problemas que, sozinho, exigiriam 3 horas de troubleshooting, em vez de 10 minutos de orientação e explicação de outra pessoa.

Segurança no ambiente de trabalho também aumenta a produtividade.

Para mim, a segurança veio de fazer perguntas, contar piadas e almoçar com a equipe. Assim que o relógio marcava 11h30, eu sabia que a meia hora seguinte seria preenchida por comida quente e rostos animados. Todos os dias eu ouvia as histórias e ideias mais elaboradas: as vantagens de ter 6 dedos, ganhar uma lagosta cozida de presente de Natal, as horas de limpeza depois de misturar dois canos diferentes no Factorio… qualquer coisa e tudo. Minha equipe me apoiou nos meus erros e nas minhas conquistas. Uma boa equipe torna muito mais fácil sair da cama de manhã para ir trabalhar.

As horas antes e depois do almoço também foram igualmente agradáveis. Passei a maior parte do tempo lendo código e entendendo conceitos novos. O compilador do Dart é composto por muitos componentes grandes e em constante mudança, o que significava que eu precisava mergulhar em várias bases de código diferentes. Adorei a oportunidade de procurar as equipes de front-end responsáveis pela análise estática, assim como as equipes de back-end que cuidavam do comportamento em tempo de execução. Foi incrível ver como os componentes trabalham juntos para criar uma nova funcionalidade na linguagem Dart.

O abismo entre implementação e teoria foi o aspecto mais desafiador do meu projeto. Não é todo dia que alguém precisa transformar uma prova em código concreto. Enquanto trabalhava com variância, esse abismo aparecia quando eu tinha dúvidas: às vezes, minhas perguntas uniam os componentes da proposta da linguagem a uma implementação apropriada. As pessoas a quem eu recorria para respostas ou sabiam qual arquivo continha o algoritmo de subtipagem, ou sabiam como as mudanças de subtipagem afetavam as operações de atribuição, mas nunca as duas coisas. Parecia construir uma casa na árvore com algumas tábuas de compensado e uma representação artística do resultado final.

Ainda assim, trabalhar no Dart foi imensamente gratificante e divertido. Adorei o desafio, especialmente sabendo que havia muito a aprender sobre áreas além da variância. O Dart era, e continua sendo, uma linguagem que cresce e evolui para dar melhor suporte aos desenvolvedores que a usam. Vi a equipe funcionar como um relógio bem ajustado quando questões cruciais surgiram e exigiram atenção imediata. Ouvi a equipe revisar erros anteriores, garantindo que processos futuros não os repetissem.

Meu estágio na equipe do Dart melhorou minhas habilidades de engenharia, minhas habilidades de comunicação e minha confiança em mim mesmo. Ele me ensinou a importância de ter uma equipe amigável, mas também muito funcional. Ensinou-me as muitas formas como a teoria pode se transformar em código e as técnicas de resolução de problemas necessárias para isso. Ensinou-me mais sobre mim mesmo e sobre o que valorizo no trabalho que faço.

Obrigado, Dart. Até a próxima.
