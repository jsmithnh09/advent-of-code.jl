
### constants and type-aliases
const MAX_DIRSIZE = 100000
const File = Dict{String, Int}
const LIST_CMD = "\$ ls"
const RE_FILE = r"(\d+) (.*)"

function parsefile(instr::String)
    !isfile(instr) && throw(ArgumentError("not a valid filepath."))
    fsizes = File()
    trace = []
    open(instr, "r") do io
        lines = readlines(io)
        for line ∈ lines
            if startswith(line, LIST_CMD) || startswith(line, "dir")
                continue
            end
            if startswith(line, "\$ cd")
                destdir = String(split(line)[3]) # $ is the first element of the split.
                if destdir == ".."
                    _ = pop!(trace)
                else
                    path = !isempty(trace) ? "$(trace[end])_$destdir" : "$destdir"
                    push!(trace, path)
                end
            else
                (size, _) = split(line, " ")
                for path ∈ trace
                    if !haskey(fsizes, path)
                        fsizes[path] = parse(Int, size)
                    else
                        fsizes[path] += parse(Int, size)
                    end
                end
            end
        end
    end
    fsizes
end

# sum of the files part I.
parsesum(files::File) = sum(x for x in values(files) if x <= MAX_DIRSIZE)

# smallest size needed to satisfy argmin(Dtotal - fpath >= 300000)
minsize(files::File) = 30000000 - (70000000 - files["/"])

# part II
function parse_minsum(files::File)
    Msize = minsize(files)
    svals =  values(files) |> collect |> sort
    svals[findfirst(svals .> Msize)]
end