module Core exposing (..)

import Draggable
import Tuple exposing (first,second)

import Model exposing (Id,Model,Box,Note,BoxSize,BoxGroup)
import Msg exposing (Color(..), Msg(..))
import Config exposing (defaultNewTilePosition)
import BoardEncoder exposing (boxListEncoder)
import Ports
import Model exposing (Position)

welcomeNotes : List Note
welcomeNotes =  
    [
        { id = "0 - learn"
        , title = "You completed a Task"
        , description = "Simply click on the message to strick  out "
        , done = True        
        }
    ,   { id = "1 - start"
        , title = "Welcome to the Finspin"
        , description = "Easy planner board"
        , done = False              
        }
    ]

emptyNote : Note
emptyNote =
    { id = "" 
    , done = False
    , title = ""
    , description = ""    
    }


emptyBox : Box
emptyBox = Box "" defaultNewTilePosition False emptyNote Nothing defaultBoxSize

makeBox : Id -> Note -> Position -> Maybe String -> BoxSize -> Box 
makeBox id note position color size =
    Box id position False note color size


makeBoxDefaultSize : Id -> Note -> Position -> Maybe String -> Box 
makeBoxDefaultSize id note position color =
    Box id position False note color defaultBoxSize

updateNoteBox : Model -> Box -> String -> String -> Box
updateNoteBox model box t d = if (box.id == model.currentBox.id) then
                                let
                                    currentBox = model.currentBox
                                    newTitle = if String.isEmpty t then box.note.title else t
                                    newDescription = if String.isEmpty d then box.note.description else d
                                    color = case currentBox.color of
                                                Just _ -> currentBox.color
                                                Nothing -> box.color
                                    note = box.note             
                                    newNote = {note | title = newTitle,description = newDescription}
                                in    
                                    {box | color = color, size = currentBox.size, note = newNote}
                            else 
                                box


emptyGroup : BoxGroup
emptyGroup =
    BoxGroup 0 Nothing []

buildNote : Int -> String -> String ->  Note
buildNote length t d  = { 
            id = ((String.fromInt length ++ String.slice 0 5 t))
            , done = False
            , title = t
            , description = d             
            }

addBoxInBoxGroup : Note -> Position -> BoxGroup -> BoxGroup
addBoxInBoxGroup note position ({ uid, idleBoxes } as group) =
    { group
        | idleBoxes = (makeBox (String.fromInt uid) note position) Nothing defaultBoxSize :: idleBoxes
        , uid = uid + 1
    }    

makeBoxGroup : List (Position,Note) -> BoxGroup
makeBoxGroup positions =
    positions
        |>  List.foldl (\position -> addBoxInBoxGroup (second position) (first position)) emptyGroup

defaultBoxGroup : BoxGroup
defaultBoxGroup =
    let
        indexToPosition =
            toFloat >> (*) 60 >> (+) 10 >> Position 10
        notes = welcomeNotes
    in
    notes |> List.indexedMap (\i x -> ((indexToPosition i),x)) |> makeBoxGroup

getColor : Color -> String
getColor color = 
    case color of 
        BoardGreen -> "#5F9A80"
        White -> "#FFF" 


boxSize : Position
boxSize =
    Position defaultBoxSize.width defaultBoxSize.height

defaultBoxSize : BoxSize         
defaultBoxSize = BoxSize "1x" 210.0 50.0   

boxSizePallet : List BoxSize
boxSizePallet = 
        [
            defaultBoxSize,
            {defaultBoxSize | title = "2x", height=defaultBoxSize.height + 20},
            {defaultBoxSize | title = "3x", height=defaultBoxSize.height + 40},
            {defaultBoxSize | title = "4x", height=defaultBoxSize.height + 60}
        ]

init : flags -> ( Model, Cmd Msg )
init _ =
    ( { boxGroup = emptyGroup
      , drag = Draggable.init
      , isPopUpActive = False
      , editNote = False
      , currentBox = emptyBox
      , saveDefault = True
      , localData = []
      , jsonError = Nothing
      , welcomeTour = True
      , position =  (160, 120)
      , hover = False
      , files = []
      }
    , Cmd.none
    )

saveNotes : List Box -> Cmd msg
saveNotes noteBoxes = boxListEncoder noteBoxes |> Ports.storeNotes            

addPosition : Position -> Position -> Position
addPosition a b = Position (a.x + b.x) (a.y + b.y)