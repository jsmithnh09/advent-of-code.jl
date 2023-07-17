"""
    dims = parsemat(infile)

Retreives the underlying matrix in the input file.
"""
function parsemat(infile::String)
    io = open(infile, "r")
    dim1 = length(split(readline(io), ""))
    seek(io, 0)
    dim2 = countlines(io)
    X = Matrix{UInt64}(undef, (dim1, dim2))
    seek(io, 0)
    for lineIdx = 1:dim2
        line = readline(io)
        ssplit = split(line, "")
        for stepIdx = 1:dim1
            X[lineIdx, stepIdx] = parse(UInt64, String(ssplit[stepIdx]))
        end
    end
    close(io)
    Int.(X)
end



    