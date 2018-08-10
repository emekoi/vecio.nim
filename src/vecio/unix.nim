import posix

converter toIOVecBuffer[T: IntoIoVector](self: openarray[T]): seq[IOVec] =
  result = newSeq[IOVec](self.len)
  for idx in 0 ..< self.len:
    let buf = self[idx]
    result[idx] = buf

proc writev*[T: IntoIoVector](fd: SocketHandle; buffers: openarray[T]): int {.tags: [WriteIOEffect], raises: [OSError].} =
  let bufs = toIOVecBuffer(buffers)
  result = int(writev(cint(fd), unsafeAddr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

proc readv*[T: IntoIoVector](fd: SocketHandle; buffers: var openarray[T]): int {.tags: [ReadIOEffect], raises: [OSError].} =
  var bufs = toIOVecBuffer(buffers)
  result = int(readv(cint(fd), addr bufs[0], cint(bufs.len)))
  if result == -1:
    raiseOSError(osLastError())

# converter toIOVecBuffer(buffers: openarray[ptr string]): seq[IOVec] =
#   result = newSeq[IOVec](buffers.len)
#   for idx in 0 ..< buffers.len:
#     let buf = buffers[idx]
#     result[idx] = IOVec(
#       iov_base: unsafeAddr buf[0],
#       iov_len: cint(buf[].len)
#     )

# proc readv*(fd: SocketHandle; buffers: openarray[ptr string]): int {.tags: [ReadIOEffect], raises: [OSError].} =
#   var bufs = toIOVecBuffer(buffers)
#   result = int(readv(cint(fd), addr bufs[0], cint(bufs.len)))
#   if result == -1:
#     raiseOSError(osLastError())
