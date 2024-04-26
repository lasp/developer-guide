## How to build the documentation

```bash
# Make the html documentation
cd docs/source
poetry run sphinx-build . build
# View the documentation locally
open build/index.html
```