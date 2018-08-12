import winlean

type
  IOVector* = object
    inner: TWSABuf

proc toIoVector*(self: seq | string): IOVector {. raises: [], tags: [].} =
  IOVector(
    inner: TWSABuf(
      buf: unsafeAddr self[0],
      len: cint(self.len)
    )
  )

proc toIOVector*(self: (pointer, int)): IOVector {. raises: [], tags: [].} =
  IOVector(
    inner: TWSABuf(
      buf: cast[cstring](self[0]),
      len: cint(self[1])
    )
  )

proc toIOVector*(self: ptr[seq | string]): IOVector {. raises: [], tags: [].} =
  IOVector(
    inner: TWSABuf(
      buf: unsafeAddr self[0],
      len: cint(self[].len)
    )
  )

proc toNative*(self: IOVector): TWSABuf {. raises: [], tags: [].} =
  self.inner
