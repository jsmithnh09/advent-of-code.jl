using Test
include("main.jl")

@testset "round results" begin
    @test playresult(ROCK, PAPER) == 0
    @test playresult(ROCK, SCISSOR) == 6
    @test playresult(ROCK, ROCK) == 3
    @test playresult(PAPER, PAPER) == 3
    @test playresult(PAPER, SCISSOR) == 0
    @test playresult(PAPER, ROCK) == 6
    @test playresult(SCISSOR, SCISSOR) == 3
    @test playresult(SCISSOR, PAPER) == 6
    @test playresult(SCISSOR, ROCK) == 0
end

@testset "character-decode results" begin
    @test matchresult('Y', 'A') == 8
    @test matchresult('X', 'B') == 1
    @test matchresult('Z', 'C') == 6
end

@testset "matchresults" begin
    @test matchresult(PAPER, ROCK) == 8 # from the example on the site.
end

@testset "player lookup" begin
    @test matchresult2('Y', 'A') == 4
    @test matchresult2('X', 'B') == 1
    @test matchresult2('Z', 'C') == 7
end