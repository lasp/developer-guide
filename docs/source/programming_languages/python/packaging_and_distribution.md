# Python Packaging and Distribution

> > **Warning:** More information is needed to complete this guideline.

Examples of Python packaging and distribution options and how to use them.

## Purpose

> **Warning** Need to add an explanation of how this guideline supports DS workflows, meets internal and external
> policies, and aids in collaboration and our overall success

## Python Packaging Background

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

## Resources

Some resources that describe the path by which we arrived where we are:

- [Python Packaging Authority (PyPA) tutorial on packaging using setuptools][1]
- [What the Heck is pyproject.toml?][2]
- [Github discussion on pyproject.toml support][3]
- [PEP 508 -- Dependency specification for Python Software Packages][4]
- [PEP 518 -- Specifying Minimum Build System Requirements for Python Projects][5]
- [PEP 621 -- Storing project metadata in pyproject.toml][6]
- [Dependency specification in pyproject.toml based on PEP 508][7]
- [Setuptools setup.cfg documentation][8]
- [Poetry documentation (an optional build tool)][9]
- [Flit documentation (an optional build tool)][10]

[1]: https://packaging.python.org/tutorials/packaging-projects/
[2]: https://snarky.ca/what-the-heck-is-pyproject-toml/
[3]: https://github.com/pypa/setuptools/issues/1688/
[4]: https://www.python.org/dev/peps/pep-0508/
[5]: https://www.python.org/dev/peps/pep-0518/
[6]: https://www.python.org/dev/peps/pep-0621/
[7]: https://www.python.org/dev/peps/pep-0631/
[8]: https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html
[9]: https://python-poetry.org/
[10]: https://flit.readthedocs.io/en/latest/

## Nomenclature

### Working definitions

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

## Configuration

Configuration depends partly on which build tool you wish to use. We will cover configuration for a project that is
built with setuptools, which has long been the best supported python build tool (though others are starting to become
popular).

### setup.py

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

### setup.cfg

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

### pyproject.toml

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

## Build Tools

Part of the current revolution in python packaging is a goal of making python build-tool-agnostic. That is, the
community is trying to agree on one or just a few metadata configuration files that can be read by many build tools so
that developers can build their projects with whatever tool they prefer.

### setuptools

This could be considered the legacy build tool for python projects but it is still the most widely used and what most
people are familiar with. It is so ubiquitous that it is one of only two packages that are installed by default in pip
virtual environments (with the other being pip itself). Setuptools uses setup.py or setup.cfg (or both).

