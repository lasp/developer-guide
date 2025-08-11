# developer-guide

This repository contains the source code for the LASP developer guide. This README serves as a guide for those who wish
to contribute. For more information about purpose, motivation, scope, and contents of the developer guide, see the
developer guide homepage here: http://lasp-developer-guide.readthedocs.io/.

## Contributing

### Markdown

This project uses the Markdown language as the source code for all documentation.
[This Markdown Guide](https://markdownguide.org) is a good resource for learning/troubleshooting Markdown syntax (google,
StackOverflow, and ChatGPT are also useful for this). Additionally, new contributors are encouraged to look through the
existing documents for examples on how to use Markdown and how to contribute with consistent formatting.

### Organization

Documents in this developer guide are mainly organized by topic, and is subject to change as more documents are added
and the project evolves. If it is not clear where to place a new document, feel free to open a GitHub issue so that the
larger group of developers can discuss it.

### Consistency in formatting, language, and tone

We aim to have a consistent tone and use of language throughout the documentation. Some things to keep in mind when
contributing:

* Avoid sharing opinions about topics without supporting facts
* Stick to third-person language and avoid using first-person
* Avoid jargon, acronyms, or abbreviations unless they are defined
* Keep sentences and paragraphs concise—break up long blocks of text
* Follow a consistent capitalization style for headings, code terms, proper nouns, etc
* Format code snippets consistently (indentation, language tags for syntax highlighting).

### What is out of scope

* Do not include any credentials, usernames, passwords, etc.
* Do not include any material that is considered Controlled Unclassified Information (CUI)
* Do not include informal meeting notes

### Template

Please refer to the
[guideline template](https://github.com/lasp/developer-guide/blob/main/guideline_template.md) markdown file as a
template for new guidelines. This template should be considered as guidance, and not a hard rule -- sections may be
removed, added, or edited based on the contributor's discretion and what makes sense for the topic.

### How to view the documentation as it appears on ReadTheDocs

It is often helpful to view what the final product will look like while developing. To do this, one can build the
docs locally and view them in a local browser:

```bash
cd docs/
make clean && make html
open build/html/index.html
```

### git Workflow

If you would like to contribute changes to the content of this repository, do the following:

1. Create a fork of this repository
2. Make a local clone of your fork:

```bash
git clone https://github.com/<username>/developer-guide.git  # For HTTPS
git clone git@github.com:<username>/developer-guide.git  # For SSH
cd developer-guide/
```

3. Set your personal fork to point to an ``origin`` and ``upstream`` remote:

```bash
git remote set-url origin git@github.com:<username>/developer-guide.git  # For SSH
git remote add upstream git@github.com:lasp/developer-guide.git  # For SSH

git remote set-url origin https://github.com/<username>/developer-guide.git  # For HTTPS
git remote add upstream https://github.com/lasp/developer-guide.git  # For HTTPS
```

4. Install the ``pre-commit`` hooks (i.e. ``pre-commit install``) (you may need to ``pip install pre-commit`` first)
5. Create a branch on that personal fork (i.e. ``git checkout -b <branch-name>``)
6. Commit changes (i.e. ``git add <file-that-changed.md>``, ``git commit -m <commit-message>``)
7. Push that branch to your fork (i.e. ``git push origin <branch-name>``)
8. On the ``lasp`` repository, create a new pull request
9. Assign a reviewer
10. Iterate with the reviewer over any needed changes until the reviewer approves of the pull request. This may require
    additional commits to the pull request. Once all changes are approved, merge the pull request.

<!-- markdownlint-disable-next-line MD026 -->
## Questions?

Any questions about this effort may be directed to the ``#ds-best-practices-documentation`` Slack channel.
