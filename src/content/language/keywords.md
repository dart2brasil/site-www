---
ia-translate: true
title: Keywords
description: Keywords em Dart.
showToc: false
---

{% assign ckw = '&nbsp;<sup>1</sup>' %}
{% assign bii = '&nbsp;<sup>2</sup>' %}
{% assign unr = '&nbsp;<sup>3</sup>' %}

A tabela a seguir lista as palavras
que a linguagem Dart reserva para seu próprio uso.
Essas palavras não podem ser usadas como identificadores, a menos que indicado de outra forma.
Mesmo quando permitido, usar keywords como identificadores pode confundir outros
desenvolvedores lendo seu código e deve ser evitado.
Para saber mais sobre o uso de identificadores, clique no termo.

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

{{ckw}} Esta keyword pode ser usada como um identificador
        dependendo do **contexto**.

{{bii}} Esta keyword não pode ser usada como o nome de um tipo
        (uma classe, um mixin, um enum, um extension type ou um type alias),
        o nome de um extension, ou como um prefixo de import.
        Pode ser usada como um identificador em todas as outras circunstâncias.

{{unr}} Esta keyword pode ser usada como um identificador sem restrição.
