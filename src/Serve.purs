module Serve (main) where

import Prelude
import Bucketchain (createServer, listen)
import Bucketchain.Middleware (Middleware)
import Bucketchain.Http (requestURL, setRequestURL)
import Bucketchain.Static (withStatic)
import Control.Monad.Reader (ask)
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Seconds(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Node.HTTP (ListenOptions, Server)

main :: Effect Unit
main = server >>= listen opts

server :: Effect Server
server =
  createServer
    $ withIndex <$> withStatic { root: "./dist", maxAge: Seconds 0.0 }

opts :: ListenOptions
opts =
  { hostname: "0.0.0.0"
  , port: 8080
  , backlog: Nothing
  }

-- | Middleware that will attempt to serve `/index.html` if the request's URL
-- | is `/`.
withIndex :: Middleware
withIndex next = do
  http <- ask
  liftEffect
    $ if requestURL http == "/" then
        setRequestURL http "/index.html"
      else
        pure unit
  next
