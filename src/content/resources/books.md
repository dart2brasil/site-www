---
ia-translate: true
title: Livros sobre Dart
description: Leia tudo sobre isso! Aqui está uma coleção de livros sobre Dart.
toc: false
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

<div class="book-img-with-details row">
<a href="{{book.link}}" title="{{book.title}}" class="col-sm-3">
  <img src="/assets/img/cover/{{book.cover}}" alt="{{book.title}}">
</a>
<div class="details col-sm-9">

### [{{book.title}}]({{book.link}})
{:.title}

por {{book.authors | arrayToSentenceString}}
{:.authors.h4}

{{book.desc}}

</div>
</div>
{% endfor %}
