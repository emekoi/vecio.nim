##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ospaths, asyncnet, net

when defined(windows):
  include vecio/private/windows
elif defined(unix):
  include vecio/private/unix
else:
  {.fatal "platform not supported".}

converter toSocketHandle*(a: AsyncSocket): SocketHandle =
  a.getFD()

converter toSocketHandle*(s: Socket): SocketHandle =
  s.getFD()
