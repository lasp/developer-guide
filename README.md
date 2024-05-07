# developer-guide

## Purpose

The purpose of this repository is to provide a collection of documented guidelines for software development workflows
and processes commonly used within Datasystems in order to assist developers in accomplishing their work. The developer
guide is  managed within this version-controlled GitHub repository as to allow for the collaborative creation and
maintenance of the guidelines.

## Motivation

This effort is motivated by Goal 3.1 from the 2024-2027 Dataystems Strategic Plan, which states "Create a set of living
DS best practices and training guides that include standard processes and expectations for common tasks".

Historically, such documentation has been spread over multiple pages and spaces within confluence and specific projects.
The developer guide endeavors to bring these resources together in one centralized space, allowing for collaboration
across individuals and teams. We can collectively determine "how we work best" and document such guidelines in a
version-controlled repository with access to the collaborative tools that GitHub provides.

Through this guide, we seek to promote a culture of continuous improvement, where feedback is encouraged, and processes
are regularly reviewed and updated to reflect evolving industry standards and emerging technologies.

Another goal to provide an equal footing for all people, regardless of their background and skill levels. Having
accessible, well-documented guidelines available to all people associated with the lab is a way to ensure all employees
(and students), regardless of background, have the same access to information. The lack of diversity within the fields
represented in Datasystems can be accounted for, in part, by how accessible - or not - the fields are. Prohibitive
costs, dearth of mentorship, strict mores and norms (think: expectations when finding an advisor or going to a
conference), and equal access to information all play a part in this overall accessibility. We can start to address
the last item on the list within our own workplace. In building this developer guide, we hope to create an accessible
start for those new to the job or learning new skills.

## Scope

The developer guide aims to provide guidelines and recommendations, not mandates. It also aims to provide information
in a non-redundant way, and avoid re-writing what may already be well documented somewhere on the internet. Instead of
describing a topic in detail, the developer guide attempts to answer the question -- "How do I apply this concept in the
context of my work in Datasystems?"

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

4. Install the ``pre-commit`` hooks (i.e. ``pre-commit install``)
5. Create a branch on that personal fork (i.e. ``git checkout -b <branch-name>``)
6. Commit changes (i.e. ``git add <file-that-changed.md>``, ``git commit -m <commit-message>``)
7. Push that branch to your fork (i.e. ``git push origin <branch-name>``)
8. On the ``lasp`` repository, create a new pull request
9. Assign a reviewer
10. Iterate with the reviewer over any needed changes until the reviewer approves of the pull request. This may require
    additional commits to the pull request. Once all changes are approved, merge the pull request.

## Questions?

Any questions about this effort may be directed to the ``#ds-best-practices-documentation`` Slack channel.
