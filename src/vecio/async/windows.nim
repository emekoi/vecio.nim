import winlean

proc writev*(socket: AsyncSocket; buffers: openarray[IntoIoVector]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  assert(not socket.isClosed, "cannot `writev` on a closed socket")
  let bufs = toIOVecBuffer(buffers)
  var written = DWORD(0)
  let res = int(WSASend(socket.getFD(), unsafeAddr bufs[0], cint(bufs.len), addr written, 0, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  written

proc readv*(socket: AsyncSocket; buffers: openarray[IntoIoVector]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  assert(not socket.isClosed, "cannot `readv` on a closed socket")
  var
    bufs = toIOVecBuffer(buffers)
    read = DWORD(0)
    flags = DWORD(0)
  let res = int(WSARecv(socket.getFD(), unsafeAddr bufs[0], cint(bufs.len), addr read, addr flags, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  read
