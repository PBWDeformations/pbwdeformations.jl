var documenterSearchIndex = {"docs":
[{"location":"util/","page":"Util functions","title":"Util functions","text":"CurrentModule = PBWDeformations","category":"page"},{"location":"util/#Utility-functions","page":"Util functions","title":"Utility functions","text":"","category":"section"},{"location":"util/","page":"Util functions","title":"Util functions","text":"This section contains some utility functions that are used in other parts of the package.","category":"page"},{"location":"util/","page":"Util functions","title":"Util functions","text":"Modules = [PBWDeformations]\nPages   = [\"Util.jl\"]","category":"page"},{"location":"util/#PBWDeformations.flatten-Union{Tuple{Array{Vector{T}, 1}}, Tuple{T}} where T","page":"Util functions","title":"PBWDeformations.flatten","text":"flatten(a::Vector{Vector{T}}) where {T}\n\nReturns a vector of all elements of elements of a.\n\nExample\n\njulia> flatten([[1],[],[2,3,4],[5],[]])\n5-element Vector{Any}:\n 1\n 2\n 3\n 4\n 5\n\n\n\n\n\n","category":"method"},{"location":"util/#PBWDeformations.groupBy-Union{Tuple{Vector{T}}, Tuple{T}} where T","page":"Util functions","title":"PBWDeformations.groupBy","text":"groupBy(a::Vector{T}; eq=(==)) where {T}\n\nReturns a vector containing the elements of a grouped into subvectors of consecutive equal elements.\n\nExamples\n\njulia> groupBy([1,1,2,2,2,2,3,1,4,4])\n5-element Vector{Vector{Int64}}:\n [1, 1]\n [2, 2, 2, 2]\n [3]\n [1]\n [4, 4]\n\njulia> groupBy([i for i in -5:5]; eq=((x, y) -> sign(x) == sign(y)))\n3-element Vector{Vector{Int64}}:\n [-5, -4, -3, -2, -1]\n [0]\n [1, 2, 3, 4, 5]\n\n\n\n\n\n","category":"method"},{"location":"util/#PBWDeformations.is_valid_dynkin-Tuple{Char, Int64}","page":"Util functions","title":"PBWDeformations.is_valid_dynkin","text":"is_valid_dynkin(dynkin::Char, n::Int)\n\nReturns true, if there given parameters uniquely define a dynkin diagram, i.e. are of one of the forms\n\nA_n for n geq 1,\nB_n for n geq 2,\nC_n for n geq 2,\nD_n for n geq 4,\nE_5, E_6, E_7,\nF_4,\nG_2.\n\nExamples\n\njulia> is_valid_dynkin('A', 2)\ntrue\n\njulia> is_valid_dynkin('F', 4)\ntrue\n\njulia> is_valid_dynkin('D', 3)\nfalse\n\n\n\n\n\n","category":"method"},{"location":"util/#PBWDeformations.std_basis-Tuple{Int64, Int64}","page":"Util functions","title":"PBWDeformations.std_basis","text":"std_basis(i::Int, n::Int)\nstd_basis(::Type{T}, i::Int, n::Int) where {T <: Number}\n\nReturns the i-th standard basis vector of dimension n. If supplied with a type, the vector is of that type, otherwise it is of type Int.\n\nExamples\n\njulia> std_basis(1, 3)\n3-element Vector{Int64}:\n 1\n 0\n 0\n\njulia> std_basis(Float64,2,4)\n4-element Vector{Float64}:\n 0.0\n 1.0\n 0.0\n 0.0\n\n\n\n\n\n","category":"method"},{"location":"util/#PBWDeformations.ur_proper_triag_entries-Union{Tuple{Matrix{T}}, Tuple{T}} where T","page":"Util functions","title":"PBWDeformations.ur_proper_triag_entries","text":"ur_proper_triag_entries(M::Matrix{T}) where {T}\n\nReturns the entries of the proper upper triangular part of M in row-major order.\n\nExamples\n\njulia> ur_proper_triag_entries([1 2 3;4 5 6;7 8 9])\n3-element Vector{Int64}:\n 2\n 3\n 6\n\n\n\n\n\n","category":"method"},{"location":"util/#PBWDeformations.ur_triag_entries-Union{Tuple{Matrix{T}}, Tuple{T}} where T","page":"Util functions","title":"PBWDeformations.ur_triag_entries","text":"ur_triag_entries(M::Matrix{T}) where {T}\n\nReturns the entries of the upper triangular part of M in row-major order.\n\nExamples\n\njulia> ur_triag_entries([1 2 3;4 5 6;7 8 9])\n6-element Vector{Int64}:\n 1\n 2\n 3\n 5\n 6\n 9\n\n\n\n\n\n","category":"method"},{"location":"references/#References","page":"References","title":"References","text":"","category":"section"},{"location":"references/","page":"References","title":"References","text":"","category":"page"},{"location":"smash_product_deform_lie/","page":"Smash product deformations","title":"Smash product deformations","text":"CurrentModule = PBWDeformations\nDocTestSetup  = quote\n    using PBWDeformations\n    using Oscar\nend","category":"page"},{"location":"smash_product_deform_lie/#Smash-products-deformations","page":"Smash product deformations","title":"Smash products deformations","text":"","category":"section"},{"location":"smash_product_deform_lie/#Constructors","page":"Smash product deformations","title":"Constructors","text":"","category":"section"},{"location":"smash_product_deform_lie/","page":"Smash product deformations","title":"Smash product deformations","text":"DeformationMap\nsmash_product_deform_lie\nsmash_product_symmdeform_lie","category":"page"},{"location":"smash_product_deform_lie/#PBWDeformations.DeformationMap","page":"Smash product deformations","title":"PBWDeformations.DeformationMap","text":"DeformationMap{C} = Matrix{QuadraticQuoAlgebraElem{C}} where {C <: RingElement}\n\nThe type for deformation maps of a Lie algebra smash product. The entry kappa[i,j] should be the image of v_i wedge v_j under the deformation map, i.e. κ(v_iv_j). Deformation maps are always assumed to be quadratic and skew-symmetric.\n\n\n\n\n\n","category":"type"},{"location":"smash_product_deform_lie/#PBWDeformations.smash_product_deform_lie","page":"Smash product deformations","title":"PBWDeformations.smash_product_deform_lie","text":"smash_product_deform_lie(sp::SmashProductLie{C}, kappa::DeformationMap{C}) where {C <: RingElement}\n\nConstructs the deformation of the smash product sp by the deformation map kappa.\n\nReturns a SmashProductDeformLie struct and a two-part basis.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_deform_lie/#PBWDeformations.smash_product_symmdeform_lie","page":"Smash product deformations","title":"PBWDeformations.smash_product_symmdeform_lie","text":"smash_product_symmdeform_lie(sp::SmashProductLie{C}) where {C <: RingElement}\n\nConstructs the symmetric deformation of the smash product sp.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_deform_lie/#SmashProductDeformLie-struct","page":"Smash product deformations","title":"SmashProductDeformLie struct","text":"","category":"section"},{"location":"smash_product_deform_lie/","page":"Smash product deformations","title":"Smash product deformations","text":"SmashProductDeformLie","category":"page"},{"location":"smash_product_deform_lie/#PBWDeformations.SmashProductDeformLie","page":"Smash product deformations","title":"PBWDeformations.SmashProductDeformLie","text":"The struct representing a deformation of a Lie algebra smash product. It consists of the underlying QuadraticQuoAlgebra and some metadata. It gets created by calling smash_product_deform_lie.\n\n\n\n\n\n","category":"type"},{"location":"smash_product_deform_lie/#Functions","page":"Smash product deformations","title":"Functions","text":"","category":"section"},{"location":"smash_product_deform_lie/","page":"Smash product deformations","title":"Smash product deformations","text":"The SmashProductDeformLie struct can be used as an argument for the following functions:","category":"page"},{"location":"smash_product_deform_lie/","page":"Smash product deformations","title":"Smash product deformations","text":"gens\nngens\nchange_base_ring","category":"page"},{"location":"structure_constants/","page":"Structure constants","title":"Structure constants","text":"CurrentModule = PBWDeformations","category":"page"},{"location":"structure_constants/#Structure-constants-functions","page":"Structure constants","title":"Structure constants functions","text":"","category":"section"},{"location":"structure_constants/","page":"Structure constants","title":"Structure constants","text":"To be able to use more sophisticated techniques, we need to have a description of Lie algebras in terms of matrices s.t. the standard representation operates by simple matrix-vector-multiplication. This is done by the functions in this section.","category":"page"},{"location":"structure_constants/","page":"Structure constants","title":"Structure constants","text":"Since most of this package only considers structural constants of Lie algebras, modules etc. one needs to additionally save the knowledge about properties of the occurring objects and their bases, e.g. using SmashProductLieInfo for SmashProductLie.","category":"page"},{"location":"structure_constants/","page":"Structure constants","title":"Structure constants","text":"Modules = [PBWDeformations]\nPages   = [\"LieAlgebraStructConsts.jl\"]","category":"page"},{"location":"structure_constants/#PBWDeformations.liealgebra_so_basis-Tuple{Int64}","page":"Structure constants","title":"PBWDeformations.liealgebra_so_basis","text":"liealgebra_so_basis(n::Int)\n\nReturns a basis of the orthogonal Lie algebra of dimension n mathfrakso_n.\n\nIt consists of the matrices X_ij = E_ij - E_ji with i  j in row-major order.\n\n\n\n\n\n","category":"method"},{"location":"structure_constants/#PBWDeformations.liealgebra_sp_basis-Tuple{Int64}","page":"Structure constants","title":"PBWDeformations.liealgebra_sp_basis","text":"liealgebra_sp_basis(n::Int)\n\nReturns a basis of the symplectic Lie algebra mathfraksp_2n.\n\nIt consists of the following elements (where i  j):\n\nA_i = E_i i+n\nB_i = E_i+n i\nC_ij = E_i j - E_j+n i+n\nD_ij = E_j i - E_i+n j+n\nF_ij = E_i j+n + E_j i+n\nG_ij = E_i+n j + E_j+n i\nH_i = E_i i - E_i+n i+n\n\n\n\n\n\n","category":"method"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"CurrentModule = PBWDeformations\nDocTestSetup  = quote\n    using PBWDeformations\n    using Oscar\nend","category":"page"},{"location":"arc_diagrams/#Arc-diagrams","page":"Arc diagrams","title":"Arc diagrams","text":"","category":"section"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"Modules = [PBWDeformations]\nPages   = [\"ArcDiagram.jl\"]","category":"page"},{"location":"arc_diagrams/#Arc-diagram-induced-bases","page":"Arc diagrams","title":"Arc diagram induced bases","text":"","category":"section"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"warning: Warning\nThe basis ArcDiagDeformBasis can currently only be used for exterior powers of the standard module of Lie type mathfrakso_n.","category":"page"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"ArcDiagDeformBasis","category":"page"},{"location":"arc_diagrams/#PBWDeformations.ArcDiagDeformBasis","page":"Arc diagrams","title":"PBWDeformations.ArcDiagDeformBasis","text":"Concrete subtype of DeformBasis. Each element of the basis is induced by an arc diagram of a suitable size, which gets symmetrized and specialised to the given smash product. This process is due to Johannes Flake, Verity Mackscheidt (2022).\n\n\n\n\n\n","category":"type"},{"location":"arc_diagrams/#Reverse-direction","page":"Arc diagrams","title":"Reverse direction","text":"","category":"section"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"Given a basis element of an above basis, one can lookup all arc diagrams that induce it (up to a scalar).","category":"page"},{"location":"arc_diagrams/","page":"Arc diagrams","title":"Arc diagrams","text":"lookup_data","category":"page"},{"location":"arc_diagrams/#PBWDeformations.lookup_data","page":"Arc diagrams","title":"PBWDeformations.lookup_data","text":"lookup_data(m::DeformationMap{C}, base::DeformBasis{C}) where {C <: RingElement}\n\nLook up additional data that was used to generate the deformation map m in the basis base. This can e.g. be an arc diagram or a pseudograph.\n\n\n\n\n\n","category":"function"},{"location":"pseudographs/","page":"Pseudographs","title":"Pseudographs","text":"CurrentModule = PBWDeformations\nDocTestSetup  = quote\n    using PBWDeformations\n    using Oscar\nend","category":"page"},{"location":"pseudographs/#Pseudographs","page":"Pseudographs","title":"Pseudographs","text":"","category":"section"},{"location":"pseudographs/","page":"Pseudographs","title":"Pseudographs","text":"Modules = [PBWDeformations]\nPages   = [\"Pseudograph.jl\"]","category":"page"},{"location":"pseudographs/#Pseudograph-induced-bases","page":"Pseudographs","title":"Pseudograph induced bases","text":"","category":"section"},{"location":"pseudographs/","page":"Pseudographs","title":"Pseudographs","text":"warning: Warning\nThe basis PseudographDeformBasis can currently only be used for exterior powers of the standard module of Lie type mathfrakso_n.","category":"page"},{"location":"pseudographs/","page":"Pseudographs","title":"Pseudographs","text":"PseudographDeformBasis","category":"page"},{"location":"pseudographs/#PBWDeformations.PseudographDeformBasis","page":"Pseudographs","title":"PBWDeformations.PseudographDeformBasis","text":"Concrete subtype of DeformBasis. Each element of the basis is induced by pseudograph with two vertices and certain properties, which gets transformed to an arc diagram and then handled as in ArcDiagDeformBasis. This process is due to Johannes Flake, Verity Mackscheidt (2022).\n\n\n\n\n\n","category":"type"},{"location":"pseudographs/#Reverse-direction","page":"Pseudographs","title":"Reverse direction","text":"","category":"section"},{"location":"pseudographs/","page":"Pseudographs","title":"Pseudographs","text":"Given a basis element of an above basis, one can lookup all pseudographs that induce it (up to a scalar). See lookup_data for more details.","category":"page"},{"location":"#PBWDeformations","page":"PBWDeformations.jl","title":"PBWDeformations","text":"","category":"section"},{"location":"#Introduction","page":"PBWDeformations.jl","title":"Introduction","text":"","category":"section"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"The package PBWDeformations will provide both a general framework and specialized functions in order to","category":"page"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"classify PBW deformations of certain smash products and\nstudy their representations.","category":"page"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"To solve classification problems efficiently, we use representation theoretic ideas.","category":"page"},{"location":"#Features","page":"PBWDeformations.jl","title":"Features","text":"","category":"section"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"Construct smash products of Lie algebras and their modules, either for highest weight modules or (only for mathfrakso_n and mathfraksp_2n) for symmetric and exterior powers of the standard module.\nConstruct deformations of such smash products.\nCompute a normal form for elements of smash products and their deformations.\nCheck, if a given deformation is a PBW-deformation (using Chelsea Walton, Sarah Witherspoon (2014)).\nFor some smash product, compute a basis of all PBW-deformations up to a given degree (using Chelsea Walton, Sarah Witherspoon (2014)). It is possible to give a basis of the relevant part of the deformation space, which is then used in the computation.\nFor some modules of mathfrakso_n, give an explicit basis using arc diagrams (cf. Johannes Flake, Verity Mackscheidt (2022)).","category":"page"},{"location":"#Installation","page":"PBWDeformations.jl","title":"Installation","text":"","category":"section"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"As this package heavily relies on Oscar, it is recommended to install Oscar first (installation instructions). Then, install this package via the Julia package manager:","category":"page"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"] add PBWDeformations","category":"page"},{"location":"#Outline","page":"PBWDeformations.jl","title":"Outline","text":"","category":"section"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"Pages = [\n    \"smash_product_lie.md\",\n    \"smash_product_deform_lie.md\",\n    \"smash_product_pbwdeform_lie.md\",\n    \"arc_diagrams.md\",\n    \"structure_constants.md\",\n    \"util.md\",\n]","category":"page"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"References","category":"page"},{"location":"#main-index","page":"PBWDeformations.jl","title":"Index","text":"","category":"section"},{"location":"","page":"PBWDeformations.jl","title":"PBWDeformations.jl","text":"","category":"page"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"CurrentModule = PBWDeformations\nDocTestSetup  = quote\n    using PBWDeformations\n    using Oscar\nend","category":"page"},{"location":"smash_product_pbwdeform_lie/#PBW-Deformations-of-smash-products","page":"PBWDeformations","title":"PBW Deformations of smash products","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/#General-deformation-functions","page":"PBWDeformations","title":"General deformation functions","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"is_pbwdeform\npbwdeform_eqs","category":"page"},{"location":"smash_product_pbwdeform_lie/#PBWDeformations.is_pbwdeform","page":"PBWDeformations","title":"PBWDeformations.is_pbwdeform","text":"is_pbwdeform(d::SmashProductDeformLie{C}) where {C <: RingElement}\n\nCheck if d is a Poincare-Birkhoff-Witt deformation of a smash product. Uses Theorem 3.1 of Chelsea Walton, Sarah Witherspoon (2014).\n\n\n\n\n\n","category":"function"},{"location":"smash_product_pbwdeform_lie/#PBWDeformations.pbwdeform_eqs","page":"PBWDeformations","title":"PBWDeformations.pbwdeform_eqs","text":"pbwdeform_eqs(deform::SmashProductDeformLie{C}; disabled::Vector{Symbol}=Symbol[]) where {C <: RingElement}\n\nReturns the equations for deform being a PBW deformation of a smash product as in Theorem 3.1 of Chelsea Walton, Sarah Witherspoon (2014). Subsets of the equations can be disabled by passing the corresponding symbols as keyword arguments, e.g. disabled = [:c, :d].\n\n\n\n\n\n","category":"function"},{"location":"smash_product_pbwdeform_lie/#All-PBW-deformations","page":"PBWDeformations","title":"All PBW deformations","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"pbwdeforms_all","category":"page"},{"location":"smash_product_pbwdeform_lie/#PBWDeformations.pbwdeforms_all","page":"PBWDeformations","title":"PBWDeformations.pbwdeforms_all","text":"pbwdeforms_all(sp::SmashProductLie{C}, deform_basis::DeformBasis{C}; special_return=Nothing) where {C <: RingElement}\n\nComputes a basis of all Poincare-Birkhoff-Witt deformations of sp. deform_basis specifies the basis to use for the space of deformation maps. If special_return is SparseArrays.SparseMatrixCSC, the function returns intermediate results.\n\nUses pbwdeform_eqs and thus Theorem 3.1 of Chelsea Walton, Sarah Witherspoon (2014).\n\n\n\n\n\npbwdeforms_all(sp::SmashProductLie{C}, degs::AbstractVector{Int}, DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C}; special_return=Nothing) where {C <: RingElement}\n\nComputes a basis of all Poincare-Birkhoff-Witt deformations of sp of degrees degs. DeformBasisType specifies the type of basis to use for the space of deformation maps. If special_return is SparseArrays.SparseMatrixCSC, the function returns intermediate results.\n\nUses pbwdeform_eqs and thus Theorem 3.1 of Chelsea Walton, Sarah Witherspoon (2014).\n\n\n\n\n\npbwdeforms_all(sp::SmashProductLie{C}, deg::Int, DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C}; special_return=Nothing) where {C <: RingElement}\n\nThe same as the other method, but only for a single degree deg.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_pbwdeform_lie/#Bases-of-deformation-map-spaces","page":"PBWDeformations","title":"Bases of deformation map spaces","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"DeformBasis","category":"page"},{"location":"smash_product_pbwdeform_lie/#PBWDeformations.DeformBasis","page":"PBWDeformations","title":"PBWDeformations.DeformBasis","text":"abstract type DeformBasis{C <: RingElement} end\n\nA basis for a deformation map space of a Lie algebra smash product. The constructor of a subtype should accept a SmashProductLie and an AbstractVector{Int} of degrees. It is required that Base.length and Base.iterate are implemented for subtypes, where iterating yields objects of type DeformationMap{C}.\n\nFor a reference implementation, we refer to StdDeformBasis.\n\n\n\n\n\n","category":"type"},{"location":"smash_product_pbwdeform_lie/#Standard-basis","page":"PBWDeformations","title":"Standard basis","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"StdDeformBasis","category":"page"},{"location":"smash_product_pbwdeform_lie/#PBWDeformations.StdDeformBasis","page":"PBWDeformations","title":"PBWDeformations.StdDeformBasis","text":"Concrete subtype of DeformBasis that implements the standard basis. Each element of the basis is a skew-symmetric matrix with 2 non-zero entries, where one entry is a pure tensor power of degree ∈ degs over the Lie algebra part of the smash product, and the other entry is its additive inverse.\n\n\n\n\n\n","category":"type"},{"location":"smash_product_pbwdeform_lie/#Other-bases","page":"PBWDeformations","title":"Other bases","text":"","category":"section"},{"location":"smash_product_pbwdeform_lie/","page":"PBWDeformations","title":"PBWDeformations","text":"Please refer to Arc diagram induced bases and Pseudograph induced bases for more specialized bases.","category":"page"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"CurrentModule = PBWDeformations\nDocTestSetup  = quote\n    using PBWDeformations\n    using Oscar\nend","category":"page"},{"location":"smash_product_lie/#Smash-products","page":"Smash products","title":"Smash products","text":"","category":"section"},{"location":"smash_product_lie/#Constructors","page":"Smash products","title":"Constructors","text":"","category":"section"},{"location":"smash_product_lie/#General-case","page":"Smash products","title":"General case","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"smash_product_lie","category":"page"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie","page":"Smash products","title":"PBWDeformations.smash_product_lie","text":"smash_product_lie(coeff_ring::Ring, symbL::Vector{Symbol}, symbV::Vector{Symbol}, struct_const_L, struct_const_V)\n\nConstructs the smash product over the coefficient ring coeff_ring using the structure constants struct_const_L and struct_const_V, and using symbL and symbV as symbols for the respective generators of the Lie algebra and the module.\n\nReturns a SmashProductLie struct and a two-part basis.\n\n\n\n\n\nsmash_product_lie(coeff_ring::Ring, symbL::Vector{String}, symbV::Vector{String}, struct_const_L, struct_const_V)\n\nThe same as the other method with structure constants, but takes strings instead of symbols to name the generators.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#Highest-weight-/-GAP-case","page":"Smash products","title":"Highest weight / GAP case","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"smash_product_lie_highest_weight","category":"page"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_highest_weight","page":"Smash products","title":"PBWDeformations.smash_product_lie_highest_weight","text":"smash_product_lie_highest_weight(coeff_ring::Ring, dynkin::Char, n::Int, lambda::Vector{Int})\n\nConstructs the smash product of the abstract semisimple Lie algebra given by dynkin and n and the highest weight module with weight lambda over the coefficient ring coeff_ring.\n\nExample\n\njulia> smash_product_lie_highest_weight(QQ, 'A', 1, [1])\n(Lie Algebra Smash Product with basis x_1, x_2, x_3, v_1, v_2 over Rational Field, (QuadraticQuoAlgebraElem{fmpq}[x_1, x_2, x_3], QuadraticQuoAlgebraElem{fmpq}[v_1, v_2]))\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#Constructive-cases","page":"Smash products","title":"Constructive cases","text":"","category":"section"},{"location":"smash_product_lie/#\\mathfrak{so}_n-–-orthogonal-Lie-algebra","page":"Smash products","title":"mathfrakso_n – orthogonal Lie algebra","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"For the orthogonal Lie algebras mathfrakso_n there is a different constructor, that results in the well-known basis of mathfrakso_n given by x_i_j = E_ij - E_ji for 1 leq i  j leq n. See liealgebra_so_basis.","category":"page"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"smash_product_lie_so_fundamental_module\nsmash_product_lie_so_symmpowers_standard_module\nsmash_product_lie_so_extpowers_standard_module","category":"page"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_so_fundamental_module","page":"Smash products","title":"PBWDeformations.smash_product_lie_so_fundamental_module","text":"smash_product_lie_so_fundamental_module(coeff_ring::Ring, n::Int, e::Int)\n\nConstructs the smash product of the Lie algebra mathfrakso_n and the e-th fundamental module over the coefficient ring coeff_ring.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_so_symmpowers_standard_module","page":"Smash products","title":"PBWDeformations.smash_product_lie_so_symmpowers_standard_module","text":"smash_product_lie_so_symmpowers_fundamental_module(coeff_ring::Ring, n::Int, e::Int)\n\nConstructs the smash product of the Lie algebra mathfrakso_n and the e-th symmetric power of the fundamental module over the coefficient ring coeff_ring.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_so_extpowers_standard_module","page":"Smash products","title":"PBWDeformations.smash_product_lie_so_extpowers_standard_module","text":"smash_product_lie_so_extpowers_standard_module(coeff_ring::Ring, n::Int, e::Int)\n\nConstructs the smash product of the Lie algebra mathfrakso_n and the e-th exterior power of the fundamental module over the coefficient ring coeff_ring.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#\\mathfrak{sp}_{2n}-–-symplectic-Lie-algebra","page":"Smash products","title":"mathfraksp_2n – symplectic Lie algebra","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"For more details about the basis used for mathfraksp_2n, refer to liealgebra_sp_basis.","category":"page"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"smash_product_lie_sp_symmpowers_standard_module\nsmash_product_lie_sp_extpowers_standard_module","category":"page"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_sp_symmpowers_standard_module","page":"Smash products","title":"PBWDeformations.smash_product_lie_sp_symmpowers_standard_module","text":"smash_product_lie_sp_symmpowers_standard_module(coeff_ring::Ring, n::Int, e::Int)\n\nConstructs the smash product of the Lie algebra mathfraksp_2n and the e-th symmetric power of the standard module over the coefficient ring coeff_ring.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#PBWDeformations.smash_product_lie_sp_extpowers_standard_module","page":"Smash products","title":"PBWDeformations.smash_product_lie_sp_extpowers_standard_module","text":"smash_product_lie_sp_extpowers_standard_module(coeff_ring::Ring, n::Int, e::Int)\n\nConstructs the smash product of the Lie algebra mathfraksp_2n and the e-th exterior power of the fundamental module over the coefficient ring coeff_ring.\n\n\n\n\n\n","category":"function"},{"location":"smash_product_lie/#SmashProductLie-struct","page":"Smash products","title":"SmashProductLie struct","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"SmashProductLie\nSmashProductLieInfo","category":"page"},{"location":"smash_product_lie/#PBWDeformations.SmashProductLie","page":"Smash products","title":"PBWDeformations.SmashProductLie","text":"The struct representing a Lie algebra smash product. It consists of the underlying QuadraticQuoAlgebra and some metadata. It gets created by calling smash_product_lie.\n\n\n\n\n\n","category":"type"},{"location":"smash_product_lie/#PBWDeformations.SmashProductLieInfo","page":"Smash products","title":"PBWDeformations.SmashProductLieInfo","text":"A struct containing additional information about a Lie algebra smash product. Every field can be set to nothing if it is unknown.\n\nName Type Description\ndynkin Char? the family of the dynkin type of the Lie algebra\nn Int? the n of the dynkin type of the Lie algebra\nlambda Vector{Int}? highest weight vector of the module, only existing if the module is simple\nconstructive_basis Bool true if the used basis for the structure constants is known in terms of matrices\npower_of_std_mod Int? if the module is a power of the standard module, positive = symmetric power, negative = exterior power\n\n\n\n\n\n","category":"type"},{"location":"smash_product_lie/#Functions","page":"Smash products","title":"Functions","text":"","category":"section"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"The SmashProductLie struct can be used as an argument for the following functions:","category":"page"},{"location":"smash_product_lie/","page":"Smash products","title":"Smash products","text":"gens\nngens\nchange_base_ring","category":"page"}]
}
