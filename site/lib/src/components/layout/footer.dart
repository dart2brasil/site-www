// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// The site-wide footer.
final class DashFooter extends StatelessComponent {
  const DashFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(
      id: 'page-footer',
      attributes: {'data-nosnippet': 'true'},
      [
        div(classes: 'footer-section footer-main', [
          a(
            href: '/',
            classes: 'brand',
            attributes: {'title': 'Dart'},
            [
              img(
                src: '/assets/img/logo/logo-white-text.svg',
                alt: 'Dart',
                width: 164,
              ),
            ],
          ),
          div(classes: 'footer-social-links', [
            a(
              href: 'https://blog.dart.dev',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s Medium publication',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/medium.svg#medium',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://github.com/dart-lang',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s GitHub organization',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/github.svg#github',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://bsky.app/profile/dart.dev',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s Bluesky (Twitter) profile',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/bluesky.svg#bluesky',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://twitter.com/dart_lang',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s X (Twitter) profile',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {'href': '/assets/img/social/x.svg#x'},
                  ),
                ]),
              ],
            ),
          ]),
        ]),
        div(classes: 'footer-section footer-translation-feedback', [
          p([
            text('Encontrou essa página sem tradução ou que precisa de correção? '),
            a(
              id: 'translation-issue-link',
              href: '#',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Abrir issue no GitHub',
              },
              events: {
                'click': (event) {
                  event.preventDefault();
                  // Get current page URL
                  final currentUrl = web.window.location.href;

                  // Create issue title and body
                  final title = Uri.encodeComponent('Problema de tradução');
                  final body = Uri.encodeComponent(
                    'Página: $currentUrl\n\n'
                    '## Descrição do problema\n'
                    '<!-- Descreva o problema encontrado -->\n\n'
                    '## Sugestão de correção\n'
                    '<!-- Se possível, sugira uma correção -->\n',
                  );

                  // Open GitHub issue with pre-filled content
                  final issueUrl =
                      'https://github.com/dart2brasil/site-www/issues/new?title=$title&body=$body';
                  web.window.open(issueUrl, '_blank');
                },
              },
              [text('Abra uma issue')],
            ),
            text(' e nos ajude a manter esse site em PT-Br para ajduar pessoas como você.'),
          ]),
        ]),
        div(classes: 'footer-section footer-tray', [
          div(classes: 'footer-licenses', [
            text('Except as otherwise noted, this site is licensed under a '),
            a(href: 'https://creativecommons.org/licenses/by/4.0/', [
              text('Creative Commons Attribution 4.0 International License,'),
            ]),
            text(' and code samples are licensed under the '),
            a(href: 'https://opensource.org/licenses/BSD-3-Clause', [
              text('3-Clause BSD License.'),
            ]),
          ]),
          div(classes: 'footer-utility-links', [
            ul([
              li([
                a(
                  href: '/terms',
                  attributes: {'title': 'Terms of use'},
                  [text('Terms')],
                ),
              ]),
              li([
                a(
                  href: 'https://policies.google.com/privacy',
                  target: Target.blank,
                  attributes: {'rel': 'noopener', 'title': 'Privacy policy'},
                  [text('Privacy')],
                ),
              ]),
              li([
                a(
                  href: '/security',
                  attributes: {'title': 'Security philosophy and practices'},
                  [text('Security')],
                ),
              ]),
            ]),
            div(classes: 'footer-technology', [
              a(
                classes: 'jaspr-badge-link',
                href: 'https://jaspr.site',
                target: Target.blank,
                attributes: {
                  'rel': 'noopener',
                  'title':
                      'This site is built with the '
                      'Jaspr web framework for Dart.',
                },
                [
                  span([const JasprBadge.light()]),
                  span([const JasprBadge.lightTwoTone()]),
                ],
              ),
            ]),
          ]),
        ]),
      ],
    );
  }
}
