module PBWDeformations

using Combinatorics
using Oscar
using SparseArrays

import AbstractAlgebra: NCRing, NCRingElem, Ring, RingElement,
                        base_ring, change_base_ring, check_parent, coeff,
                        elem_type, gen, gens, isgen, ismonomial,
                        monomial, ngens, parent_type, quo, symbols, vars

import Oscar: comm, normal_form

import Base: Array, deepcopy, deepcopy_internal,
             hash, isequal, isone, iszero, length,
             one, parent, show, xor, zero, +, -, *, ^, ==

export FreeAlgebra, FreeAlgebraElem,
       QuadraticQuoAlgebra, QuadraticQuoAlgebraElem,
       SmashProductLie, SmashProductDeformLie

export free_algebra, ispbwdeform, quadratic_quo_algebra,
       pbwdeforms_all, pbwdeform_eqs,
       smash_product_lie, smash_product_lie_so,
       smash_product_struct_const_from_gap, smash_product_struct_const_so,
       smash_product_deform_lie, smash_product_symmdeform_lie

GAP = Oscar.GAP

include("Util.jl")
include("Algebra.jl")
include("FreeAlgebra.jl")
include("QuadraticQuoAlgebra.jl")


function isvalidlie_for_gap(dynkin::Char, n::Int64)
    if dynkin == 'A'
        return n >= 1
    elseif dynkin == 'B'
        return n >= 2
    elseif dynkin == 'C'
        return n >= 2
    elseif dynkin == 'D'
        return n >= 4
    elseif dynkin == 'E'
        return 6 <= n <= 8
    elseif dynkin == 'F'
        return n == 4
    elseif dynkin == 'G'
        return n == 2
    else
        return false
    end
end

include("SmashProductLie.jl")
include("SmashProductDeformLie.jl")


end
