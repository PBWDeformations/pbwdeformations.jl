@testset ExtendedTestSet "All SmashProductDeformLie.jl tests" begin

    @testset "smash_product_deform_lie constructor" begin
        @testset "$(dynkin)_$n with hw $lambda; R = $R" for (dynkin, n, lambda) in [('A', 2, [1, 1]), ('B', 2, [1, 0])],
            R in [QQ, PolynomialRing(QQ, ["x", "y", "z"])[1]]

            sp, (sp_basisL, sp_basisV) = smash_product_lie(R, dynkin, n, lambda)
            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = sp_basisL[1]
            kappa[2, 1] = -kappa[1, 2]
            kappa[3, 4] = sp_basisL[2]
            kappa[4, 3] = -kappa[3, 4]
            deform, (basisL, basisV) = smash_product_deform_lie(sp, kappa)

            @test deform.dimL == sp.dimL == length(deform.basisL)
            @test deform.dimV == sp.dimV == length(deform.basisV)
            @test deform.basisL == basisL
            @test deform.basisV == basisV
            @test deform.coeff_ring == R
            @test deform.symmetric == false
            @test deform.kappa == kappa

            @test ngens(deform) == (deform.dimL, deform.dimV)
            @test gens(deform) == (deform.basisL, deform.basisV)

            # Test the module basis relations
            for i in eachindex(basisV), j in eachindex(basisV)
                if i == 1 && j == 2
                    @test comm(basisV[i], basisV[j]; strict=true) == basisL[1]
                elseif i == 2 && j == 1
                    @test comm(basisV[i], basisV[j]; strict=true) == -basisL[1]
                elseif i == 3 && j == 4
                    @test comm(basisV[i], basisV[j]; strict=true) == basisL[2]
                elseif i == 4 && j == 3
                    @test comm(basisV[i], basisV[j]; strict=true) == -basisL[2]
                else
                    @test iszero(comm(basisV[i], basisV[j]; strict=true))
                end
            end

            showOutput = @test_nowarn sprint(show, deform)
            @test occursin("smash product", lowercase(showOutput))
            @test occursin("lie algebra", lowercase(showOutput))
            # @test_broken occursin(string(dynkin), showOutput)
            # @test_broken occursin(string(lambda), showOutput)
            @test !occursin("symmetric", lowercase(showOutput))
            @test occursin("deformation", lowercase(showOutput))
        end

    end

    @testset "smash_product_symmdeform_lie constructor" begin
        @testset "$(dynkin)_$n with hw $lambda; R = $R" for (dynkin, n, lambda) in [('A', 2, [1, 1]), ('B', 2, [1, 0])],
            R in [QQ, PolynomialRing(QQ, ["x", "y", "z"])[1]]

            sp, _ = smash_product_lie(R, dynkin, n, lambda)
            deform, (basisL, basisV) = smash_product_symmdeform_lie(sp)

            @test deform.dimL == sp.dimL == length(deform.basisL)
            @test deform.dimV == sp.dimV == length(deform.basisV)
            @test deform.basisL == basisL
            @test deform.basisV == basisV
            @test deform.coeff_ring == R
            @test deform.symmetric == true
            @test deform.kappa == fill(zero(sp.alg), sp.dimV, sp.dimV)

            # Test that the module basis commutes
            for vi in basisV, vj in basisV
                @test iszero(comm(vi, vj; strict=true))
            end

            showOutput = @test_nowarn sprint(show, deform)
            @test occursin("smash product", lowercase(showOutput))
            @test occursin("lie algebra", lowercase(showOutput))
            # @test_broken occursin(string(dynkin), showOutput)
            # @test_broken occursin(string(lambda), showOutput)
            @test occursin("symmetric deformation", lowercase(showOutput))
        end

    end

    @testset "smash_product_deform_lie sanitize checks; R = $R" for R in [QQ, PolynomialRing(QQ, ["x", "y", "z"])[1]]
        @testset "check dimensions of kappa" begin
            sp, _ = smash_product_lie(R, 'B', 2, [1, 0])

            for eps in [-1, 1]
                kappa = fill(zero(sp.alg), sp.dimV + eps, sp.dimV)
                @test_throws ArgumentError("kappa has wrong dimensions.") smash_product_deform_lie(sp, kappa)

                kappa = fill(zero(sp.alg), sp.dimV, sp.dimV + eps)
                @test_throws ArgumentError("kappa has wrong dimensions.") smash_product_deform_lie(sp, kappa)

                kappa = fill(zero(sp.alg), sp.dimV + eps, sp.dimV + eps)
                @test_throws ArgumentError("kappa has wrong dimensions.") smash_product_deform_lie(sp, kappa)
            end
        end

        @testset "check entries of kappa contained in Hopf algebra of smash product" begin
            sp, (basisL, basisV) = smash_product_lie(R, 'B', 2, [1, 0])

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = basisV[1]
            kappa[2, 1] = -kappa[1, 2]
            @test_throws ArgumentError("kappa does not only take values in the hopf algebra") smash_product_deform_lie(
                sp,
                kappa,
            )

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = basisV[1] * basisL[1]
            kappa[2, 1] = -kappa[1, 2]
            @test_throws ArgumentError("kappa does not only take values in the hopf algebra") smash_product_deform_lie(
                sp,
                kappa,
            )

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = sp.alg(2)
            kappa[2, 1] = -kappa[1, 2]
            @test_nowarn smash_product_deform_lie(sp, kappa)
        end

        @testset "check kappa is skew symmetric" begin
            sp, (basisL, basisV) = smash_product_lie(R, 'B', 2, [1, 0])

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 1] = basisL[1]
            @test_throws ArgumentError("kappa is not skew-symmetric.") smash_product_deform_lie(sp, kappa)

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = basisL[1]
            @test_throws ArgumentError("kappa is not skew-symmetric.") smash_product_deform_lie(sp, kappa)

            kappa = fill(zero(sp.alg), sp.dimV, sp.dimV)
            kappa[1, 2] = basisL[1]
            kappa[2, 1] = -2 * basisL[1]
            @test_throws ArgumentError("kappa is not skew-symmetric.") smash_product_deform_lie(sp, kappa)
        end

    end


    @testset "is_pbwdeform" begin
        @testset "symmetric deformation of $(dynkin)_$n with hw $lambda is PBW" for (dynkin, n, lambda) in
                                                                                    [('A', 2, [1, 1]), ('B', 2, [1, 0])]
            sp, _ = smash_product_lie(QQ, dynkin, n, lambda)
            d, _ = smash_product_symmdeform_lie(sp)
            @test is_pbwdeform(d)
        end

        @testset "non-PBW deformations" begin
            sp, (basisL, basisV) = smash_product_lie(QQ, 'A', 2, [1, 0])
            kappa = fill(zero(sp.alg), 3, 3)
            # some made-up skew-symmetric entries
            kappa[1, 2] = basisL[2]
            kappa[2, 1] = -basisL[2]
            d, _ = smash_product_deform_lie(sp, kappa)
            @test !is_pbwdeform(d)
        end

    end

    @testset "pbwdeforms_all construction stuff" begin
        @testset "coefficient_comparison tests" begin
            A, (x, y, z) = free_algebra(QQ, ["x", "y", "z"])
            eq = QQ(2 // 3) * x + 88 * y * z - 12 * x * z + 3 * y + 0 * z^4 - 2 * y + 12 * x * z
            @test issetequal(PD.coefficient_comparison(eq), elem_type(QQ)[2//3, 88, 1])
        end

        @testset "pbwdeforms_all tests" begin
            sp, _ = smash_product_lie(QQ, 'A', 1, [1])
            @testset "A_1 with hw [1], maxdeg = $maxdeg" for maxdeg in 0:8
                basis = pbwdeforms_all(sp, 0:maxdeg)

                @test length(basis) == 1 + div(maxdeg, 2)

                for b in basis
                    for i in 1:sp.dimV, j in 1:sp.dimV
                        @test iszero(b[i, j] + b[j, i])
                    end
                end

                @test repr("text/plain", basis[1][1, 2]) == "1"
                if length(basis) >= 2
                    @test repr("text/plain", basis[2][1, 2]) == "-2*x_3 + 4*x_1*x_2 + x_3^2"
                end
                if length(basis) >= 3
                    @test repr("text/plain", basis[3][1, 2]) ==
                          "8*x_3 + 16*x_1*x_2 + -32*x_1*x_2*x_3 + -4*x_3^3 + 16*x_1^2*x_2^2 + 8*x_1*x_2*x_3^2 + x_3^4"
                end
                if length(basis) >= 4
                    @test repr("text/plain", basis[4][1, 2]) ==
                          "-96*x_3 + 64*x_1*x_2 + -64*x_1*x_2*x_3 + 40*x_3^3 + 320*x_1^2*x_2^2 + 208*x_1*x_2*x_3^2 + -288*x_1^2*x_2^2*x_3 + -96*x_1*x_2*x_3^3 + -6*x_3^5 + 64*x_1^3*x_2^3 + 48*x_1^2*x_2^2*x_3^2 + 12*x_1*x_2*x_3^4 + x_3^6"
                end
            end

            sp, _ = smash_product_lie(QQ, 'B', 2, [1, 0])
            @testset "B_2 with hw [1,0], maxdeg = $maxdeg" for maxdeg in 0:2
                basis = pbwdeforms_all(sp, 0:maxdeg)

                @test length(basis) == div(maxdeg + 1, 2)

                for b in basis
                    for i in 1:sp.dimV, j in 1:sp.dimV
                        @test iszero(b[i, j] + b[j, i])
                    end
                end

                if length(basis) >= 1
                    @test repr("text/plain", basis[1]) == """
                        5×5 Matrix{QuadraticQuoAlgebraElem{fmpq}}:
                         0                    -1*x_4     x_3     -1*x_1      x_9 + 1//2*x_10
                         x_4                  0          x_2     -1//2*x_10  x_5
                         -1*x_3               -1*x_2     0       -1*x_6      x_7
                         x_1                  1//2*x_10  x_6     0           x_8
                         -1*x_9 + -1//2*x_10  -1*x_5     -1*x_7  -1*x_8      0"""
                end

            end

        end

    end


end
