{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Utils where
import Import
import Yesod
import Yesod.Static
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius
import Text.Julius


supremeWidget :: Widget
supremeWidget = toWidgetHead [hamlet|
    <link rel="stylesheet" href="https://bootswatch.com/sandstone/bootstrap.min.css">    
    <script src="https://code.jquery.com/jquery-1.10.2.min.js">
    <script src="https://bootswatch.com/bower_components/bootstrap/dist/js/bootstrap.min.js">
|] >> toWidget $(luciusFile "assets/css/style.lucius") >> toWidget $(juliusFile "assets/js/script.julius")


commonWidget :: Widget -> Widget
commonWidget hamletWidget = do
    supremeWidget
    $(whamletFile "modules/common/header.hamlet")    
    hamletWidget
    $(whamletFile "modules/common/footer.hamlet")    
