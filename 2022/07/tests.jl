using Test

include("main.jl")

node = parsefile("example.txt")

@testset "total size" begin
    @test parsesum(node) == 95437
end