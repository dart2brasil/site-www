---
ia-translate: true
title: "Anunciando o Dart 2.10"
description: "Uma nova ferramenta dart unificada para todas as tarefas principais. E também uma atualização sobre o cronograma da null safety e os princípios de migração."
publishDate: 2020-10-01
author: mit-mit
image: images/19wrenixSu1viOYLF1nWhAw.webp
category: releases
layout: blog
---


*Por: [Michael Thomsen](https://medium.com/@mit.mit) & [Kevin Moore](https://twitter.com/kevmoo)*

Hoje estamos anunciando uma nova versão do Dart, a 2.10 (*dois-ponto-dez*). Esta versão traz uma nova ferramenta de desenvolvimento Dart unificada: uma única ferramenta para todas as suas necessidades de desenvolvimento, como criar projetos, analisar e formatar código, executar testes e compilar apps. Também temos uma atualização sobre o roadmap e o cronograma da null safety, e uma discussão sobre os princípios para migrar código existente para null safety.

<DashImage src="images/19wrenixSu1viOYLF1nWhAw.webp" alt="Banner de lançamento do Dart 2.10 destacando a ferramenta Dart unificada e a atualização sobre null safety." />


## Uma nova ferramenta de desenvolvimento Dart unificada {:#a-new-unified-dart-developer-tool}

O Dart é a base do Flutter SDK: ele não só fornece a linguagem e os runtimes que dão vida aos apps Flutter, como também oferece suporte a muitas tarefas essenciais de desenvolvimento, como formatar, analisar e testar código. Porém, enquanto o Flutter tem uma única ferramenta de desenvolvimento de uso geral (o comando `flutter`), o Dart historicamente teve muitas ferramentas menores (por exemplo, `dartfmt` e `dartanalyzer`). O Dart 2.10 tem uma nova ferramenta de desenvolvimento `dart` unificada, muito parecida com a ferramenta `flutter`. Essa nova ferramenta dá suporte a todas as tarefas comuns, como criar novos projetos e pacotes; analisar e formatar código; e executar, compilar e testar projetos. Para usar a ferramenta, basta executar o comando `dart`:

<DashImage src="images/1y-udLgjneGgP-y8UATZrlw.webp" alt="Saída de ajuda no terminal da ferramenta dart do Dart 2.10." caption="Conheça a ferramenta dart do 2.10 executando dart help." />


O Flutter inclui essa nova ferramenta Dart no Flutter SDK. A partir do [Flutter 1.22 SDK]({{site.flutter-blog}}/announcing-flutter-1-22) lançado hoje, o diretório `&lt;flutter-sdk&gt;/bin` (que provavelmente está no seu `PATH`) contém os comandos `flutter` e `dart`. Se você faz tanto desenvolvimento Flutter quanto desenvolvimento Dart de uso geral, tem as duas experiências de desenvolvimento a partir de um único Flutter SDK, sem precisar instalar mais nada.
> **Observação:** se você quiser baixar e instalar um segundo Dart SDK (talvez porque precise de uma versão diferente), garanta que o SDK da ferramenta `dart` que você quer usar por padrão esteja no início da sua variável de ambiente `PATH`.

Ao longo das próximas versões estáveis, planejamos acrescentar mais coisas a essa ferramenta `dart` e descontinuar aos poucos as ferramentas menores (`dartdoc`, `dartfmt`, `dartanalyzer` etc.). No ano que vem esperamos lançar Dart SDKs que contenham apenas a ferramenta `dart`. Recomendamos que você passe a usar a nova ferramenta ao executar comandos Dart a partir de agora, seja manualmente no terminal ou em scripts de integração contínua (*CI*), e que [nos envie feedback](https://github.com/dart-lang/sdk/issues/new?labels=area-dart-cli) se algo estiver faltando ou não funcionar como esperado.

## Aguardando a null safety {:#looking-forward-to-null-safety}

Temos visto um grande interesse em null safety desde que lançamos nosso [primeiro technical preview](/blog/announcing-sound-null-safety) há alguns meses. Todos nós estamos ansiosos pela null safety como ferramenta para evitar erros de null difíceis de identificar e, como bônus, pelas melhorias de desempenho que esperamos ver com a sound null safety. Se quiser saber mais, recomendamos nossa nova página [Entendendo null safety](https://dart.dev/null-safety/understanding-null-safety). Se preferir um vídeo curto, confira [o vídeo sobre null safety](https://www.youtube.com/watch?v=ZxSyZHq8gUg&feature=youtu.be&list=PLjxrf2q8roU1rBlI9vz01K2324nzIhYgp&t=322) do [evento Flutter Day](https://events.withgoogle.com/flutter-day/#content), de alguns meses atrás.

Quando a null safety vai estar pronta para uso? Este é o cronograma atual:

1. **Experimentação no Flutter com o *technical preview 2***: já migramos com sucesso a maior parte do Flutter. Em breve, provavelmente no próximo mês, esperamos ter o framework Flutter completo migrado e, assim, estar prontos para habilitar o uso experimental com Flutter. Você poderá testar null safety em um exemplo Flutter e fazer uma migração de teste dos seus apps e pacotes Flutter. Você vai precisar passar uma [flag de experimento](https://dart.dev/tools/experiment-flags), não deve usar em produção e não deve publicar nenhum pacote migrado.

1. **Migração antecipada de pacotes com o *beta***: mais para o fim do ano, vamos concluir o ajuste de desempenho e ter cobertura de testes suficiente para termos confiança de que o recurso funciona como esperado e de que a retrocompatibilidade é sólida. Nesse momento vamos publicar uma versão beta do recurso, e você não vai precisar passar a flag de experimento. Esperamos ver os mantenedores de pacotes começando a migrar seus pacotes para null safety, com aquela última rodada de validação de que o recurso está pronto para uma versão estável.

1. **Uso em produção com o *stable***: dependendo do feedback do lançamento beta, vamos corrigir os problemas restantes e então publicar no stable. É difícil dar um cronograma concreto para isso, mas estamos pensando no início do ano que vem. Quando o recurso estiver estável, esperamos ver muita adoção da null safety, com apps null-safe publicados nas lojas e muitos pacotes null-safe publicados no pub.dev em versões estáveis.

## Princípios para migrar para null safety {:#principles-for-migrating-to-null-safety}

Queremos compartilhar os princípios que orientam a migração para null safety.

### Adote quando estiver pronto {:#adopt-when-youre-ready}

Null safety é uma mudança fundamental no sistema de tipos do Dart. Ela muda o básico das declarações de variáveis, porque [decidimos](/blog/announcing-sound-null-safety) tornar as variáveis non-nullable por padrão:

```
**Without null safety**                 W**ith null safety**

String s; // A String or null.      String s; // A String, not null.
```


Uma mudança tão fundamental seria extremamente disruptiva se insistíssemos na adoção forçada. Queremos deixar *você* decidir quando é a hora certa, então null safety é um recurso opt-in: você vai poder usar as versões mais recentes do Dart e do Flutter sem ser obrigado a habilitar null safety antes de estar pronto. Você pode até depender de pacotes que já habilitaram null safety a partir de um app ou pacote que ainda não habilitou.

### Adote de forma incremental, em ordem {:#adopt-incrementally-in-order}

Recomendamos fortemente migrar o código em ordem, começando pelas folhas do grafo de dependências. Por exemplo, se C depende de B, que depende de A, migre A para null safety primeiro, depois B, depois C. Essa ordem vale quer A, B e C sejam bibliotecas, pacotes ou apps.

Por que a ordem é importante? Embora você consiga avançar um pouco na migração do código antes que suas dependências migrem, corre o risco de ter que fazer uma segunda passada de migração se as dependências mudarem suas APIs durante a migração delas. Vamos fornecer ferramentas para ajudar você a descobrir quais das suas dependências já migraram. Se você é autor de pacotes, para evitar o risco de quebrar suas APIs, espere até que todas as suas dependências tenham migrado antes de publicar uma versão null-safe.

### Use ferramentas automatizadas para reduzir o custo da migração {:#use-automated-tools-to-reduce-migration-cost}

Quando suas dependências estiverem prontas e você decidir fazer a migração, pode usar nossa ferramenta de migração. A ferramenta funciona analisando todo o seu código existente, procurando quais declarações podem ser non-nullable (ficam sem alteração) e quais precisam ser nullable (precisam de um marcador de nulabilidade `?` na declaração).

A ferramenta de migração é interativa, então você pode revisar as propriedades de nulabilidade que a ferramenta inferiu. Se discordar de alguma conclusão da ferramenta, você pode adicionar dicas de nulabilidade para mudar a inferência. Por exemplo, se quiser tornar uma API non-nullable mesmo que isso exija alguma refatoração, você pode avisar a ferramenta e executar a análise de migração de novo. Adicionar algumas dicas de migração pode ter um impacto enorme na qualidade da migração.

<DashImage src="images/0wqrweNI-0SK9DB0z.webp" alt="A interface interativa da ferramenta dart migrate mostrando as mudanças de código propostas." />


### Aproveite todos os benefícios com o uso completo {:#get-full-benefit-with-full-use}

Quando *todo* o seu código (e os pacotes dos quais ele depende) estiver migrado, seu código poderá ser executado com null safety *sound*. Antes disso, seu código vai continuar executando e compilando como hoje, mas a null safety totalmente sound permite verificação completa em tempo de execução e otimizações do compilador. Executar testes com sound null safety ajuda a evitar problemas com asserções de null em tempo de execução, e compilar suas aplicações com sound null safety garante que você receba as otimizações atuais e futuras, como saída compilada menor e execução mais rápida.

## Próximos passos {:#next-steps}

A nova ferramenta de desenvolvimento `dart` já está disponível no Dart 2.10 SDK e no Flutter 1.22 SDK. Se você já tem um Flutter SDK, pode obter um Dart SDK com o comando `dart` simplesmente executando `flutter upgrade`; isso vai trazer o Flutter 1.22 SDK, que tem o Dart 2.10 embutido. Recomendamos que você passe a usar a nova ferramenta `dart` imediatamente e que [nos envie feedback](https://github.com/dart-lang/sdk/issues/new?labels=area-dart-cli) se algo estiver faltando ou não funcionar como esperado.

Teremos mais novidades sobre null safety em breve, muito provavelmente no próximo mês, quando esperamos que nossos amigos do time do Flutter tenham um framework Flutter com null safety pronto para experimentação. Fique de olho no [blog do Flutter]({{site.flutter-blog}}) para novidades. Enquanto isso, você pode experimentar código Dart null-safe usando o [DartPad com Null Safety](https://nullsafety.dartpad.dev/3d9c1769de7912c654bc5d132aff60ac) e saber mais sobre o design do recurso lendo nossa [documentação de null safety](https://dart.dev/null-safety).
