"""
    dims = parsemat(infile)

Retreives the underlying matrix in the input file.
"""
function parsemat(infile::String)
    io = open(infile, "r")
    dim1 = length(split(readline(io), ""))
    seek(io, 0)
    dim2 = countlines(io)
    X = Matrix{Int}(undef, (dim1, dim2))
    seek(io, 0)
    for lineIdx = 1:dim2
        line = readline(io)
        ssplit = split(line, "")
        for stepIdx = 1:dim1
            X[lineIdx, stepIdx] = parse(Int, String(ssplit[stepIdx]))
        end
    end
    close(io)
    X
end

function isvisible(mat::Matrix{Int}, rowIdx::Int, colIdx::Int)
    # instead of grabbing individual items, grab the whole matrix.
    comp = mat[rowIdx, colIdx]
    left = mat[rowIdx, 1:colIdx-1]
    right = mat[rowIdx, colIdx+1:end]
    top = mat[1:rowIdx-1, colIdx]
    bottom = mat[rowIdx+1:end, colIdx]

    # based on the question, we only need to satisfy ONE direction
    # where the comparison point is greater than the other inputs.
    gtfcn(c, v) = all(c .> v)
    return gtfcn(comp, left) || gtfcn(comp, right) || gtfcn(comp, top) || gtfcn(comp, bottom)

end

"""
    count_trees(mat)

Counting trees in the matrix that are visible. Initial value will be the
number of trees that run around the border/edge.
"""
function count_trees(mat::Matrix{Int})
    tcount = 2*(size(mat, 2)) + 2*(size(mat, 1)-2)
    for rowIdx = 2:size(mat, 1)-1
        for colIdx = 2:size(mat, 2)-1
            tcount += Int(isvisible(mat, rowIdx, colIdx))
        end
    end
    tcount
end

count_file(instr::String) = instr |> parsemat |> count_trees

"""
    treescore(mat, rowIdx, colIdx)

The tree-score is determined by the # of trees that don't impede
the view, (including the impeding tree if encountered.) The number
in all four directions are then multiplied together. Since impeding
trees are included, we'll never have a multiply by zero case.
"""
function direction_score(tree::Int, direction)
    score = 0
    for comp in direction
        if tree > comp
            score += 1
        else
            score += 1
            break
        end
    end
    score
end
function treescore(mat::Matrix{Int}, rowIdx::Int, colIdx::Int)
    left = (mat[rowIdx, 1:colIdx-1])[end:-1:1]
    right = mat[rowIdx, colIdx+1:end]
    top = (mat[1:rowIdx-1, colIdx])[end:-1:1] # need to reverse iterate going left or up.
    bottom = mat[rowIdx+1:end, colIdx]
    comp = mat[rowIdx, colIdx]
    prod([direction_score(comp, x) for x in (left, right, top, bottom)])
end

"""
    score = highest_score(infile)

Given the TXT input file, compute the highest tree score present in the matrix.
"""
function highest_score(infile::String)
    mat = parsemat(infile)
    score = 0
    for rowIdx = 2:size(mat, 1)-1
        for colIdx = 2:size(mat, 2)-1
            score = max(score, treescore(mat, rowIdx, colIdx))
        end
    end
    score
end