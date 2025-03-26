# Python Best Practices

Some Python terminology that a user might encounter, particularly when working through this Python guide.

## Purpose

This document is intended to provide a guide for LASP Python developers. In particular, we hope that any libraries that
are intended to be shared at LASP will adhere to these conventions. We recognize that individual projects may need to
violate some of these principles but we strive to keep them general enough that few exceptions will be made.

## General

### Values

- "Build tools for others that you want to be built for you." - Kenneth Reitz
- "Simplicity is always better than functionality." - Pieter Hintjens
- "Fit the 90% use-case. Ignore the nay sayers." - Kenneth Reitz
- "Beautiful is better than ugly." - PEP 20
- Build for open source (even for closed source projects)

### Guidelines

- "Explicit is better than implicit" - PEP 20
- "Readability counts." - PEP 20
- "Anybody can fix anything." - Khan Academy Development Docs
- Fix each broken window (bad design, wrong decision, or poor code) as soon as it is discovered.
- "Now is better than never." - PEP 20
- Test ruthlessly. Write docs for new features.
- Even more important that Test-Driven Development--Human-Driven Development

## Style

### Naming

- Variables, functions, methods, packages, modules
  - lower_case_with_underscores
- Classes and Exceptions
  - CapWords
- Protected methods and internal functions
  - _single_leading_underscore(self, ...)
- Private methods
  - __double_leading_underscore(self, ...)
- Constants
  - ALL_CAPS_WITH_UNDERSCORES

#### General Naming Guidelines

##### Avoid one-letter variables (esp. l, O, I)

Exception: In very short blocks, when the meaning is clearly visible from the immediate context

**Fine:**

```python
for e in elements:
    e.mutate()
```

##### Avoid redundant labeling

**Yes:**

```python
import audio

core = audio.Core()
controller = audio.Controller()
```

**No:**

```python
import audio

core = audio.AudioCore()
controller = audio.AudioController()
```

##### Prefer "reverse notation"

**Yes:**

```python
elements = ...
elements_active = ...
elements_defunct = ...
```

**No:**

```python
elements = ...
active_elements = ...
defunct_elements ...
```

##### Avoid getter and setter methods

**Yes:**

```python
person.age = 42
```

**No:**

```python
person.set_age(42)
```

##### Return only one type from functions

Prefer raising exceptions to returning multiple types.

**Yes:**

```python
def get_user_name(id: int) -> str
    """Retrieves username from database by ID"""
    record = db.get_user(id)
    if record:
        return record.name
    else:
        raise RecordNotFoundError(f"No record found for user ID={id}")
```

**No:**

```python
def get_user_name(id: int) -> str
    """Retrieves username from database by ID"""
    record = db.get_user(id)
    if record:
        return record.name
    else:
        return None
```

##### Indentation

Use 4 spaces--never tabs. Enough said.

##### Imports

Import entire modules instead of individual symbols within a module. For example, for a top-level module canteen that
has a file canteen/sessions.py,

**Yes:**

```python
import canteen
import canteen.sessions
from canteen import sessions
```

**No:**

```python
from canteen import get_user  # Symbol from canteen/__init__.py
from canteen.sessions import get_session  # Symbol from canteen/sessions.py
```

Exception: For third-party code where documentation explicitly says to import individual symbols.
Rationale: Avoids circular imports. See here.
Put all imports at the top of the page with three sections, each separated by a blank line, in this order:

1. System imports
2. Third-party imports
3. Local source tree imports

Rationale: Makes it clear where each module is coming from.

##### Documentation

Follow PEP 257's docstring guidelines. reStructured Text and Sphinx can help to enforce these standards.
Use one-line docstrings for obvious functions:

```python
"""Return the pathname of ``foo``."""
```

Multiline docstrings should include:

- Summary line
- Use case, if appropriate
- Args
- Return type and semantics, unless ```None``` is returned

```python
"""Train a model to classify Foos and Bars.

Usage::

    >>> import klassify
    >>> data = [("green", "foo"), ("orange", "bar")]
    >>> classifier = klassify.train(data)

:param train_data: A list of tuples of the form ``(color, label)``.
:rtype: A :class:`Classifier <Classifier>`
"""
```

Notes:

- Use action words ("Return") rather than descriptions ("Returns").
- Document __init__ methods in the docstring for the class.

