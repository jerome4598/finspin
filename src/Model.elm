module Model exposing (..)

import Draggable
import Json.Decode exposing (Error(..))
import File exposing (File)


type alias Id =
    String

-------------------------------Note-----------------------------------    
type alias Note =
    { id : Id
    , done : Bool
    , title : String
    , description : String            
    }

-------------------------------Box-----------------------------------
type alias Box =
    { id : Id
    , position : Position
    , clicked : Bool
    , note : Note
    , color : Maybe String
    , size : BoxSize
    }

-------------------------------BoxGroup-----------------------------------
type alias BoxGroup =
    { uid : Int
    , movingBox : Maybe Box
    , idleBoxes : List Box
    }

-------------------------------Model-----------------------------------
type alias Model =
    { boxGroup : BoxGroup
    , isPopUpActive : Bool
    , welcomeTour : Bool
    , editNote : Bool
    , saveDefault : Bool
    , currentBox : Box
    , drag : Draggable.State Id
    , localData : List Box
    , jsonError : Maybe Error
    , position :  (Int, Int)
    , hover : Bool
    , files : List File
    }



type alias LocalStore = 
    {
      welcomeTour : Bool,
      boxGroups : List BoxGroup
    }

-------------------------------TileSize-----------------------------------
type alias BoxSize = 
    {
        title : String,            
        width : Float,
        height : Float
    }

-------------------------------Position-----------------------------------
type alias Position = 
    {
        x : Float,
        y : Float        
    }
