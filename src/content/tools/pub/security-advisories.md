---
title: Security advisories
description: >-
  Use security advisories to inform and be informed
  about security vulnerabilities in Dart packages.
ia-translate: true
---

Security advisories são um meio de reportar informações sobre
vulnerabilidades de segurança. Pub usa o [GitHub Advisory Database][]
para publicar security advisories para pacotes Dart e Flutter.

Para criar um advisory em seu repositório GitHub, use
o mecanismo de reporte de security advisory do GitHub conforme
explicado na documentação do GitHub sobre [Creating a repository security advisory][].
Primeiro você cria um draft security advisory, que então será revisado pelo
GitHub e ingerido no banco de dados central de advisory.

[GitHub Advisory Database]: https://github.com/advisories
[Creating a repository security advisory]: https://docs.github.com/code-security/security-advisories/working-with-repository-security-advisories/creating-a-repository-security-advisory

## Security advisories in the pub client

O cliente pub exibe security advisories na resolução de dependências.
Por exemplo, ao executar `dart pub get` você obterá a seguinte saída:

```console
$ dart pub get
Resolving dependencies...
http 0.13.0 (affected by advisory: [^0], 1.2.0 available)
Got dependencies!
Dependencies are affected by security advisories:
  [^0]: https://github.com/advisories/GHSA-4rgh-jx4f-qfcq
```

Se a resolução identificar um advisory, o time Dart recomenda que você
visite o link e revise o advisory.
Se você avaliar que a vulnerabilidade afeta seu pacote,
você deve fortemente considerar atualizar para uma versão não afetada da dependência.


### Ignoring security advisories

Se um security advisory não é relevante para sua aplicação,
você pode suprimir o aviso adicionando o identificador do advisory à
lista [`ignored_advisories`][] no `pubspec.yaml` do seu pacote.
Por exemplo, o seguinte ignora o advisory
com o identificador GHSA `GHSA-4rgh-jx4f-qfcq`:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

A lista `ignored_advisories` afeta apenas o pacote raiz. Advisories ignorados
em suas dependências não terão efeito na resolução de pacotes
para seu próprio pacote.

[`ignored_advisories`]: /tools/pub/pubspec#ignored_advisories