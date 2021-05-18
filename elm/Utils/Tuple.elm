module Utils.Tuple exposing (map2)


map2 : (a -> b -> c) -> ( a, b ) -> c
map2 func ( a, b ) =
    func a b
