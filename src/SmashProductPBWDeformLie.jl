"""
    pbwdeform_eqs(deform::SmashProductDeformLie{C}; disabled::Vector{Symbol}=Symbol[]) where {C <: RingElement}

Returns the equations for `deform` being a PBW deformation of a smash product as
in Theorem 3.1 of [WW14](@cite).
Subsets of the equations can be disabled by passing the corresponding symbols as
keyword arguments, e.g. `disabled = [:c, :d]`.
"""
function pbwdeform_eqs(deform::SmashProductDeformLie{C}; disabled::Vector{Symbol}=Symbol[]) where {C <: RingElement}
    # Uses Theorem 3.1 of Walton, Witherspoon: Poincare-Birkhoff-Witt deformations of smash product algebras from Hopf actions on Koszul algebras.
    # DOI:	10.2140/ant.2014.8.1701. https://arxiv.org/abs/1308.6011
    dimL = deform.dimL
    dimV = deform.dimV
    kappa = deform.kappa
    x(i) = gen(deform.alg, i)
    v(i) = gen(deform.alg, dimL + i)

    ## (a) κ is H-invariant
    iter_a =
        :a in disabled ? [] :
        (
            comm(comm(h, v(i); strict=true), v(j)) # κ([h⋅v_i,v_j])
            + comm(v(i), comm(h, v(j); strict=true)) # κ([v_i,h⋅v_j])
            - comm(h, comm(v(i), v(j); strict=true)) # h⋅κ([v_i,v_j])
            for (h, (i, j)) in Iterators.product([x(i) for i in 1:dimL], Combinatorics.Combinations(dimV, 2))
        )

    ## (b) trivial
    iter_b = :b in disabled ? [] : []

    ## (c) 0 = κ ⊗ id - id ⊗ κ on (I ⊗ V) ∩ (V ⊗ I)
    # (I ⊗ V) ∩ (V ⊗ I) has basis v_iv_jv_k + v_jv_kv_i + v_kv_iv_j - v_kv_jv_i - v_jv_iv_k - v_iv_kv_j for i<j<k
    iter_c =
        :c in disabled ? [] :
        (
            comm(v(i), v(j); strict=true) * v(k) - v(i) * comm(v(j), v(k); strict=true) +
            comm(v(j), v(k); strict=true) * v(i) - v(j) * comm(v(k), v(i); strict=true) +
            comm(v(k), v(i); strict=true) * v(j) - v(k) * comm(v(i), v(j); strict=true) -
            comm(v(k), v(j); strict=true) * v(i) + v(k) * comm(v(j), v(i); strict=true) -
            comm(v(j), v(i); strict=true) * v(k) + v(j) * comm(v(i), v(k); strict=true) -
            comm(v(i), v(k); strict=true) * v(j) + v(i) * comm(v(k), v(j); strict=true) for
            (i, j, k) in Combinatorics.Combinations(dimV, 3)
        )

    ## (d) trivial
    iter_d = :d in disabled ? [] : []

    iter = Iterators.flatten([iter_a, iter_b, iter_c, iter_d])
    return Iterators.map(normal_form, iter)
end

function pbwdeform_neqs(deform::SmashProductDeformLie{C}) where {C <: RingElement}
    num_a = deform.dimL * binomial(deform.dimV, 2)
    num_b = 0
    num_c = binomial(deform.dimV, 3)
    num_d = 0

    return num_a + num_b + num_c + num_d
end

"""
    is_pbwdeform(d::SmashProductDeformLie{C}) where {C <: RingElement}

Check if `d` is a Poincare-Birkhoff-Witt deformation of a smash product.
Uses Theorem 3.1 of [WW14](@cite).
"""
function is_pbwdeform(d::SmashProductDeformLie{C}) where {C <: RingElement}
    return all(iszero, pbwdeform_eqs(d))
end


###############################################################################
#
#   All PBW deformations
#
###############################################################################

@inline function coefficient_comparison(eq::AlgebraElem{C}) where {C <: RingElement}
    return eq.coeffs
end

@inline function linpoly_to_spvector(a::fmpq_mpoly, var_lookup::Dict{fmpq_mpoly, Int}, nvars::Int)
    @assert total_degree(a) <= 1

    return sparsevec(Dict(var_lookup[monomial(a, i)] => coeff(a, i) for i in 1:length(a)), nvars)
end

function reduce_and_store!(
    lgs::Vector{Union{Nothing, SparseVector{T, Int}}},
    v::SparseVector{T, Int},
) where {T <: Union{RingElement, Number}}
    while count(!iszero, v) > 0
        nz_inds, nz_vals = findnz(v)

        if !isone(nz_vals[1])
            v = inv(nz_vals[1]) .* v
        end

        if lgs[nz_inds[1]] === nothing
            lgs[nz_inds[1]] = v
            return
        else
            v -= lgs[nz_inds[1]]
        end
    end
end

function reduced_row_echelon!(lgs::Vector{Union{Nothing, SparseVector{T, Int}}}) where {T <: Union{RingElement, Number}}
    for i in length(lgs):-1:1
        if lgs[i] === nothing
            continue
        end
        nz_inds, nz_vals = findnz(lgs[i])
        for (ind, j) in enumerate(nz_inds[2:end])
            if lgs[j] !== nothing
                lgs[i] -= nz_vals[ind+1] .* lgs[j]
            end
        end
    end
    return lgs
end

