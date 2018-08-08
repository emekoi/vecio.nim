##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ospaths, asyncnet, net

when defined(windows):
  import windows
elif defined(unix):
  import posix

proc writev*(fd: SocketHandle; buffers: openarray[seq[byte] | string]): int {.tags: [WriteIOEffect], raises: [OSError].}
  ## write to buffers in buffer
proc readv*(fd: SocketHandle; buffers: var openarray[seq[byte] | string]): int {.tags: [ReadIOEffect], raises: [OSError].}
  ## read data from ``fd`` into the contents of``buffers``
  ##
  ## Note: the contents of buffer must be ``shallow`` otherwise a copy of the contents of ``buffers`` is created and written to instead.
proc readv*(fd: SocketHandle; buffers: openarray[ptr string]): int {.tags: [ReadIOEffect], raises: [OSError].}
  ## read data from ``fd`` into the contents of ``buffers``

when defined(windows):
  include vecio/windows
elif defined(unix):
  include vecio/unix
else:
  {.fatal "platform not supported".}

converter toSocketHandle*(a: AsyncSocket): SocketHandle =
  ## obtain a ``SocketHandle`` from a ``AsyncSocket``
  a.getFD()

converter toSocketHandle*(s: Socket): SocketHandle =
  ## obtain a ``SocketHandle`` from a ``Socket``
  s.getFD()
