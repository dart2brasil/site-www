---
ia-translate: true
title: "Anunciando publishers verificados no pub.dev"
description: "Hoje anunciamos um novo recurso de ‘publishers verificados’ no pub.dev, o repositório de pacotes do Dart"
publishDate: 2019-10-10
author: mit-mit
image: images/0DfmB09PD2DK-pvTz.webp
category: announcements
layout: blog
---


Hoje anunciamos um novo recurso no [pub.dev](https://pub.dev) (o repositório de pacotes do Dart): *publishers verificados*. Quando você *usa* um pacote que tem um publisher verificado, pode ter certeza de que o publisher é quem ele diz ser. Quando você *publica* pacotes como um publisher verificado, ganha de bônus uma administração de pacotes mais fácil.

<DashImage src="images/0DfmB09PD2DK-pvTz.webp" alt="Release banner reading 'Announcing verified publishers for pub.dev' with a shield checkmark icon." />


## Aumentando a confiança de quem consome pacotes {:#increasing-trust-for-package-consumers}

Desenvolvedores de apps que criam aplicativos com o [Flutter](https://flutter.dev) nos dizem que ter uma seleção rica de pacotes de alta qualidade é fundamental para a produtividade deles, pois permite reutilizar componentes comuns e acessar SDKs e bibliotecas populares. Estamos vendo um crescimento imenso no ecossistema do [pub.dev](https://pub.dev/), com milhares de pacotes publicados no último ano e centenas de milhares de desenvolvedores usando o pub.dev todo mês para navegar e pesquisar novos pacotes.

Um dos critérios de seleção mais importantes que ouvimos de quem usa pacotes é *quem publicou o pacote.* Os publishers verificados reforçam esse sinal, pois verificam a identidade de quem publica e exibem claramente essa identidade nos resultados de busca e nas páginas de detalhes dos pacotes (observe o selo azul ao lado de dart.dev nas capturas de tela abaixo).

<DashImage src="images/0LQMWHLFUi6F7nPO1.webp" alt="Package search result showing a package that was published by a verified publisher." caption="*Package search result showing a package that was published by a verified publisher*" />


<DashImage src="images/0GJcMpmN8bNi6H5_g.webp" alt="Package detail page showing a package that was published by a verified publisher." caption="*Package detail page showing a package that was published by a verified publisher*" />


Quando você clica no publisher, pode ver mais alguns detalhes, incluindo um e-mail de contato, um link para a página inicial do publisher e uma breve descrição. A descrição do publisher é fornecida pelo próprio publisher, o que oferece uma pequena oportunidade de branding.

Você também pode ver a lista de todos os pacotes publicados pelo publisher. Abaixo há um exemplo do novo [publisher dart.dev](https://pub.dev/publishers/dart.dev/packages).

<DashImage src="images/0Q24NUEox8eA10hVB.webp" alt="Package list for the verified dart.dev publisher." caption="*Sample package list for a publisher*" />


### Processo de verificação do publisher {:#publisher-verification-process}

Ao desenhar o processo de verificação, queríamos um mecanismo confiável, de baixo custo e disponível para qualquer pessoa interessada em ser um publisher verificado. Também preferimos um processo automatizado, para que as contas pudessem ser criadas sem atrasos.

Depois de avaliar várias alternativas, decidimos basear a verificação em domínios de segundo nível do DNS (sistema de nomes de domínio). Escolhemos o DNS porque acreditamos que a maioria dos publishers de pacotes já tem um domínio e uma página inicial nesse domínio. Durante o [processo de criação do publisher](https://dart.dev/tools/pub/publishing#create-verified-publisher), o pub.dev verifica se o usuário que cria o publisher verificado tem acesso de administrador ao domínio associado, com base na lógica já existente do [Google Search Console](https://search.google.com/search-console/about).

### Administração de pacotes aprimorada {:#improved-package-administration}

Além dos benefícios claros de verificar a identidade do publisher, o recurso de publishers verificados também oferece vantagens administrativas. Antes, se você publicava muitos pacotes, o gerenciamento de acesso era uma tarefa tediosa, feita pacote por pacote, que roubava tempo que você poderia usar para melhorar seus pacotes. Com os publishers verificados, você pode configurar uma única equipe de administradores para a conta do seu publisher, em que todos os membros da equipe podem publicar atualizações em todos os pacotes que pertencem ao publisher.

Também adicionamos algumas novas opções de autoadministração, incluindo a possibilidade de mover um pacote existente para uma conta de publisher (veja abaixo) ou de marcar um pacote como [descontinuado](https://dart.dev/tools/pub/publishing#discontinue).

### Transferir pacotes existentes {:#transfer-existing-packages}

É fácil transferir pacotes existentes para um publisher verificado. Basta [criar um publisher verificado](https://dart.dev/tools/pub/publishing#create-verified-publisher) e usar a [função de transferência](https://dart.dev/tools/pub/publishing#transferring-a-package-to-a-verified-publisher) nos seus pacotes existentes. Esse processo simples leva apenas alguns minutos por pacote.

### Roadmap do pub.dev {:#pub-dev-roadmap}

Estamos discutindo muitas melhorias futuras para o pub.dev. Aqui estão algumas das ideias:

* Suporte de busca para pacotes que oferecem suporte a uma plataforma específica (por exemplo, Android ou web; [#187](https://github.com/dart-lang/pub-dev/issues/187)), incluindo uma melhor distinção entre pacotes de Dart web e de Flutter web

* Tags ou categorias para pacotes ([#367](https://github.com/dart-lang/pub-dev/issues/367))

* Votar ou curtir pacotes de alta qualidade ([#798](https://github.com/dart-lang/pub-dev/issues/798))

* Política e processo claros para denunciar conteúdo questionável ([#1570](https://github.com/dart-lang/pub-dev/issues/1570))

Se você tiver interesse em alguma dessas ideias, recomendamos que consulte o [rastreador de issues do pub.dev](https://github.com/dart-lang/pub-dev/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) para confirmar que a ideia já está registrada e para demonstrar seu interesse adicionando uma reação de *joinha* ao comentário mais no topo da issue.

### Próximos passos {:#next-steps}

Se você é um publisher de pacotes, recomendamos que transfira seus pacotes para uma conta de publisher verificado o quanto antes, para obter os benefícios listados acima tanto para você quanto para os usuários dos seus pacotes. Já transferimos muitos dos [pacotes mais populares do dart.dev](https://pub.dev/publishers/dart.dev/packages), e esperamos que mais sejam transferidos em breve.

É isso por enquanto. Esperamos ver ainda mais pacotes de alta qualidade no [pub.dev](https://pub.dev/)!
