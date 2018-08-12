##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

when defined(windows):
  include iovec/windows

  type IntoIoVector* = concept s
    type Native = TWSABuf

    toIOVector(s) is IOVector
    toIOVector(s).toNative() is Native

elif defined(unix):
  include iovec/unix

  type IntoIoVector* = concept s
    type Native = IOVec

    toIOVector(s) is IOVector
    toIOVector(s).toNative() is Native

else:
  include iovec/unknown

  type IntoIoVector* = concept s
    IOVector(s) is IOVector
