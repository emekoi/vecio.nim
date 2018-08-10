type
  IOVector* = object
    data: pointer
    len: uint

converter toIoVector*(self: seq | string): IOVector =
  IOVector(
    data: unsafeAddr self[0],
    len: uint(self.len)
  )

converter toIOVector*(self: (pointer, int)): IOVector =
  IOVector(
    data: self[0],
    len: uint(self[1])
  )

converter toIOVector*(self: ptr string): IOVector =
  IOVector(
    data: unsafeAddr self[0],
    len: uint(self[].len)
  )