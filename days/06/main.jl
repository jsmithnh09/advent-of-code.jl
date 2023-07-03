"""
    ind = findbuff(buffer)

Given an input string, find the first index of a non-repeating code
after 4 characters, (or n-characters, if a sliding window with adjustable 
size.)
"""
function findbuff(buffer::String; winsize::Int = 4)
    # this is really just a sliding window with size 4...
    ind = 1
    win = 1
    while (ind+winsize-1 <= length(buffer))
        packet = buffer[ind:ind+winsize-1]
        dupFound = findduplicates(packet)
        if !dupFound
            return ind+winsize-1
        else
            ind += 1
        end
    end
    return -1
end

"""
    flag = findduplicates(instr)

The output `flag` returns true if duplicate characters are present in the string.
"""
function findduplicates(instr::String)
    inbuff = [Int(instr[ind]) for ind in eachindex(instr)]
    flag = false
    for iter in eachindex(inbuff)
        matches = findall(inbuff[iter] .== inbuff)
        if length(matches) > 1
            flag = true
            return flag
        end
    end
    flag
end