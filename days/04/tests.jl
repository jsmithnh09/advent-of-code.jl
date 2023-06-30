using Test

include("main.jl")

@testset "example case" begin
    @test tally_groups("example.txt")[1] == 2
    @test tally_groups("example.txt", compare=comp2)[1] == 4
end