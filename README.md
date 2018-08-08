# vecio.nim
[![Build Status](https://api.cirrus-ci.com/github/emekoi/vecio.nim.svg)](https://cirrus-ci.com/github/emekoi/vecio.nim)  
vectored io for nim.

# usage
just call `readv` or `writev` on a `seq` or `array` of `string`s, `ptr string`s, or `seq`s of `uint8`.

```nim
import net
import src/vecio

var server = newSocket()
server.setSockOpt(OptReuseAddr, true)
server.bindAddr(Port(3444))
server.listen()

block:
  let
    outgoing = newSocket()
    buf = ["foo", "bar"]
  outgoing.connect("localhost", Port(3444))
  discard outgoing.writev(buf)

var
  incomming = new Socket
  one = newString(2)
  two = newString(4)

# prevent the strings from being copied
one.shallow()
two.shallow()

var buf = [one, two]

server.accept(incomming)
discard incomming.readv(buf)
doAssert(buf == ["fo", "obar"])
server.close()
```
