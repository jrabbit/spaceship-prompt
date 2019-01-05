import os
import sys
import ast
import importlib
import logging

logger = logging.getLogger(__name__)

logging.basicConfig(level=logging.INFO)

with open("setup.py") as f:
    tree = ast.parse(f.read())


sys.path.insert(0, "")
v = False

for node in ast.walk(tree):
    if isinstance(node, ast.Call):
        if hasattr(node.func, "id"):
            if node.func.id == "setup":
                d = {x.arg: x.value for x in node.keywords}
    elif isinstance(node, ast.ImportFrom):
        if any(filter(lambda x: x.name == "__version__", node.names)):
            # print("got version")
            versionimpmodule = node.module
            try:
                v = importlib.import_module(node.module).__version__
            except:
                logging.exception("It broke")

if isinstance(d["version"], ast.Str):
    print(d["version"].s)

elif v:
    print(v)

else:
    logging.info(ast.dump(d["version"]))
    raise NotImplementedError
