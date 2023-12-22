using Test
include("main.jl")

@testset "basic examples" begin
    @test tallypriority("example.txt") == 157
    @test tallypriority2("example.txt") == 70
end

