
const swap = Dict{Char, Int}(
    '.' => 0,
    'T' => 1,
    'H' => 2)

"""
    swap = readlayout(in)

swap is a matrix with characters swapped for values instead.
"""
function readlayout(layout::String)
    rows = split(layout, "\n")
    mat = zeros(Int, size(rows, 1), length(rows[1]))
    for colIdx = axes(mat, 2)
        for rowIdx = axes(mat, 1)
            mat[rowIdx, colIdx] = swap[rows[rowIdx][colIdx]]
        end
    end
    mat
end
            