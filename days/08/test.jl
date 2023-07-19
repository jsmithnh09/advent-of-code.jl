using Test

include("main.jl")

@testset "test example # 1" begin
    @test count_file("example.txt") == 21
end