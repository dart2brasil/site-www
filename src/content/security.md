---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e processos de segurança da equipe Dart.
showBreadcrumbs: false
skipFreshness: true
---

A equipe Dart leva a sério a segurança do Dart e das aplicações
criadas com ele.
Esta página descreve como relatar quaisquer vulnerabilidades que você encontrar,
e lista as melhores práticas para minimizar o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança

A estratégia de segurança do Dart é baseada em cinco pilares principais:

- **Identificar**: Rastrear e priorizar os principais riscos de segurança, identificando ativos principais,
  principais ameaças e vulnerabilidades.
- **Detectar**: Detectar e identificar vulnerabilidades usando técnicas e ferramentas como
  vulnerability scanning,
  static application security testing e fuzzing.
- **Proteger**: Eliminar riscos mitigando vulnerabilidades conhecidas e proteger
  ativos críticos contra ameaças de origem.
- **Responder**: Definir processos para relatar, triar e responder a vulnerabilidades
  ou ataques.
- **Recuperar**: Construir capacidades para conter e recuperar de um incidente com
  impacto mínimo.

## Relatando vulnerabilidades

Para relatar um problema de segurança, use [https://g.co/vulnz][].
A coordenação e divulgação acontecem nos [repositórios GitHub dart-lang][repos]
(incluindo [GitHub security advisories][]).
Por favor, inclua uma descrição detalhada do problema,
as etapas que você seguiu para criar o problema, versões afetadas e quaisquer
mitigações para o problema.
O Google Security Team responderá dentro de 5 dias úteis do
seu relato em g.co/vulnz.

Para mais informações sobre como o Google lida com problemas de segurança, consulte
[a filosofia de segurança do Google][Google's security philosophy].

## Sinalizando problemas existentes como relacionados à segurança

Se você acredita que um problema existente está relacionado à segurança,
pedimos que você o relate via [https://g.co/vulnz][] e inclua
o id do problema no seu relato.

## Versões suportadas

Comprometemo-nos a publicar atualizações de segurança para a versão do Dart atualmente para
o lançamento [stable][] mais recente do Dart.

[stable]: https://dart.dev/get-dart#release-channels

## Expectativas

Tratamos problemas de segurança equivalentes a um nível de prioridade P0
e lançamos uma correção beta ou patch
para quaisquer problemas de segurança importantes encontrados
no lançamento stable mais recente do Dart SDK.
Qualquer vulnerabilidade relatada para sites Dart como dart.dev não
requer um lançamento e será corrigida no próprio site.

Dart não possui um programa de bug bounty.

## Recebendo atualizações de segurança

Dependendo do problema e do lançamento da correção, um anúncio será feito para a
lista de e-mails [dart-announce](https://groups.google.com/a/dartlang.org/g/announce).

## Melhores práticas

* **Mantenha-se atualizado com os últimos lançamentos do Dart SDK.**
  Atualizamos regularmente o Dart, e essas atualizações podem corrigir defeitos de segurança
  descobertos em versões anteriores.
  Verifique o [changelog do Dart][Dart changelog]
  para atualizações relacionadas à segurança.

* **Mantenha as dependências da sua aplicação atualizadas.**
  Certifique-se de [atualizar as dependências do seu pacote][upgrade your package dependencies]
  para manter as dependências atualizadas.
  Evite fixar versões específicas
  para suas dependências e, se fizer isso, certifique-se de verificar
  periodicamente se suas dependências tiveram atualizações de segurança,
  e atualize a fixação da versão de acordo.

[Dart changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[GitHub security advisories]: https://docs.github.com/en/code-security/security-advisories
[Google's security philosophy]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: {{site.repo.dart.org}}/
[upgrade your package dependencies]: /tools/pub/packages#upgrading-a-dependency
