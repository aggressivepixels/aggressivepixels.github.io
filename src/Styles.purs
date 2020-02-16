module Styles
  ( accentColor
  , logoClass
  , navContentClass
  , notFoundClass
  , notFoundTitleClass
  , postClass
  , postContentClass
  , postDateClass
  , postEntryClass
  , postEntryDescriptionClass
  , postEntryTitleClass
  , postListClass
  , postTitleClass
  , sheet
  ) where

import Prelude

import CSS
  ( class Val
  , CSS
  , Color
  , Feature(..)
  , FontFaceFormat(..)
  , FontFaceSrc(..)
  , GenericFontFamily(..)
  , Rendered
  , Selector
  , (&)
  , (?)
  , (|*)
  , a
  , after
  , alignItems
  , anyLink
  , article
  , backgroundColor
  , before
  , body
  , borderBox
  , borderRadius
  , borderTop
  , boxSizing
  , byClass
  , code
  , color
  , column
  , display
  , flex
  , flexDirection
  , flexGrow
  , fontFace
  , fontFaceFamily
  , fontFaceSrc
  , fontFamily
  , fontSize
  , footer
  , fromString
  , h1
  , h2
  , h3
  , h4
  , h5
  , h6
  , height
  , html
  , justifyContent
  , key
  , lineHeight
  , main
  , margin
  , marginBottom
  , marginLeft
  , marginRight
  , marginTop
  , nav
  , noneTextDecoration
  , p
  , padding
  , paddingBottom
  , paddingLeft
  , paddingRight
  , paddingTop
  , pre
  , query
  , render
  , rgb
  , rgba
  , sansSerif
  , solid
  , star
  , strong
  , textDecoration
  , value
  , width
  )
import CSS.Common (auto, inherit, none, normal)
import CSS.Common as Common
import CSS.FontStyle (fontStyle, italic)
import CSS.ListStyle.Type (listStyleType)
import CSS.Media (screen)
import CSS.Overflow (overflow, overflowAuto)
import CSS.Pseudo (firstChild)
import CSS.Size (Abs, Size, em, nil, pct, px, unitless)
import CSS.Text.Transform (textTransform, uppercase)
import CSS.Text.Whitespace (textWhitespace, whitespacePre)
import CSS.TextAlign (center, textAlign)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|), singleton)

-- COLORS

primaryTextColor :: Color
primaryTextColor = rgba 0 0 0 0.87

secondaryTextColor :: Color
secondaryTextColor = rgba 0 0 0 0.6

accentColor :: Color
accentColor = rgb 50 115 220

separatorColor :: Color
separatorColor = rgb 219 219 219

darkerBackgroundColor :: Color
darkerBackgroundColor = rgb 245 245 245

navPrimaryTextColor :: Color
navPrimaryTextColor = rgb 255 255 255

navSecondaryTextColor :: Color
navSecondaryTextColor = rgba 255 255 255 0.6

-- CLASSES

postListClass :: String
postListClass = "post-list"

postEntryClass :: String
postEntryClass = "post-entry"

postEntryTitleClass :: String
postEntryTitleClass = "post-entry-title"

postEntryDescriptionClass :: String
postEntryDescriptionClass = "post-entry-description"

postDateClass :: String
postDateClass = "post-date"

postClass :: String
postClass = "post"

postContentClass :: String
postContentClass = "post-content"

postTitleClass :: String
postTitleClass = "post-title"

navContentClass :: String
navContentClass = "nav-content"

logoClass :: String
logoClass = "logo"

notFoundClass :: String
notFoundClass = "not-found"

notFoundTitleClass :: String
notFoundTitleClass = "not-found-title"

-- STYLESHEETS

sheet :: Rendered
sheet = render $ fonts *> styles

fonts :: CSS
fonts = rubik *> rajdhani *> firaMono

