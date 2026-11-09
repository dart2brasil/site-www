---
ia-translate: true
title: "O Dart ganha um sistema de tipos"
description: "Alegrem-se, todos os fiéis, pois o Dart 2.0 está chegando, e ele tem tipos."
publishDate: 2017-07-04
author: davidmorgan
image: images/0C4V5HBaOprKmpRUh.webp
category: announcements
layout: blog
---


<DashImage src="images/0C4V5HBaOprKmpRUh.webp" alt="Duas pessoas pulando em silhueta ao pôr do sol." />


Esta é a primeira grande mudança incompatível do Dart, e daí o “2” no nome, e é justamente *por causa* de ser uma mudança incompatível que ela é um desenvolvimento tão importante. Vamos entender por quê. Primeiro, um código do Dart 1:

```
void main() {
  cleanUp([new TempFile(), new BankAccount()]);
}

void cleanUp(List<TempFile> files) =>
    files.forEach((f) => f.delete());

class TempFile {
  void delete() => print('TempFile deleted.');
}

class BankAccount {
  void delete() => print('BankAccount deleted. Whoops!');
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


O código é um pouco surpreendente.

Tanto “TempFile” quanto “BankAccount” têm um método “delete”; acontece que, como o Dart 1 não se importa com tipos por padrão, ele vai alegremente nos deixar chamar “delete” em um “BankAccount” quando estávamos claramente tentando chamar “delete” em um “TempFile”.

Não é bom.

## Análise do Strong Mode {:#strong-mode-analysis}

Entra o Strong Mode, o novo sistema de tipos do Dart. (Não vamos precisar do nome quando o Dart 2.0 chegar; será simplesmente “o sistema de tipos”).

O [analisador do Dart](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli) já oferece análise estática no Strong Mode há algum tempo; ele usa inferência de tipos para descobrir quais tipos você provavelmente pretendia e exige que cada variável tenha um único tipo. Ele também adiciona rigor em relação a overrides e genéricos.

Se passarmos o trecho de código acima para o analisador com o Strong Mode habilitado, ele nos diz:

```
error: The element type 'BankAccount' can't be assigned to the list type 'TempFile'.
```


…o que parece razoável. Problema resolvido. Ou não?

Infelizmente, não. Há algumas formas de enganar a análise estática. Por exemplo, podemos usar “new List.from”, que aceita qualquer “Iterable”:

```
void main() {
  var list = new List<TempFile>.from(
      [new TempFile(), new BankAccount()]);
  cleanUp(list);
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


…e o analisador não consegue ajudar. Simplesmente não há como pegar esse problema com verificações estáticas.

## O Strong Mode de verdade {:#strong-mode-proper}

Aqui chegamos ao conceito de solidez (*soundness*): se o sistema de tipos consegue cumprir o que promete. As verificações estáticas extras do analisador ajudam a pegar bugs, mas não são suficientes para fechar todas as brechas. O que é necessário são algumas verificações adicionais em tempo de execução.

Atualmente, há apenas um runtime do Dart que implementa essas verificações: o [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler). Se executarmos o último trecho com o DDC, obtemos um erro em tempo de execução:

```
Type 'BankAccount' is not a subtype of type 'TempFile'
```


Então, nossa conta bancária está segura. O Strong Mode com verificações em tempo de execução garante que, se tentarmos executar “TempFile.delete”, nunca, em circunstância alguma[1], executaremos “BankAccount.delete” no lugar.

## Dart 2.0 {:#dart-2-0}

E aqui voltamos ao anúncio do Dart 2.0 e ao motivo de ele ser importante.

A razão pela qual o DDC é o único runtime a adicionar essas verificações é que elas são mudanças incompatíveis na linguagem. Programas que antes eram válidos deixam de ser válidos. O DDC é uma ferramenta de desenvolvimento, então ele não precisa compilar e executar todo o Dart válido; a VM e o dart2js precisam.

Assim, com a mudança para o Dart 2.0, os programas com problemas de tipo agora podem ser declarados inválidos, e todos os runtimes podem seguir em frente para oferecer tipos que cumpram o que prometem. Um final feliz e um passo importante para a minha linguagem de programação favorita.

## Um parêntese: e nada de valor foi perdido {:#aside-and-nothing-of-value-was-lost}

É natural perguntar sobre as *desvantagens* da mudança. E se *quisermos* tipos frouxos no Dart?

Felizmente, a linguagem já cobre isso. Sempre podemos desativar as verificações de tipo com o tipo especial “dynamic”. Na verdade, “dynamic” é o padrão se você não adicionar uma anotação de tipo, então poderíamos ter escrito apenas “List” em vez de “List&lt;TempFile&gt;”:

```
void main() {
  cleanUp([new TempFile(), new BankAccount()]);
}

void cleanUp(List files) =>
    files.forEach((f) => f.delete());

class TempFile {
  void delete() => print('TempFile deleted.');
}

class BankAccount {
  void delete() => print('BankAccount deleted. Whoops!');
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


…e temos código do Dart 2.0 perfeitamente válido[2]. O método “cleanUp” agora é escrito para funcionar com *qualquer* classe que tenha um método “delete”, e é exatamente isso que ele faz.

*[1] Como outras linguagens [já mostraram](https://dev.to/rosstate/java-is-unsound-the-industry-perspective), deixar um sistema de tipos 100% sólido é difícil. Mas não haverá nenhuma* forma conhecida *de quebrar o sistema de tipos.*

*[2] O Dart 2.0 ainda não existe, então isso não é 100% garantido. Mas, quanto aos tipos, deve estar tudo bem.*
