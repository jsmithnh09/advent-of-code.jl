using Test

include("main.jl")

@testset "test example # 1" begin
    @test count_file("example.txt") == 21
    @test highest_score("example.txt") == 8
end