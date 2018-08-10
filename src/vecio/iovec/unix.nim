import posix

type
  IOVector* = object
    inner: IOVec

converter toIoVector*(self: seq | string): IOVector =
  IOVector(
    inner: IOVec(
      iov_base: unsafeAddr self[0],
      iov_len: cint(self.len)
    )
  )

converter toIOVector*(self: (pointer, int)): IOVector =
  IOVector(
    inner: IOVec(
      iov_base: self[0],
      iov_len: cint(self[1])
    )
  )

converter toIOVector*(self: ptr string): IOVector =
  IOVector(
    inner: IOVec(
      iov_base: unsafeAddr self[0],
      iov_len: cint(self[].len)
    )
  )

converter toNative*(self: IOVector): IOVec =
  self.inner