```python
class Person(object):
    """A simple representation of a human being.

    :param name: A string, the person's name.
    :param age: An int, the person's age.
    """
    def __init__(self, name, age):
        self.name = name
        self.age = age
```

##### Line Lengths

Don't stress over it. 80-100 characters is fine.

Use parentheses for line continuations:

```python
wiki = (
    "The Colt Python is a .357 Magnum caliber revolver formerly manufactured "
    "by Colt's Manufacturing Company of Hartford, Connecticut. It is sometimes "
    'referred to as a "Combat Magnum". It was first introduced in 1955, the '
    "same year as Smith & Wesson's M29 .44 Magnum."
)
```

## Anti-Patterns

These are not limited to a language, or even to the software itself. They may manifest during the planning process,
implementation, or even years down the road due to iterative changes. If you see an anti-pattern, make an effort to fix
it. Now is better than never.

### Main Causes of Anti-Patterns

1. **Haste** – When project deadlines are tight, budgets are cut, team sizes are reduced, in these pressure situations
   we tend to ignore good practices.
2. **Apathy** – Developers who really don’t care about the problem or the solution will almost always produce a poor
   design.
3. **Ignorance** – When a developer either lacks knowledge of the domain or of the technology being used, that ignorance
   will result in anti-patterns being introduced.

### God Objects (aka "The Blob")

A class or package in your system that does far too much. The catch-all for any code where the developer is not sure
where to put it, or is just too lazy to create a new class or package. Also what can happen is developers will put code
somewhere else simply because it is smaller and easier to work with, even if it is not the correct location. This
anti-pattern is usually caused by a lack of proper object-oriented design skills on a team.

- How to avoid it:
  - Code reviews or pair programming.
  - If you can’t describe the scope of a class's functionality with a single sentence, then it has too much
  responsibility.

### Lava Flows

Lava Flows occur when code has been around for so long that people are afraid to modify it. This often happens because
the original authors/maintainers have left and there is no one who fully groks that area of the code. Some warning signs
are big chunks of commented code with notes like "FIXME: This doesn't appear to be used, commenting it out".

### Copy on Write Code (Parallel Protectionism)

Similar to Lava Flows, this tends to occur when developers aren't sure of the consequences of modifying areas of a
codebase. Instead of trusting regression tests or digging into the scope, they simply copy the code so that their
changes don't interfere with existing functionality. That is, the original code is used as is until it needs to be
modified, then it gets copied for modification (copy-on-write).

### Method Container Objects

This is most common when coming to Python from Java, where everything must be an object. If a class contains many
class methods and not much else, you may have a Method Container object and you can probably make all the methods
into functions within a module.

### Tramp Data

Named for a parameter that tramps from function to function in the code base, this is less of an anti-pattern and
more of a code smell that indicates poor design decisions. It occurs when a parameter is passed several levels deep
into the stack without being used by the intermediate functions. Often it is used as a (better) alternative to a global
variable but it indicates that there is a poor division of responsibility in the codebase.

## Testing

Strive for 100% code coverage, but don't get obsessed over the coverage score.
Useful python testing libraries are `unittest` and `pytest`. The `pytest` `testrunner` can run
`unittest` tests but not vice versa.

### General Testing Guidelines

- Use long, descriptive names. This often obviates the need for docstrings in test methods.
- Tests should be isolated. Don't interact with a real database or network. Use a separate test database that gets torn
  down (Docker is great for this) or use mock objects.
- Prefer factories to fixtures.
- Never let incomplete tests pass, else you run the risk of forgetting about them. Instead, add a placeholder like
  assert False, "TODO: finish me". Pytest offers an xfail decorator to mark tests that are expected to fail (but they
  still show up separately from passed tests).

### Unit Tests

- Focus on one tiny bit of functionality. Mock out everything else.
- Should be fast, but a slow test is better than no test.
- It often makes sense to have one testcase class for a single class or model.

```python
import unittest
import factories

class PersonTest(unittest.TestCase):
    def setUp(self):
        self.person = factories.PersonFactory()

    def test_has_age_in_dog_years(self):
        self.assertEqual(self.person.dog_years, self.person.age / 7)
```

### Functional / Integration Tests

Functional tests are higher level tests that are closer to how an end-user would interact with your application. They
are typically used for web and GUI applications.

