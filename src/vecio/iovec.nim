##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

when defined(windows):
  include iovec/windows

  type IntoIoVector* = concept i, var j
    type Native = TWSABuf

    toIOVector(i) is IOVector
    toIOVector(j) is var IOVector
    toIOVector(i).toNative() is Native
    toIOVector(j).toNative() is Native

elif defined(unix):
  include iovec/unix

  type IntoIoVector* = concept i, var j
    type Native = IOVec

    toIOVector(i) is IOVector
    toIOVector(j) is var IOVector
    toIOVector(i).toNative() is Native
    toIOVector(j).toNative() is Native

else:
  include iovec/unknown

  type IntoIoVector* = concept i, var j
    IOVector(i) is IOVector
    IOVector(j) is var IOVector
