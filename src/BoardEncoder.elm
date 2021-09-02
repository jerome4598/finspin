module BoardEncoder exposing (boxListEncoder)

import Json.Encode as Encode
import Math.Vector2 exposing ( getX, getY)
import Types exposing (Note,Box)

noteEncoder : Note -> Encode.Value
noteEncoder note = Encode.object
        [ ("id", Encode.string note.id)
        , ("done", Encode.bool note.done)
        , ("title", Encode.string note.title)
        , ("description", Encode.string note.description)        
        ]

noteBoxEncoder : Box -> Encode.Value
noteBoxEncoder noteBox =
  let 
    positionStr = String.fromFloat (getX noteBox.position) ++ "," ++ String.fromFloat (getY noteBox.position)
  in
    Encode.object
        [ ("id", Encode.string noteBox.id)
        , ("position", Encode.string positionStr)
        , ("note", noteEncoder noteBox.note)
        , ("clicked", Encode.bool noteBox.clicked)        
        ]

boxListEncoder : List Box -> Encode.Value
boxListEncoder noteBoxes = Encode.list noteBoxEncoder noteBoxes