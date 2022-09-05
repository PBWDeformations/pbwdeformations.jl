module PBWDeformations

using Combinatorics
using Oscar
using SparseArrays

import AbstractAlgebra:
    NCRing,
    NCRingElem,
    Ring,
    RingElement,
    base_ring,
    canonical_unit,
    change_base_ring,
    check_parent,
    coeff,
    divexact,
    elem_type,
    gen,
    gens,
    is_gen,
    is_monomial,
    monomial,
    ngens,
    parent_type,
    quo,
    symbols,
    vars

import Oscar: comm, normal_form

import Base:
    Array,
    deepcopy,
    deepcopy_internal,
    hash,
    isequal,
    isone,
    iszero,
    length,
    one,
    parent,
    show,
    xor,
    zero,
    +,
    -,
    *,
    ^,
    ==

export FreeAlgebra,
    FreeAlgebraElem, QuadraticQuoAlgebra, QuadraticQuoAlgebraElem, SmashProductLie, SmashProductDeformLie

export free_algebra,
    is_pbwdeform,
    quadratic_quo_algebra,
    pbwdeforms_all,
    pbwdeform_eqs,
    smash_product_lie,
    smash_product_lie_highest_weight,
    smash_product_lie_so_fundamental_module,
    smash_product_lie_so_symmpowers_standard_module,
    smash_product_lie_so_extpowers_standard_module,
    smash_product_lie_sp_symmpowers_standard_module,
    smash_product_lie_sp_extpowers_standard_module,
    smash_product_deform_lie,
    smash_product_symmdeform_lie


GAP = Oscar.GAP


include("Util.jl")
include("LieAlgebraStructConsts.jl")
include("Algebra.jl")
include("FreeAlgebra.jl")
include("QuadraticQuoAlgebra.jl")
include("SmashProductLie.jl")
include("SmashProductDeformLie.jl")
include("ArcDiagram.jl")


end
