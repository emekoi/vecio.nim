##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import asyncnet, asyncdispatch
import net, unittest
import vecio


proc testSync(address: (string, Port)) =
  let
    outgoing = newSocket()
    buf = ["foo", "bar"]
  outgoing.connect(address[0], address[1])
  discard outgoing.writev(buf)

proc testAsync(address: (string, Port)) {.async.} =
  let
    outgoing = newAsyncSocket()
    buf = ["foo", "bar"]
  waitFor outgoing.connect(address[0], address[1])
  discard outgoing.writev(buf)

suite "test vectored io with different types of sockets":
  setup:
    var
      one = newString(2)
      two = newString(4)

    one.shallow()
    two.shallow()

    var buf = [one, two]

  test "synchronous sockets":
    var server = newSocket()
    server.setSockOpt(OptReuseAddr, true)
    server.bindAddr(Port(3444))
    server.listen()

    testSync(("localhost", Port(3444)))

    var incomming = new Socket
    server.accept(incomming)

    discard incomming.readv(buf)
    doAssert(buf == ["fo", "obar"])
    server.close()

  test "asynchronous sockets":
    var server = newAsyncSocket()
    server.setSockOpt(OptReuseAddr, true)
    server.bindAddr(Port(3444))
    server.listen()

    proc wrapAsync() {.async.} =
      asyncCheck testAsync(("localhost", Port(3444)))
      var incomming = waitFor server.accept()
      discard incomming.readv(buf)

    waitFor wrapAsync()
    doAssert(buf == ["fo", "obar"])
    server.close()