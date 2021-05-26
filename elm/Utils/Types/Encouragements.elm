module Utils.Types.Encouragements exposing (Encouragements, init, switchToNext)

import Utils.List


type alias Encouragements =
    { list : List String
    , current : Int
    }


init : Int -> Encouragements
init seed =
    { list = Utils.List.shuffle seed availableEncouragements
    , current = 0
    }


switchToNext : Encouragements -> Encouragements
switchToNext ({ list, current } as encouragements) =
    { encouragements | current = Utils.List.nextValidIndex current list }


availableEncouragements : List String
availableEncouragements =
    [ "Debugging is genuinely hard! Don't sweat it if it takes time, and if it's really frustrating, just look at the answer this time — you can learn just as much from that as from struggling to solve it."
    , "I would make you an adorable yet encouraging cross-stitch, but I'm a computer and I don't have any arms."
    , " 💫 🌟 🎉 I believe in you! 🎉 ✨ ⭐️ "
    , "Good job asking for encouragement! Sometimes that's hard, but you deserve it!"
    , "You're doing a good job! If you've been working at this a while, give yourself the time and space to take a break for a bit."
    ]
