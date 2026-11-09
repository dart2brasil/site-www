---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e dos processos da equipe Dart para segurança.
showBreadcrumbs: false
skipFreshness: true
---

A equipe Dart leva a sério a segurança do Dart e das aplicações
criadas com ele.
Esta página descreve como relatar quaisquer vulnerabilidades que você encontrar
e lista as melhores práticas para minimizar o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança {:#security-philosophy}

A estratégia de segurança do Dart é baseada em cinco pilares principais:

- **Identificar**: Rastrear e priorizar os principais riscos de segurança, identificando os ativos
  principais, as ameaças principais e as vulnerabilidades.
- **Detectar**: Detectar e identificar vulnerabilidades usando técnicas e ferramentas como
  vulnerability scanning,
  static application security testing e fuzzing.
- **Proteger**: Eliminar riscos mitigando vulnerabilidades conhecidas e proteger
  ativos críticos contra ameaças de origem.
- **Responder**: Definir processos para relatar, triar e responder a vulnerabilidades
  ou ataques.
- **Recuperar**: Construir capacidades para conter e se recuperar de um incidente com
  impacto mínimo.

## Relatando vulnerabilidades {:#reporting-vulnerabilities}

Para relatar um problema de segurança, use [https://g.co/vulnz][].
A coordenação e a divulgação acontecem nos [repositórios GitHub dart-lang][repos]
(incluindo [GitHub security advisories][]).
Por favor, inclua uma descrição detalhada do problema,
os passos que você seguiu para reproduzi-lo, as versões afetadas e quaisquer
mitigações para o problema.
A equipe Google Security responderá em até 5 dias úteis após
o seu relato em g.co/vulnz.

Para mais informações sobre como o Google lida com problemas de segurança, veja
[a filosofia de segurança do Google][Google's security philosophy].

## Sinalizando problemas existentes como relacionados à segurança {:#flagging-existing-issues-as-security-related}

Se você acredita que um problema existente está relacionado à segurança,
pedimos que o relate via [https://g.co/vulnz][] e inclua
o id do problema no seu relato.

## Versões suportadas {:#supported-versions}

Nós nos comprometemos a publicar atualizações de segurança para a versão do Dart atualmente na
última versão [stable][] do Dart.

[stable]: https://dart.dev/get-dart#release-channels

## Expectativas {:#expectations}

Tratamos problemas de segurança como equivalentes a um nível de prioridade P0
e lançamos uma correção beta ou um patch
para quaisquer problemas de segurança importantes encontrados
na versão stable mais recente do Dart SDK.
Qualquer vulnerabilidade relatada para sites do Dart, como dart.dev, não
exige um lançamento e será corrigida no próprio site.

O Dart não tem um programa de bug bounty.

## Recebendo atualizações de segurança {:#receiving-security-updates}

Dependendo do problema e da versão da correção, um anúncio será feito na
lista de e-mails [dart-announce]({{site.announce}}).

## Melhores práticas {:#best-practices}

* **Mantenha-se atualizado com as últimas versões do Dart SDK.**
  Atualizamos o Dart regularmente, e essas atualizações podem corrigir defeitos de segurança
  descobertos em versões anteriores.
  Verifique o [changelog do Dart][Dart changelog]
  para atualizações relacionadas à segurança.

* **Mantenha as dependências da sua aplicação atualizadas.**
  Certifique-se de [atualizar as dependências dos seus pacotes][upgrade your package dependencies]
  para mantê-las atualizadas.
  Evite fixar versões específicas
  das suas dependências e, se fizer isso, verifique
  periodicamente se as suas dependências receberam atualizações de segurança,
  e atualize a versão fixada de acordo.

[Dart changelog]: /changelog
[GitHub security advisories]: https://docs.github.com/en/code-security/security-advisories
[Google's security philosophy]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: {{site.repo.dart.org}}/
[upgrade your package dependencies]: /tools/pub/packages#upgrading-a-dependency
