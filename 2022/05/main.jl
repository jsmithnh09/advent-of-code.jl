RE_MOVE = r"move (\d+) from (\d+) to (\d+)"

"""
    moves = isolate_moves(in)

Isolate the moves as integers from the input string.
"""
function isolate_moves(in::String)
    ms = match(RE_MOVE, in)
    isempty(ms) && throw(ArgumentError("Bad string input."))
    map(x -> parse(Int, x), ms)
end


"""
    move_crates!(fpath, stacks)

fpath is the `String` and `stacks` is the initial state of the crate
stack.
"""
function move_crates!(fpath::String, stacks::Dict; movefcn::Function = crateshift!)
    !isfile(fpath) && throw(ArgumentError("Input is not a file."))
    open(fpath) do io
        numlines = countlines(io)
        seekstart(io)
        for lineIdx = 1:numlines
            line = readline(io)
            if typeof(match(RE_MOVE, line)) === Nothing
                continue
            else
                (num_stacks, source, dest) = isolate_moves(line)
                movefcn(stacks, source, dest, num_stacks)
            end
        end
    end
    stacks
end

function crateshift!(stack::Dict, src::Int, dest::Int, num::Int)
    for _ = 1:num
        crate = pop!(stack[src])
        push!(stack[dest], crate)
    end
end

function crateshift2!(stack::Dict, src::Int, dest::Int, num::Int)
    L = length(stack[src])
    crates = splice!(stack[src], L-num+1:L)
    append!(stack[dest], crates)
end
    

