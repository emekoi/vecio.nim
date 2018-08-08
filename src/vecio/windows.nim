import winlean

converter toWSABuffer(buffers: openarray[seq[byte] | string]): seq[WSABuf] =
  result = newSeq[WSABuf](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = WSABuf(
      buf: unsafeAddr buf[0],
      len: cint(buf.len)
    )

proc writev*(fd: SocketHandle; buffers: openarray[seq[byte] | string]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let bufs = toWSABuffer(buffers)
  let res = int(WSASend(fd, unsafeAddr bufs[0], cint(bufs.len), addr int32(result), 0, nil, nil))
  if res != 0:
    raiseOSError(osLastError())

proc readv*(fd: SocketHandle; buffers: var openarray[seq[byte] | string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var bufs = toWSABuffer(buffers)
  let res = int(WSARecv(fd, unsafeAddr bufs[0], cint(bufs.len), addr int32(result), nil, nil, nil))
  if res != 0:
    raiseOSError(osLastError())

converter toWSABuffer(buffers: openarray[ptr string]): seq[WSABuf] =
  result = newSeq[WSABuf](buffers.len)
  for idx in 0 ..< buffers.len:
    let buf = buffers[idx]
    result[idx] = WSABuf(
      buf: unsafeAddr buf[0],
      len: cint(buf[].len)
    )

proc readv*(fd: SocketHandle; buffers: openarray[ptr string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var bufs = toWSABuffer(buffers)
  let res = int(WSARecv(fd, unsafeAddr bufs[0], cint(bufs.len), addr int32(result), nil, nil, nil))
  if res != 0:
    raiseOSError(osLastError())
