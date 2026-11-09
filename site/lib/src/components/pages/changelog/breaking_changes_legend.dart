// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../models/changelog_model.dart';

import '../../common/dialog.dart';

/// A modal dialog extending [StatelessComponent] that displays definitions
/// of the various breaking change tags used in the changelog.
class BreakingChangesLegend extends StatelessComponent {
  const BreakingChangesLegend({
    required this.onClose,
    this.visible = false,
    super.key,
  });

  /// Callback triggered when the close button or overlay is clicked.
  final VoidCallback onClose;

  /// Whether the legend is visible.
  final bool visible;

  @override
  Component build(BuildContext context) {
    return Dialog(
      visible: visible,
      onClose: onClose,
      title: 'Tipos de mudança',
      children: const [
        dl([
          dt([.text('Novo '), _TagLabel(ChangelogTag.newTag)]),
          dd([.text('Introduz um novo recurso ou API.')]),
          dt([.text('Corrigido '), _TagLabel(ChangelogTag.fixed)]),
          dd([.text('Corrige um bug ou defeito.')]),
          dt([.text('Alterado '), _TagLabel(ChangelogTag.changed)]),
          dd([.text('Modifica comportamento ou APIs existentes.')]),
          dt([.text('Breaking '), _TagLabel(ChangelogTag.breaking)]),
          dd([
            .text('Mudança incompatível que pode exigir migração de código.'),
          ]),
          dt([.text('Não versionado')]),
          dd([
            .text(
              'O Dart SDK não mantém compatibilidade retroativa, '
              'e o código pode quebrar assim que você atualizar '
              'a versão do SDK se depender do comportamento anterior. '
              'Essa é a maioria das mudanças, e elas '
              'não recebem marcação especial.',
            ),
          ]),
          dt([
            .text('Versionado por linguagem '),
            _TagLabel(ChangelogTag.languageVersioned),
          ]),
          dd([
            .text(
              'O Dart SDK mantém compatibilidade retroativa para '
              'código existente, e a mudança de comportamento só vale quando '
              'você atualiza a versão de linguagem do seu código.',
            ),
          ]),
          dt([
            .text('Descontinuações '),
            _TagLabel(ChangelogTag.deprecated),
            .text(' / '),
            _TagLabel(ChangelogTag.removed),
          ]),
          dd([
            .text(
              'O Dart SDK mantém compatibilidade para código descontinuado, '
              'com um aviso. Depois, as descontinuações são removidas '
              'de vez em uma versão posterior, quebrando qualquer código que '
              'dependa do comportamento anterior.',
            ),
          ]),
          dt([
            .text('Experimental '),
            _TagLabel(ChangelogTag.experimental),
          ]),
          dd([
            .text(
              'Faz parte da versão, mas ainda não é tratado como estável no '
              'SDK e pode quebrar de uma versão para outra.',
            ),
          ]),
        ]),
      ],
    );
  }
}

/// A private helper component to render a consistent tag label.
class _TagLabel extends StatelessComponent {
  const _TagLabel(this.tag);

  /// The tag definition containing the ID (for CSS class) and label text.
  final ChangelogTag tag;

  @override
  Component build(BuildContext context) {
    return span(classes: 'tag-label ${tag.id}-tag', [
      .text(tag.label),
    ]);
  }
}
