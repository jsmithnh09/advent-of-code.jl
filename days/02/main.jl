const ROCK::Int8 = 1
const PAPER::Int8 = 2
const SCISSOR::Int8 = 3

"""
Wins are 6 points, losses 0, and draws 3.

            ROCK   PAPER    SCISSOR
 ROCK          3       0          6
 PAPER         6       3          0
 SCISSOR       0       6          3
"""
# win/loss matrix. row is player, column is opponent.
const WL_MAT::Matrix{Int8} = [3 0 6; 6 3 0; 0 6 3]

# A -> C corresponds to rock/paper/scissor, X -> Z corresponds to rock/paper/scissor.
playresult(player::Int8, opponent::Int8) = WL_MAT[player, opponent]
decode_player(in::Char) = Int8(Int8(in - 88) % 3 + 1)
decode_opponent(in::Char) = Int8(in - 64)
playresult(player::Char, opponent::Char) = playresult(decode_player(player), decode_opponent(opponent))

function matchresult(player::Int8, opponent::Int8)
    sum = player # constants match shape code.
    sum += playresult(player, opponent)
end
matchresult(player::Char, opponent::Char) = matchresult(decode_player(player), decode_opponent(opponent))

function tallyresults(fpath::String)
    !isfile(fpath) && throw(ArgumentError("Input must be the puzzle file."))
    playersum = 0
    open(fpath) do io
        while !eof(io)
            vec = split(readline(io))
            playersum += matchresult(only(vec[2]), only(vec[1]))
        end
    end
    playersum
end
            

"""
part two threw in a monkey wrench; 
    second column indicates "X" to lose, "Y" to end in a draw, and "Z" to end in a win.
lookup the outcome based on what the opponent specified for an input.
"""
const P2_DICT = Dict("X" => 0, "Y" => 3, "Z" => 6)
function matchresult2(player::Char, opponent::Char)
    outcome = P2_DICT[string(player)]
    oppInd = decode_opponent(opponent) # this gives the column index.
    playInd = findall(WL_MAT[:,oppInd] .== outcome)[1] # this gives the item to play; now get the match result of this.
    matchresult(Int8(playInd), Int8(oppInd))
end

"""
    tallyresults2(fpath)

This will re-tally using the new deciphering scheme with the outcome lookup
in `matchresults2`.
"""
function tallyresults2(fpath::String)
    !isfile(fpath) && throw(ArgumentError("Input must be the puzzle file."))
    playersum = 0
    open(fpath) do io
        while !eof(io)
            vec = split(readline(io))
            playersum += matchresult2(only(vec[2]), only(vec[1]))
        end
    end
    playersum
end

