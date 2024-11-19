**<span style="font-size:3em;color:black">Python</span>**
***

# Virtual environment
```
/opt/homebrew/bin/python3.12 -m venv .venv-python3.12
source .venv-python3.12/bin/activate
pip3 install ortools
...
deactivate
```

# Pip Upgrade
```bash
python -m pip install --upgrade pip
```

# Elapsed time
```
from datetime import datetime

start = datetime.now()
# Do....
exec_time = datetime.now() - start
print(f"Execution time: {exec_time}")
```

# Scripting 

## Arbitrary path
```python
#!/usr/bin/env python
```