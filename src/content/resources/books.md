---
ia-translate: true
title: Books about Dart
shortTitle: Books
description: Read all about it! Here's a collection of books about Dart.
showToc: false
---

Esta página cobre uma coleção de livros sobre a linguagem Dart.
Muitos [livros sobre Flutter]({{site.flutter-docs}}/resources/books)
também cobrem Dart.
Se você encontrar outro livro sobre Dart que possa ser útil,
[nos avise.]({{site.repo.this}}/issues)

:::warning
Se você encontrar um livro sobre Dart que não esteja listado nesta página,
verifique as datas de publicação posteriores a junho de 2021.
Livros mais antigos não cobrem tópicos do Dart 2 e 3, como
tipagem forte (strong typing), null safety, FFI (Foreign Function Interface - Interface de Função Estrangeira), o utilitário de linha de comando `dart`
e novas ferramentas de desenvolvedor.
:::


{% for book in books-dart %}

<div class="book-img-with-details">
<a href="{{book.link}}" title="{{book.title}}">
  <img src="/assets/img/cover/{{book.cover}}" alt="{{book.title}}" />
</a>
<div class="details">

<h3 class="title" id="{{book.title | slugify}}">
<a href="{{book.link}}">{{book.title}}</a>
</h3>

by {{book.authors | arrayToSentenceString}}
{:.authors}

{{book.desc}}

</div>
</div>
{% endfor %}
