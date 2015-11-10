{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
 
pRoutes = [parseRoutes|
   / CadastroR GET POST
   /listar ListarR GET
   /pessoa/#UsuarioId PessoaR GET
|]