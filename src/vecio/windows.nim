import winlean

proc writev*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let fd = socket.getFD()
  assert(fd != osInvalidSocket, "cannot `writev` on a closed socket")
  let bufs = toIOVecBuffer(buffers)
  var written = DWORD(0)
  let res = int(WSASend(fd, unsafeAddr bufs[0], cint(bufs.len), addr written, 0, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  written

proc readv*(socket: Socket; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  let fd = socket.getFD()
  assert(fd != osInvalidSocket, "cannot `readv` on a closed socket")
  var
    bufs = toIOVecBuffer(buffers)
    read = DWORD(0)
    flags = DWORD(0)
  let res = int(WSARecv(fd, unsafeAddr bufs[0], cint(bufs.len), addr read, addr flags, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  read
