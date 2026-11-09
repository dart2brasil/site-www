#!/usr/bin/env python3
"""Tradução PT-BR de src/data/diagnostics.json e src/data/linter_rules.json.

Esses JSONs vêm prontos do upstream (dart-lang/site-www), que os gera a partir
do SDK. Aqui eles são a nossa fonte: traduzimos no próprio arquivo e, a cada
sync com o upstream, retraduzimos só o que mudou.

Uso:
  python3 tool/i18n/diagnostics_i18n.py status [--ref upstream/main]
      Lista as entradas cujo texto ainda é idêntico ao do upstream (em inglês).
  python3 tool/i18n/diagnostics_i18n.py export <dir> [--ref upstream/main] [--all]
      Escreve <dir>/en/<kind>__<id>.md para cada entrada ainda em inglês
      (ou todas, com --all). Traduza para <dir>/pt/ com o mesmo nome.
  python3 tool/i18n/diagnostics_i18n.py import <dir>
      Lê <dir>/pt/*.md e grava as traduções de volta nos JSONs.

Campos traduzidos:
  diagnostics.json  -> documentation (description é a mensagem do analisador,
                       igual à que aparece na IDE; fica em inglês de propósito)
  linter_rules.json -> description e details
"""
import argparse
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DIAG = 'src/data/diagnostics.json'
LINT = 'src/data/linter_rules.json'


def load(path):
    with open(os.path.join(ROOT, path), encoding='utf-8') as f:
        return json.load(f)


def load_ref(path, ref):
    out = subprocess.run(['git', '-C', ROOT, 'show', f'{ref}:{path}'],
                         capture_output=True, text=True, check=True).stdout
    return json.loads(out)


def save(path, data):
    # Mantém a formatação do upstream (indent 2, UTF-8 cru e a presença ou não
    # de \n no fim) para os merges futuros só conflitarem nas entradas que
    # mudaram de verdade.
    full = os.path.join(ROOT, path)
    with open(full, encoding='utf-8') as f:
        trailing_newline = f.read().endswith('\n')
    with open(full, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        if trailing_newline:
            f.write('\n')


def to_md(kind, entry):
    if kind == 'diag':
        return entry['documentation'] + '\n'
    return ('---\ndescription: ' + json.dumps(entry['description'], ensure_ascii=False)
            + '\n---\n\n' + entry['details'] + '\n')


def from_md(kind, text):
    if kind == 'diag':
        return {'documentation': text[:-1] if text.endswith('\n') else text}
    if not text.startswith('---\ndescription: '):
        raise ValueError('frontmatter "description" ausente')
    head, _, body = text[len('---\n'):].partition('\n---\n')
    desc = json.loads(head[len('description: '):])
    body = body[1:] if body.startswith('\n') else body
    return {'description': desc, 'details': body[:-1] if body.endswith('\n') else body}


def _slug(text):
    """Mesmo algoritmo de slugify() em site/lib/src/util.dart."""
    s = re.sub(r'[:.]', '-', text.lower().strip())
    s = re.sub(r'[^\w\s:._-]', '', s)
    return re.sub(r'[\s-]+', '-', s).strip('-')


def _heading_lines(md):
    inside, out = False, []
    for i, line in enumerate(md.split('\n')):
        if line.lstrip().startswith('```'):
            inside = not inside
        elif not inside and re.match(r'^#{1,6} ', line):
            out.append(i)
    return out


def add_english_anchors(translated, original):
    """Põe {:#id-em-inglês} nos títulos traduzidos, para os links com âncora
    do dart.dev (ex.: #common-fixes) continuarem funcionando."""
    pt, en = translated.split('\n'), original.split('\n')
    hp, he = _heading_lines(translated), _heading_lines(original)
    if len(hp) != len(he):
        return translated
    for a, b in zip(hp, he):
        if '{:' not in pt[a]:
            pt[a] = pt[a].rstrip() + ' {:#' + _slug(re.sub(r'^#+ ', '', en[b])) + '}'
    return '\n'.join(pt)


def untranslated(ref):
    """Yields (kind, id, entry) for entries identical to the upstream ref."""
    up_d = {x['id']: x for x in load_ref(DIAG, ref)}
    for x in load(DIAG):
        u = up_d.get(x['id'])
        if x.get('documentation') and u and x['documentation'] == u.get('documentation'):
            yield 'diag', x['id'], x
    up_l = {x['name']: x for x in load_ref(LINT, ref)}
    for x in load(LINT):
        u = up_l.get(x['name'])
        # Só o details decide: descrições curtas ("Use `ColoredBox`.") podem ser
        # iguais nas duas línguas.
        if u and x['details'] == u['details']:
            yield 'lint', x['name'], x


def cmd_status(args):
    items = list(untranslated(args.ref))
    for kind, id_, _ in items:
        print(f'{kind}\t{id_}')
    d = sum(1 for k, *_ in items if k == 'diag')
    print(f'\n{d} diagnósticos e {len(items) - d} lints ainda em inglês.', file=sys.stderr)


def cmd_export(args):
    if args.all:
        items = [('diag', x['id'], x) for x in load(DIAG) if x.get('documentation')]
        items += [('lint', x['name'], x) for x in load(LINT)]
    else:
        items = list(untranslated(args.ref))
    os.makedirs(os.path.join(args.dir, 'en'), exist_ok=True)
    os.makedirs(os.path.join(args.dir, 'pt'), exist_ok=True)
    for kind, id_, entry in items:
        with open(os.path.join(args.dir, 'en', f'{kind}__{id_}.md'), 'w', encoding='utf-8') as f:
            f.write(to_md(kind, entry))
    print(f'{len(items)} arquivos exportados para {args.dir}/en')


def cmd_import(args):
    pt = os.path.join(args.dir, 'pt')
    diag, lint = load(DIAG), load(LINT)
    # O texto em inglês de cada entrada, antes da importação, para as âncoras.
    original = {('diag', x['id']): x.get('documentation') or '' for x in diag}
    original.update({('lint', x['name']): x['details'] for x in lint})
    by = {'diag': {x['id']: x for x in diag}, 'lint': {x['name']: x for x in lint}}
    n, errs = 0, []
    for root, _, files in os.walk(pt):
        for name in sorted(files):
            if not name.endswith('.md') or '__' not in name:
                continue
            kind, id_ = name[:-3].split('__', 1)
            entry = by.get(kind, {}).get(id_)
            if entry is None:
                errs.append(f'{name}: entrada não existe mais no JSON')
                continue
            try:
                with open(os.path.join(root, name), encoding='utf-8') as f:
                    new = from_md(kind, f.read())
                field = 'documentation' if kind == 'diag' else 'details'
                new[field] = add_english_anchors(new[field], original[(kind, id_)])
                entry.update(new)
                n += 1
            except Exception as e:  # noqa: BLE001
                errs.append(f'{name}: {e}')
    save(DIAG, diag)
    save(LINT, lint)
    print(f'{n} traduções importadas.')
    for e in errs:
        print('ERRO', e, file=sys.stderr)
    sys.exit(1 if errs else 0)


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest='cmd', required=True)
    s = sub.add_parser('status'); s.add_argument('--ref', default='upstream/main'); s.set_defaults(f=cmd_status)
    e = sub.add_parser('export'); e.add_argument('dir'); e.add_argument('--ref', default='upstream/main')
    e.add_argument('--all', action='store_true'); e.set_defaults(f=cmd_export)
    i = sub.add_parser('import'); i.add_argument('dir'); i.set_defaults(f=cmd_import)
    args = p.parse_args()
    args.f(args)


if __name__ == '__main__':
    main()
