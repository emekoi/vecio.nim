import winlean

type
  IOVector* = object
    inner: WSABuf

converter toIoVector*(self: seq | string): IOVector =
  IOVector(
    inner: WSABuf(
      buf: unsafeAddr self[0],
      len: cint(self.len)
    )
  )

converter toIOVector*(self: (pointer, int)): IOVector =
  IOVector(
    inner: WSABuf(
      buf: self[0],
      len: cint(self[1])
    )
  )

converter toIOVector*(self: ptr string): IOVector =
  IOVector(
    inner: WSABuf(
      buf: unsafeAddr self[0],
      len: cint(self[].len)
    )
  )

converter toNative*(self: IOVector): WSABuf =
  self.inner