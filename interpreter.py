
from typing import List, Tuple, Union, Any
import sys
import re

Atom = str
SExp = Union[Atom, List['SExp']]


def tokenize(s: str) -> List[str]:
    # 保留字符串字面量，分离括号
    token_spec = r'"(\\.|[^\\"])*"|\(|\)|[^\s()]+'
    return re.findall(token_spec, s)


def parse_tokens(tokens: List[str], pos: int = 0) -> Tuple[SExp, int]:
    if pos >= len(tokens):
        raise SyntaxError('Unexpected EOF while reading')
    tok = tokens[pos]
    if tok == '(':
        lst: List[SExp] = []
        pos += 1
        while pos < len(tokens) and tokens[pos] != ')':
            elem, pos = parse_tokens(tokens, pos)
            lst.append(elem)
        if pos >= len(tokens) or tokens[pos] != ')':
            raise SyntaxError('Missing )')
        return lst, pos + 1
    elif tok == ')':
        raise SyntaxError('Unexpected )')
    else:
        # atom or string literal
        atom = tok
        # strip surrounding quotes for string literals
        if len(atom) >= 2 and atom[0] == '"' and atom[-1] == '"':
            atom = atom[1:-1]
        return atom, pos + 1


def parse_sexp(text: str) -> List[SExp]:
    tokens = tokenize(text)
    exps: List[SExp] = []
    pos = 0
    while pos < len(tokens):
        if tokens[pos].strip() == '':
            pos += 1
            continue
        exp, pos = parse_tokens(tokens, pos)
        exps.append(exp)
    return exps


def check_bracket_balance(text: str) -> Tuple[bool, str]:
    stack = []
    for i, ch in enumerate(text):
        if ch == '(':
            stack.append(i)
        elif ch == ')':
            if not stack:
                return False, f'Unmatched ) at position {i}'
            stack.pop()
    if stack:
        return False, f'Unmatched ( at position {stack[-1]}'
    return True, 'Brackets balanced'


def is_list(node: Any) -> bool:
    return isinstance(node, list)


def flatten_atoms(node: SExp) -> List[str]:
    if isinstance(node, list):
        out: List[str] = []
        for e in node[1:]:
            out.extend(flatten_atoms(e))
        return out
    else:
        return [str(node)]


def collect_predicates(tree: SExp) -> List[Tuple[str, List[str]]]:
    preds: List[Tuple[str, List[str]]] = []

    def visit(node: SExp):
        if isinstance(node, list) and node:
            head = node[0]
            if isinstance(head, str):
                args = flatten_atoms(node)
                preds.append((head, args))
            for child in node:
                if isinstance(child, list):
                    visit(child)

    visit(tree)
    return preds


def check_consistency(preds: List[Tuple[str, List[str]]]) -> Tuple[bool, List[str]]:
    messages: List[str] = []
    # Map predicate name -> set of args
    mapping = {}
    for name, args in preds:
        mapping.setdefault(name, set()).update(args)

    # Absolute contradiction: requires(X) and prevents(X)
    requires = mapping.get('requires', set())
    prevents = mapping.get('prevents', set())
    conflicts = requires & prevents
    if conflicts:
        for c in conflicts:
            messages.append(f'Conflict: both requires({c}) and prevents({c})')

    # Example conditional warning: first-line(X) and contraindicated(X,...)
    first_line = mapping.get('first-line', set())
    contraindicated = mapping.get('contraindicated', set())
    inter = first_line & contraindicated
    if inter:
        for c in inter:
            messages.append(f'Warning: first-line({c}) and contraindicated({c}) — verify condition')

    ok = len(messages) == 0
    return ok, messages


def verify_text(text: str) -> None:
    ok_balance, msg = check_bracket_balance(text)
    print('Bracket check:', msg)
    if not ok_balance:
        return
    try:
        exps = parse_sexp(text)
    except SyntaxError as e:
        print('Parse error:', e)
        return
    if not exps:
        print('No expressions found.')
        return
    # Validate each top-level expression
    for i, tree in enumerate(exps, 1):
        print(f'--- Expression #{i} ---')
        preds = collect_predicates(tree)
        ok, messages = check_consistency(preds)
        print(f'Parsed predicates ({len(preds)}):', ', '.join(p for p, _ in preds[:10]) or '(none)')
        if ok:
            print('Consistency: PASSED')
        else:
            print('Consistency: ISSUES FOUND')
            for m in messages:
                print(' -', m)


SAMPLE = '''(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))'''


def main(argv: List[str]):
    if len(argv) >= 2:
        path = argv[1]
        with open(path, 'r', encoding='utf-8') as f:
            text = f.read()
        verify_text(text)
    else:
        print('No input file provided — running sample verification.')
        verify_text(SAMPLE)


if __name__ == '__main__':
    main(sys.argv)
