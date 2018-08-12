# Imports & Consts

import strutils

const indexFile = """
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="refresh" content="0; url=vecio.html" />
  </head>
</html>
"""

# Package

version       = "0.1.0"
author        = "emekoi"
description   = "vectored io for nim"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests", "docs"]

# Dependencies

requires "nim >= 0.18.0"

task docs, "generate documentation":
  try:
    if not existsDir("docs"):
      mkDir("docs")
    writeFile("docs/index.html", indexFile)
    exec "nim doc2 -o:docs/vecio.html src/vecio.nim"
  except:
    discard
