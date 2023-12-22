const VALID_NUM = '0':'9'
const INVALID_CHAR = '.'
const INVALID_VAL = -2
const SYMBOL_VAL = -1
const GEAR_CHAR = '*'

# iterating range will be "inside" of the matrix.
"""
    mat = matrixdims(fpath)

Determines the matrix dimensions based on
the line-length and number of lines.
"""
function matrixdims(fpath::String)
    nrows, ncols = 0, 0
    open(fpath) do io
        while !eof(io)
            line = readline(io)
            nrows += 1
            if ncols == 0
                ncols = length(line)
            end
        end
    end
    (nrows, ncols)
end

"""
    mat = mkmatrix(fpath)

Given the filepath, we'll parse out a numeric
matrix where symbols are -1 and the invalid char
is treated as zero.
"""
function mkmatrix(fpath::String)
    dims = matrixdims(fpath)
    mat = fill(INVALID_VAL, dims)
    row = 1
    open(fpath) do io
        while !eof(io)
            line = readline(io)
            for idx in eachindex(line)
                if line[idx] == INVALID_CHAR
                    continue
                elseif line[idx] in VALID_NUM
                    mat[row, idx] = parse(Int, line[idx])
                else
                    mat[row, idx] = SYMBOL_VAL
                end
            end
            row += 1
        end
    end
    mat
end

"""
    gearmat = mkgearmatrix(fpath)

Constructs the matrix but only identifies gears
as proper symbols.
"""
function mkgearmatrix(fpath::String)
    dims = matrixdims(fpath)
    mat = fill(INVALID_VAL, dims)
    row = 1
    open(fpath) do io
        while !eof(io)
            line = readline(io)
            for idx in eachindex(line)
                if line[idx] == INVALID_CHAR
                    continue
                elseif line[idx] ∈ VALID_NUM
                    mat[row, idx] = parse(Int, line[idx])
                elseif line[idx] == GEAR_CHAR
                    mat[row, idx] = SYMBOL_VAL
                end
            end
            row += 1
        end
    end
    mat
end

"""
    val = int2full(X)

take a vector of ints and combine it into
a single number.
"""
function int2full(X::Vector{Int})
    M = length(X)-1
    f = 0
    for idx in eachindex(X)
        f = muladd(10^M, X[idx], f)
        M -= 1
    end
    f
end

"""
    (part, present) = rowsearch(X, curpos)

Given the current position in the matrix, we want to determine the 
sequence of integers that make up a part number. We'll search backward
and forward along the row until we hit the invalid #. If a value is in the range,
we'll indicate that its present.
"""
function rowsearch(X::Matrix{Int}, curpos::Tuple{Int,Int})
    N = size(X,2)
    fwd, bwd = curpos[2], curpos[2]
    if !(X[curpos...] ∈ 0:9)
        return 0
    end
    while (fwd != N && X[curpos[1], fwd+1] != INVALID_VAL && X[curpos[1], fwd+1] ∈ 0:9)
        fwd += 1
    end
    while (bwd != 1 && X[curpos[1], bwd-1] != INVALID_VAL && X[curpos[1], bwd-1] ∈ 0:9)
        bwd -= 1
    end
    int2full(X[curpos[1], bwd:fwd])
end


"""
    numvec = rownums(fpath)

Returns the full numbers present within each row of
the input string for lookup and comparison.
"""
function rownums(fpath::String)
    io = open(fpath)
    nrows = countlines(io)
    seek(io, 0)
    vrows = [[] for _ in 1:nrows]
    ind = 1
    while !eof(io)
        line = readline(io)
        m = collect(eachmatch(r"(\d+)", line))
        for iter in m
            append!(vrows[ind], parse(Int, iter.match))
        end
        ind += 1
    end
    close(io)
    vrows
end

"""
    sum = pullsum(X, row, col)

Given a symbol index at (row, col), we'll search around the
symbol for any valid numbers. If found, we'll look along the row
to determine the part number sequence, and sum it together for that
particular symbol.
"""
function pullsum(X::Matrix{Int}, row::Int, col::Int, allvals::Vector{Vector{Any}})
   sum = 0
   top = [(row-1, col-1), (row-1, col), (row-1, col+1)]
   mid = [(row, col-1), (row, col+1)]
   bot = [(row+1, col-1),(row+1, col), (row+1, col+1)]
    
    for topidx = eachindex(top)
        partno = rowsearch(X, top[topidx])
        if partno > 0 && partno ∈ allvals[row-1]
            # remove the instance from the row to indicate we found it, avoid overlap.
            popidx = findfirst(partno .== allvals[row-1])
            allvals[row-1][popidx] = 0
            sum += partno
        end
    end
    for mididx = eachindex(mid)
        partno = rowsearch(X, mid[mididx])
        sum += partno
    end
    for botidx = eachindex(bot)
        partno = rowsearch(X, bot[botidx])
        if partno > 0 && partno ∈ allvals[row+1]
            popidx = findfirst(partno .== allvals[row+1])
            allvals[row+1][popidx] = 0
            sum += partno
        end
    end
    sum
end

function gearratio(X::Matrix{Int}, row::Int, col::Int, allvals::Vector{Vector{Any}})
    top = [(row-1, col-1), (row-1, col), (row-1, col+1)]
    mid = [(row, col-1), (row, col+1)]
    bot = [(row+1, col-1),(row+1, col), (row+1, col+1)]
    nhits = 0
    hitvals = [0, 0]
    for (sect, offset) in ((top, -1), (mid, 0), (bot, +1))
        for sectidx = eachindex(sect)
            partno = rowsearch(X, sect[sectidx])
            if partno > 0 && partno ∈ allvals[row+offset]
                nhits += 1
                if (nhits > 2)
                    return 0
                end
                popidx = findfirst(partno .== allvals[row+offset])
                allvals[row+offset][popidx] = 0
                hitvals[nhits] = partno
            end
        end
    end
    return prod(hitvals)
end

function main()
    mat = mkmatrix("E:\\code\\advent2023.jl\\03\\puzzle.txt")
    vrows = rownums("E:\\code\\advent2023.jl\\03\\puzzle.txt")
    (M, N) = size(mat)
    sum = 0
    for rowIdx = 2:M-1
        for colIdx = 2:N-1
            if mat[rowIdx,colIdx] == SYMBOL_VAL
                sum += pullsum(mat, rowIdx, colIdx, vrows)
            end
        end
    end
    println("sum: ", sum)
end

function main2()
    mat = mkgearmatrix("E:\\code\\advent2023.jl\\03\\puzzle.txt")
    vrows = rownums("E:\\code\\advent2023.jl\\03\\puzzle.txt")
    (M, N) = size(mat)
    sum = 0
    for rowIdx = 2:M-1
        for colIdx = 2:N-1
            if mat[rowIdx, colIdx] == SYMBOL_VAL
                sum += gearratio(mat, rowIdx, colIdx, vrows)
            end
        end
    end
    println("ratio sum: ", sum)
end
main()
main2()