Documentation: [https://setuptools.readthedocs.io/en/latest/](https://setuptools.readthedocs.io/en/latest/)

### Poetry

Poetry might be the trendiest python build tool out there. It uses pyproject.toml for configuration. IMAP SDC and some
SWxTREC projects use Poetry. For an example, you can look to the IMAP SDC infrastructure repository, which has an
example of a pyproject.toml, and pre-commit tools to update poetry.lock and generate a requirements.txt file for use
in AWS Lambdas. There is also an overview document on using Poetry.

Documentation: [https://python-poetry.org/docs/](https://python-poetry.org/docs/)

### Flit

Flit appears to be a lightweight tool that leverages pyproject.toml similar to Poetry.

Documentation: [https://flit.readthedocs.io/en/latest/](https://flit.readthedocs.io/en/latest/)

## Distribution

### Generating Distribution Archives Using a Build Tool

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

### Uploading Artifacts to LASP Package Index

The LASP PyPI is hosted on our Nexus artifact repository,
at [https://artifacts.pdmz.lasp.colorado.edu/#browse/browse:lasp-pypi]
(https://artifacts.pdmz.lasp.colorado.edu/#browse/browse:lasp-pypi)

Documentation on uploading python build artifacts to Nexus can be found
here: [https://confluence.lasp.colorado.edu/x/WQ96Aw](https://confluence.lasp.colorado.edu/x/WQ96Aw)

### Versioning

Versioning can be managed in many ways as long as it is kept PEP
440 ([https://www.python.org/dev/peps/pep-0440/](https://www.python.org/dev/peps/pep-0440/)). The
suggested way is to use a library such as setuptools_scm, which introspects the local git repo and finds the latest tag
from which to create a version identifier. During the build process, that version is injected into the metadata for the
package and optionally also written to a version.py file so it remains accessible to the library internally.

## Options

The options for Python packaging and distribution that we often see used at LASP are:

- [PyPI](#packaging-for-pypi--pip-install-)
- [Conda](#packaging-for-conda--conda-install-)

## Packaging for PyPI (`pip install`)

### PyPI resources

- [PyPI Help Page](https://pypi.org/help/)
- [Setting up a PyPI account](https://pypi.org/account/register/)
- [Getting a PyPI access token](https://pypi.org/help/#apitoken)

### Built-In (`build` + `twine`)

> **Warning**: Need to add introductory paragraph that summarizes Built-In

#### How to use Built-In

Python Packaging User Guide: https://packaging.python.org/en/latest/
The link below is a fairly complete tutorial. There are also instructions there for using various other build tools:
https://packaging.python.org/en/latest/tutorials/packaging-projects/

#### Built-In resources

- [Python Packaging User Guide](https://packaging.python.org/en/latest/)

#### Setuptools Example – Library Package

<details>
  <summary>setup.py</summary>

```python
"""
Setup file for the science data processing pipeline.

The only required fields for setup are name, version, and packages. Other fields to consider (from looking at other
projects): keywords, include_package_data, requires, tests_require, package_data
"""
from setuptools import setup, find_packages

# Reads the requirements file
with open('requirements.txt') as f:
    requirements = f.read().splitlines()

setup(
    name='my_py_library',
    version='0.1.0',
    author='Jane Doe, John Doe, This is just a str',
    author_email='jane.doe@lasp.colorado.edu',
    description='Science data processing pipeline for the instrument',
    long_description=open('README.md', 'r').read(),  # Reads the readme file
    python_requires='>=3.8, <4',
    url='https://some-git.url',
    classifiers=[
        "Natural Language :: English",
        "Topic :: Scientific/Engineering",
        "Topic :: Scientific/Engineering :: Astronomy",
        "Programming Language :: Python :: 3.8",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: POSIX :: Linux",
    ],
    packages=find_packages(exclude=('tests', 'tests.*')),
    package_data={
        "my_py_library": [
            "some_necessary_config_data.json",
            "calibration_data/*"
        ]
    },
    py_modules=['root_level_module_name',],
    install_requires=requirements,
    entry_points={
        'console_scripts': [
            'run-processing=my_py_library.cli:main',  # package.module:function
        ]
    }
)
```

</details>

<br/>

### Publish to PyPI - Poetry

[Poetry Build and Publish Docs](https://python-poetry.org/docs/cli/#build)

How to Publish to PyPI from Poetry

```bash
poetry lock
poetry install
poetry version
poetry build
PYPI_USERNAME=__token__
PYPI_TOKEN=<token-copied-from-pypi-account>
poetry publish  # You will be prompted for your PyPI credentials if you don't provide the environment variables
```

#### Poetry Project Configuration Example – Library Package

<details>
  <summary>pyproject.toml</summary>

  ```toml
    # pyproject.toml
    # See: https://python-poetry.org/docs/pyproject/

    [tool.poetry]
    name = "my_python_package"
    version = "0.1.0"
    description = "Science data processing library and applications for some instrument."
    authors = [  # Alphabetical
        "Jane Doe <jane.doe@lasp.colorado.edu>",
        "John Doe <john.doe@lasp.colorado.edu>"
    ]

    # Configure private PyPI repo to download packages
    [[tool.poetry.source]]
    name = "lasp-pypi"  # This name will be used in the configuration to retrieve the proper credentials
    url = "https://artifacts.pdmz.lasp.colorado.edu/repository/lasp-pypi/simple"  # URL used to download your private packages

    # Dependency specification for core package
    [tool.poetry.dependencies]
    python = "^3.9"
    astropy = "^4.2.1"
    h5py = "^3.3.0"
    numpy = "^1.21.0"
    spiceypy = "^4.0.1"
    lasp-packets = "1.2"
    requests = "^2.26.0"
    SQLAlchemy = "^1.4.27"
    psycopg2 = "^2.9.2"
    cloudpathlib = {extras = ["s3"], version = "^0.6.2"}

    # Development dependencies
    [tool.poetry.dev-dependencies]
    pytest-cov = "^2.12.1"
    pylint = "^2.9.3"
    responses = "^0.14.0"
    pytest-randomly = "^3.10.2"
    moto = {extras = ["s3"], version = "^2.2.16"}

    # Script entrypoints to put in installed bin directory
    [tool.poetry.scripts]
    sdp = 'my_python_package.cli:main'

    # Poetry boilerplate
    [build-system]
    requires = ["poetry-core>=1.0.0"]
    build-backend = "poetry.core.masonry.api"
  ```

</details>

<br/>

## Packaging for Conda (`conda install`)

> **Warning**: Need a volunteer to expand on Conda

### How to install and use Conda

https://conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs.html

> Conda Develop:
> There is a conda subcommand called `conda develop`, but it is not actively maintained. The maintainers of
conda recommend using `pip install` to install an editable package in development mode.
> See: https://github.com/conda/conda-build/issues/1992

## Useful Links

Here are some helpful resources:

- [Python Packaging User's Guide](https://packaging.python.org/en/latest/)
- [The Hitchhiker's Guide to Python - Packaging your Code](https://docs.python-guide.org/shipping/packaging/)
- [The Sheer Joy of Packaging](https://python-packaging-tutorial.readthedocs.io/en/latest/index.html)
- [Package Python Projects the Proper Way with Poetry](https://hackersandslackers.com/python-poetry-package-manager/)
- [Poetry Documentation](https://python-poetry.org/docs/)
- [Setuptools Documentation](https://setuptools.pypa.io/en/latest/)
- [Building conda packages from scratch](https://conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs.html)

Credit: Content taken from a Confluence guide written by Gavin Medley
