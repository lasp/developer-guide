# developer-guide

This repository contains the source code for the LASP developer guide. This README serves as a
guide for those who wish to contribute. For more information about purpose, motivation, scope, and
contents of the developer guide, see the developer guide homepage here:
<http://lasp-developer-guide.readthedocs.io/>.

## Contributing

### First-time setup

After cloning the repo, run these two commands once:

```bash
pip install poetry pre-commit
poetry install          # installs Sphinx and all doc dependencies
pre-commit install      # wires up the git commit hooks
```

`pre-commit install` is important — it runs a set of checks automatically every time you
`git commit`, so formatting problems are caught locally before they ever reach CI.

### Making changes

1. Create a branch: `git checkout -b my-branch`
2. Edit or add `.md` files under `docs/source/`
3. Preview the docs locally (see below)
4. Commit — pre-commit hooks run automatically and fix what they can
5. If hooks modify files, `git add .` and commit again
6. Push and open a pull request

### Previewing docs locally

```bash
poetry run sphinx-build -n docs/source docs/source/build
open docs/source/build/index.html
```

To match CI exactly (warnings treated as errors):

```bash
poetry run sphinx-build -W --keep-going -n docs/source docs/source/build
```

### Pre-commit hooks

The following checks run automatically on every `git commit`:

| Hook | What it catches / fixes |
|---|---|
| `trailing-whitespace` | Trailing spaces (auto-fixed) |
| `end-of-file-fixer` | Missing trailing newline (auto-fixed) |
| `check-merge-conflict` | Leftover `<<<<`/`>>>>` conflict markers |
| `check-yaml` | Syntax errors in YAML files |
| `check-case-conflict` | Filenames that differ only by case |
| `markdownlint` | Heading hierarchy, line length, blank lines (auto-fixes where safe) |
| `rstcheck` | Broken toctree entries and RST directives |
| `yamllint` | Style issues in workflow and config YAML |
| `codespell` | Spelling mistakes in `.md`, `.rst`, `.yml` (auto-fixes unambiguous ones) |

To run all hooks manually against every file:

```bash
poetry run pre-commit run --all-files
```

Hooks that can auto-fix (trailing whitespace, missing newlines, some Markdown issues, spelling)
will modify files and exit non-zero. Just `git add .` and commit again — the fixes are already
applied.

### What happens when you open a pull request

Two automated checks run on every PR:

1. **GitHub Actions — "Build Sphinx docs"** (~2 min): builds the docs with warnings-as-errors.
   Click **Details** on the check to see the full Sphinx output in the job summary.

2. **ReadTheDocs — "docs/readthedocs.com"** (~5–8 min): builds a live preview of exactly what
   the docs will look like if merged. Click **Details** for a direct URL you can open in any
   browser — no login or download required.

Both checks must pass before a PR can be merged.

### Markdown

This project uses Markdown for all documentation content.
[This Markdown Guide](https://markdownguide.org) is a good resource. New contributors are also
encouraged to look through existing documents for formatting examples.

Line length is capped at **120 characters** (enforced by `markdownlint`). Code blocks and tables
are exempt.

### Organization

Documents are organized by topic under `docs/source/`. If it is not clear where to place a new
document, open a GitHub issue so the group can discuss it.

Use `guideline_template.md` as the starting point for any new guideline page, and register the
new file in the nearest `index.rst` toctree.

### Consistency in formatting, language, and tone

* Avoid sharing opinions about topics without supporting facts
* Stick to third-person language and avoid using first-person
* Avoid jargon, acronyms, or abbreviations unless they are defined
* Keep sentences and paragraphs concise; break up long blocks of text
* Format code snippets consistently (always specify a language tag on fenced code blocks)

### What is out of scope

* Do not include any credentials, usernames, passwords, etc.
* Do not include links or references to LASP internal resources
* Do not include any material that is considered Controlled Unclassified Information (CUI)
* Do not include informal meeting notes

### git Workflow

If you would like to contribute changes to the content of this repository, do the following:

1. Create a fork of this repository
2. Make a local clone of your fork:

```bash
git clone https://github.com/<username>/developer-guide.git  # HTTPS
git clone git@github.com:<username>/developer-guide.git      # SSH
cd developer-guide/
```

3. Set your personal fork to point to an `origin` and `upstream` remote:

```bash
git remote set-url origin git@github.com:<username>/developer-guide.git
git remote add upstream git@github.com:lasp/developer-guide.git
```

4. Run the first-time setup steps above (`poetry install`, `pre-commit install`)
5. Create a branch: `git checkout -b <branch-name>`
6. Make changes, commit (`git add <file>`, `git commit -m "<message>"`)
7. Push: `git push origin <branch-name>`
8. Open a pull request against `lasp/developer-guide`
9. The automated checks will run; address any failures before requesting review
10. Iterate with reviewers until approved, then merge

<!-- markdownlint-disable-next-line MD026 -->
## Questions?

Any questions about this effort may be directed to the `#ds-best-practices-documentation` Slack
channel.
