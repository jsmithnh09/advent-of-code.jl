fcn1 = open("test.txt") do io
    sum = 0
    while !eof(io)
        line = readline(io)
        mvec = eachmatch(r"\d", line) |> collect
        if isempty(mvec)
            break
        end
        if (length(mvec) == 1)
            sum += parse(Int, mvec[1].match * mvec[1].match)
        else
            sum += parse(Int, mvec[1].match * mvec[end].match)
        end
    end
    return sum
end

# lookup for any of the matches.
const DIGIT_DICT = Dict{String, String}(
    "zero" =>   "0",
    "one" =>    "1",
    "two" =>    "2",
    "three" =>  "3",
    "four" =>   "4",
    "five" =>   "5",
    "six" =>    "6",
    "seven" =>  "7",
    "eight" =>  "8",
    "nine" =>   "9"
)
# create the over-arching regex match.
const RE_TOTAL = Regex("(?:[0-9]|" * join(collect(keys(DIGIT_DICT)), "|") * ")")
fcn2 = open("test.txt") do io
    sum = 0
    while !eof(io)
        line = readline(io)
        mvec = eachmatch(RE_TOTAL, line, overlap=true) |> collect
        dstr = fill("", length(mvec))
        for idx in eachindex(mvec)
            if mvec[idx].match in keys(DIGIT_DICT)
                dstr[idx] = DIGIT_DICT[mvec[idx].match]
            else
                dstr[idx] = mvec[idx].match
            end
        end
        if length(dstr) == 1
            sum += parse(Int64, dstr[1] * dstr[1])
        else
            sum += parse(Int64, dstr[1] * dstr[end])
        end
    end
    return sum
end
println("Part 1: ", fcn1)
println("Part 2: ", fcn2)