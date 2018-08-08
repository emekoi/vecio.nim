# Package

version       = "0.1.0"
author        = "emekoi"
description   = "vectored io for nim"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests"]

# Dependencies

requires "nim >= 0.18.0"

task docs, "generate documentation":
  try:
    if not existsDir("docs"):
      mkDir("docs")
    exec("nim doc2 -o:docs/vecio.html src/vecio.nim")
  except:
    discard
