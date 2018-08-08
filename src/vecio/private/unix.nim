##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import posix

type IoVec = object
  iov_base: pointer
  iov_len: cint

proc readv(fd: SocketHandle, bufs: ptr IoVec, count: cint): cint {.cdecl, importc.}
proc writev(fd: SocketHandle, bufs: ptr IoVec, count: cint): cint {.cdecl, importc.}

converter toIovecBuffer(buffers: openarray[seq[byte] or string]): seq[IoVec] =
  result = newSeq[IoVec](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = IoVec(
      iov_base: unsafeAddr buf[0],
      iov_len: cint(buf.len)
    )

proc writev*(fd: SocketHandle, buffers: openarray[seq[byte] or string]): int =
  let bufs = toIoVecBuffer(buffers)
  result = int(writev(fd, unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*(fd: SocketHandle, buffers: var openarray[seq[byte] or string]): int =
  var bufs = toIoVecBuffer(buffers)
  result = int(readv(fd, addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

converter toIovecBuffer(buffers: openarray[ptr string]): seq[IoVec] =
  result = newSeq[IoVec](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = IoVec(
      iov_base: unsafeAddr buf[0],
      iov_len: cint(buf[].len)
    )

proc readv*(fd: SocketHandle, buffers: openarray[ptr string]): int =
  var bufs = toIovecBuffer(buffers)
  result = int(readv(fd, addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())
