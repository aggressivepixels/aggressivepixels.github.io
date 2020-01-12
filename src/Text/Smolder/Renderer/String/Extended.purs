module Text.Smolder.Renderer.String.Extended
  ( module Text.Smolder.Renderer.String
  , renderWithDoctype
  ) where

import Prelude
import Text.Smolder.Renderer.String (render)
import Text.Smolder.Markup (Markup)

renderWithDoctype :: forall e. Markup e -> String
renderWithDoctype = ("<!DOCTYPE html>" <> _) <<< render
