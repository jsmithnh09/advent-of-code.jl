using Test
include("main.jl")


EXAMPLE_STACK = Dict(
    1 => ["Z", "N"],
    2 => ["M",  "C", "D"],
    3 => ["P"]
)

PUZZLE_STACK = Dict(
1 => ["T", "D", "W", "Z", "V", "P"],
2 => ["L", "S", "W", "V", "F", "J", "D"],
3 => ["Z", "M", "L", "S", "V", "T", "B", "H"],
4 => ["R", "S", "J"],
5 => ["C", "Z", "B", "G", "F", "M", "L", "W"],
6 => ["Q", "W", "V", "H", "Z", "R", "G", "B"],
7 => ["V", "J", "P", "C", "B", "D", "N"],
8 => ["P", "T", "B", "Q"],
9 => ["H", "G", "Z", "R", "C"]
)

@testset "example stack" begin
    move_crates!("example.txt", EXAMPLE_STACK)
    @test EXAMPLE_STACK[1][end] == "C"
    @test EXAMPLE_STACK[2][end] == "M"
    @test EXAMPLE_STACK[3][end] == "Z"
end

## Resetting the stack; could have made the functions immutable and returned a copy.
EXAMPLE_STACK = Dict(
    1 => ["Z", "N"],
    2 => ["M",  "C", "D"],
    3 => ["P"]
)
@testset "example stack #2" begin
    move_crates!("example.txt", EXAMPLE_STACK, movefcn=crateshift2!)
    @test EXAMPLE_STACK[1][end] == "M"
    @test EXAMPLE_STACK[2][end] == "C"
    @test EXAMPLE_STACK[3][end] == "D"
end