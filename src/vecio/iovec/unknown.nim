type
  IOVector* = object
    data: pointer
    len: uint

proc toIoVector*(self: seq | string): IOVector {. raises: [], tags: [].} =
  IOVector(
    data: unsafeAddr self[0],
    len: uint(self.len)
  )

proc toIoVector*(self: var seq | var string): IOVector {. raises: [], tags: [].} =
  IOVector(
    data: unsafeAddr self[0],
    len: uint(self.len)
  )

proc toIOVector*(self: (pointer, int)): IOVector {. raises: [], tags: [].} =
  IOVector(
    data: self[0],
    len: uint(self[1])
  )

proc toIOVector*(self: ptr[string | byte]): IOVector {. raises: [], tags: [].} =
  IOVector(
    data: unsafeAddr self[0],
    len: uint(self[].len)
  )
