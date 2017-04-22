module Tests exposing (..)

import Test exposing (..)
import Expect
import Utilities


all : Test
all =
    describe "A Test Suite"
        [ test "Utilities" <|
            \() ->
                Expect.equal (Utilities.addTwoInts 2 3) 5
        ]
