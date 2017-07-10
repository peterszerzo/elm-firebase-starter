module Tests exposing (..)

import Test exposing (..)
import Expect
import Misc


all : Test
all =
    describe "A Test Suite"
        [ test "Misc" <|
            \() ->
                Expect.equal (Misc.addTwoInts 2 3) 5
        ]
