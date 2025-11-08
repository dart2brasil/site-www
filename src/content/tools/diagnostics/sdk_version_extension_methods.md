---
ia-translate: true
title: sdk_version_extension_methods
description: "Detalhes sobre o diagnóstico sdk_version_extension_methods produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Métodos de extensão não eram suportados até a versão 2.6.0, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando uma declaração de extensão ou uma
sobreposição de extensão é encontrada em código que tem uma restrição de SDK cuja limite inferior
é menor que 2.6.0. O uso de extensões não era suportado em versões anteriores,
então este código não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.6.0:

```yaml
environment:
 sdk: '>=2.4.0 <2.7.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
[!extension!] E on String {
  void sayHello() {
    print('Hello $this');
  }
}
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.6.0 <2.7.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não fazer uso de extensões. A forma mais comum de fazer isso é reescrever
os membros da extensão como funções (ou métodos) de nível superior que recebem
o valor que teria sido associado a `this` como um parâmetro:

```dart
void sayHello(String s) {
  print('Hello $s');
}
```
