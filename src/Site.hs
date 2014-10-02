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
import           Snap
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
handleHomePage :: Handler App (App) ()
handleHomePage = render "home_page"

------------------------------------------------------------------------------
handleCommunityChat :: Handler App App ()
handleCommunityChat = redirect "http://imamathwiz.github.io/community_chat/"

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("", handleHomePage)
         , ("static",  serveDirectory "static")
         , ("community_chat", handleCommunityChat)
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h

