##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ospaths, net, nativesockets

when defined(windows):
  import winlean
elif defined(unix):
  import posix

import vecio/iovec

proc writev*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].}
  ## write to buffers in buffer
proc readv*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].}
 ## read data from ``fd`` into the contents of ``buffers``
 ##
 ## note: the contents of buffer must be ``shallow``, a ``ptr[seq | string]``, or a ``(pointer, len)``,
 ## otherwise a copy of the contents of ``buffers`` is created and written to instead.

proc toIOVecBuffer(self: openarray[IntoIoVector]): seq[IntoIoVector.Native] =
  result = newSeq[IntoIoVector.Native](self.len)
  for idx in 0 ..< self.len:
    let buf = self[idx]
    result[idx] = toIOVector(buf).toNative()

when defined(windows):
  include vecio/windows
elif defined(unix):
  include vecio/unix
else:
  {.fatal "platform not supported".}

# converter toSocketHandle*(s: Socket): SocketHandle =
#   ## obtain a ``SocketHandle`` from a ``Socket``
#   s.getFD()
