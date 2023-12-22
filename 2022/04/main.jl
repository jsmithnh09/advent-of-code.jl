
compfcn(x::UnitRange{Int64}, y::UnitRange{Int64}) = ((x[1] >= y[1]) && (x[end] <= y[end]))

# Part I of the challenge.
comp1(x::UnitRange{Int64}, y::UnitRange{Int64}) = Int(compfcn(x, y) || compfcn(y, x))

# Part II - find any intersection at all.
comp2(x::UnitRange{Int64}, y::UnitRange{Int64}) = Int(!isempty(intersect(Set(x), Set(y))))

function tally_groups(fpath::String; compare::Function=comp1)
    tally = 0
    elves = Array{UnitRange{Int64}, 2}[]
    open(fpath) do io
        nelves = countlines(io)
        seekstart(io)
        elves = Array{UnitRange{Int64}, 2}(undef, nelves, 2)
        for lineInd = 1:nelves
            line = readline(io)
            group = split(line, ",")
            for iter in 1:2
                rsplit = split(group[iter], "-")
                inds = map(x->parse(Int, x), rsplit)
                elves[lineInd, iter] = inds[1]:inds[2]
            end
        end

        # after storing the unit ranges, we need to check if (per line)
        # the ranges are fully contained in the other.
        for groupIdx = 1:size(elves, 1)
            tally += compare(elves[groupIdx, 1], elves[groupIdx, 2])
        end
    end
    (tally, elves)
end


