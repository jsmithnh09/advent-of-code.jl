const _RE_GAMEID = r"(?<=Game )\d+"
const _COMP_λ = x->(isnothing(x) ? 0 : parse(Int, x.match))

### Constructor for a single hand-grab.
struct Cubes{T<:Real}
    red::T
    green::T
    blue::T
end
Cubes{T}(r) where {T<:Real} = Cubes{T}(r,0,0)
Cubes{T}(r,g) where {T<:Real} = Cubes{T}(r,g,0)


"""
    (id, hand) = parsecubes(line)

Parsing function that will extract the game ID and a Vector
of cube results from each bag-pull.
"""
function parsecubes(line::String)
    gameid = match(_RE_GAMEID, line) |> x->parse(Int, x.match)
    groups = split(line[findfirst(':', line)+1:end], ";")
    hand = Vector{Cubes{Int}}(undef, length(groups))
    for idx in eachindex(groups)
        R = match(r"\d+(?= red)", groups[idx]) |> _COMP_λ
        G = match(r"\d+(?= green)", groups[idx]) |> _COMP_λ
        B = match(r"\d+(?= blue)", groups[idx]) |> _COMP_λ
        hand[idx] = Cubes{Int}(R,G,B)
    end
    (gameid, hand)
end


"""
    nodes = pullnodes(fpath)

nodes is a Vector{Tuple{Int64, Cubes{Int64}}} which
is the full data-set from the input puzzle file.
"""
function pullnodes(file::String)
    data = Tuple{Int, Vector{Cubes{Int}}}[]
    open(file) do io
        while !eof(io)
            line = readline(io)
            push!(data, parsecubes(line))
        end
    end
    data
end


### primary entry
function main()
    n = pullnodes("test.txt")
    sum = 0
    pow = 0
    for idx in eachindex(n)
        gid, cvec = n[idx][:]
        rmax = maximum([x.red for x in cvec])
        bmax = maximum([x.blue for x in cvec])
        gmax = maximum([x.green for x in cvec])
        pow += *(rmax, bmax, gmax)
        if (rmax > 12 || bmax > 14 || gmax > 13)
            continue
        else
            sum += gid
        end
    end
    println("GID total: ", sum)
    println("POW total: ", pow)
end
main()