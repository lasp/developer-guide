> **Warning:** More information is needed to complete this guideline

# Python Packaging and Distribution
Examples of Python packaging and distribution options and how use them.

## Purpose
> **Warning** Need to add an explanation of how this guideline supports DS workflows, meets internal and external
> policies, and aids in collaboration and our overall success

## Options
The options for Python packaging and distribution that we often see used at LASP are:
- [PyPI](#packaging-for-pypi--pip-install-)
- [Conda](#packaging-for-conda--conda-install-)

## Packaging for PyPI (`pip install`)

### PyPI resources:

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
</details>

### Poetry

> **Warning**: Need to add introductory paragraph that summarizes Built-In

[Poetry Build and Publish Docs](https://python-poetry.org/docs/cli/#build)

How to Publish to PyPI from Poetry
```
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
</details>

## Packaging for Conda (`conda install`)
> **Warning**: Need a volunteer

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