- Write tests as scenarios. Testcase and test method names should read like a scenario description.
- Use comments to write out stories, before writing the test code.

```python
import unittest

class TestAUser(unittest.TestCase):

    def test_can_write_a_blog_post(self):
        # Goes to the her dashboard
        ...
        # Clicks "New Post"
        ...
        # Fills out the post form
        ...
        # Clicks "Submit"
        ...
        # Can see the new post
        ...
```

Notice how the testcase and test method read together like "Test A User can write a blog post".

## Exception Handling

For more complete documentation,
see: [https://docs.python.org/3/tutorial/errors.html](https://docs.python.org/3/tutorial/errors.html)

### When to Handle an Exception – Common Examples

The basic rule of thumb is to handle exceptions that you expect to arise during normal runtime but allow the program to
continue on a useful path.
Different parts of a codebase may have different context about how to handle errors. Low level functions should rarely
do much error handling to keep them as general as possible. Higher level abstractions are more likely to live in a
context where assumptions can be made about which exceptions are recoverable.

#### Parsing Messy Data

Without guarantees about the integrity of a data, we frequently need a program to get as much out of the data as
possible. In this example, we log exceptions raised by parse_csv_record and simply continue on.

**Resilient Data Processing:**

```python
with open(file) as csv:
    new_line = csv.readline()
    parsed_data = []
    n_parsing_failures = 0
    n_parsed_records = 0
    while new_line:
        try:
            parsed_data.append(parse_csv_record(line))
            n_parsed_records += 1
        except CsvRecordParsingError as csv_err:
            n_parsing_failures += 1
            logger.exception(csv_err)  # Logs exception, including stack trace
        new_line = csv.readline()
if n_parsing_failures:
    logger.info(f"{n_parsing_failures} parsing failures encountered in {file}. {n_parsed_records} successfully parsed.")
```

#### Connection Retries

No Web API is 100% reliable. Connection errors do occur. Whenever you are making a request to a Web API, it's always a
good idea to check for timeout errors and other common connection problems (4XX responses) and retry the request. For
example

**Connection Retry:**

```python
def resilient_push_data(payload: dict, n_tries: int = 3):
    while n_tries:
        n_tries -= 1
        try:
            response = push_data_to_server(data={"payload": True})
            return response
        except TimeoutError as timeout_err:
            logger.error(f"Failed to push data. Connection timed out. {n_tries} remaining.")
        except ConnectionError is conn_err:
            logger.error("Failed to push data. Server refused the request.")
    raise DataPushError(f"Failed to push data.")  # Handle this higher up in the stack, if necessary
```

#### Multiprocessing

When spawning process pools for handling parallel workloads, you typically want to know what happens in those
processes, including exceptions. If an exception is raised in a subprocess, you lose control over that process and
cannot notify the parent process what occurred.

```python
from multiprocessing import Pipe, Process

def child_process_function(data, pipe):
    try:
        result = process_data(data)
    except Exception as unexpected_error:
        result = unexpected_error
        process_logger.exception(unexpected_error)
    pipe.send({"pid": os.getpid(), "result": result})

def process_data(data):
    processes = []
    receiver_pipes = []
    for datum in data:
        receiver, sender = Pipe()
        process = Process(target=child_process_function, args=(datum, sender))
        processes.append(process)
        receiver_pipes.append(receiver)
        process.start()
    for p in processes:
        p.join()
    for receiver in receiver_pipes:
        try:
            msg = receiver.recv()
            logger.info(msg)
        except Exception as comms_error:  # This should really never happen unless your child process blocks forever
        or dies before it can communicate for some reason.
            print("Failed to communicate with a child process. You should probably check the logs for that process.")
```

### Custom Exceptions

[https://docs.python.org/3/tutorial/errors.html#user-defined-exceptions](https://docs.python.org/3/tutorial/errors.html#user-defined-exceptions)

In general, ValueError should be the default built in exception. Most other built-in exception types have specific
meanings within the Python standard library. If you wish to impart more specific information, define custom exceptions
as follows:

```python
import Exception

class CsvRecordParsingException(Exception):
    """Exception raised when a single CSV record fails to parse"""
    pass
```

### Exception Handling as Control Flow

In most cases, using exception handling as control flow is an anti-pattern and can be rewritten more clearly by
checking assumptions before your `try`  clause. However, there are cases where it's useful such as when an external
state
cannot be determined without calling functions that raise exceptions.

```python
x = MaybeContainsData()

def gross_costly_control_flow(x):
    try:
        parse_data(x)  # Costly
    except NoDataError as no_data:
        x.add_data()  # Costly
        gross_costly_control_flow(x)
    except DataMalformed as bad_data:
        x.fix_data()  # Costly
        gross_costly_control_flow(x)
```

There are a few code smells above, but it's a contrived example. If your code looks like this, seriously consider
refactoring it:

```python
x = MaybeContains_data()

if not x.contains_data():  # Cheap
    x.add_data()
if not x.data_valid():  # Cheap
    x.fix_data()

parse_data(x)  # Any exceptions raised now should be unexpected since we dealt with the cases we understand
```

### Chaining Exceptions

Sometimes it's useful to raise one exception from another in order to add context. In this case, the stack trace will
indicate that the `TotalFailureError` was raised as a result of the `UnderstoodButNotRecoverableError`

```python
try:
    do_a_thing()
except UnderstoodButNotRecoverableError as really_bad_error:
    raise TotalFailureError("A bad thing happened. Unfortunately, we can't do anything useful except tell you about
    it.") from really_bad_error
```

### The Finally Clause

At the end of all your exception handling, regardless of whether things were handled, you can still do stuff. This
should only be used for cleanup and should not be used for continuing a lengthy program execution.

```python
try:
    do_a_thing()
except TimeoutError as timeout_error:
    handle_timeout_condition()
finally:
    clean_up_db_connections()
    flush_logs_to_log_server()
```

## Packaging and Distribution

### Python Packaging Background

Python packaging has modernized a lot since the release of Python 3 in 2008. It is still changing and there is no
universally agreed upon standard for packaging. We expect these guidelines to change as the ecosystem continues to
evolve.
In short, at the time of writing, the python community is attempting to centralize project configuration into a single
pyproject.toml file that is supported by many build tools. Unfortunately this process is not complete. Setuptools,
which is probably still the most common build tool used by python developers (alternatives include Flit and Poetry),
still uses the legacy setup.py file to enable editable installs. All other setuptools configuration can be represented
in setup.cfg, which was the setuptools solution that has been superseded by pyproject.toml for other build tools.
Hopefully someday all these tools will centralize on pyproject.toml but for now, to support setuptools, we need all
three configuration files. See the example project structure below for an example.

#### Resources

Some resources that describe the path by which we arrived where we are:
Python Packaging Authority (PyPA) tutorial on packaging using
setuptools: [https://packaging.python.org/tutorials/packaging-projects/](https://packaging.python.org/tutorials/packaging-projects/)
What the Heck is
pyproject.toml? [https://snarky.ca/what-the-heck-is-pyproject-toml/](https://snarky.ca/what-the-heck-is-pyproject-toml/)
Github discussion on pyproject.toml
support: [https://github.com/pypa/setuptools/issues/1688](https://github.com/pypa/setuptools/issues/1688)
PEP 508 -- Dependency specification for Python Software
Packages: [https://www.python.org/dev/peps/pep-0508/](https://www.python.org/dev/peps/pep-0508/)
PEP 518 -- Specifying Minimum Build System Requirements for Python
Projects: [https://www.python.org/dev/peps/pep-0518/](https://www.python.org/dev/peps/pep-0518/)
PEP 621 -- Storing project metadata in
pyproject.toml: [https://www.python.org/dev/peps/pep-0621/](https://www.python.org/dev/peps/pep-0621/)
Dependency specification in pyproject.toml based on PEP
508: [https://www.python.org/dev/peps/pep-0631/](https://www.python.org/dev/peps/pep-0631/)
Setuptools setup.cfg
documentation: [https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html](https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html)
Poetry documentation (an optional build tool): [https://python-poetry.org/](https://python-poetry.org/)
Flit documentation (an optional build
tool): [https://flit.readthedocs.io/en/latest/](https://flit.readthedocs.io/en/latest/)

### Nomenclature

#### Working definitions

Package: A directory containing python modules and an __init__.py file.
Subpackage: A package directory containing an __init__.py file, which is itself contained inside an enclosing package.
Module: A python file that can be imported, possibly as part of a package or subpackage.

### Package Structure

Packages can be structured in various ways but some general practices have emerged as the most readable.

From the repo root directory:

```text
.
├── CHANGES.md                                                            # Changes log, e.g. between versions
├── LICENSE.txt                                                           # License file
├── README.md            # Readme file for display on upstream git server (e.g. Bitbucket) and in building documentation
├── build                                                                 # Build artifacts (ignored by git)
│   ├── bdist.macosx-10.15-x86_64
│   └── lib
├── data                                                                  # Directory for data required by package
│   └── naif0012.tls
├── dist                                    # Build artifacts, pushed to PyPI by twine for distribution (ignored by git)
│   ├── lasp_datetime-0.1.dev5+gbea8efc.d20210430-py3-none-any.whl
│   └── lasp_datetime-0.1.dev5+gbea8efc.d20210430.tar.gz
├── lasp_datetime                                                         # Package root
│   ├── __init__.py
│   ├── constants.py                                                      # Example of a module
│   ├── conversions
│   ├── core.py
│   ├── leapsecond.py
│   ├── utils.py
│   └── version.py
├── lasp_datetime.egg-info                                                # Build artifacts (ignored by git)
│   ├── PKG-INFO
│   ├── SOURCES.txt
│   ├── dependency_links.txt
│   ├── requires.txt
│   └── top_level.txt
├── pyproject.toml      # Unified configuration file, used by setuptools, poetry, flit, and many others. Allows
                        # flexibility in build tools.
├── setup.cfg           # Setuptools-specific configuration file (will eventually be replaced by pyproject.toml)
├── setup.py            # Legacy setuptools script, for supporting editable installs only
├── tests               # Tests package root directory (may be excluded from distributions via setup.cfg)
│   ├── __init__.py
│   ├── test_constants.py        # Example test module. Should be named `test_xyz.py` when testing `xyz.py` module
│   ├── test_conversions
│   ├── test_core.py
│   ├── test_leapsecond.py
│   ├── test_utils.py
│   └── test_version.py
└── venv                               # Project virtual environment (ignored by git). May be located elsewhere but
                                       # most easily managed in the repo directory.
    ├── bin
    ├── include
    ├── lib
    └── pyvenv.cfg
```

#### Configuration

Configuration depends partly on which build tool you wish to use. We will cover configuration for a project that is
built with setuptools, which has long been the best supported python build tool (though others are starting to become
popular).

##### setup.py

You have almost certainly seen this before. This is the legacy configuration file for setuptools. It traditionally
contained all the metadata for a python project and was executed during installation with something like python setup.py
install. These days, this file is only necessary to support editable installs (pip install -e .) and can be reduced to
the following stub, with all remaining configuration placed in declarative files, setup.cfg and pyproject.toml.

```python
#! /usr/bin/env python
"""Bare bones setup script. The sole purpose of this script is to support editable pip installs for development"""

import setuptools

if __name__ == "__main__":
    setuptools.setup()
```

##### setup.cfg

This is the declarative successor to setup.py. All the same metadata that once existed in setup.py can now be placed
here. This file also supersedes requirements.txt (see the install_requires keyword). Someday this is likely to be
superseded by pyproject.toml. Documentation on format exists here:
[https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html]
(https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html)

**An example file contents is below:**

```python
[metadata]
name = lasp_datetime
author = Gavin Medley, Brandon Stone
author_email = Gavin.Medley@lasp.colorado.edu, Brandon.Stone@lasp.colorado.edu
license = Copyright 2018 Regents of the University of Colorado. All rights reserved.
license_file = LICENSE.txt
url = https://bitbucket.lasp.colorado.edu/projects/SDS/repos/py_datetime/browse
description = Python implementation of LASP's heritage idl_datetime library
long_description = file: README.md
long_description_content_type = text/markdown
keywords = astronomy, astrophysics, cosmology, space, science, units, time
classifiers =
    Intended Audience :: Science/Research
    Natural Language :: English
    Topic :: Scientific/Engineering
    Topic :: Scientific/Engineering :: Astronomy
    Programming Language :: Python :: 3
    Operating System :: MacOS :: MacOS X
    Operating System :: POSIX :: Linux
platforms =
    Operating System :: MacOS :: MacOS X
    Operating System :: POSIX :: Linux

[options]
# We set packages to find: to automatically find all sub-packages
packages = find:
install_requires =
    numpy

python_requires = >=3.8, <4

[options.packages.find]
exclude =
    tests
    tests.*

[options.extras_require]
dev =
    build
    coverage
    pylint
    pytest
    twine
test =
    coverage
    pylint
    pytest
build =
    build
    twine
```

##### pyproject.toml

In the current state of python packaging, pyproject.toml is primarily for specifying which build backend to use when
installing and preparing packages for distribution (e.g. setuptools vs poetry vs flit vs others). pip reads this file
and acts according to the metadata specified here. This allows additional functionality that has never been provided
directly by setuptools, such as the ability to specify packages that are required for building (but not using) the
package being developed. For example, setuptools_scm is a library for detecting package versioning by introspecting
the local git repo, but it is not necessary for using the package, only for building it so we specify it here rather
than in setup.cfg.

```python
[build-system]
# Minimum requirements for the build system to execute.
requires = ["setuptools>=45", "wheel", "setuptools_scm[toml]>=6.0"]
build-backend = "setuptools.build_meta"
```

The pyproject.toml file is also used by many other python libraries as a source of configuration information. See this
Awesome pyproject.toml page for a list of projects currently using this file for configuration:
[https://github.com/carlosperate/awesome-pyproject](https://github.com/carlosperate/awesome-pyproject)

#### Build Tools

Part of the current revolution in python packaging is a goal of making python build-tool-agnostic. That is, the
community is trying to agree on one or just a few metadata configuration files that can be read by many build tools so
that developers can build their projects with whatever tool they prefer.

##### setuptools

This could be considered the legacy build tool for python projects but it is still the most widely used and what most
people are familiar with. It is so ubiquitous that it is one of only two packages that are installed by default in pip
virtual environments (with the other being pip itself). Setuptools uses setup.py or setup.cfg (or both).

Documentation: [https://setuptools.readthedocs.io/en/latest/](https://setuptools.readthedocs.io/en/latest/)

##### Poetry

Poetry might be the trendiest python build tool out there. It uses pyproject.toml for configuration. IMAP SDC and some
SWxTREC projects use Poetry. For an example, you can look to the IMAP SDC infrastructure repository, which has an
example of a pyproject.toml, and pre-commit tools to update poetry.lock and generate a requirements.txt file for use
in AWS Lambdas. There is also an overview document on using Poetry.

Documentation: [https://python-poetry.org/docs/](https://python-poetry.org/docs/)

##### Flit

Flit appears to be a lightweight tool that leverages pyproject.toml similar to Poetry.

Documentation: [https://flit.readthedocs.io/en/latest/](https://flit.readthedocs.io/en/latest/)

### Distribution

#### Generating Distribution Archives Using a Build Tool

Tutorial on generating distribution
archives: [https://packaging.python.org/tutorials/packaging-projects/#generating-distribution-archives]
(https://packaging.python.org/tutorials/packaging-projects/#generating-distribution-archives)

Depending on the build tool you choose, generating distribution archives will be managed differently. For the PyPA
build tool, it may look like:

```python
# First, ensure the build module is installed from PyPI with
# pip install build

# Then
python -m build
```

#### Uploading Artifacts to LASP Package Index

The LASP PyPI is hosted on our Nexus artifact repository,
at [https://artifacts.pdmz.lasp.colorado.edu/#browse/browse:lasp-pypi]
(https://artifacts.pdmz.lasp.colorado.edu/#browse/browse:lasp-pypi)

Documentation on uploading python build artifacts to Nexus can be found
here: [https://confluence.lasp.colorado.edu/x/WQ96Aw](https://confluence.lasp.colorado.edu/x/WQ96Aw)

#### Versioning

Versioning can be managed in many ways as long as it is kept PEP
440 ([https://www.python.org/dev/peps/pep-0440/](https://www.python.org/dev/peps/pep-0440/)). The
suggested way is to use a library such as setuptools_scm, which introspects the local git repo and finds the latest tag
from which to create a version identifier. During the build process, that version is injected into the metadata for the
package and optionally also written to a version.py file so it remains accessible to the library internally.

## Credit

Content taken from a Confluence guide written by Gavin Medley
