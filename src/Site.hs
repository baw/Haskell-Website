{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString (ByteString)
import qualified Data.Text as T
import           Heist.Interpreted
import           Snap
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import qualified Text.XmlHtml as HTML

------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
handleHomePage :: Handler App (App) ()
handleHomePage = render "home_page"

------------------------------------------------------------------------------
handleCommunityChat :: Handler App App ()
handleCommunityChat = redirect "http://imamathwiz.github.io/community_chat/"

------------------------------------------------------------------------------
handleAsteroids :: Handler App App ()
handleAsteroids = redirect "http://imamathwiz.github.io/asteroids/"

------------------------------------------------------------------------------
pageNameSplice :: String -> Splice AppHandler
pageNameSplice selector  = do
    return [ HTML.Element (T.pack "script") [] [ HTML.TextNode $ T.pack $ "$(function () { $('" ++ selector ++ "').click() });" ] ]

------------------------------------------------------------------------------
handleProjectsPage :: Handler App App ()
handleProjectsPage = heistLocal (bindSplice "pageName" (pageNameSplice "#projectsLink")) $ render "home_page"

------------------------------------------------------------------------------
handleResumePage :: Handler App App ()
handleResumePage = heistLocal (bindSplice "pageName" (pageNameSplice "#resumeLink")) $ render "home_page"

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("", handleHomePage)
         , ("static",  serveDirectory "static")
         , ("asteroids", handleAsteroids)
         , ("community_chat", handleCommunityChat)
         , ("projects", handleProjectsPage)
         , ("resume", handleResumePage)
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h

