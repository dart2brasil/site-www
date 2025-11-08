---
ia-translate: true
title: unsafe_variance
description: >-
  Detalhes sobre o diagnóstico unsafe_variance
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unsafe_variance"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Este tipo não é seguro: um type parameter ocorre em uma posição não-covariant._

## Description

O analisador produz este diagnóstico quando um membro de instância tem um tipo de
resultado que é [contravariant ou invariant](https://dart.dev/resources/glossary#variance)
em um type parameter da declaração que o contém. O tipo de resultado de uma
variável é seu tipo, e o tipo de resultado de um getter ou método é seu
tipo de retorno. Este lint avisa contra tais membros porque eles provavelmente
causarão uma verificação de tipo com falha em tempo de execução, sem aviso estático ou erro
no local da chamada.

## Example

O código a seguir produz este diagnóstico porque `X` ocorre
como um tipo de parâmetro no tipo de `f`, que é uma
ocorrência contravariant deste type parameter:

```dart
class C<X> {
  bool Function([!X!]) f;
  C(this.f);
}
```

Isso não é seguro: Se `c` tem tipo estático `C<num>` e tipo em tempo de execução `C<int>`
então `c.f` lançará uma exceção. Portanto, toda invocação `c.f(a)` também lançará uma exceção,
mesmo no caso onde `a` tem um tipo correto como argumento para `c.f`.

## Common fixes

Se o membro com lint é ou pode ser privado, então você pode ser capaz
de garantir que ele nunca seja acessado em nenhum outro receptor além de `this`.
Isso é suficiente para garantir que o erro de tipo em tempo de execução não
ocorra. Por exemplo:

```dart
class C<X> {
  // NB: Ensure manually that `_f` is only accessed on `this`.
  // ignore: unsafe_variance
  bool Function(X) _f;

  C(this._f);

  // We can write a forwarding method to allow clients to call `_f`.
  bool f(X x) => _f(x);
}
```

Você pode eliminar a variance não segura usando um tipo mais geral para
o membro com lint. Neste caso, você pode precisar verificar o tipo em tempo de execução
e executar um downcast nos locais de chamada.

```dart
class C<X> {
  bool Function(Never) f;
  C(this.f);
}
```

Se `c` tem tipo estático `C<num>`, então você pode testar o tipo. Por exemplo,
`c.f is bool Function(num)`. Você pode chamá-lo com segurança com um argumento do
tipo `num` se ele tiver esse tipo.

Você também pode eliminar a variance não segura usando um tipo muito mais geral
como `Function`, que é essencialmente o tipo `dynamic` para
funções.

```dart
class C<X> {
  Function f;
  C(this.f);
}
```

Isso tornará `c.f(a)` dinamicamente seguro: Ele lançará uma exceção se e somente se o
argumento `a` não tiver o tipo exigido pela função. Isso é
melhor do que a versão original porque não lançará uma exceção por causa de um
tipo estático incompatível. Ele só lança uma exceção quando _deve_ lançar por razões de
soundness.
