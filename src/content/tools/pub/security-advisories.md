---
ia-translate: true
title: "Avisos de segurança"
description: >-
  Use avisos de segurança para informar e ser informado
  sobre vulnerabilidades de segurança em pacotes Dart.
---

Avisos de segurança são um meio de relatar informações sobre vulnerabilidades
de segurança. O Pub usa o [Banco de Dados de Avisos do GitHub][]
para publicar avisos de segurança para pacotes Dart e Flutter.

Para criar um aviso em seu repositório GitHub, use
o mecanismo de relatório de avisos de segurança do GitHub, conforme
explicado na documentação do GitHub sobre [Criando um aviso de segurança de
repositório][]. Primeiro, você cria um rascunho de aviso de segurança, que
será revisado pelo GitHub e inserido no banco de dados de avisos central.

[Banco de Dados de Avisos do GitHub]: https://github.com/advisories
[Criando um aviso de segurança de repositório]: https://docs.github.com/code-security/security-advisories/working-with-repository-security-advisories/creating-a-repository-security-advisory

## Avisos de segurança no cliente pub {:#security-advisories-in-the-pub-client}

O cliente pub exibe avisos de segurança na resolução de dependência.
Por exemplo, ao executar `dart pub get`, você obterá a seguinte saída:

```console
$ dart pub get
Resolvendo dependências...
http 0.13.0 (afetado por aviso: [^0], 1.2.0 disponível)
Obteve dependências!
As dependências são afetadas por avisos de segurança:
  [^0]: https://github.com/advisories/GHSA-4rgh-jx4f-qfcq
```

Se a resolução identificar um aviso, a equipe Dart recomenda que você
visite o link e revise o aviso.
Se você avaliar que a vulnerabilidade afeta seu pacote, você
deve considerar fortemente a atualização para uma versão não afetada da dependência.


### Ignorando avisos de segurança {:#ignoring-security-advisories}

Se um aviso de segurança não for relevante para seu aplicativo,
você pode suprimir o aviso adicionando o identificador do aviso ao
lista [`ignored_advisories`][] em `pubspec.yaml` do seu pacote.
Por exemplo, o seguinte ignora o aviso
com o identificador GHSA `GHSA-4rgh-jx4f-qfcq`:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

A lista `ignored_advisories` afeta apenas o pacote raiz. Avisos ignorados
em suas dependências não terão efeito na resolução do pacote
para seu próprio pacote.

[`ignored_advisories`]: /tools/pub/pubspec#ignored_advisories