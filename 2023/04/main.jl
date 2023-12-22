"""
    (winning, hand) = readhands(fpath)

Read out the winning #'s and the current hand
line-per-line.
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
    points = 0
    for matchidx = 1:Mrows
        winners = intersect(Set(handmat[matchidx,:]), Set(winmat[matchidx,:]))
        if isempty(winners)
            p = 0
        else
            p = 2^(length(winners)-1)
        end
        points += p
    end
    points
end
            