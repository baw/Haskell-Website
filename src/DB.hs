module DB where

import Data.Text (Text)

data Post = Post
    { postID    :: Integer
    , title     :: Text
    , body      :: Text
    , createdAt :: UTCTime
    } deriving (Eg, Show, Read)
