---
ia-translate: true
title: "Dart e os benefícios de desempenho dos tipos sound"
description: "Usando solidez de tipos e null safety para gerar código mais rápido e menor."
publishDate: 2021-01-19
author: vijaysmenon
image: images/1x0UcFY8XwG-3vHe5hYxyQw.webp
category: other
layout: blog
---


### Usando solidez de tipos e null safety para gerar código mais rápido e menor {:#using-soundness-and-null-safety-to-generate-faster-smaller-code}

<DashImage src="images/1WOmw6jN-nt82uXjGCqRC4g.webp" alt="Código gerado a partir do mesmo método Dart nas versões 1.24, 2.0 e 2.12 (da esquerda para a direita), mostrando uma redução de tamanho." caption="Código gerado a partir do mesmo método Dart nas versões 1.24, 2.0 e 2.12 (da esquerda para a direita) ficou menor. Para entender o porquê (e ver o código gerado de verdade), continue lendo." />


Nos últimos anos, fortalecemos o sistema de tipos do Dart. A linguagem Dart original (Dart 1) tinha um sistema de tipos opcional e unsound (parecido com dialetos de JavaScript tipado, como o TypeScript da Microsoft ou o Flow do Facebook). O Dart 2 introduziu um [sistema de tipos *sound*](https://dart.dev/guides/language/type-system), mais rigoroso. Nos últimos dois anos, trabalhamos para estender ainda mais o sistema de tipos, por meio do [*sound null safety*](https://dart.dev/null-safety).

Embora um sistema de tipos sound dê mais confiança aos desenvolvedores, ele também permite que nossos compiladores usem os tipos com segurança para otimizar o código gerado. Com a solidez, nossas ferramentas garantem que os tipos estão corretos por meio de uma combinação de verificação estática e, quando necessário, verificação em tempo de execução. Sem solidez, a verificação de tipos só consegue ir até certo ponto, e os tipos estáticos podem estar incorretos em tempo de execução.

Na prática, a solidez permite que nossos compiladores gerem código menor e mais rápido, principalmente em um contexto de compilação antecipada (AOT), em que enviamos código nativo pré-compilado aos clientes.

## Um exemplo {:#an-example}

O método de exemplo a seguir demonstra como tipos sound podem ter um impacto enorme em um código relativamente simples:

```
**int getAge(Animal a) {
  return a.age;
}**
```


Na nossa última versão estável do Dart 1 (1.24.3), esse método era mapeado para **26 instruções nativas x64**, e isso só depois de instrumentação e otimização guiada por perfil, que atrasava a inicialização do runtime. Com o sound null safety no Dart 2.12, esse código é mapeado para apenas **3 instruções**, sem precisar de nenhuma otimização guiada por perfil.
> O Dart compila tanto para as arquiteturas ARM32/64 quanto x86/x64. Nos exemplos abaixo, usamos x64, mas os resultados são parecidos em outros alvos.

O código Dart completo e o contexto do método de exemplo são mostrados no final deste artigo, mas aqui estão os pontos principais:

* A classe `Animal` contém um campo `age` do tipo `int`.

* `Animal` tem várias subclasses (`Cat`, `Dog`, `Snake`, `Hamster`).

* O método acima é chamado em muitos desses tipos em tempo de execução.

## Layout de objetos do Dart {:#dart-object-layout}

A classe Dart `Animal`, quando compilada para código nativo (x64), tem um layout simples:

<DashImage src="images/1GjL59kevCm5NQ5P9Unn_NA.webp" alt="Layout de memória da classe Animal quando compilada para código nativo." />


Os primeiros 8 bytes são um cabeçalho que fornece informações de tipo reificadas (ou seja, o tipo de runtime do objeto). Os 8 bytes seguintes contêm o campo `age`. Todas as subclasses preservam (e podem acrescentar a) essa estrutura: quaisquer campos adicionais são dispostos depois, preservando a estrutura do tipo base. O método `getAge`, dada uma instância de `Animal` (ou de qualquer subclasse), deve carregar o campo a partir de um offset de 8 bytes e retorná-lo.

## Dart 1: tipos unsound {:#dart-1-unsound-types}

No Dart 1, porém, os tipos estáticos não eram sound e eram efetivamente ignorados durante a compilação. Em tempo de execução, não podíamos presumir que o tipo estático estava correto (e, portanto, que o layout era o esperado). O acesso a `age` podia ser a um campo em outro offset, a um getter que disparava mais código executável, ou a um campo inexistente (disparando um erro de runtime capturável).

O Dart 1 foi projetado para depender de um compilador just-in-time e de uma máquina virtual no dispositivo do cliente, que otimizavam o código usando informações de tipo de runtime. Nesse esquema, compilávamos cada método duas vezes: primeiro, para coletar informações, e segundo (para métodos "quentes") para gerar código mais otimizado com base no comportamento observado em runtime.

### Dart 1: primeira compilação {:#dart-1-first-compilation}

A primeira compilação de `getAge` produziu as seguintes 47 instruções em x64:

<DashImage src="images/1BmagjRb3ei3C-HjyYfLNyw.webp" alt="Código assembly mostrando as 47 instruções produzidas pela primeira compilação de getAge no Dart 1." />


Repare que esse código é instrumentado para determinar o que acontece em runtime. Ele não presume nada sobre o objeto passado e, efetivamente, executa o equivalente a uma busca em tabela hash para encontrar o campo corretamente, executar um getter ou lançar um erro.

### Dart 1: segunda compilação {:#dart-1-second-compilation}

Nesse caso, o código é chamado repetidamente e dispara uma segunda compilação, otimizadora, que gera as seguintes 26 instruções:

<DashImage src="images/11bEjUe15A0s47XMsZPqdNQ.webp" alt="Código assembly mostrando as 26 instruções produzidas pela compilação otimizadora no Dart 1." />


Esse código otimizado ainda é bem grande. Ele se baseia em informações de perfil que indicaram que o método era invocado apenas em instâncias de `Cat`, `Hamster` e `Dog`, e é otimizado com a suposição de que o mesmo será verdade no futuro.

O código em **azul** é o prólogo e o epílogo do método (para montar e restaurar o frame da pilha). O código em **vermelho** verifica os casos esperados (que a instância não é nula e é de um dos tipos vistos antes) e invoca um caminho lento para os outros casos. O código em **negrito** é o trabalho real de carregar o campo.

O código otimizado pode até ficar mais lento se o comportamento futuro for diferente do passado: se `getAge` for invocado em uma nova instância (como um `Snake`), o código executará as verificações extras, mas ainda assim cairá no caminho lento.

### Problemas com o código gerado pelo Dart 1 {:#problems-with-dart-1-generated-code}

O código gerado acima tem uma estrutura muito parecida com a que o V8, o motor JavaScript do Chrome, produz hoje para um programa JavaScript/TypeScript/Flow mais ou menos equivalente. Embora essa abordagem (e o código gerado correspondente) possa oferecer bom desempenho em muitos cenários, ela não era adequada quando começamos (com o Flutter em particular) a mirar um conjunto mais amplo de plataformas clientes, incluindo dispositivos móveis mais sensíveis a tamanho e uso de memória:

* Primeiro, o custo da compilação no lado do cliente aumentava a pegada geral dos aplicativos Dart.

* Segundo, o custo da compilação especulativa em duas fases prejudicava a inicialização do aplicativo.

* Terceiro, a compilação just-in-time não é permitida no iOS: precisaríamos de uma estratégia alternativa para pelo menos alguns alvos.

Passamos, então, para uma abordagem de compilação antecipada (ahead-of-time), mas com o Dart 1 ela resultava em código consideravelmente pior. Mesmo com uma análise sofisticada de programa inteiro, nem sempre conseguíamos determinar as informações de tipo em tempo de compilação, especialmente conforme os aplicativos cresciam. Além disso, o custo da especulação — o código vermelho acima — se tornou proibitivo quando o aplicativo inteiro era pré-compilado.

## Dart 2: tipos sound {:#dart-2-sound-types}

Com o Dart 2, introduzimos a solidez, que nos permitiu compilar código com segurança com base nas informações de tipo e reduziu nossa dependência de profiling para obter desempenho. Com o Dart 2, em uma única compilação antecipada, geramos 10 instruções em x64:

<DashImage src="images/1x0UcFY8XwG-3vHe5hYxyQw.webp" alt="Código assembly mostrando as 10 instruções geradas pelo Dart 2 em uma única compilação antecipada." />


Esse código ainda faz a verificação de null (em vermelho) e chama um método auxiliar se encontrar um null.

## Dart 2.12: sound null safety {:#dart-2-12-sound-null-safety}

Com o sound null safety, o sistema de tipos fica mais rico, e nosso compilador pode aproveitar isso. O compilador pode confiar com segurança no tipo (agora) não anulável e eliminar o código em vermelho acima. Na versão beta do Dart 2.12, geramos 3 instruções a menos:

<DashImage src="images/1xVdpKVxtt_TtfoXZDlu1Qw.webp" alt="Instruções assembly geradas para o Dart 2.12 com sound null safety." />


Na verdade, como o código ficou mais simples, também conseguimos simplificar o prólogo e o epílogo. Na nossa próxima versão estável, vamos gerar apenas 3 instruções para o método de exemplo:

<DashImage src="images/1JPFuwgxqf2K-7tVD52M5uQ.webp" alt="Instruções assembly simplificadas para sound null safety, reduzidas a apenas 3 instruções." />


Com o sound null safety, podemos reduzir o código gerado para este método à sua essência: um carregamento de campo. Na prática, uma chamada a esse método sempre será inlined, já que agora é trivial para o compilador perceber que o inlining traz ganho de desempenho e de tamanho de código. Verificações em tempo de execução e código de compensação não são mais necessários: mais do trabalho pesado acontece em tempo de compilação. Não precisamos mais do custo de inicialização e de memória da compilação no lado do cliente. Como resultado, nossos usuários recebem código menor e mais rápido.

## Experimente! {:#try-it}

Encorajamos você a experimentar o [null safety](https://dart.dev/null-safety). Ele está disponível no Dart 2.12, agora no nosso canal beta. Assim que as suas dependências upstream forem migradas, você poderá migrar os seus próprios pacotes e aplicativos. Como o exemplo aqui ilustra, talvez você não precise mudar muita coisa.

Lembre-se de que, para obter os benefícios de desempenho do null safety, você precisa de um aplicativo totalmente migrado. Quando o seu aplicativo estiver totalmente migrado, nossos compiladores vão aproveitar automaticamente o null safety para gerar código melhor e menor.

## PS: o código {:#ps-the-code}

Aqui está o código Dart completo que compilei para gerar todo o código deste artigo. Embora o exemplo seja artificial, o padrão — um campo em uma hierarquia de classes — é bastante comum.

```dart
int N = 1000000;

class Animal {
  int age = 0;
}

class Cat extends Animal {}

class Dog extends Animal {}

class Snake extends Animal {}

class Hamster extends Animal {}

List<Animal> _animals = [
  new Cat()..age = 1,
  new Hamster()..age = 2,
  new Dog()..age = 3
];
List<Animal> listOfA = [];
void init() {
  for (int i = 0; i < N; ++i) {
    listOfA.add(_animals[i % _animals.length]);
  }
}

int sum() {
  int k = 0;
  for (int i = 0; i < N; ++i) {
    k += getAge(listOfA[i]);
  }
  return k;
}

@pragma('vm:never-inline')
int getAge(Animal a) {
  return a.age;
}

void main() {
  init();
  print(sum());
  print(getAge(listOfA[0]));
}
```
