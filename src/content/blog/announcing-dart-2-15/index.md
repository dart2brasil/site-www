---
ia-translate: true
title: "Anunciando o Dart 2.15"
description: "Concorrência rápida, constructor tear-offs, enums melhorados e mais"
publishDate: 2021-12-08
author: mit-mit
image: images/196RfgLO4RYR2ReAs8t6x5w.webp
category: releases
layout: blog
---


Hoje lançamos a versão 2.15 do SDK do Dart, com concorrência rápida usando worker isolates, um novo recurso de linguagem de constructor tear-off, suporte melhorado a enums na biblioteca dart:core, novos recursos para publicadores de pacotes e mais.

<DashImage src="images/196RfgLO4RYR2ReAs8t6x5w.webp" alt="Dart 2.15 release banner highlighting concurrency, constructor tear-offs, and pub tools." />


## Concorrência rápida com worker isolates {:#fast-concurrency-with-worker-isolates}

Praticamente todos os dispositivos modernos têm CPUs com vários núcleos, capazes de executar várias tarefas em paralelo. Para a maioria dos programas Dart, a forma como esses núcleos são usados é transparente para você como desenvolvedor: o runtime do Dart, por padrão, executa todo o seu código Dart em um único núcleo, mas depois usa núcleos adicionais para executar tarefas de nível de sistema, como entrada/saída assíncrona, por exemplo, gravar um arquivo ou fazer uma chamada de rede.

Mas o seu próprio código Dart pode precisar rodar de forma concorrente. Por exemplo, você pode ter uma animação contínua e uma tarefa de longa duração, como analisar um arquivo JSON grande. Se a tarefa adicional demorar demais, isso pode causar travamentos ou atrasos na interface. Ao mover essas tarefas adicionais para um núcleo separado, a animação pode continuar rodando na thread principal de execução, sem interrupções.

