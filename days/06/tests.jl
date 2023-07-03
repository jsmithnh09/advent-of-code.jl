using Test
include("main.jl")

example = readlines("example.txt")

@testset "example" begin
    @test findbuff(example[1]) == 7
    @test findbuff(example[2]) == 5
    @test findbuff(example[3]) == 6
    @test findbuff(example[4]) == 10
    @test findbuff(example[5]) == 11
end

@testset "example #2" begin
    @test findbuff(example[1], winsize=14) == 19
    @test findbuff(example[2], winsize=14) == 23
    @test findbuff(example[3], winsize=14) == 23
    @test findbuff(example[4], winsize=14) == 29
    @test findbuff(example[5], winsize=14) == 26
end