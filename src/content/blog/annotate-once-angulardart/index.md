---
ia-translate: true
title: "Anote uma vez: AngularDart"
description: "Apresentando a herança de componentes"
publishDate: 2017-08-31
author: leonsenft
image: images/1JLI4Zv7yp3j6qSzoaGEehw.webp
category: deep-dive
layout: blog
---


<DashImage src="images/1JLI4Zv7yp3j6qSzoaGEehw.webp" alt="Um beija-flor de origami azul polinizando uma flor laranja." />


O AngularDart permite que desenvolvedores criem [componentes e diretivas](https://webdev.dartlang.org/angular/guide/architecture) anotando definições de classe com metadados. Esses metadados instruem o compilador a gerar o código necessário para injeção de dependência, construção de templates, data binding e muito mais.

```dart
import 'package:angular/angular.dart';

@Component(
  selector: 'greet',
  template: '<p>Hello {{name}}!</p>',
)
class GreetComponent {
  String name;
}
```

Até pouco tempo atrás, o compilador do AngularDart não processava metadados em supertipos. Isso significava que compartilhar funcionalidades comuns entre componentes e diretivas diferentes por meio de herança exigia declarar novamente todos os metadados em cada classe.

Vamos ver como era esse padrão.

*Ao longo deste artigo, voltaremos ao exemplo a seguir para demonstrar os benefícios da herança de metadados. É um exemplo simplificado, tirado dos [componentes Material Design para AngularDart](https://pub.dartlang.org/packages/angular_components) oficiais usados no Google.*

```dart
import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[my-button]')
class MyButtonDirective {
  final StreamController<UIEvent> _trigger = new StreamController<UIEvent>();
  
  @Input()
  bool disabled = false;

  @Output()
  Stream<UIEvent> get trigger => _trigger.stream;

  @HostListener('click', const [r'$event'])
  void onClick(MouseEvent event) {
    if (disabled) return;
    _trigger.add(event);
  }

  @HostListener('keypress', const [r'$event'])
  void onKeyPress(KeyboardEvent event) {
    if (disabled) return;
    if (event.keyCode == KeyCode.ENTER) {
      _trigger.add(event);
    }
  }
}
```

Aqui temos uma diretiva simples que adiciona a funcionalidade de botão ao seu elemento host. Se o elemento host for clicado, ou estiver com foco quando a tecla enter for pressionada, ele emite um evento pelo output `trigger`. Ele também pode ser desabilitado para não emitir eventos. Essa lógica pode ser reaproveitada para criar um componente de botão usando herança.

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Component(
  selector: 'my-button',
  template: '<ng-content></ng-content>',
  inputs: const ['disabled'],
  outputs: const ['trigger'],
  host: const {
    '(click)': r'onClick($event)',
    '(keypress)': r'onKeyPress($event)',
  },
)
class MyButtonComponent extends MyButtonDirective {}
```

Agora temos um componente que herda o comportamento de botão da diretiva, mas percebeu a necessidade de declarar de novo o input, o output e os host listeners na anotação do componente derivado?

A partir da versão 4.0, declarar metadados novamente em tipos derivados não é mais necessário!

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Component(
  selector: 'my-button',
  template: '<ng-content></ng-content>',
)
class MyButtonComponent extends MyButtonDirective {}
```

Agora `MyButtonComponent` tem implicitamente os mesmos input, output e host listeners que `MyButtonDirective`, de forma parecida com o jeito como uma classe normalmente herda propriedades e métodos. Agora que você viu um exemplo simples e, esperamos, convincente, vamos ver exatamente o que pode ser herdado e como isso funciona.

### O que pode ser herdado? {:#what-is-inheritable}

As anotações a seguir agora são herdadas de todos os supertipos, incluindo superclasses, interfaces e mixins.

* `@ContentChild` / `@ContentChildren`

* `@HostBinding`

* `@HostListener`

* `@Input`

* `@Output`

* `@ViewChild` / `@ViewChildren`

Isso significa que não é mais necessário declarar novamente nenhuma das anotações acima em uma classe derivada.

### O que não pode ser herdado? {:#what-isnt-inheritable}

Templates, estilos e outros parâmetros de `@Directive` *não* são herdados. Só os metadados vinculados a uma propriedade ou método são herdados. Essa decisão foi tomada porque tipos derivados podem sobrescrever acessores e métodos, referenciando a implementação original via `super`, enquanto não existe um mecanismo assim para os valores vinculados a outros metadados.

### Metadados herdados são imutáveis {:#inherited-metadata-is-immutable}

Ainda é válido declarar anotações novamente em tipos derivados; porém, não é permitido modificar os metadados herdados nem vinculá-los a outra propriedade.

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Directive(selector: '[illegal-button]')
class IllegalButtonDirective extends MyButtonDirective {
  @Input('notEnabled') // Changing the binding name causes a compile error.
  set disabled(bool value) {
    super.disabled = value; 
  }
}
```

Essa restrição pode ser removida no futuro, mas por enquanto é necessária para simplificar o ferramental e garantir que componentes e diretivas possam ser substituídos com facilidade.

### Tipos base de metadados {:#metadata-base-types}

A herança de metadados traz uma consequência interessante: classes que não são, elas mesmas, diretivas ou componentes agora podem ser anotadas para servir de tipos base ou mixins para outras. Vamos desenvolver mais o nosso exemplo para demonstrar.

Há um problema na implementação atual do componente de botão: o botão não pode receber foco. Isso significa que ele não é acessível e não pode ser acionado pelo listener de tecla pressionada. Esse problema também existe na diretiva de botão se o elemento host dela não puder receber foco. Podemos resolver isso fazendo a diretiva de botão definir a propriedade `tabindex` no elemento host.

`MyButtonDirective` poderia implementar isso diretamente, mas vamos imaginar que temos outros componentes que também vão querer o comportamento de receber foco. Em vez disso, vamos criar uma classe abstrata que pode ser estendida ou usada como mixin por diretivas ou componentes.

```dart
import 'package:angular/angular.dart';

abstract class HasTabIndex {
  bool get disabled;

  @HostBinding('tabindex')
  String get tabIndex => disabled ? null : '0';
}
```

Agora basta estender `HasTabIndex` ou usá-la como mixin para que a diretiva de botão (e, por consequência, o componente derivado) possa receber foco.

```dart
@Directive(selector: '[my-button]')
class MyButtonDirective extends HasTabIndex {
  ...
}
```

### Conclusão {:#conclusion}

Vimos como os metadados herdáveis reduzem a duplicação de código entre componentes e diretivas com funcionalidades em comum. Além disso, eles devem melhorar a legibilidade, já que permitem que os metadados fiquem ao lado do campo ou método associado. Esperamos que esse recurso seja útil no desenvolvimento e na manutenção dos seus próprios projetos.
