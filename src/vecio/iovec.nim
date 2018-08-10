##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

when defined(windows):
  include iovec/windows
elif defined(unix):
  include iovec/unix
else:
  include iovec/unknown

type IntoIoVector* = concept s
  toIOVector(s) is IOVector
  return toIOVector(s)