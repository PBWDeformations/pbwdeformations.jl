ArcDiagram = PD.ArcDiagram
is_crossing_free = PD.is_crossing_free
all_arc_diagrams = PD.all_arc_diagrams

@testset ExtendedTestSet "All ArcDiagram.jl tests" begin
    @testset "ArcDiagram constructor" begin
        # wrong length
        @test_throws ArgumentError ArcDiagram(5, 5, [2, 1, 4, 3, 6, 5, 8, 7])
        @test_throws ArgumentError ArcDiagram(5, 5, [2, 1, 4, 3, 6, 5, 8, 7, 10])
        @test_throws ArgumentError ArcDiagram(5, 5, [2, 1, 4, 3, 6, 5, 8, 7, 10, 9, 1])

        # out of bounds
        @test_throws ArgumentError ArcDiagram(5, 5, [-1, 1, 4, 3, 6, 5, 8, 7, 10, 9])
        @test_throws ArgumentError ArcDiagram(5, 5, [11, 1, 4, 3, 6, 5, 8, 7, 10, 9])

        # self-loops
        @test_throws ArgumentError ArcDiagram(5, 5, [1, 2, 4, 3, 6, 5, 8, 7, 10, 9])
        @test_throws ArgumentError ArcDiagram(5, 5, [10, 1, 2, 3, 4, 5, 6, 7, 8, 9])

        # correct
        @test ArcDiagram(5, 5, [2, 1, 4, 3, 6, 5, 8, 7, 10, 9]) !== nothing

    end

    @testset "is_crossing_free" begin
        @test is_crossing_free(ArcDiagram(2, 4, [2, 1, 4, 3, 6, 5])) == true      # AA,CCEE
        @test is_crossing_free(ArcDiagram(2, 4, [2, 1, 5, 6, 3, 4])) == false     # AA,CDCD
        @test is_crossing_free(ArcDiagram(2, 4, [2, 1, 6, 5, 4, 3])) == true      # AA,CDDC
        @test is_crossing_free(ArcDiagram(2, 4, [3, 4, 1, 2, 6, 5])) == true      # AB,ABEE
        @test is_crossing_free(ArcDiagram(2, 4, [3, 5, 1, 6, 2, 4])) == false     # AB,ADBD
        @test is_crossing_free(ArcDiagram(2, 4, [3, 6, 1, 5, 4, 2])) == true      # AB,ADDB
        @test is_crossing_free(ArcDiagram(2, 4, [4, 3, 2, 1, 6, 5])) == false     # AB,BAEE
        @test is_crossing_free(ArcDiagram(2, 4, [4, 5, 6, 1, 2, 3])) == false     # AB,CABC
        @test is_crossing_free(ArcDiagram(2, 4, [4, 6, 5, 1, 3, 2])) == false     # AB,CACB
        @test is_crossing_free(ArcDiagram(2, 4, [5, 3, 2, 6, 1, 4])) == false     # AB,BDAD
        @test is_crossing_free(ArcDiagram(2, 4, [5, 4, 6, 2, 1, 3])) == false     # AB,CBAC
        @test is_crossing_free(ArcDiagram(2, 4, [5, 6, 4, 3, 1, 2])) == true      # AB,CCAB
        @test is_crossing_free(ArcDiagram(2, 4, [6, 3, 2, 5, 4, 1])) == false     # AB,BDDA
        @test is_crossing_free(ArcDiagram(2, 4, [6, 4, 5, 2, 3, 1])) == false     # AB,CBCA
        @test is_crossing_free(ArcDiagram(2, 4, [6, 5, 4, 3, 2, 1])) == false     # AB,CCBA

        @test is_crossing_free(ArcDiagram(3, 3, [2, 1, 4, 3, 6, 5])) == true      # AAC,CEE
        @test is_crossing_free(ArcDiagram(3, 3, [2, 1, 5, 6, 3, 4])) == false     # AAC,DCD
        @test is_crossing_free(ArcDiagram(3, 3, [2, 1, 6, 5, 4, 3])) == true      # AAC,DDC
        @test is_crossing_free(ArcDiagram(3, 3, [3, 4, 1, 2, 6, 5])) == false     # ABA,BEE
        @test is_crossing_free(ArcDiagram(3, 3, [3, 5, 1, 6, 2, 4])) == false     # ABA,DBD
        @test is_crossing_free(ArcDiagram(3, 3, [3, 6, 1, 5, 4, 2])) == false     # ABA,DDB
        @test is_crossing_free(ArcDiagram(3, 3, [4, 3, 2, 1, 6, 5])) == true      # ABB,AEE
        @test is_crossing_free(ArcDiagram(3, 3, [4, 5, 6, 1, 2, 3])) == true      # ABC,ABC
        @test is_crossing_free(ArcDiagram(3, 3, [4, 6, 5, 1, 3, 2])) == false     # ABC,ACB
        @test is_crossing_free(ArcDiagram(3, 3, [5, 3, 2, 6, 1, 4])) == false     # ABB,DAD
        @test is_crossing_free(ArcDiagram(3, 3, [5, 4, 6, 2, 1, 3])) == false     # ABC,BAC
        @test is_crossing_free(ArcDiagram(3, 3, [5, 6, 4, 3, 1, 2])) == false     # ABC,CAB
        @test is_crossing_free(ArcDiagram(3, 3, [6, 3, 2, 5, 4, 1])) == true      # ABB,DDA
        @test is_crossing_free(ArcDiagram(3, 3, [6, 4, 5, 2, 3, 1])) == false     # ABC,BCA
        @test is_crossing_free(ArcDiagram(3, 3, [6, 5, 4, 3, 2, 1])) == false     # ABC,CBA

        @test is_crossing_free(ArcDiagram(4, 2, [2, 1, 4, 3, 6, 5])) == true      # AACC,EE
        @test is_crossing_free(ArcDiagram(4, 2, [2, 1, 5, 6, 3, 4])) == true      # AACD,CD
        @test is_crossing_free(ArcDiagram(4, 2, [2, 1, 6, 5, 4, 3])) == false     # AACD,DC
        @test is_crossing_free(ArcDiagram(4, 2, [3, 4, 1, 2, 6, 5])) == false     # ABAB,EE
        @test is_crossing_free(ArcDiagram(4, 2, [3, 5, 1, 6, 2, 4])) == false     # ABAD,BD
        @test is_crossing_free(ArcDiagram(4, 2, [3, 6, 1, 5, 4, 2])) == false     # ABAD,DB
        @test is_crossing_free(ArcDiagram(4, 2, [4, 3, 2, 1, 6, 5])) == true      # ABBA,EE
        @test is_crossing_free(ArcDiagram(4, 2, [4, 5, 6, 1, 2, 3])) == false     # ABCA,BC
        @test is_crossing_free(ArcDiagram(4, 2, [4, 6, 5, 1, 3, 2])) == false     # ABCA,CB
        @test is_crossing_free(ArcDiagram(4, 2, [5, 3, 2, 6, 1, 4])) == true      # ABBD,AD
        @test is_crossing_free(ArcDiagram(4, 2, [5, 4, 6, 2, 1, 3])) == false     # ABCB,AC
        @test is_crossing_free(ArcDiagram(4, 2, [5, 6, 4, 3, 1, 2])) == true      # ABCC,AB
        @test is_crossing_free(ArcDiagram(4, 2, [6, 3, 2, 5, 4, 1])) == false     # ABBD,DA
        @test is_crossing_free(ArcDiagram(4, 2, [6, 4, 5, 2, 3, 1])) == false     # ABCB,CA
        @test is_crossing_free(ArcDiagram(4, 2, [6, 5, 4, 3, 2, 1])) == false     # ABCC,BA

    end

    @testset "all_arc_diagrams" begin
        for n in 0:5
            for i in 0:2n
                @test length(collect(all_arc_diagrams(i, 2n - i))) ==
                      length(all_arc_diagrams(i, 2n - i)) ==
                      div(factorial(2 * n), 2^n * factorial(n))
            end
            for i in 0:2n+1
                @test length(collect(all_arc_diagrams(i, 2n + 1 - i))) == length(all_arc_diagrams(i, 2n + 1 - i)) == 0
            end

            for i in 0:2n
                @test length(collect(all_arc_diagrams(i, 2n - i; indep_sets=[1:n, n+1:2n]))) ==
                      length(all_arc_diagrams(i, 2n - i; indep_sets=[1:n, n+1:2n])) ==
                      factorial(n)
            end
        end

        @test length(collect(all_arc_diagrams(6, 6, indep_sets=[[1, 2, 3], [4, 5, 6], [7, 8], [9, 10], [11, 12]]))) ==
              length(all_arc_diagrams(6, 6, indep_sets=[[1, 2, 3], [4, 5, 6], [7, 8], [9, 10], [11, 12]])) ==
              4440
    end

end