rubik :: CSS
rubik = do
  fontFace do
    fontFaceFamily "Rubik"
    fontStyle normal
    fontDisplay Swap
    fontWeight $ FontWeight 400
    fontFaceSrc $
      FontFaceSrcLocal "Rubik Regular" :|
      [ FontFaceSrcLocal "Rubik-Regular"
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-regular.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-regular.woff" (Just WOFF)
      ]

  fontFace do
    fontFaceFamily "Rubik"
    fontStyle italic
    fontDisplay Swap
    fontWeight $ FontWeight 400
    fontFaceSrc $
      FontFaceSrcLocal "Rubik Italic" :|
      [ FontFaceSrcLocal "Rubik-Italic"
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-italic.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-italic.woff" (Just WOFF)
      ]

  fontFace do
    fontFaceFamily "Rubik"
    fontStyle normal
    fontDisplay Swap
    fontWeight $ FontWeight 500
    fontFaceSrc $
      FontFaceSrcLocal "Rubik Medium" :|
      [ FontFaceSrcLocal "Rubik-Medium"
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-500.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-500.woff" (Just WOFF)
      ]

  fontFace do
    fontFaceFamily "Rubik"
    fontStyle italic
    fontDisplay Swap
    fontWeight $ FontWeight 500
    fontFaceSrc $
      FontFaceSrcLocal "Rubik Medium Italic" :|
      [ FontFaceSrcLocal "Rubik-MediumItalic"
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-500italic.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rubik-v9-latin-500italic.woff" (Just WOFF)
      ]

rajdhani :: CSS
rajdhani = do
  fontFace do
    fontFaceFamily "Rajdhani"
    fontStyle normal
    fontDisplay Swap
    fontWeight $ FontWeight 400
    fontFaceSrc $
      FontFaceSrcLocal "Rajdhani Regular" :|
      [ FontFaceSrcLocal "Rajdhani-Regular"
      , FontFaceSrcUrl "../fonts/rajdhani-v9-latin-regular.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rajdhani-v9-latin-regular.woff" (Just WOFF)
      ]

  fontFace do
    fontFaceFamily "Rajdhani"
    fontStyle normal
    fontDisplay Swap
    fontWeight $ FontWeight 500
    fontFaceSrc $
      FontFaceSrcLocal "Rajdhani-Medium" :|
      [ FontFaceSrcLocal "Rajdhani-Medium"
      , FontFaceSrcUrl "../fonts/rajdhani-v9-latin-500.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/rajdhani-v9-latin-500.woff" (Just WOFF)
      ]

firaMono :: CSS
firaMono =
  fontFace do
    fontFaceFamily "Fira Mono"
    fontStyle normal
    fontDisplay Swap
    fontWeight $ FontWeight 400
    fontFaceSrc $
      FontFaceSrcLocal "Fira Mono Regular" :|
      [ FontFaceSrcLocal "FiraMono-Regular"
      , FontFaceSrcUrl "../fonts/fira-mono-v8-latin-regular.woff2" (Just WOFF2)
      , FontFaceSrcUrl "../fonts/fira-mono-v8-latin-regular.woff" (Just WOFF)
      ]

