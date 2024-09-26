# developer-guide

This repository contains the source code for the LASP developer guide. For more information about purpose, motivation,
scope, and contents, see the developer guide here: http://lasp-developer-guide.readthedocs.io/.

## Contributing

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

## Questions?

Any questions about this effort may be directed to the ``#ds-best-practices-documentation`` Slack channel.
