
## Winning points
point_tally(in::Set) = isempty(in) ? 0 : 2^(length(in)-1)
"""
    (winning, hand) = readhands(fpath)

Read out the winning #'s and the current hand
line-per-line into a matrix. Last few lines
actually computes the sum.
"""
function readhands(fpath::String)
    λp = x->[parse(Int, v) for v in x]
    io = open(fpath)
    Mrows = countlines(io)
    Nh, Nw, rowidx = 0, 0, 0
    seek(io, 0)
    line = readline(io)
    seek(io, 0)
    
    idx = findfirst(':', line)
    sline = line[idx+1:end]
    winning, hand = split(sline, '|')
    wins = split(winning) |> λp
    hand = split(hand) |> λp
    
    winmat = fill(0, (Mrows, length(wins)))
    handmat = fill(0, (Mrows, length(hand)))
    
    seek(io, 0)
    while !eof(io)
        line = readline(io)
        rowidx += 1
        idx = findfirst(':', line)
        sline = line[idx+1:end]
        winning, hand = split(sline, '|')
        wins = split(winning) |>  λp
        hand = split(hand) |> λp
        winmat[rowidx,:] = wins
        handmat[rowidx,:] = hand
    end
    (winmat, handmat)
end

### part I of the challenge
function part1(winnings, hand)
    points = 0
    for matchidx = axes(hand, 1)
        winners = intersect(Set(winnings[matchidx,:]), Set(hand[matchidx,:]))
        points += point_tally(winners)
    end
    points
    println("Part 1: ", points)
end

function part2(winnings, hand)
    # the point tallys will grow the matrix in size...sorry memory!
    rowIdx = 1
    cardids = collect(1:size(winnings,1))

    # to avoid growing the matrix size, we'll only grow the card IDs.
    #   (1) the replica cards are offset from the winning card, (2 points on card 3 gives 4 and 5.)
    while(rowIdx <= size(cardids, 1)) # winnings and hand, i.e. each "card" or row.
        winners = intersect(Set(hand[cardids[rowIdx],:]), Set(winnings[cardids[rowIdx],:]))
        numreplicas = length(winners)
        if (numreplicas == 0)
            rowIdx += 1
            continue
        else
            replicaInds = cardids[rowIdx]+1:cardids[rowIdx]+1+numreplicas-1
            cardids = vcat(cardids, collect(replicaInds))
            rowIdx += 1
        end
    end
    rowIdx-1
end
wins, hand = readhands("E:\\code\\advent-of-code.jl\\2023\\04\\example.txt")
points = part2(wins, hand)