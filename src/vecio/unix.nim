import posix

proc writev*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let fd = socket.getFD()
  assert(fd != osInvalidSocket, "cannot `writev` on a closed socket")
  let bufs = toIOVecBuffer(buffers)
  result = int(writev(cint(fd), unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  let fd = socket.getFD()
  assert(fd != osInvalidSocket, "cannot `readv` on a closed socket")
  var bufs = toIOVecBuffer(buffers)
  result = int(readv(cint(fd), addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())
