import posix

proc writev*(socket: AsyncSocket; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  assert(not socket.isClosed, "cannot `writev` on a closed socket")
  let bufs = toIOVecBuffer(buffers)
  result = int(writev(cint(socket.getFD()), unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*(socket: AsyncSocket; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  assert(not socket.isClosed, "cannot `readv` on a closed socket")
  var bufs = toIOVecBuffer(buffers)
  result = int(readv(cint(socket.getFD()), addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())
