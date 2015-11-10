{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
 
pRoutes = [parseRoutes|
   / UsuarioR GET POST
   /listar ListUserR GET
|]