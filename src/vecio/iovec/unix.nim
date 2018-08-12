import posix

type
  IOVector* = object
    inner: IOVec

proc toIoVector*(self: seq | string): IOVector {.raises: [], tags: [].} =
  IOVector(
    inner: IOVec(
      iov_base: unsafeAddr self[0],
      iov_len: cint(self.len)
    )
  )

proc toIOVector*(self: (pointer, int)): IOVector {.raises: [], tags: [].} =
  IOVector(
    inner: IOVec(
      iov_base: self[0],
      iov_len: cint(self[1])
    )
  )

proc toIOVector*(self: ptr[seq | string]): IOVector {.raises: [], tags: [].} =
  IOVector(
    inner: IOVec(
      iov_base: unsafeAddr self[0],
      iov_len: cint(self[].len)
    )
  )

proc toNative*(self: IOVector): IOVec {.raises: [], tags: [].} =
  self.inner
