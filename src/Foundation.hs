{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable,
             GeneralizedNewtypeDeriving, ViewPatterns #-}
module Foundation where
import Import
import Yesod
import Yesod.Static
import Data.Text
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool, runMigration )

data Sitio = Sitio { connPool :: ConnectionPool,
                     getStatic :: Static }

staticFiles "."

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Usuario
   nome Text
   pass Text
   deriving Show

Curso
   nome Text
   sigla Text
   descricao Text
   deriving Show
   
Materia
   nome Text
   codigo Text
   descricao Text
   deriving Show

Professor
   nome Text
   descricao Text
   deriving Show

|]

mkYesodData "Sitio" pRoutes

instance YesodPersist Sitio where
   type YesodPersistBackend Sitio = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

instance Yesod Sitio where
    authRoute _ = Just $ LoginR
    isAuthorized LoginR _ = return Authorized
    isAuthorized SobreR _ = return Authorized
    isAuthorized CursosR _ = return Authorized
    isAuthorized ProfessoresR _ = return Authorized
    isAuthorized MateriasR _ = return Authorized
    isAuthorized AdminR _ = isAdmin
    isAuthorized _ _ = isUser

isAdmin = do
    mu <- lookupSession "_ID"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just "admin" -> Authorized
        Just _ -> Unauthorized "Soh o admin acessa aqui!"

isUser = do
    mu <- lookupSession "_ID"
    return $ case mu of
        Nothing -> AuthenticationRequired
        Just _ -> Authorized

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage Sitio FormMessage where
    renderMessage _ _ = defaultFormMessage
