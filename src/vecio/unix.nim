import posix

type IoVec = object
  iov_base: pointer
  iov_len: cint

proc readv(fd: SocketHandle, bufs: ptr IoVec, count: cint): cint {.cdecl, importc.}
proc writev(fd: SocketHandle, bufs: ptr IoVec, count: cint): cint {.cdecl, importc.}

converter toIovecBuffer(buffers: openarray[seq[byte] | string]): seq[IoVec] =
  result = newSeq[IoVec](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = IoVec(
      iov_base: unsafeAddr buf[0],
      iov_len: cint(buf.len)
    )

proc writev*(fd: SocketHandle, buffers: openarray[seq[byte] | string]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let bufs = toIoVecBuffer(buffers)
  result = int(writev(fd, unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*(fd: SocketHandle, buffers: var openarray[seq[byte] | string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
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

proc readv*(fd: SocketHandle, buffers: openarray[ptr string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var bufs = toIovecBuffer(buffers)
  result = int(readv(fd, addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())
