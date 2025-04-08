# Python Best Practices

Some Python terminology that a user might encounter, particularly when working through this Python guide.

## Purpose

This document is intended to provide a guide for LASP Python developers. In particular, we hope that any libraries that
are intended to be shared at LASP will adhere to these conventions. We recognize that individual projects may need to
violate some of these principles but we strive to keep them general enough that few exceptions will be made.

---

## General

### Values

- "Build tools for others that you want to be built for you." - Kenneth Reitz
- "Simplicity is always better than functionality." - Pieter Hintjens
- "Fit the 90% use-case. Ignore the nay sayers." - Kenneth Reitz
- "Beautiful is better than ugly." - [PEP 20](https://peps.python.org/pep-0020/)
- Build for open source (even for closed source projects)

### Guidelines

- "Explicit is better than implicit" - [PEP 20](https://peps.python.org/pep-0020/)
- "Readability counts." - [PEP 20](https://peps.python.org/pep-0020/)
- "Anybody can fix anything." - Khan Academy Development Docs
- Fix each broken window (bad design, wrong decision, or poor code) as soon as it is discovered.
- "Now is better than never." - [PEP 20](https://peps.python.org/pep-0020/)
- Test ruthlessly. Write docs for new features.
- Even more important that Test-Driven Development--Human-Driven Development

---

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

#### Naming Guidelines

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

#### Other Guidelines

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

Follow [PEP 257's](https://peps.python.org/pep-0257/) docstring guidelines. reStructured Text and Sphinx can help to
enforce these standards.
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

---

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

---

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

---

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

---

## Useful Links

[PEP 8 (Python's Official Style Guide)](https://peps.python.org/pep-0008/)

---

## Acronyms

- **PEP** = Python Enhancement Proposals

---

## Credit

Content taken from a Confluence guide written by Gavin Medley
