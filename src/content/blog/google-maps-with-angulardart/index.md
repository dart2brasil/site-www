---
ia-translate: true
title: "Google Maps com AngularDart"
description: "Neste artigo vamos integrar o Google Maps a uma aplicação AngularDart. O app calcula a distância do grande círculo…"
publishDate: 2017-02-23
author: isoos
image: images/1hLce2qgbJEkxjOlOr8jn9g.webp
category: other
skipTemplateRendering: true
layout: blog
---


Neste artigo vamos integrar o Google Maps a uma aplicação AngularDart. O app em si será bem simples: ele calcula a [distância do grande círculo](https://en.wikipedia.org/wiki/Great-circle_distance) (a menor distância na superfície de uma esfera) entre dois marcadores selecionados no mapa.

Ao longo do caminho, você vai:

* Registrar sua própria chave de API do Google Maps.

* Criar uma aplicação web Angular básica.

* Integrar o Dart com a API JavaScript do Google Maps e tratar a interação com o mapa.

* Aprender algumas dicas de acabamento para o componente Angular.

Este artigo é cerca de quatro vezes mais longo que o código. Se quiser, basta ir direto ao [**código-fonte completo**](https://github.com/isoos/google_maps_angular_dart) e à [**demo**](https://isoos.github.io/google_maps_angular_dart/) final.

<DashImage src="images/1hLce2qgbJEkxjOlOr8jn9g.webp" alt="Demo do Google Maps mostrando marcadores perto de Paris e Roma com uma distância calculada de 1095 km." caption="Captura de tela da demo" />


## API JavaScript do Google Maps {:#google-maps-javascript-api}

A [API JavaScript do Google Maps](https://developers.google.com/maps/documentation/javascript/) permite que desenvolvedores incorporem e integrem o Google Maps em seus sites. Você pode personalizar o conteúdo exibido no mapa e o seu tratamento com suas próprias imagens, dados e processamento.

Para começar a desenvolver com a API do Google Maps, você precisa registrar uma chave de API gratuita, que permite um uso razoável. À medida que sua aplicação ganhar tração, você pode migrar para um plano pago.

Acesse a [página da API JavaScript](https://developers.google.com/maps/documentation/javascript/) e, no topo da página, clique em `GET A KEY`. Crie um nome para o seu projeto e clique em `CREATE AND ENABLE API`:

<DashImage src="images/1cPMKvi22U5csti4Dubb-4A.webp" alt="Caixa de diálogo com o título 'Enable Google Maps JavaScript API' e um campo de texto com 'My Dart Map Project' preenchido." />


Sua chave será habilitada e estará pronta para uso em alguns segundos:

<DashImage src="images/18Opaixc6Ardgd0wYKyvKNw.webp" alt="Mensagem de sucesso 'You're all set!' no console da API do Google Maps, indicando que a chave de API está pronta para uso." />


Anote sua chave de API. Vamos usá-la ao carregar a biblioteca JavaScript do Maps:

```
https://maps.googleapis.com/maps/api/js?key=KEY_GOES_HERE
```


Em JavaScript, para criar uma instância de mapa e colocar um marcador nele, usaríamos o seguinte código:

```js
var hostElement = document.getElementById('map-id');
var map = new google.maps.Map(hostElement, {
  zoom: 2,
  center: {lat: 47.4979, lng: 19.0402}
});
var marker = new google.maps.Marker({
  position: {lat: 47.4979, lng: 19.0402},
  map: map,
  label: 'A'
});
```


Como você verá mais adiante, o código em Dart será muito parecido (com todos os benefícios adicionais do Dart).

## A aplicação AngularDart {:#the-angulardart-application}

A forma mais fácil de começar com uma aplicação AngularDart é seguir o guia [Get Started](https://webdev.dartlang.org/guides/get-started) e [criar um novo projeto](https://webdev.dartlang.org/guides/get-started#4-create-and-run-a-web-app) no WebStorm ou na Community Edition do IntelliJ IDEA.

Caso você use outro editor, ou apenas queira seguir a estrutura do nosso código de exemplo, aqui está o mínimo necessário.

No arquivo de pubspec, `pubspec.yaml`:

```
name: google_maps_angular_dart
version: 0.0.1
description: Angular application with Google Maps integration

environment:
  sdk: '>=1.19.0 <2.0.0'

dependencies:
  angular2: ^2.2.0

dev_dependencies:
  dart_to_js_script_rewriter: ^1.0.1

transformers:
- angular2:
    platform_directives:
      - 'package:angular2/common.dart#COMMON_DIRECTIVES'
    platform_pipes:
      - 'package:angular2/common.dart#COMMON_PIPES'
    entry_points: web/main.dart
- dart_to_js_script_rewriter
```


Na página hospedeira, `web/index.html`:

```
<!DOCTYPE html>
<html>
<head>
    <!-- other headers -->
    <script defer src="main.dart" type="application/dart"></script>
</head>
<body>
   **<map-control></map-control>**
</body>
</html>
```


No ponto de entrada da aplicação, `web/main.dart`:

```
import 'package:angular2/platform/browser.dart';
import 'package:google_maps_angular_dart/component/map_control.dart';

void main() {
  bootstrap(MapControl);
}
```


No arquivo Dart do componente `&lt;map-control&gt;`, `lib/component/map_control.dart`:

```
import 'package:angular2/core.dart';

@Component(
  selector: 'map-control',
  template: '{{distance}}',
)
class MapControl {
  String distance = 'no distance yet';
}
```


O código acima não faz muita coisa, mas é um começo, e você pode executá-lo usando `pub serve` e depois abrindo a página no Dartium:

```
$ pub serve
Loading source assets...
Loading angular2 and dart_to_js_script_rewriter transformers...
Serving google_maps_angular_dart web on [http://localhost:8080](http://localhost:8080)
Build completed successfully
```


## Integração com o Google Maps {:#google-maps-integration}

Para começar a integração com o Google Maps, coloque a seguinte tag script no seu `web/index.html`. Observe que você precisa definir sua chave de API:

```
<script src="https://maps.googleapis.com/maps/api/js?key=**[YOUR_KEY_HERE]**"></script>
```


Felizmente, existe um pacote Dart pronto para uso do Google Maps no pub. Adicione-o ao seu `pubspec.yaml`:

```
dependencies:
  angular2: ^2.2.0
  **google_maps: ^3.0.0**
```


Em seguida, execute `pub get` para baixar o pacote.

Precisamos criar um elemento hospedeiro para a área do mapa no template do nosso componente. Vamos começar com um estilo básico e usar a âncora `#mapArea` para identificar o elemento no próximo passo:

```
<div style="width: 300px; height: 300px" #**mapArea**>[map]</div>
```


No código do componente, podemos injetar a referência do elemento da seguinte forma:

```
@ViewChild('mapArea')
ElementRef mapAreaRef;
```


A referência do elemento não está disponível imediatamente depois que a classe MapControl é criada, então precisamos nos conectar aos callbacks do ciclo de vida do Angular:

```
class MapControl **implements AfterViewInit** {

  @override
  void ngAfterViewInit() {
    // mapAreaRef is available now
  }
}
```


Dica: use a IDE para escrever os corpos dos métodos para você. Por exemplo, no IntelliJ, pressione `CMD + N` (ou `CTRL + N`) e selecione o item de menu “Implement Methods…”. Ele permitirá selecionar os métodos que faltam, e você só precisa se preocupar com o corpo do método:

<DashImage src="images/1V9N-6dAV8vZjuT6cI1Sftw.webp" alt="Menu de contexto no IntelliJ IDEA mostrando opções de 'Generate', como 'Constructor', 'Getter' e 'Implement Methods...'." />


Como mostra o código a seguir, a API do Dart é muito parecida com a do JavaScript, com o benefício adicional de ser verificada pelo sistema de tipos.

```
class MapControl implements AfterViewInit {
  // ...

@override
  void ngAfterViewInit() {
    GMap map = new GMap(
        mapAreaRef.nativeElement,
        new MapOptions()
          ..zoom = 2
          ..center = new LatLng(47.4979, 19.0402)
                             // ^ Budapest, Hungary
        );
    new Marker(new MarkerOptions()
      ..map = map
      ..position = new LatLng(47.4979, 19.0402)
      ..label = 'A');
  }
}
```


Um exemplo dos benefícios da verificação de tipos é que, ao escutar eventos, não precisamos pensar em como acessar as propriedades. Por exemplo, a IDE pode nos ajudar a encontrar a propriedade do MouseEvent (`latLng`) que guarda a localização do marcador.

Aqui está o código que reage ao arrastar o marcador:

```
    marker.onDrag.listen((MouseEvent event) {
      print('New location while dragging: ${event.latLng}');
    });
```


Capturar eventos de clique no mapa é semelhante:

```
    map.onClick.listen((MouseEvent event) {
      print('User clicked on position: ${event.latLng}');
    });
```


## Juntando tudo {:#putting-it-together}

Para medir a distância entre duas coordenadas, vamos acompanhar dois marcadores no mapa. O usuário poderá arrastar os marcadores ou posicioná-los clicando.

Precisamos manter o mapa e os marcadores como campos:

```
  GMap _map;
  Marker _aMarker;
  Marker _bMarker;
```


Atualize a inicialização para armazenar a referência do mapa e registrar um handler de clique. O handler de clique atualiza as posições dos marcadores e a distância:

```
  @override
  void ngAfterViewInit() {
    **_map** = new GMap(
        mapAreaRef.nativeElement,
        new MapOptions()
          ..zoom = 2
          ..center = new LatLng(47.4979, 19.0402)
                             // ^ Budapest, Hungary
        );
    **_map.onClick**.listen((MouseEvent event) {
      **_updatePosition**(event.latLng);
      **_updateDistance**();
    });
  }
```


Aqui está o código da primeira parte do handler de clique:

```
  void _updatePosition(LatLng position) {
    if (_aMarker == null) {
      _aMarker = _createMarker(_map, 'A', position);
    } else if (_bMarker == null) {
      _bMarker = _createMarker(_map, 'B', position);
    } else {
      _aMarker.position = _bMarker.position;
      _bMarker.position = position;
    }
  }
```


O código para instanciar o marcador é semelhante ao exemplo anterior:

```
  Marker _createMarker(GMap map, String label, LatLng position) {
    final Marker marker = new Marker(new MarkerOptions()
      ..map = map
      ..draggable = true
      ..label = label
      ..position = position);
    marker.onDrag.listen((MouseEvent event) {
      _updateDistance();
    });
    return marker;
  }
```


Com a ajuda de funções utilitárias de `dart:math`, conseguimos fazer as contas do cálculo da distância do grande círculo e definir o valor no nosso campo `distance`:

```
  /// Radius of the earth in km.
  const int radiusOfEarth = 6371;

double _toRadian(num degree) => degree * PI / 180.0;

void _updateDistance() {
    if (_aMarker == null || _bMarker == null) return;
    LatLng a = _aMarker.position;
    LatLng b = _bMarker.position;
    double dLat = _toRadian(b.lat - a.lat);
    double sLat = pow(sin(dLat / 2), 2);
    double dLng = _toRadian(b.lng - a.lng);
    double sLng = pow(sin(dLng / 2), 2);
    double cosALat = cos(_toRadian(a.lat));
    double cosBLat = cos(_toRadian(b.lat));
    double x = sLat + cosALat * cosBLat * sLng;
    double d = 2 * atan2(sqrt(x), sqrt(1 - x)) * radiusOfEarth;
    distance = '${d.round()} km';
  }
```


Você já se perguntou a que distância mora de um parente, de um local famoso ou de um ponto de referência? Chegou a hora de testar a aplicação e conferir por si mesmo. Acontece que a minha casa fica a 9815 km da sede do Google em Mountain View:

<DashImage src="images/1AOtq_2d-f5cETtXb-ixzYA.webp" alt="Mapa mostrando a distância entre o Googleplex, em Mountain View, Califórnia, e a casa do autor, em Budapeste, Hungria." caption="A distância entre o Googleplex, em Mountain View, Califórnia, e a casa do autor, em Budapeste, Hungria" />


## Polindo a aplicação {:#polishing-the-application}

A integração com o Google Maps na nossa aplicação Angular está completa neste ponto. Estamos escutando e reagindo aos eventos do mapa e criando objetos no mapa. Nesta última seção, vamos implementar recursos que dão um acabamento legal para a nossa demo.

### Separar template e estilo {:#separate-template-and-style}

É uma boa prática colocar um template de UI complexo em um arquivo .html separado. Podemos fazer o mesmo com os estilos CSS:

```
@Component(
    selector: 'map-control',
    templateUrl: 'map_control.html',
    styleUrls: const <String>['map_control.css'])
class MapControl implements AfterViewInit {
```


O elemento do mapa tem uma classe CSS, map-area:

```
<div class="map-area" #mapArea>[map]</div>
```


Nosso arquivo CSS pode ser tão simples quanto este:

```
.map-area {
  width: 500px;
  height: 400px;
  margin: 10px;
}
```


### Tratando a unidade de distância {:#handling-the-unit-of-distance}

Algumas pessoas dominam as conversões entre km ⟷ milhas, mas o resto de nós prefere um dropdown para selecionar a unidade de distância. No template HTML, o dropdown pode ser um simples elemento `&lt;SELECT&gt;` com um model binding para o campo `unit`.

```
<label>Unit:</label>
<select [(ngModel)]="**unit**">
  <option value="km">km</option>
  <option value="miles">miles</option>
</select>
```


No código Dart, queremos armazenar a unidade e atualizar a distância sempre que a unidade for alterada:

```
String _unit = 'km';

String get unit => _unit;

set unit(String value) {
  _unit = value;
  _updateDistance();
}
```


E não se esqueça de atualizar o `km` fixo que estava no cálculo da distância:

```
    /// Const value to convert from km to miles.
    const double milesPerKm = 0.621371;

    // ... same code as earlier
    if (unit == 'miles') {
      d *= milesPerKm;
    }
    distance = '${d.round()} $unit';
```


### Formatando as coordenadas {:#formatting-the-coordinates}

E se tivermos interesse em publicar a posição dos nossos marcadores? A forma mais fácil seria expor os valores de posição em Dart, para que possamos usar `{{a}}` e `{{b}}` no template:

```
  // Expose the position values.
  LatLng get a => _aMarker?.position;
  LatLng get b => _bMarker?.position;
```


O template pode ocultar o rótulo quando o marcador ainda não estiver inicializado, evitando possíveis problemas com valores nulos:

```
  <div *ngIf="a != null">A: {{a}}</div>
  <div *ngIf="b != null">B: {{b}}</div>
```


No entanto, `{{a}}` seria traduzido para uma chamada a `LatLng.toString()`, que nos daria dois valores double muito longos, quando alguns dígitos bastariam. Uma solução é usar pipes no template:

```
<div *ngIf="a != null">A: {{a.lat | number : '1.4-4'}}, {{a.lng | number : '1.4-4'}}</div>
<div *ngIf="b != null">B: {{b.lat | number : '1.4-4'}}, {{b.lng | number : '1.4-4'}}</div>
```


O [guia de sintaxe de templates](https://webdev.dartlang.org/angular/guide/template-syntax) sugere colocar essa lógica na classe controladora, para facilitar os testes:

```
  /// Formatted position of the 'A' marker.
  String get **aPosition** => _formatPosition(a);

  /// Formatted position of the 'B' marker.
  String get bPosition => _formatPosition(b);

  String _formatPosition(LatLng pos) {
    if (pos == null) return null;
    return '${pos.lat.toStringAsFixed(4)}, ' 
        '${pos.lng.toStringAsFixed(4)}';
  }
```


Com isso, o template pode ficar bem mais simples:

```
<div *ngIf="a != null">A: {{**aPosition**}}</div>
<div *ngIf="b != null">B: {{**bPosition**}}</div>
```


### Limpando o template {:#clean-up-the-template}

Como último passo, mova todas as partes de código que restaram no template para o controlador:

```
  /// Whether the 'A' marker's positions should be shown
  bool get **showA** => a != null;

  /// Whether the 'B' marker's positions should be shown
  bool get showB => b != null;

  /// Whether the 'distance' label should be shown
  bool get showDistance => distance != null;
```


Feito isso, o template referencia apenas os getters:

```
<div *ngIf="**showA**">A: {{aPosition}}</div>
<div *ngIf="**showB**">B: {{bPosition}}</div>

<p *ngIf="showDistance">
  Distance: {{distance}}<br/>
</p>
```


## Considerações finais {:#closing-notes}

Como você pode ver, implementar uma integração bidirecional com o Google Maps é fácil: o código-fonte é limpo e legível. Com o suporte completo da toolchain do Dart, ele é facilmente extensível, sem nunca se preocupar com o que possamos quebrar em outros lugares.

Como exercício para o leitor, você pode adicionar uma [visualização em mapa de calor](https://developers.google.com/maps/documentation/javascript/earthquakes#heatmaps) ao mapa usando a mesma API em Dart. Confira o pacote [google_maps](https://pub.dartlang.org/packages/google_maps) para ver todas as possibilidades.
