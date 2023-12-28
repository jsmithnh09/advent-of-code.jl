
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
    rowidx = 0
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

"""
    windict = readwinnings(fpath)

returns a card # --> cards dictionary for easier parsing with part I.
"""
function readpoints(fpath)
    (winnings, hand) = readhands(fpath)
    windict = Dict{Int, Int}()
    for matchidx = axes(hand, 1)
        windict[matchidx] = intersect(Set(winnings[matchidx,:]), Set(hand[matchidx,:])) |> point_tally
    end
    windict
end

"""
    clonedict = readclones(fpath)

Create a Dict{Int, Vector{Int}} where the card key
returns  the cloned cards from that match.
"""
function readclones(fpath)
    cloned = Dict{Int, UnitRange{Int}}()
    (winnings, hand) = readhands(fpath)
    for matchidx = axes(hand, 1)
        winners = intersect(Set(winnings[matchidx,:]), Set(hand[matchidx,:]))
        nclones = length(winners)
        if (nclones == 0)
            cloned[matchidx] = 0:0
        else
            reps = matchidx+1:matchidx+nclones
            cloned[matchidx] = reps
        end
    end
    cloned
end


"""
    cloneresults(fpath)

First, we'll gather our clone card results. Then, we'll create a "bucket" dictionary where
we grow the tally in each bucket as we process the winnings.
"""
function cloneresults(fpath::String)
    cloned = readclones(fpath)
    bidxs = 1:length(keys(cloned))
    bucket = Dict(bidxs .=> 1) # there's always minimum one card to play...
    
    # need to go through each key in order
    for key in sort(collect(keys(bucket)))
        iteridx = 1
        while !(iteridx > bucket[key])
            # look back to the clone winnings and pull the cloned card for this bucket entry.
            cards = cloned[key]
            for c in cards
                # increment the card # bucket where we pulled a cloned card.
                if c > 0 && c in keys(bucket)
                    bucket[c] += 1
                end
            end
            iteridx += 1
        end
    end
    bucket
end

"""
    part1(fpath)

Prints the results for part I.
"""
function part1(fpath::String)
    wind = readpoints(fpath)
    println("Part 1: ", values(wind) |> sum)
end


"""
    part2(fpath)

Prints the results for part II.
"""
function part2(fpath::String)
    wind = cloneresults(fpath)
    println("Part 2: ", values(wind) |> sum)
end