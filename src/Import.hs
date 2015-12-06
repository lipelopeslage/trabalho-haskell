{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
import Yesod.Static
 
pRoutes = [parseRoutes|
   /user UsuarioR GET POST -- apenas para insercao de outros admins
   /static StaticR Static getStatic
   /login LoginR GET POST
   / WelcomeR GET
   /logout LogoutR GET
   /admin AdminR GET
   /sobre SobreR GET
   /professores ProfessoresR GET
   /materias MateriasR GET
   /cursos CursosR GET
   /professor ProfessorR GET POST
   /curso CursoR GET POST
   /materia MateriaR GET POST
|]