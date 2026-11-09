---
ia-translate: true
title: "Migração gradual para o null safety em projetos Dart grandes"
description: "A migração para o null safety do Dart é um trabalho de 1 a 2 horas para um pacote simples e pequeno, mas pode virar uma maratona de meses em um projeto grande. Idealmente…"
publishDate: 2022-03-31
author: polina-c
image: images/16-SfhIoFLl1NPaNi8Ld8Og.webp
category: other
layout: blog
---


<DashImage src="images/16-SfhIoFLl1NPaNi8Ld8Og.webp" alt="Logo do Dart com as palavras 'Null Safe' estampadas." />


A [migração para o null safety do Dart](https://dart.dev/null-safety/migration-guide) é um trabalho de 1 a 2 horas para um pacote simples e pequeno, mas pode virar uma maratona de meses em um projeto grande. Idealmente, você quer migrar o projeto de forma gradual — durante a maratona, é importante manter o projeto crescendo, fácil de manter e fácil de lançar.

Eu migrei um projeto grande para o null safety e decidi reunir passos e dicas para tornar o processo confiável e eficiente, na esperança de economizar seu tempo.

## Passo 1: migrar para o null safety unsound {:#step-1-convert-to-unsound-null-safety}

Primeiro, migre seu projeto para o [null safety *unsound*](https://dart.dev/null-safety/unsound-null-safety).

Comece atualizando suas dependências para versões com null safety. O null safety unsound não exige que todas as dependências sejam null-safe. No entanto, é altamente recomendável esperar até que todas as suas dependências upstream estejam migradas, pois migrar uma dependência pode obrigar você a revisar decisões de migração no seu próprio código. Para pacotes que dependem mutuamente uns dos outros, você pode ser forçado a migrar fora de ordem ou a migrar os pacotes ao mesmo tempo (muitos pacotes que dependem mutuamente se referem uns aos outros apenas nos testes). Siga [as orientações do dart.dev](https://dart.dev/null-safety/migration-guide#update-dependencies) para atualizar o máximo de dependências que puder antes de migrar o seu código.

Em seguida, atualize o SDK do Dart para o seu pacote e marque cada biblioteca não migrada como legacy, seguindo estes passos:

1. Certifique-se de que sua IDE (VSCode, IntelliJ / Android Studio) tem o plugin do Dart instalado.

1. Abra seu pacote na IDE e certifique-se de que não há erros de compilação.

1. Atualize a dependência `dart_sdk` no arquivo `pubspec.yaml` para exigir a faixa de versão: `‘>=2.12.0 <3.0.0’`.

1. A IDE vai destacar os erros relacionados ao null safety em bibliotecas que ainda não são null-safe. Remova os erros adicionando o comentário `‘// @dart=2.9’` no topo de cada arquivo afetado. Adicione o comentário ao seu arquivo main.dart mesmo que ele não tenha erros, para manter o app rodando no modo unsound até que você esteja pronto para trocar.

1. Verifique se todos os testes passam e envie as mudanças para sua branch principal. Se os seus testes já forem null-safe, você vai precisar da flag de linha de comando `--no-sound-null-safety` para suprimir os erros de null safety.

Certifique-se de ver `Running with unsound null-safety` no console ao iniciar a aplicação.

Agora você está pronto para migrar seu projeto para o sound null safety, uma biblioteca por vez.

## Passo 2: avançar em direção ao sound null safety {:#step-2-iterate-towards-sound-null-safety}

Escolha uma biblioteca ou um conjunto de bibliotecas para migrar.
> **Dica de ouro**: se a biblioteca escolhida for grande, talvez seja bom dividi-la em bibliotecas menores antes de migrar.

Use `dart pub deps` para criar um grafo de dependências do seu projeto. O ideal é migrar os pacotes de baixo para cima: comece pelas folhas da árvore de dependências e vá subindo até a raiz. No entanto, se o seu projeto tiver ciclos de dependência, isso pode não ser possível, e tudo bem não seguir essa ordem.

Migre a biblioteca (ou o conjunto de bibliotecas) [usando a ferramenta de migração](https://dart.dev/null-safety/migration-guide):

1. Inicie a ferramenta de migração interativa executando `dart migrate --skip-import-check`. Você pode querer usar `cd` para ir até o diretório com as bibliotecas selecionadas, para facilitar a navegação na árvore.

1. Desmarque tudo, desmarcando as raízes da árvore de arquivos no painel da esquerda. (Se tiver interesse, vote por um [botão **Deselect All**](https://github.com/dart-lang/sdk/issues/48314).)

1. Use `Control+F` para encontrar o(s) arquivo(s) que você quer migrar.

1. Selecione o(s) arquivo(s) e clique em **Apply Migration**. Há duas opções para fazer ajustes: (1) usar comentários para ajustar as escolhas da ferramenta antes de aplicar a migração ou (2) usar a IDE para avaliar a nulabilidade de campos, parâmetros e variáveis depois de aplicar a migração.

1. Abra o pacote na IDE. Corrija os erros e pesquise nos arquivos os casos em que a ferramenta pode ter errado (veja a lista de possíveis problemas abaixo). Faça as correções e use os avisos de lint para limpar interativamente o código upstream e downstream.

Você não vai conseguir corrigir dois erros de lint:

1. `import_of_legacy_library_into_null_safe` (em bibliotecas migradas)

1. `avoid_redundant_argument_values` (em bibliotecas legacy)

Por enquanto, desative esses erros com comentários. Você vai limpar isso depois, quando a migração estiver concluída.

Imprecisões da ferramenta a observar:

1. Tipos adicionados como `dynamic` ou `num`. Quase sempre você sabe qual tipo específico deveria ser usado no lugar.

1. Na maioria dos casos, `bool?` pode virar `bool` com um valor padrão.

1. Casts de tipo (pesquise por `‘ as ‘`) podem significar que a ferramenta não adicionou um parâmetro de tipo genérico. Depois de adicioná-lo, um lint indica que o cast se tornou desnecessário e pode ser removido.

1. Em alguns casos, a ferramenta torna nulável o limite de um parâmetro genérico, quando talvez fosse melhor torná-lo não nulável (pesquise por `?>` e `?,`).

1. A ferramenta pode tornar nullable coisas que seriam melhor expressas com `late` ou `late final`, ou que poderiam ser refatoradas para permitir a inicialização na lista de inicializadores do construtor. (Se tiver interesse, vote por um [lint](https://github.com/dart-lang/linter/issues/3267).)

1. Usar um operador de asserção nula `!` sem antes verificar se o valor é nulo pode significar que a variável ou o parâmetro deveria ser, na verdade, não nulável. (Se tiver interesse, vote por um [lint](https://github.com/dart-lang/linter/issues/3266).)

1. A ferramenta adiciona casts para coleções na forma `collection as Iterable<TheType>`. Às vezes, essa mudança apenas torna explícito um cast que já era implícito. Em outros casos, esses casts podem introduzir [erros de tempo de execução](https://stackoverflow.com/questions/72252891) por causa de incompatibilidades de nulabilidade dos argumentos genéricos. Na dúvida, considere substituir o cast por uma conversão explícita elemento por elemento (por exemplo, `collection.cast<TheType>()`), ou considere usar [o método de extensão `whereNotNull` do `package:collection`](https://pub.dev/documentation/collection/latest/collection/IterableNullableExtension/whereNotNull.html).

1. Se uma variável, campo ou parâmetro é nulável, mas a nulabilidade só é usada nos testes, talvez o código deva ser refatorado para remover a nulabilidade desse identificador.

(Agradecimentos a [Kenzie Davisson](https://github.com/kenzieschmoll), que me ajudou a identificar esses casos.)

## Passo 3: limpeza {:#step-3-cleanup}

Depois de migrar todas as suas bibliotecas, faça uma limpeza final:

1. Limpe os comentários de desativação dos lints.

1. Atualize as dependências restantes para versões com null safety.

1. Garanta que não restem comentários ``//@dart = 2.9`` no seu app. Neste ponto, você deve ver `Running with sound null-safety` no console ao iniciar o app. Se não vir isso, você tem bibliotecas que ainda não foram migradas (pesquise por ``// @dart = 2.9``) ou uma dependência que ainda não foi migrada.

1. Garanta que o app continua funcionando corretamente e que os testes passam. Como o modo sound oferece garantias de tempo de execução mais fortes, é possível (embora improvável) que você veja novos erros de tempo de execução que precisará corrigir ao ativar o sound null safety. Normalmente, isso é resultado de fazer cast de uma coleção nullable (como `List<int?>`) para um tipo de coleção não nulável (como `List<int>`).

Boa migração!