O modelo de concorrência do Dart se baseia em [isolates](https://dart.dev/guides/language/concurrency), unidades independentes de execução que são isoladas umas das outras, para evitar uma grande classe de bugs de programação concorrente relacionados a memória compartilhada, como [*race conditions*, como data races](https://en.wikipedia.org/wiki/Race_condition#In_software). O Dart evita esses bugs não permitindo que objetos mutáveis sejam compartilhados entre isolates e, em vez disso, usa um modelo em que os isolates trocam estado por meio de [*troca de mensagens*](https://dart.dev/guides/language/concurrency#sending-multiple-messages-between-isolates). No Dart 2.15, fizemos várias melhorias substanciais nos isolates.

Começamos redesenhando e reimplementando como os isolates funcionam, introduzindo um novo conceito: *isolate groups* (grupos de isolates). Os isolates em um grupo compartilham várias estruturas de dados internas que representam o programa em execução*.* Isso torna cada isolate individual do grupo muito mais barato. Agora, iniciar um isolate adicional em um grupo de isolates existente é mais de 100 vezes mais rápido, já que não precisamos inicializar as estruturas do programa, e esses isolates gerados consomem entre 10 e 100 vezes menos memória.

Embora os grupos de isolates ainda impeçam o acesso compartilhado a objetos mutáveis entre isolates, o grupo é implementado com um heap compartilhado, o que desbloqueia outras capacidades. Podemos passar objetos de um isolate para outro, o que pode ser usado em worker isolates que executam uma tarefa que retorna um grande bloco de memória. Um exemplo é um worker isolate que faz uma chamada de rede para obter dados, faz o parse desses dados em um grande grafo de objetos JSON e, em seguida, devolve esse grafo JSON ao isolate principal. Antes do Dart 2.15, esse resultado precisava ser copiado em profundidade (deep copy), o que poderia causar travamentos na UI se a cópia demorasse mais do que o tempo disponível para um frame.

No 2.15, o worker isolate pode chamar [`Isolate.exit()`](https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate/exit.html), passando o seu resultado como argumento. O runtime do Dart então passa a memória que contém o resultado do worker isolate para o isolate principal sem copiar, e o isolate principal pode receber o resultado em tempo constante. Atualizamos a função utilitária [`compute()`](https://api.flutter.dev/flutter/foundation/compute-constant.html) no [Flutter 2.8 ]({{site.flutter-blog}}/whats-new-in-flutter-2-8) para aproveitar o `Isolate.exit()`. Se você já usa `compute()`, vai obter esses ganhos de desempenho automaticamente após atualizar para o Flutter 2.8.

Por fim, reformulamos a implementação do mecanismo de troca de mensagens entre isolates, tornando a passagem de mensagens pequenas e médias cerca de 8 vezes mais rápida. O envio ficou significativamente mais rápido, e o recebimento de mensagens quase sempre é feito em tempo constante. Também ampliamos os tipos de objetos que os isolates podem enviar uns aos outros, adicionando suporte a tipos de função, closures e objetos de stacktrace. Para detalhes, veja a documentação da API de [`SendPort.send()`](https://api.dart.dev/stable/2.15.0/dart-isolate/SendPort/send.html).

Para aprender mais sobre como usar isolates, veja a nova documentação [*Concorrência em Dart*](https://dart.dev/guides/language/concurrency) que adicionamos para o 2.15. Também temos vários [exemplos de código](https://github.com/dart-lang/samples/tree/master/isolates) que você pode conferir.

## Novo recurso de linguagem: constructor tear-offs {:#new-language-feature-constructor-tear-offs}

No Dart, você pode criar um objeto de função que aponta para uma função de outro objeto, usando o nome da função. No exemplo a seguir, a segunda linha do método main() ilustra essa sintaxe ao atribuir `g` a `m.greet`:

```
class Greeter {
  final String name;
  Greeter(this.name);
  
  void greet(String who) {
    print('$name says: Hello $who!');
  }
}

void main() {
  final m = Greeter('Michael');
  final g = m.greet; // g holds a function pointer to m.greet.
  g('Leaf'); // Invokes and prints "Michael says: Hello Leaf!"
}
```


Esses ponteiros de função, também chamados de *tear-offs* de função, aparecem com frequência ao usar as bibliotecas core do Dart. Aqui está um exemplo de chamada de `forEach()` em um iterable passando a ele um ponteiro de função:

```
final m = Greeter('Michael');

['Lasse', 'Bob', 'Erik'].forEach(m.greet);

// Prints "Michael says: Hello Lasse!", "Michael says: Hello Bob!",
// "Michael says: Hello Erik!"
```


Historicamente, não oferecíamos suporte à criação de tear-offs a partir de um construtor (issue da linguagem [#216](https://github.com/dart-lang/language/issues/216)). Isso era incômodo porque, em muitos casos, como ao construir UIs em Flutter, um tear-off de construtor é exatamente o que você precisa. A partir do Dart 2.15, essa sintaxe agora é suportada. Aqui está um exemplo de como construir um widget `Column` contendo três widgets `Text`, chamando `.map()` e passando a ele um tear-off do construtor de `Text`:

```
class FruitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: ['Apple', 'Orange'].map(Text.new).toList());
  }
}
```


`Text.new` se refere ao construtor padrão da classe `Text`. Você também pode referenciar um construtor nomeado, por exemplo, `.map(Text.rich)`.

## Mudanças relacionadas na linguagem {:#related-language-changes}

Enquanto implementávamos os constructor tear-offs, aproveitamos para corrigir algumas inconsistências no suporte existente a ponteiros de função. Agora você pode especializar um método genérico para criar um método não genérico:

```
T id<T>(T value) => value;
var intId = id<int>; // New in 2.15.
int Function(int) intId = id; // Pre-2.15 workaround.
```


Você pode até especializar um objeto de função genérico para criar um objeto de função não genérico:

```
const fo = id; // Tear off `id`, creating a function object.
const c1 = fo<int>; // New in 2.15; error before.
```


Por fim, limpamos os literais de tipo que envolvem genéricos:

```
var y = List; // Already supported.
var z = List<int>; // New in 2.15.
var z = typeOf<List<int>>(); // Pre-2.15 workaround.
```


## Enums melhorados na biblioteca dart:core {:#improved-enums-in-the-dartcore-library}

Fizemos várias adições de conveniência às APIs de enum na biblioteca dart:core (issue da linguagem [#1511](https://github.com/dart-lang/language/issues/1511)). Agora você pode obter o valor `String` de cada valor de enum usando `.name`:

```
enum MyEnum {
  one, two, three
}

void main() {
  print(MyEnum.one.name);  // Prints "one".
}
```


Você também pode buscar um valor de enum pelo nome:

```
print(MyEnum.values.byName('two') == MyEnum.two);  // Prints "true".
```


Por fim, você pode obter um mapa com todos os pares nome-valor:

```
final map = MyEnum.values.asNameMap(); 
print(map['three'] == MyEnum.three);  // Prints "true".
```


Para um exemplo de uso dessas novas APIs, veja [este PR do Flutter](https://github.com/flutter/flutter/pull/94496/files).

## Ponteiros compactados {:#compressed-pointers}

O Dart 2.15 adiciona suporte a ponteiros compactados, uma técnica em que um SDK de 64 bits pode usar uma representação de ponteiros mais eficiente em termos de espaço, caso só precise dar suporte a um espaço de endereçamento de 32 bits (até 4 GB de memória). Ponteiros compactados resultam em uma redução significativa de memória; em nossos testes internos com o app GPay, observamos uma redução de aproximadamente 10% no tamanho do heap do Dart.

Como ponteiros compactados implicam não conseguir endereçar nenhuma RAM disponível acima de 4 GB, o recurso fica atrás de uma opção de configuração do SDK do Dart que só pode ser alterada por quem incorpora (embedders) o SDK do Dart, no momento da build do SDK. O SDK do Flutter 2.8 ativou essa configuração para builds Android, e a equipe do Flutter está considerando também [ativá-la para builds iOS](https://github.com/flutter/flutter/issues/94753) em uma versão futura.

## Dart DevTools incluído no SDK do Dart {:#dart-devtools-included-in-the-dart-sdk}

O conjunto de ferramentas de depuração e desempenho [DevTools](https://dart.dev/tools/dart-devtools#) não estava incluído no SDK do Dart; você precisava baixá-lo separadamente. A partir do Dart 2.15, o DevTools vem junto quando você baixa o SDK do Dart, sem etapas de instalação adicionais. Para mais informações sobre como usar o DevTools com aplicações de linha de comando em Dart, veja a [documentação do DevTools](https://dart.dev/tools/dart-devtools#using-devtools-with-a-command-line-app).

## Novos recursos do pub para publicadores de pacotes {:#new-pub-features-for-package-publishers}

O SDK do Dart 2.15 também tem dois novos recursos no comando de desenvolvedor `dart pub` e no repositório de pacotes [pub.dev](https://pub.dev).

Primeiro, há um novo recurso de segurança para publicadores de pacotes. O objetivo é detectar quando um publicador publica acidentalmente segredos, como credenciais de nuvem ou de CI, dentro de pacotes do pub. Decidimos adicionar essa detecção de vazamentos depois de sabermos que, em repositórios do GitHub, milhares de segredos [vazam todos os dias](https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf).

A detecção de vazamentos roda como parte da validação pré-publicação do comando `dart pub publish`. Se ela detectar um possível segredo nos arquivos prestes a ser publicados, o comando `publish` é encerrado sem publicar e exibe uma saída como esta:

```
Publishing my_package 1.0.0 to [https://pub.dartlang.org](https://pub.dartlang.org):
Package validation found the following errors:
* line 1, column 1 of lib/key.pem: Potential leak of Private Key detected.
╷
1 │ ┌ - - -BEGIN PRIVATE KEY - - -
2 │ │ H0M6xpM2q+53wmsN/eYLdgtjgBd3DBmHtPilCkiFICXyaA8z9LkJ
3 │ └ - - -END PRIVATE KEY - - -
╵
* line 2, column 23 of lib/my_package.dart: Potential leak of Google OAuth Refresh Token detected.
╷
2 │ final refreshToken = "1//042ys8uoFwZrkCgYIARAAGAQSNwF-L9IrXmFYE-sfKefSpoCnyqEcsHX97Y90KY-p8TPYPPnY2IPgRXdy0QeVw7URuF5u9oUeIF0";
```


Em raras ocasiões, essa detecção pode gerar falsos positivos, sinalizando possíveis vazamentos em conteúdos ou arquivos que você de fato pretende publicar. Nesses casos, você pode adicionar os arquivos a uma [lista de permissões](https://dart.dev/go/false-secrets) (allowlist).

Em segundo lugar, adicionamos outro recurso para publicadores que permite retrair (retract) uma versão de pacote que já foi publicada. Quando uma versão de pacote defeituosa é publicada, geralmente recomendamos publicar uma nova versão com um incremento de versão menor que corrija o problema não intencional. Em casos raros, por exemplo quando você ainda não tem essa correção, ou quando publicou por engano uma nova versão major, mas pretendia publicar uma nova versão minor, você pode usar, como último recurso, o novo [recurso de retração de pacotes](https://dart.dev/go/package-retraction). Essa funcionalidade está disponível na interface de administração do pub.dev:

<DashImage src="images/19KDYm1R4x6D4S-mzL-QE2g.webp" alt="The pub.dev Admin interface showing the option to retract a package version." />


Quando uma versão de pacote é retraída, o cliente pub não resolve mais para essa versão em `pub get` ou `pub upgrade`. Se algum desenvolvedor já tiver resolvido para a versão retraída (e ela estiver no arquivo `pubspec.lock`), ele verá um aviso na próxima vez que executar o `pub`:

```
$ dart pub get
Resolving dependencies…
mypkg 0.0.181-buggy (retracted, 0.0.182-fixed available)
Got dependencies!
```


## Análise de segurança para detectar caracteres Unicode bidirecionais (CVE-2021–22567) {:#security-analysis-for-detecting-bidirectional-unicode-characters-cve-2021-22567}

Recentemente, foi descoberta uma vulnerabilidade geral em linguagens de programação envolvendo caracteres Unicode bidirecionais ([CVE-2021–42574](https://nvd.nist.gov/vuln/detail/CVE-2021-42574)). Essa vulnerabilidade afeta a maioria das linguagens de programação modernas que suportam Unicode. O código-fonte Dart a seguir ilustra o problema:

```
main() {
  final accessLevel = 'user';

  if (accessLevel == 'user‮ .⁦// Check if admin⁩ ⁦') {
    print('You are a regular user.');
  } else {
    print('You are an admin.');
  }
}
```


Você provavelmente pensaria que esse programa imprime *You are a regular user.*, mas ele pode, na verdade, imprimir *You are an admin.*! Essa exploração é possível usando uma string que contém caracteres Unicode bidirecionais. São caracteres que mudam a direção do texto da esquerda para a direita e de volta para a direita para a esquerda, tudo dentro de uma única linha. Com caracteres bidirecionais, o texto pode ser renderizado na tela de forma bem diferente do conteúdo real do texto. Você pode ver um exemplo disso neste [gist de código do GitHub](https://gist.github.com/mit-mit/7dda00ca6278ce7d2555f78d59d9e67b?h=1).

As mitigações contra essa vulnerabilidade incluem usar ferramentas (editores, ferramentas de revisão de código etc.) que detectem caracteres Unicode bidirecionais, para que o desenvolvedor seja alertado sobre eles e aceite conscientemente o seu uso. O visualizador de arquivos de gist do GitHub, linkado acima, é um exemplo de ferramenta que revela esses caracteres.

O Dart 2.15 introduz mais uma mitigação (advisory de segurança do Dart [CVE-2021–22567](https://github.com/dart-lang/sdk/security/advisories/GHSA-8pcp-6qc9-rqmv)): o analisador do Dart agora verifica a existência de caracteres Unicode bidirecionais e sinaliza qualquer uso deles:

```
$ dart analyze
Analyzing cvetest...                   2.6s

info • bin/cvetest.dart:4:27 • The Unicode code point 'U+202E'
       changes the appearance of text from how it's interpreted
       by the compiler. Try removing the code point or using the 
       Unicode escape sequence '\u202E'. •
       text_direction_code_point_in_literal
```


Recomendamos substituir esses caracteres por sequências de escape Unicode, para que fiquem visíveis em qualquer editor ou visualizador de texto. Alternativamente, se você tiver um uso legítimo desses caracteres, pode desabilitar o aviso adicionando uma substituição na linha anterior ao uso:

```
// ignore: text_direction_code_point_in_literal
```


## Vulnerabilidade de credenciais do pub.dev ao usar servidores de pacotes de terceiros (CVE-2021–22568) {:#pubdev-credentials-vulnerability-when-using-third-party-pub-servers-cve-2021-22568}

Também estamos publicando um segundo advisory de segurança do Dart relacionado ao pub.dev: [CVE-2021–22568](https://github.com/dart-lang/sdk/security/advisories/GHSA-r32f-vhjp-qhj7). Este advisory é direcionado a publicadores de pacotes que possam ter publicado pacotes em servidores de pacotes de terceiros, como servidores privados ou internos de empresas. Desenvolvedores que publicam apenas no repositório público pub.dev (a configuração padrão) **não são afetados** por essa vulnerabilidade.

Se você publicou em um repositório de terceiros, a vulnerabilidade é que o token de acesso OAuth2 temporário (de uma hora) apresentado para autenticação nesse repositório de terceiros pode ser usado indevidamente para se autenticar no repositório público pub.dev. Assim, um servidor de pacotes de terceiros malicioso poderia usar um token de acesso para se passar por você no pub.dev e publicar pacotes ali. Se você publicou um pacote em um repositório de pacotes de terceiros não confiável, considere fazer uma auditoria de toda a sua atividade de conta no repositório público de pacotes pub.dev. Você pode usar o [log de atividades do pub.dev](https://pub.dev/my-activity-log) para isso.

## Considerações finais {:#closing-comments}

Esperamos que você goste dos novos recursos do Dart 2.15, [disponíveis hoje](https://dart.dev/get-dart). Este é o nosso último lançamento do ano, e gostaríamos de aproveitar a oportunidade para expressar nossa gratidão pelo maravilhoso ecossistema Dart. Obrigado por todo o feedback incrível, pelo seu apoio contínuo, comprovado pelo nosso crescimento constante, e por ampliar o nosso ecossistema com milhares de pacotes publicados no [pub.dev](https://pub.dev) ao longo do último ano. Mal podemos esperar para voltar ao trabalho no ano que vem, e temos muitas coisas empolgantes planejadas para 2022. Até lá, aproveitem as festas de fim de ano!