styles :: CSS
styles = do
  html ? boxSizing borderBox

  (star <> star & before <> star & after) ? boxSizing inherit

  body ? do
    margin nil nil nil nil
    color secondaryTextColor
    fontFamily ["Rubik"] (singleton sansSerif)

  a & anyLink ? color accentColor

  (h1 <> h2 <> h3 <> h4 <> h5 <> h6) ? do
    color primaryTextColor
    fontFamily ["Rajdhani"] (singleton sansSerif)
    fontWeight (FontWeight 500)

  h2 ? fontSize (em 2.0)

  strong ? fontWeight (FontWeight 500)

  footer ? do
    backgroundColor darkerBackgroundColor
    borderTop solid (px 1.0) separatorColor
    padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    textAlign center

  footer |* p ? do
    marginTop (em 0.5)
    marginBottom (em 0.5)

  pre ? do
    color primaryTextColor
    overflow overflowAuto
    wordWrap "normal"
    textWhitespace whitespacePre
    backgroundColor darkerBackgroundColor
    borderRadius (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    marginTop (em 0.5)
    marginBottom (em 0.5)

  code ? fontFamily ["Fira Mono"] (singleton monospace)

  nav ? do
    color navSecondaryTextColor
    backgroundColor accentColor

  star & byClass logoClass ? do
    fontFamily ["Rajdhani"] (singleton sansSerif)
    fontSize (em 1.5)
    textTransform uppercase
    textDecoration noneTextDecoration
    fontWeight $ FontWeight 500

  (star & byClass logoClass) & anyLink ? color navPrimaryTextColor

  article ? do
    paddingTop (em 1.5)
    paddingBottom (em 1.5)
    paddingLeft (em 1.0)
    paddingRight (em 1.0)

  star & byClass postListClass ? do
    listStyleType none
    margin nil nil nil nil
    paddingLeft (em 1.0)
    paddingRight (em 1.0)
    paddingTop (em 1.5)

  star & byClass postDateClass ? color primaryTextColor

  star & byClass postEntryClass ? paddingBottom (em 2.0)

  star & byClass postEntryTitleClass ? do
    marginTop nil
    marginBottom (em 0.25)

  star & byClass postEntryDescriptionClass ? do
    marginTop nil
    marginBottom (em 0.5)

  star & byClass postTitleClass ? do
    fontSize (em 2.5)
    marginTop nil

  (star & byClass postTitleClass) |* (a & anyLink) ?
    textDecoration noneTextDecoration

  (star & byClass postContentClass) |* p ? lineHeight (unitless 1.75)

  (star & byClass postContentClass) |* (p & firstChild) ? marginTop nil

  (html <> body) ? height (pct 100.0)

  body ? do
    display flex
    flexDirection column

  main ? flexGrow 1

  star & byClass navContentClass ? padding (em 0.75) (em 1.0) (em 0.6) (em 1.0)

  star & byClass notFoundClass ? do
    alignItems Common.center
    display flex
    flexDirection column
    height (pct 100.0)
    justifyContent Common.center
    padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    textAlign center

  star & byClass notFoundTitleClass ? do
    color accentColor
    fontSize (em 4.0)
    marginBottom nil
    marginTop nil

  query screen (singleton $ minWidth (px 800.0)) desktopStyle

desktopStyle :: CSS
desktopStyle = do
  (main <> (star & byClass navContentClass)) ? do
    marginLeft auto
    marginRight auto
    width (px 800.0)

-- HELPER CSS FUNCTIONS

wordWrap :: String -> CSS
wordWrap = key $ fromString "word-wrap"

monospace :: GenericFontFamily
monospace = GenericFontFamily $ fromString "monospace"

time :: Selector
time = fromString "time"

minWidth :: Size Abs -> Feature
minWidth = Feature "min-width" <<< Just <<< value

-- Unfortunately, the CSS library's weight function takes a Number and not an
-- Int, which then gets written as a floating number instead of an integer.
-- This (at least in Epiphany) breaks the font weights.
-- TODO: Make a PR for this.

newtype FontWeight =
  FontWeight Int

instance valFontWeight :: Val FontWeight where
  value (FontWeight weight) = value $ show weight

fontWeight :: FontWeight -> CSS
fontWeight = key $ fromString "font-weight"

data FontDisplay
  = Auto
  | Block
  | Swap
  | Fallback
  | Optional

instance valFontDisplay :: Val FontDisplay where
  value Auto = value "auto"
  value Block = value "block"
  value Swap = value "swap"
  value Fallback = value "fallback"
  value Optional = value "optional"

fontDisplay :: FontDisplay -> CSS
fontDisplay = key $ fromString "font-display"
