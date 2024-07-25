> :warning: **Warning:** More information is needed to complete this guideline

# Python Packaging and Distribution
> **Warning** Need to add a short description of the guideline

## Purpose for this guideline
> **Warning** Need to add an explanation of how this guideline supports DS workflows, meets internal and external
> policies, and aids in collaboration and our overall success

## Options and Applications for this guideline

### PyPI (`pip install`)

#### PyPI resources:

- [PyPI Help Page](https://pypi.org/help/)

- [Setting up a PyPI account](https://pypi.org/account/register/)

- [Getting a PyPI access token](https://pypi.org/help/#apitoken)

#### How to Apply this guideline
### Poetry Project Configuration Example – Library Package
```
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

### Built-In (build + twine)

#### Built-In resources

- [Python Packaging User Guide](https://packaging.python.org/en/latest/):

#### How to Apply this guideline
The link below is a pretty complete tutorial. There are also instructions for using
various other build tools.

https://packaging.python.org/en/latest/tutorials/packaging-projects/

### Poetry

[Poetry Build and Publish Docs](https://python-poetry.org/docs/cli/#build):

poetry lock
poetry install
poetry version
poetry build
PYPI_USERNAME=__token__
PYPI_TOKEN=<token-copied-from-pypi-account>
poetry publish  # You will be prompted for your PyPI credentials if you don't provide the environment variables

### Packaging for Conda (`conda install`)
Conda

> **Need Help:** Anyone want to volunteer to write this section? TAG

## How to apply this guideline
Detailed instructions or general guidance for implementation of the guideline
## Examples

### Setuptools Example – Library Package
```
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

### Conda Package

> :warning: Need a volunteer.
https://conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs.html

## Useful Links
Here are some helpful resources:

- [Python Packaging User's Guide](https://packaging.python.org/en/latest/)
- [The Hitchhiker's Guide to Python - Packaging your Code](https://docs.python-guide.org/shipping/packaging/)
- [The Sheer Joy of Packaging](https://python-packaging-tutorial.readthedocs.io/en/latest/index.html)
- [Package Python Projects the Proper Way with Poetry](https://hackersandslackers.com/python-poetry-package-manager/)
- [Poetry Documentation](https://python-poetry.org/docs/)
- [Setuptools Documentation](https://setuptools.pypa.io/en/latest/)
- [Building conda packages from scratch](https://conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs.html)



## Some Terminology
### Library Packages vs Applications vs Scripts

Python is a highly flexible interpreted language. This means it's easy to get started, quick to write, and easy to run.
Unfortunately, this also means it's very easy to write code that works in one context but not in others or code that is
robust but isn't designed to be inherited.

Library Package: A python package, intended for redistribution, containing objects that serve as building blocks for
other developers to use. Examples are `numpy`, `pytest`, and `sqlalchemy`.

Application: A python project (which may or may not be a packaged distribution) that provides specific and possibly
configurable functionality. Examples are Poetry, the AWS CLI, the Conda CLI, the Green Unicorn WSGI HTTP server, any
Django "app".

Script: Pretty much anything else written in Python. One could arguably say that a Script is just a trivial Application
with little configuration or portability. Scripts are usually run with `python my_script.py argv`. They tend to be
difficult to maintain, update, or distribute.

> **Note** A Python "package" is any directory containing an __init__.py file.

Packaging Tooling: Not only managing a local environment, but also providing tooling for developing, building, and
distributing python packages for other users. While Conda does support this use case (it's how one creates and
distributes conda packages to conda-forge), Poetry and setuptools are much easier to develop with (for PyPI) and Poetry
boasts a similar dependency resolver to Conda. One major drawback to Conda in packaging is that there is no notion of an
"editable install" so the developer is forced to build and test end user functionality (e.g. script entrypoints) over
and over instead of simply making code changes in place.

> :warning: Conda Develop:
> There is a conda subcommand called conda develop but it is not maintained and has a lot of issues. The maintainers of
conda recommend using pip install to install an editable package in development mode.

See: https://github.com/conda/conda-build/issues/1992


Original Author: Gavin Medley