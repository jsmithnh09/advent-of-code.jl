using Test

include("main.jl")

node = parsefile("example.txt")

@testset "total size" begin
    @test filesum(node, full=true) == 48381165
    @test filesum(node.subdirs["a"], full=true) == 94853
    @test filesum(node.subdirs["d"], full=true) == 24933642
    @test sizesum(node) == 95437
end