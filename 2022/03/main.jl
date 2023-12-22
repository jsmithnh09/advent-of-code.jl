"""
    pval = priority(in)

    Returns the priority value associated with the character.
    'a' to 'z' is 1 to 26 and 'A' to 'Z' are 27 to 52.
"""
function priority(inchar::Int64)
    if inchar in 97:122
        return Int(inchar) - 96
    elseif inchar in 65:90
        return Int(inchar) - 38
    else
        throw(ArgumentError("Unknown character. Not in range."))
    end
end
priority(inchar::Char) = priority(Int64(inchar))

function isolate_item(sack::String)
    num_elements = Int(length(sack) / 2)
    sack1 = sack[1:num_elements]
    sack2 = sack[num_elements+1:end]
    cval = ""
    for compchar in sack1
        if occursin(compchar, sack2)
            cval = compchar
            break
        end
    end
    priority(cval)
end

function tallypriority(fpath::String)
    !isfile(fpath) && throw(ArgumentError("Input file must point to a valid file."))
    sum = 0
    open(fpath) do io
        while !eof(io)
            sum += isolate_item(readline(io))
        end
    end
    sum
end

function tallypriority2(fpath::String)
    !isfile(fpath) && throw(ArgumentError("Input file must point to a valid file."))
    sum = 0
    open(fpath) do io
        while !eof(io)
            group = ["", "", ""]
            cval = ""
            for ind = 1:3
                group[ind] = readline(io)
            end
            for compchar in group[1]
                if occursin(compchar, group[2]) && occursin(compchar, group[3])
                    cval = compchar
                    break
                end
            end
            sum += priority(cval)
        end
    end
    sum
end