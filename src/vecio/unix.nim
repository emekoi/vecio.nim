import posix

proc writev*(fd: SocketHandle; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let bufs = toIOVecBuffer(buffers)
  result = int(writev(cint(fd), unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*(fd: SocketHandle; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var bufs = toIOVecBuffer(buffers)
  result = int(readv(cint(fd), addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())
