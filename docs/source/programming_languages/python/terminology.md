# Python Terminology

Some Python terminology that a user might encounter, particularly when working through this Python guide.

## Purpose

Like all programming languages, Python has some terminology that is unique to it and it is helpful to have that language
explained. This page may be updated over time so that it holds the most useful terminology to those that use this
developer's guide.

### Library Packages vs Applications vs Scripts

Python is a highly flexible interpreted language. This means it's easy to get started, quick to write, and easy to run.
Unfortunately, this also means it's very easy to write code that works in one context but not in others or code that is
robust but isn't designed to be inherited.

**Package**: A `python` package, intended for redistribution, containing objects that serve as building blocks for
other developers to use. Examples are `numpy`, `pytest`, and `sqlalchemy`.

> **Note** While most people think of a Python package as the above definition, a Python "package" is technically
> any directory containing an `__init__.py` file.

**Application**: A python project (which may or may not be a packaged distribution) that provides specific and possibly
configurable functionality. Examples are Poetry, the AWS CLI, the Conda CLI, the Green Unicorn WSGI HTTP server, any
Django "app".

**Script**: Pretty much anything else written in Python. One could arguably say that a Script is just a trivial Application
with little configuration or portability. Scripts are usually run with `python my_script.py argv`. They tend to be
difficult to maintain, update, or distribute.

**Packaging Tooling**: Not only managing a local environment, but also providing tooling for developing, building, and
distributing python packages for other users. While Conda does support this use case (it's how one creates and
distributes conda packages to `conda-forge`), Poetry and `setuptools` are much easier to develop with (for PyPI) and Poetry
boasts a similar dependency resolver to Conda. One major drawback to Conda in packaging is that there is no notion of an
"editable install" so the developer is forced to build and test end user functionality (e.g. script entrypoints) over
and over instead of simply making code changes in place.

## Useful Links

Helpful links to additional resources on the topic

Credit: Content taken from a Confluence guide written by Gavin Medley
