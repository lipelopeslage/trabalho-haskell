{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handlers where
import Import
import Yesod
import Utils
import Yesod.Static
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius

import Database.Persist.Postgresql

mkYesodDispatch "Sitio" pRoutes

widgetFormLogin :: Route Sitio -> Enctype -> Widget -> Text -> Text -> Widget
widgetFormLogin x enctype widget y val = do
     msg <- getMessage
     commonWidget $(whamletFile "modules/forms/login.hamlet")

widgetForm :: Route Sitio -> Enctype -> Widget -> Text -> Text -> Widget
widgetForm x enctype widget y val = do
     msg <- getMessage
     commonWidget $(whamletFile "modules/forms/login.hamlet")

widgetFormCadastro :: Route Sitio -> Enctype -> Widget -> Text -> Text -> Widget
widgetFormCadastro x enctype widget y val = do
     msg <- getMessage
     commonWidget $(whamletFile "modules/forms/cadastro.hamlet")


formUsu :: Form Usuario
formUsu = renderDivs $ Usuario <$>
    areq textField "Login" Nothing <*>
    areq textField "Senha" Nothing

formCurso :: Form Curso
formCurso = renderDivs $ Curso <$>
    areq textField "Nome" Nothing <*>
    areq textField "Sigla" Nothing <*>
    areq textField "Descricao" Nothing


formMateria :: Form Materia
formMateria = renderDivs $ Materia <$>
    areq textField "Nome" Nothing <*>
    areq textField "Codigo" Nothing <*>
    areq textField "Descricao" Nothing 


formProfessor :: Form Professor
formProfessor = renderDivs $ Professor <$>
    areq textField "Nome" Nothing <*>
    areq textField "Descricao" Nothing 


getUsuarioR :: Handler Html
getUsuarioR = do
    (wid,enc) <- generateFormPost formUsu
    defaultLayout $ widgetForm UsuarioR enc wid "Cadastro de Usuarios" "Cadastrar"


getWelcomeR :: Handler Html
getWelcomeR = do
     usr <- lookupSession "_ID"
     defaultLayout $ commonWidget $(whamletFile "modules/home.hamlet")

getLoginR :: Handler Html
getLoginR = do
    (wid,enc) <- generateFormPost formUsu
    defaultLayout $ widgetFormLogin LoginR enc wid "" "Entrar"

postLoginR :: Handler Html
postLoginR = do
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess usr -> do
            usuario <- runDB $ selectFirst [UsuarioNome ==. usuarioNome usr, UsuarioPass ==. usuarioPass usr ] []
            case usuario of
                Just (Entity uid usr) -> do
                    setSession "_ID" (usuarioNome usr)
                    redirect WelcomeR
                Nothing -> do
                    setMessage $ [shamlet| Invalid user |]
                    redirect LoginR 
        _ -> redirect LoginR

postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess usr -> do
            runDB $ insert usr
            setMessage $ [shamlet| <p> Usuario inserido com sucesso! |]
            redirect UsuarioR
        _ -> redirect UsuarioR


{- Não serão listados usuários
getListUserR :: Handler Html
getListUserR = do
    listaU <- runDB $ selectList [] [Asc UsuarioNome]
    defaultLayout $(whamletFile "modules/list.hamlet")
-}

getLogoutR :: Handler Html
getLogoutR = do
    deleteSession "_ID"
    redirect LoginR

getAdminR :: Handler Html
getAdminR = defaultLayout [whamlet| <h1> Bem-vindo ADMIN!! |]

-- P A G I N A S   S I M P L E S

getSobreR :: Handler Html
getSobreR = do
    defaultLayout $ commonWidget $(whamletFile "modules/about.hamlet")

getProfessoresR :: Handler Html
getProfessoresR = do
    professores <- runDB $ selectList [] [Asc ProfessorNome]
    defaultLayout $ commonWidget $(whamletFile "modules/professores.hamlet")

getMateriasR :: Handler Html
getMateriasR = do
    materias <- runDB $ selectList [] [Asc MateriaNome]
    defaultLayout $ commonWidget $(whamletFile "modules/materias.hamlet")

getCursosR :: Handler Html
getCursosR = do
    cursos <- runDB $ selectList [] [Asc CursoNome]
    defaultLayout $ commonWidget $(whamletFile "modules/cursos.hamlet")

getProfessorR :: Handler Html
getProfessorR = do
    (wid,enc) <- generateFormPost formProfessor
    defaultLayout $ widgetFormCadastro ProfessorR enc wid "Cadastrar Professor" "Cadastrar"

getMateriaR :: Handler Html
getMateriaR = do
    (wid,enc) <- generateFormPost formMateria
    defaultLayout $ widgetFormCadastro MateriaR enc wid "Cadastrar Matéria" "Cadastrar"

getCursoR :: Handler Html
getCursoR = do
    (wid,enc) <- generateFormPost formCurso
    defaultLayout $ widgetFormCadastro CursoR enc wid "Cadastrar Curso" "Cadastrar"


postCursoR :: Handler Html
postCursoR = do
    ((result,_),_) <- runFormPost formCurso
    case result of
        FormSuccess usr -> do
            runDB $ insert usr
            setMessage $ [shamlet| <div class="container alert alert-dismissible alert-warning"> 
                                        <button type="button" class="close" data-dismiss="alert">x</button>
                                            Curso inserido com sucesso! |]
            redirect CursosR
        _ -> redirect CursosR


postMateriaR :: Handler Html
postMateriaR = do
    ((result,_),_) <- runFormPost formMateria
    case result of
        FormSuccess usr -> do
            runDB $ insert usr
            setMessage $ [shamlet| <div class="container alert alert-dismissible alert-warning"> 
                                        <button type="button" class="close" data-dismiss="alert">x</button>
                                            Matéria inserida com sucesso! |]
            redirect MateriasR
        _ -> redirect MateriasR


postProfessorR :: Handler Html
postProfessorR = do
    ((result,_),_) <- runFormPost formProfessor
    case result of
        FormSuccess usr -> do
            runDB $ insert usr
            setMessage $ [shamlet| <div class="container alert alert-dismissible alert-warning"> 
                                        <button type="button" class="close" data-dismiss="alert">x</button>
                                            Professor inserido com sucesso! |]
            redirect ProfessorR
        _ -> redirect ProfessorR


{-
B A N C O   N O V O

Host       ec2-54-204-41-175.compute-1.amazonaws.com
Database   d3bqri6dndmvvm
User       axntyghmizoayd
Port       5432
Password   3VDVOUFykftOgb9_kzMPEYrXhg 

-}


-- connStr = "dbname=dd9en8l5q4hh2a host=ec2-107-21-219-201.compute-1.amazonaws.com user=kpuwtbqndoeyqb password=aCROh525uugAWF1l7kahlNN3E0 port=5432"
connStr = "dbname=d3bqri6dndmvvm host=ec2-54-204-41-175.compute-1.amazonaws.com user=axntyghmizoayd password=3VDVOUFykftOgb9_kzMPEYrXhg port=5432"
main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool
       s <- static "."
       warpEnv (Sitio pool s)