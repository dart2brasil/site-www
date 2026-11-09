---
ia-translate: true
title: "Anunciando o Dart 3.9"
description: "Olá, desenvolvedores Dart! A versão estável mais recente, o Dart 3.9, já está oficialmente disponível!"
publishDate: 2025-08-14
author: antfitch
image: images/1VIHR_FuzQzulhqczfx8eAA.webp
category: releases
layout: blog
---


Esta versão é toda sobre facilitar o seu trabalho e tornar seus apps mais eficientes. Com atualizações importantes no null safety, ganhos de desempenho na CLI do Dart e a chegada empolgante do servidor MCP do Dart e do Flutter para dar superpoderes aos seus assistentes de IA, há muito o que curtir. Continue lendo para descobrir tudo o que há de novo no Dart 3.9.

<DashImage src="images/1VIHR_FuzQzulhqczfx8eAA.webp" alt="Banner de lançamento do Dart 3.9 com o logo do Dart e um ícone de alvo animado." caption="Anunciando o Dart 3.9" />


## Atualizações da linguagem {:#language-updates}

### Null safety {:#null-safety}

O Dart 3.9 assume null safety ao calcular a promoção de tipos, a alcançabilidade e a atribuição definitiva. Para aproveitar essas melhorias, defina o limite inferior da restrição de SDK do seu pacote como 3.9 ou superior (`sdk: ^3.9.0`). Como consequência dessa mudança, podem aparecer mais avisos de dead_code.

### **Atualizações de solidez** {:#soundness-updates}

Corrigimos um problema de solidez que permitia a invocação direta de um valor retornado por um getter sem nenhuma verificação em tempo de execução, quando o tipo de retorno do getter era um argumento de tipo genérico instanciado como dynamic ou Function. Esse problema de solidez surgiu com o compilador de desenvolvimento DDC, e nenhuma outra ferramenta é afetada.

Antes da correção, o getter a seguir podia disparar um problema com uma invocação direta. Por exemplo:

```dart
// The following getter used to trigger an issue with a direct 
// invocation

// The getter
class Container<T> {
  T get value => ((int i) => i.isEven) as T;
}

// The direct invocation
Container<dynamic>().value('Invocation with missing runtime checks!');
```


## Atualizações de ferramentas {:#tools-updates}

### **Servidor MCP do Dart e do Flutter** {:#dart-and-flutter-mcp-server}

O [servidor MCP do Dart e do Flutter](https://dart.dev/tools/mcp-server) funciona como uma ponte, dando a assistentes de código com IA, como o Gemini CLI, o Cursor e o GitHub Copilot, acesso a mais do contexto do seu projeto Dart. Em vez de apenas sugerir código, seu assistente de IA agora pode entender o seu projeto em profundidade e agir em seu nome.

Com o servidor MCP do Dart e do Flutter, você pode pedir a um assistente de IA para:

* Corrigir erros em tempo de execução ([veja o exemplo](https://dart.dev/tools/mcp-server#fix-a-runtime-layout-error-in-a-flutter-app)).

* Gerenciar dependências ([veja o exemplo](https://dart.dev/tools/mcp-server#add-new-functionality-with-package-search)).

* Escrever e corrigir código.

* E mais.

O servidor MCP do Dart e do Flutter já está disponível no canal estável do SDK do Dart.

<DashImage src="images/13K1rgoDtIBWbIFZPp1VCEQ.webp" alt="Animação mostrando um assistente de IA corrigindo um problema de layout usando o servidor MCP do Dart e do Flutter." caption="*Corrigindo um problema de layout, possibilitado pelo servidor MCP do Dart e do Flutter (partes desta gravação foram aceleradas)*" />


### **CLI do Dart mais rápida** {:#faster-dart-cli}

Antes, quando você executava alguns [comandos da CLI do Dart](https://dart.dev/tools/dart-tool), como `dart analyze` ****e `dart fix`, o computador precisava compilar o código do [servidor de análise](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/README.md) logo antes de executá-lo. Agora, essas ferramentas usam um snapshot do servidor de análise compilado antecipadamente (AOT, *Ahead-Of-Time*), o que significa que o servidor foi pré-compilado em código de máquina nativo e rápido.

Os resultados variam conforme o código-fonte, mas executamos alguns comandos comuns em um pacote de exemplo e obtivemos resultados interessantes. Alguns comandos curtos, como `dart format`, agora são concluídos em uma fração do tempo, e os de execução mais longa, como `dart analyze`, ficaram quase 50% mais rápidos.

<DashImage src="images/1NkNNA4xfB08k9FjtIHSTEw.webp" alt="Gráfico mostrando as melhorias de desempenho dos comandos da CLI do Dart, como format e analyze mais rápidos." caption="Exemplo de resultados de desempenho após a atualização da CLI do Dart" />


### **Atualizações do cliente do pub** {:#pub-client-updates}

As [dependências Git](https://dart.dev/tools/pub/dependencies#git-packages) agora podem ter a versão resolvida com base em tags do git.

Quando você usa um `tag_pattern` no descritor e há uma restrição de `version`, todos os commits que correspondem ao padrão são considerados durante a resolução. No exemplo a seguir, apenas a versão 2.0.1 de `my_dependency` e as superiores são consideradas:

```yaml
dependencies:
  my_dependency:
    git:
      url: https://github.com/example/my_dependency
      tag_pattern: v{{version}}
    version: ^2.0.1
```


A partir da [versão da linguagem](https://dart.dev/language/versioning) 3.9, o limite superior da restrição de `flutter` agora é respeitado no seu pacote raiz (a restrição de `dart` já era respeitada). Definir uma restrição de dart ou de flutter mais restrita pode ser útil para garantir que uma equipe de desenvolvedores use a mesma versão do SDK ao desenvolver um app em conjunto (veja a [issue #95472](https://github.com/flutter/flutter/issues/95472) para detalhes).

Por exemplo, em um pubspec raiz como este, o `pub get` vai falhar se for invocado com uma versão do SDK do Flutter diferente de 3.33.0:

```yaml
name: my_app
environment:
  sdk: ^3.9.0
  flutter: 3.33.0
```


### **Compilador nativo do Dart** {:#dart-native-compiler}

Adicionamos [suporte a compilação cruzada](https://dart.dev/tools/dart-compile#cross-compilation-exe) para as arquiteturas de destino `arm` (ARM32) e `riscv64` (RV64GC) quando o sistema operacional de destino é Linux.

## Descontinuações e mudanças incompatíveis {:#deprecations-breaking-changes}

### **Arquitetura x86 de 32 bits** {:#32-bit-x86-architecture}

O Dart descontinuou a arquitetura x86 de 32 bits. Para a maioria dos desenvolvedores, isso não terá impacto, pois afeta principalmente emuladores Android x86 mais antigos e um pequeno número de dispositivos físicos. Emuladores e dispositivos ARM de 32 bits e x86_64 de 64 bits continuam suportados. O detalhamento técnico completo está disponível na [issue de descontinuação no GitHub do Dart](https://github.com/dart-lang/sdk/issues/49969).

### **dart build** {:#dart-build}

O `dart build` está em prévia no canal beta.

`dart build -f exe &lt;target&gt;` agora é `dart build cli — target=&lt;target&gt;`. Veja `dart build cli — help` para mais informações.

## Encerramento {:#wrap-up}

É isso por enquanto para o Dart 3.9! Esperamos que você esteja tão empolgado com essas atualizações quanto nós. Sempre agradecemos o seu feedback, então sinta-se à vontade para compartilhar suas ideias. Até a próxima, bom código!
