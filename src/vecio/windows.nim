import winlean

converter toWSABuffer(buffers: openarray[var seq[byte] | var string]): seq[TWSABuf] =
  result = newSeq[TWSABuf](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = TWSABuf(
      buf: unsafeAddr buf[0],
      len: cint(buf.len)
    )

proc writev*(fd: SocketHandle; buffers: openarray[seq[byte] | string]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let bufs = toWSABuffer(buffers)
  var sent = DWORD(0)
  let res = int(WSASend(fd, unsafeAddr bufs[0], cint(bufs.len), addr sent, 0, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  sent

proc readv*(fd: SocketHandle; buffers: openarray[var seq[byte] | var string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var
    bufs = toWSABuffer(buffers)
    read = DWORD(0)
    flags = DWORD(0)
  let res = int(WSARecv(fd, unsafeAddr bufs[0], cint(bufs.len), addr read, addr flags, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  read

proc toWSABuffer(buffers: openarray[ptr string | ptr byte]): seq[TWSABuf] =
  result = newSeq[TWSABuf](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = TWSABuf(
      buf: unsafeAddr buf[0],
      len: cint(buf[].len)
    )

proc readv*(fd: SocketHandle; buffers: openarray[ptr string | ptr byte]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  let bufs = toWSABuffer(buffers)
  var
    read = DWORD(0)
    flags = DWORD(0)
  let res = int(WSARecv(fd, unsafeAddr bufs[0], cint(bufs.len), addr read, addr flags, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
  read
