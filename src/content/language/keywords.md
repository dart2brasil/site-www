---
ia-translate: true
title: Keywords
description: Palavras-chave em Dart.
toc: false
prevpage:
  url: /language/libraries
  title: Libraries
nextpage:
  url: /language/built-in-types
  title: Built-in types
---

{% assign ckw = '&nbsp;<sup>1</sup>' %}
{% assign bii = '&nbsp;<sup>2</sup>' %}
{% assign unr = '&nbsp;<sup>3</sup>' %}

A tabela a seguir lista as palavras que a linguagem Dart reserva para seu
próprio uso. Essas palavras não podem ser usadas como identificadores, a menos
que seja indicado o contrário. Mesmo quando permitido,
usar palavras-chave como identificadores pode confundir
outros desenvolvedores que leem seu código e deve ser
evitado. Para saber mais sobre o uso de identificadores, clique no termo.

<table class="table table-striped">

{% tablerow keyword in keywords cols: 4 %}
<a href="{{keyword.link}}">{{keyword.term}}</a>
{%- case keyword.type %}
{% when 'bit' %}{{bii}}
{% when 'context' %}{{ckw}}
{% when 'unrestricted' %}{{unr}}
{% endcase %}
{% endtablerow %}
</table>

{{ckw}} Esta palavra-chave pode ser usada como um identificador
        dependendo do **contexto**.

{{bii}} Esta palavra-chave não pode ser usada como o nome de um tipo
        (uma classe, um mixin, um enum, um tipo de extensão ou um alias de tipo),
        o nome de uma extensão, ou como um prefixo de importação.
        Ela pode ser usada como um identificador em todas as outras circunstâncias.

{{unr}} Esta palavra-chave pode ser usada como um identificador sem restrição.