function lgs_to_mat(lgs::Vector{Union{Nothing, SparseVector{T, Int}}}) where {T <: Union{RingElement, Number}}
    n = length(lgs)
    mat = spzeros(T, n, n)
    for i in 1:n
        if lgs[i] !== nothing
            mat[i, :] = lgs[i]
        end
    end
    return mat
end

function indices_of_freedom(mat::SparseArrays.SparseMatrixCSC{T, Int}) where {T <: Union{RingElement, Number}}
    size(mat)[1] == size(mat)[2] || throw(ArgumentError("Matrix needs to be square."))
    return filter(i -> iszero(mat[i, i]), 1:size(mat)[1])
end


"""
    pbwdeforms_all(sp::SmashProductLie{C}, deform_basis::DeformBasis{C}; special_return=Nothing) where {C <: RingElement}

Computes a basis of all Poincare-Birkhoff-Witt deformations of `sp`.
`deform_basis` specifies the basis to use for the space of deformation maps.
If `special_return` is `SparseArrays.SparseMatrixCSC`, the function returns intermediate results.

Uses [`pbwdeform_eqs`](@ref) and thus Theorem 3.1 of [WW14](@cite).
"""
function pbwdeforms_all(
    sp::SmashProductLie{C},
    deform_basis::DeformBasis{C};
    special_return::Type{T}=Nothing,
) where {C <: RingElement, T <: Union{Nothing, SparseMatrixCSC}}
    dimL = sp.dimL
    dimV = sp.dimV

    nvars = length(deform_basis)

    @info "Constructing MPolyRing..."
    R, vars = PolynomialRing(sp.coeff_ring, max(nvars, 1))
    var_lookup = Dict(vars[i] => i for i in 1:nvars)

    @info "Changing SmashProductLie coeffcient type..."
    new_sp = change_base_ring(R, sp)

    @info "Constructing kappa..."
    kappa = fill(new_sp.alg(0), dimV, dimV)
    for (i, b) in enumerate(deform_basis)
        kappa += vars[i] .* new_sp.alg.(b)
    end

    @info "Constructing deformation..."
    deform = smash_product_deform_lie(new_sp, kappa)[1]

    @info "Generating equation iterator..."
    neqs = pbwdeform_neqs(deform)
    iter = Iterators.map(
        a -> linpoly_to_spvector(a, var_lookup, nvars),
        Iterators.flatten(
            Iterators.map(
                function (x)
                    i = x[1]
                    a = x[2]
                    @debug "Equation $i/$(neqs), $(floor(Int, 100*i / neqs))%"
                    coefficient_comparison(a)
                end,
                enumerate(pbwdeform_eqs(deform)),
            ),
        ),
    )

    @info "Computing row-echelon form..."
    lgs = Vector{Union{Nothing, SparseVector{fmpq, Int}}}(nothing, nvars)
    for v in iter
        reduce_and_store!(lgs, v)
    end

    @info "Computing reduced row-echelon form..."
    reduced_row_echelon!(lgs)

    mat = lgs_to_mat(lgs)

    if special_return === SparseMatrixCSC
        return mat, vars
    end

    @info "Computing a basis..."
    freedom_ind = indices_of_freedom(mat)
    freedom_deg = length(freedom_ind)
    kappas = Vector{DeformationMap{C}}(undef, freedom_deg)
    for l in 1:freedom_deg
        kappas[l] = fill(sp.alg(0), dimV, dimV)
    end
    if freedom_deg > 0
        for (i, b) in enumerate(deform_basis)
            if iszero(mat[i, i])
                l = findfirst(isequal(i), freedom_ind)
                kappas[l] += b
            else
                for j in i+1:nvars
                    if !iszero(mat[i, j])
                        l = findfirst(isequal(j), freedom_ind)
                        kappas[l] += -mat[i, j] .* b
                    end
                end
            end
        end
    end
    return kappas
end

"""
    pbwdeforms_all(sp::SmashProductLie{C}, degs::AbstractVector{Int}, DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C}; special_return=Nothing) where {C <: RingElement}

Computes a basis of all Poincare-Birkhoff-Witt deformations of `sp` of degrees `degs`.
`DeformBasisType` specifies the type of basis to use for the space of deformation maps.
If `special_return` is `SparseArrays.SparseMatrixCSC`, the function returns intermediate results.

Uses [`pbwdeform_eqs`](@ref) and thus Theorem 3.1 of [WW14](@cite).
"""
function pbwdeforms_all(
    sp::SmashProductLie{C},
    degs::AbstractVector{Int},
    DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C};
    special_return::Type{T}=Nothing,
) where {C <: RingElement, T <: Union{Nothing, SparseMatrixCSC}}
    @info "Computing Deform Basis"
    deform_basis = DeformBasisType(sp, degs)
    return pbwdeforms_all(sp, deform_basis; special_return)
end

"""
    pbwdeforms_all(sp::SmashProductLie{C}, deg::Int, DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C}; special_return=Nothing) where {C <: RingElement}

The same as the other method, but only for a single degree `deg`.
"""
function pbwdeforms_all(
    sp::SmashProductLie{C},
    deg::Int,
    DeformBasisType::Type{<:DeformBasis{C}}=StdDeformBasis{C};
    special_return::Type{T}=Nothing,
) where {C <: RingElement, T <: Union{Nothing, SparseMatrixCSC}}
    return pbwdeforms_all(sp, [deg], DeformBasisType; special_return)
end
