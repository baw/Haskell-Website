{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString (ByteString)
import           Data.Functor ((<$>))
import qualified Data.Text as T
import           Data.Time.Clock (UTCTime)
import           Database.PostgreSQL.Simple.FromRow
import           Heist.Interpreted
import           Snap
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Util.FileServe
import qualified Text.XmlHtml as HTML

------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
-- DATA Types
------------------------------------------------------------------------------

data Post = Post
    { postID    :: Integer
    , title     :: T.Text
    , body      :: T.Text
    , createdAt :: UTCTime
    , updatedAt :: UTCTime
    } deriving (Eq)

instance FromRow Post where
    fromRow = Post <$> field <*> field <*> field <*> field <*> field

instance Show Post where
    show (Post postId title body createdAt updatedAt) =
        "Post { title "     ++ T.unpack title   ++
                "body "     ++ T.unpack body    ++
                "createdAt" ++ (show createdAt) ++
                "updatedAt" ++ (show updatedAt) ++
             "}"

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
    return [ HTML.Element (T.pack "script") [] [ HTML.TextNode $ T.pack $
             "$(function () { $('" ++ selector ++ "').click() });" ] ]

------------------------------------------------------------------------------
handleProjectsPage :: Handler App App ()
handleProjectsPage = heistLocal (bindSplice "pageName" (
                          pageNameSplice "#projectsLink")) $ render "home_page"

------------------------------------------------------------------------------
handleResumePage :: Handler App App ()
handleResumePage = heistLocal (bindSplice "pageName" (pageNameSplice
                          "#resumeLink")) $ render "home_page"

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
    pg <- nestSnaplet "pg" pg pgsInit
    addRoutes routes
    return $ App h pg

