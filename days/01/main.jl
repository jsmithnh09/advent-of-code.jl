# Calorie Counting

## Part 1: just count the calories for each elf and find the maximum.
function countcals(fpath::String)
    """
        maxcal = countcals(fpath)
    
    Returns a count of the calories where each elf is an index in the array.
    """
    elves = Int[0]
    !isfile(fpath) && throw(ArgumentError("Input file must point to a valid file."))
    open(fpath) do io
        while !eof(io)
            line = readline(io)
            if isempty(line)
                push!(elves, 0)
            else
                elves[end] += parse(Int, line)
            end
        end
    end
    maximum(elves)
end

## Part 2: Find the top 3 elves carrying the most calories; return the sum.
top3(elves::Vector{Int64}) = sort(elves)[end-2:end] |> sum