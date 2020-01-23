module New.Serve where

import Prelude
import Bucketchain (createServer, listen)
import Bucketchain.Static (withStatic)
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Seconds(..))
import Effect (Effect)
import Node.HTTP (ListenOptions, Server)

main :: Effect Unit
main = server >>= listen opts

server :: Effect Server
server = createServer $ withStatic { root: "./dist", maxAge: Seconds 86400.0 }

opts :: ListenOptions
opts =
  { hostname: "localhost"
  , port: 8080
  , backlog: Nothing
  }
