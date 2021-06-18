lie = PD.lie
mod = PD.mod

@testset ExtendedTestSet "All PBWDeformations.SmashProductLie tests" begin
    @testset "smashProductLie constructor" begin
        @testset "A_2 with hw [1,1]" begin
            sp = PD.smashProductLie('A', 2, [1,1])
            @test sp.extraData.dynkin == 'A'
            @test sp.extraData.n == 2
            @test sp.extraData.lambda == [1,1]
            @test sp.extraData.nL == 8
            @test sp.extraData.nV == 8
            @test length(sp.basis) == sp.extraData.nL + sp.extraData.nV
            @test sp.commTable == Dict(
                (lie(2), lie(1)) => [(1,    [lie(3)])],
                (lie(3), lie(1)) => [],
                (lie(3), lie(2)) => [],
                (lie(4), lie(1)) => [(-1,   [lie(7)])],
                (lie(4), lie(2)) => [],
                (lie(4), lie(3)) => [(-1,   [lie(2)])],
                (lie(5), lie(1)) => [],
                (lie(5), lie(2)) => [(-1,   [lie(8)])],
                (lie(5), lie(3)) => [(1,    [lie(1)])],
                (lie(5), lie(4)) => [(-1,   [lie(6)])],
                (lie(6), lie(1)) => [(-1,   [lie(5)])],
                (lie(6), lie(2)) => [(1,    [lie(4)])],
                (lie(6), lie(3)) => [(-1,   [lie(7)]), (-1, [lie(8)])],
                (lie(6), lie(4)) => [],
                (lie(6), lie(5)) => [],
                (lie(7), lie(1)) => [(2,    [lie(1)])],
                (lie(7), lie(2)) => [(-1,   [lie(2)])],
                (lie(7), lie(3)) => [(1,    [lie(3)])],
                (lie(7), lie(4)) => [(-2,   [lie(4)])],
                (lie(7), lie(5)) => [(1,    [lie(5)])],
                (lie(7), lie(6)) => [(-1,   [lie(6)])],
                (lie(8), lie(1)) => [(-1,   [lie(1)])],
                (lie(8), lie(2)) => [(2,    [lie(2)])],
                (lie(8), lie(3)) => [(1,    [lie(3)])],
                (lie(8), lie(4)) => [(1,    [lie(4)])],
                (lie(8), lie(5)) => [(-2,   [lie(5)])],
                (lie(8), lie(6)) => [(-1,   [lie(6)])],
                (lie(8), lie(7)) => [],
                (lie(1), mod(1)) => [],
                (lie(2), mod(1)) => [],
                (lie(3), mod(1)) => [],
                (lie(4), mod(1)) => [(1,    [mod(2)])],
                (lie(5), mod(1)) => [(1,    [mod(3)])],
                (lie(6), mod(1)) => [(1,    [mod(5)])],
                (lie(7), mod(1)) => [(1,    [mod(1)])],
                (lie(8), mod(1)) => [(1,    [mod(1)])],
                (lie(1), mod(2)) => [(1,    [mod(1)])],
                (lie(2), mod(2)) => [],
                (lie(3), mod(2)) => [],
                (lie(4), mod(2)) => [],
                (lie(5), mod(2)) => [(1,    [mod(4)]), (-1, [mod(5)])],
                (lie(6), mod(2)) => [(1,    [mod(6)])],
                (lie(7), mod(2)) => [(-1,   [mod(2)])],
                (lie(8), mod(2)) => [(2,    [mod(2)])],
                (lie(1), mod(3)) => [],
                (lie(2), mod(3)) => [(1,    [mod(1)])],
                (lie(3), mod(3)) => [],
                (lie(4), mod(3)) => [(1,    [mod(4)])],
                (lie(5), mod(3)) => [],
                (lie(6), mod(3)) => [(1,    [mod(7)])],
                (lie(7), mod(3)) => [(2,    [mod(3)])],
                (lie(8), mod(3)) => [(-1,   [mod(3)])],
                (lie(1), mod(4)) => [(2,    [mod(3)])],
                (lie(2), mod(4)) => [(1,    [mod(2)])],
                (lie(3), mod(4)) => [(1,    [mod(1)])],
                (lie(4), mod(4)) => [(2,    [mod(6)])],
                (lie(5), mod(4)) => [(-1,   [mod(7)])],
                (lie(6), mod(4)) => [(1,    [mod(8)])],
                (lie(7), mod(4)) => [],
                (lie(8), mod(4)) => [],
                (lie(1), mod(5)) => [(1,    [mod(3)])],
                (lie(2), mod(5)) => [(-1,   [mod(2)])],
                (lie(3), mod(5)) => [(2,    [mod(1)])],
                (lie(4), mod(5)) => [(1,    [mod(6)])],
                (lie(5), mod(5)) => [(1,    [mod(7)])],
                (lie(6), mod(5)) => [(2,    [mod(8)])],
                (lie(7), mod(5)) => [],
                (lie(8), mod(5)) => [],
                (lie(1), mod(6)) => [(1,    [mod(4)])],
                (lie(2), mod(6)) => [],
                (lie(3), mod(6)) => [(1,    [mod(2)])],
                (lie(4), mod(6)) => [],
                (lie(5), mod(6)) => [(-1,   [mod(8)])],
                (lie(6), mod(6)) => [],
                (lie(7), mod(6)) => [(-2,   [mod(6)])],
                (lie(8), mod(6)) => [(1,    [mod(6)])],
                (lie(1), mod(7)) => [],
                (lie(2), mod(7)) => [(-1,   [mod(4)]), (1, [mod(5)])],
                (lie(3), mod(7)) => [(1,    [mod(3)])],
                (lie(4), mod(7)) => [(1,    [mod(8)])],
                (lie(5), mod(7)) => [],
                (lie(6), mod(7)) => [],
                (lie(7), mod(7)) => [(1,    [mod(7)])],
                (lie(8), mod(7)) => [(-2,   [mod(7)])],
                (lie(1), mod(8)) => [(1,    [mod(7)])],
                (lie(2), mod(8)) => [(-1,   [mod(6)])],
                (lie(3), mod(8)) => [(1,    [mod(5)])],
                (lie(4), mod(8)) => [],
                (lie(5), mod(8)) => [],
                (lie(6), mod(8)) => [],
                (lie(7), mod(8)) => [(-1,   [mod(8)])],
                (lie(8), mod(8)) => [(-1,   [mod(8)])],
            )
        end

        @testset "B_2 with hw [1,0]" begin
            sp = PD.smashProductLie('B', 2, [1,0])
            @test sp.extraData.dynkin == 'B'
            @test sp.extraData.n == 2
            @test sp.extraData.lambda == [1,0]
            @test sp.extraData.nL == 10
            @test sp.extraData.nV == 5
            @test length(sp.basis) == sp.extraData.nL + sp.extraData.nV
            @test sp.commTable == Dict(
                (lie(2),  lie(1)) => [(-1,  [lie(3)])],
                (lie(3),  lie(1)) => [],
                (lie(3),  lie(2)) => [(2,   [lie(4)])],
                (lie(4),  lie(1)) => [],
                (lie(4),  lie(2)) => [],
                (lie(4),  lie(3)) => [],
                (lie(5),  lie(1)) => [(-1,  [lie(9)])],
                (lie(5),  lie(2)) => [],
                (lie(5),  lie(3)) => [(1,   [lie(2)])],
                (lie(5),  lie(4)) => [],
                (lie(6),  lie(1)) => [],
                (lie(6),  lie(2)) => [(-1,  [lie(10)])],
                (lie(6),  lie(3)) => [(-2,  [lie(1)])],
                (lie(6),  lie(4)) => [(-1,  [lie(3)])],
                (lie(6),  lie(5)) => [(1,   [lie(7)])],
                (lie(7),  lie(1)) => [(1,   [lie(6)])],
                (lie(7),  lie(2)) => [(-2,  [lie(5)])],
                (lie(7),  lie(3)) => [(-2,  [lie(9)]), (-1, [lie(10)])],
                (lie(7),  lie(4)) => [(1,   [lie(2)])],
                (lie(7),  lie(5)) => [],
                (lie(7),  lie(6)) => [(-2,  [lie(8)])],
                (lie(8),  lie(1)) => [],
                (lie(8),  lie(2)) => [(-1,  [lie(7)])],
                (lie(8),  lie(3)) => [(1,   [lie(6)])],
                (lie(8),  lie(4)) => [(-1,  [lie(9)]), (-1, [lie(10)])],
                (lie(8),  lie(5)) => [],
                (lie(8),  lie(6)) => [],
                (lie(8),  lie(7)) => [],
                (lie(9),  lie(1)) => [(2,   [lie(1)])],
                (lie(9),  lie(2)) => [(-1,  [lie(2)])],
                (lie(9),  lie(3)) => [(1,   [lie(3)])],
                (lie(9),  lie(4)) => [],
                (lie(9),  lie(5)) => [(-2,  [lie(5)])],
                (lie(9),  lie(6)) => [(1,   [lie(6)])],
                (lie(9),  lie(7)) => [(-1,  [lie(7)])],
                (lie(9),  lie(8)) => [],
                (lie(10), lie(1)) => [(-2,  [lie(1)])],
                (lie(10), lie(2)) => [(2,   [lie(2)])],
                (lie(10), lie(3)) => [],
                (lie(10), lie(4)) => [(2,   [lie(4)])],
                (lie(10), lie(5)) => [(2,   [lie(5)])],
                (lie(10), lie(6)) => [(-2,  [lie(6)])],
                (lie(10), lie(7)) => [],
                (lie(10), lie(8)) => [(-2,  [lie(8)])],
                (lie(10), lie(9)) => [],
                (lie(1),  mod(1)) => [],
                (lie(2),  mod(1)) => [],
                (lie(3),  mod(1)) => [],
                (lie(4),  mod(1)) => [],
                (lie(5),  mod(1)) => [(1,   [mod(2)])],
                (lie(6),  mod(1)) => [],
                (lie(7),  mod(1)) => [(1,   [mod(3)])],
                (lie(8),  mod(1)) => [(1,   [mod(4)])],
                (lie(9),  mod(1)) => [(1,   [mod(1)])],
                (lie(10), mod(1)) => [],
                (lie(1),  mod(2)) => [(1,   [mod(1)])],
                (lie(2),  mod(2)) => [],
                (lie(3),  mod(2)) => [],
                (lie(4),  mod(2)) => [],
                (lie(5),  mod(2)) => [],
                (lie(6),  mod(2)) => [(1,   [mod(3)])],
                (lie(7),  mod(2)) => [],
                (lie(8),  mod(2)) => [(1,   [mod(5)])],
                (lie(9),  mod(2)) => [(-1,  [mod(2)])],
                (lie(10), mod(2)) => [(2,   [mod(2)])],
                (lie(1),  mod(3)) => [],
                (lie(2),  mod(3)) => [(2,   [mod(2)])],
                (lie(3),  mod(3)) => [(2,   [mod(1)])],
                (lie(4),  mod(3)) => [],
                (lie(5),  mod(3)) => [],
                (lie(6),  mod(3)) => [(2,   [mod(4)])],
                (lie(7),  mod(3)) => [(-2,  [mod(5)])],
                (lie(8),  mod(3)) => [],
                (lie(9),  mod(3)) => [],
                (lie(10), mod(3)) => [],
                (lie(1),  mod(4)) => [],
                (lie(2),  mod(4)) => [(1,   [mod(3)])],
                (lie(3),  mod(4)) => [],
                (lie(4),  mod(4)) => [(1,   [mod(1)])],
                (lie(5),  mod(4)) => [(1,   [mod(5)])],
                (lie(6),  mod(4)) => [],
                (lie(7),  mod(4)) => [],
                (lie(8),  mod(4)) => [],
                (lie(9),  mod(4)) => [(1,   [mod(4)])],
                (lie(10), mod(4)) => [(-2,  [mod(4)])],
                (lie(1),  mod(5)) => [(1,   [mod(4)])],
                (lie(2),  mod(5)) => [],
                (lie(3),  mod(5)) => [(-1,  [mod(3)])],
                (lie(4),  mod(5)) => [(1,   [mod(2)])],
                (lie(5),  mod(5)) => [],
                (lie(6),  mod(5)) => [],
                (lie(7),  mod(5)) => [],
                (lie(8),  mod(5)) => [],
                (lie(9),  mod(5)) => [(-1,  [mod(5)])],
                (lie(10), mod(5)) => [],
            )
        end
    end

end
