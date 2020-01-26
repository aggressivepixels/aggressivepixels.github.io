module Index (view) where

import Prelude
import Data.Foldable (traverse_)
import Text.Smolder.HTML (ul)
import Text.Smolder.HTML.Attributes (className)
import Text.Smolder.Markup (Markup, (!))
import Post (Post, viewEntry)
import Styles as Styles

-- TODO: traverse_ is not stack-safe.
view :: forall e. Array Post -> Markup e
view posts = ul ! className Styles.postListClass $ traverse_ viewEntry posts
