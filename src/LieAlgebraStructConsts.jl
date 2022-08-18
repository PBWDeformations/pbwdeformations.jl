###############################################################################
#
#       liealgebra_so, i.e. types B and D
#
###############################################################################

function liealgebra_so_basis(n::Int)
    return [(b = zeros(Int, n, n); b[i, j] = 1; b[j, i] = -1; b) for i in 1:n for j in i+1:n]
end

function liealgebra_so_symbols(n::Int)
    return ["x_$(i)_$(j)" for i in 1:n for j in i+1:n]
end

function liealgebra_so_struct_const(n::Int) # so_n
    dimL = div(n * (n - 1), 2)
    basisL = liealgebra_so_basis(n)

    struct_const_L = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimL)
    for i in 1:dimL, j in 1:dimL
        struct_const_L[i, j] = [
            (c, k) for
            (k, c) in enumerate(ur_proper_triag_entries(basisL[i] * basisL[j] - basisL[j] * basisL[i])) if !iszero(c)
        ]
    end

    return dimL, struct_const_L
end

function liealgebra_standard_module_so_basis(n::Int)
    return [std_basis(i, n) for i in 1:n]
end

function liealgebra_fundamental_module_so_symbols(n::Int, e::Int)
    return liealgebra_outpowers_standard_module_so_symbols(n, e)
end

function liealgebra_fundamental_module_so_struct_const(n::Int, e::Int)
    return liealgebra_outpowers_standard_module_so_struct_const(n, e)
end

function liealgebra_symmpowers_standard_module_so_symbols(n::Int, e::Int)
    return e == 1 ? ["v_$(i)" for i in 1:2n] :
           ["v_$(js)" for js in Combinatorics.with_replacement_combinations(1:2n, e)]
end

function liealgebra_symmpowers_standard_module_so_struct_const(n::Int, e::Int) # so_n, e-th symm power of the standard rep
    basisL = liealgebra_sp_basis(n)
    basis_standardV = liealgebra_standard_module_sp_basis(n)
    dimL = length(basisL)
    if e == 1
        dimV = n
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        for i in 1:dimL, j in 1:dimV
            struct_const_V[i, j] = [(c, k) for (k, c) in enumerate(basisL[i] * basis_standardV[j]) if !iszero(c)]
        end
    elseif e > 1
        dimV = binomial(e + n - 1, e)
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        index = Dict{Vector{Int}, Int}()
        for (j, js) in enumerate(Combinatorics.with_replacement_combinations(1:n, e))
            index[js] = j
        end
        for i in 1:dimL, js in Combinatorics.with_replacement_combinations(1:n, e)
            struct_const_V[i, index[js]] = [
                (c, index[sort([js[1:l-1]; k; js[l+1:end]])]) for l in 1:e for
                (k, c) in enumerate(basisL[i] * basis_standardV[js[l]]) if !iszero(c)
            ]
        end
    else
        error("non-negative power")
    end

    return dimV, struct_const_V
end

function liealgebra_outpowers_standard_module_so_symbols(n::Int, e::Int)
    return e == 1 ? ["v_$(i)" for i in 1:n] : ["v_$(js)" for js in Combinatorics.combinations(1:n, e)]
end

function liealgebra_outpowers_standard_module_so_struct_const(n::Int, e::Int) # so_n, e-th outer power of the standard rep
    basisL = liealgebra_so_basis(n)
    basis_standardV = liealgebra_standard_module_so_basis(n)
    dimL = length(basisL)
    if e == 1
        dimV = n
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        for i in 1:dimL, j in 1:dimV
            struct_const_V[i, j] = [(c, k) for (k, c) in enumerate(basisL[i] * basis_standardV[j]) if !iszero(c)]
        end
    elseif e > 1
        dimV = binomial(n, e)
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        index = Dict{Vector{Int}, Int}()
        for (j, js) in enumerate(Combinatorics.combinations(1:n, e))
            index[js] = j
        end
        for i in 1:dimL, js in Combinatorics.combinations(1:n, e)
            struct_const_V[i, index[js]] = [
                (levicivita(sortperm([js[1:l-1]; k; js[l+1:end]])) * c, index[sort([js[1:l-1]; k; js[l+1:end]])])
                for l in 1:e for (k, c) in enumerate(basisL[i] * basis_standardV[js[l]]) if
                !iszero(c) && allunique([js[1:l-1]; k; js[l+1:end]])
            ]
        end
    else
        error("non-negative power")
    end

    return dimV, struct_const_V
end


###############################################################################
#
#       liealgebra_sp, i.e. type C
#
###############################################################################

function liealgebra_sp_basis(n::Int)
    as = [(e = zeros(Int, 2n, 2n); e[i, i+n] = 1; e) for i in 1:n]
    bs = [(e = zeros(Int, 2n, 2n); e[i+n, i] = 1; e) for i in 1:n]
    cs = [(e = zeros(Int, 2n, 2n); e[i, j] = 1; e[j+n, i+n] = -1; e) for i in 1:n for j in i+1:n]
    ds = [(e = zeros(Int, 2n, 2n); e[j, i] = 1; e[i+n, j+n] = -1; e) for i in 1:n for j in i+1:n]
    fs = [(e = zeros(Int, 2n, 2n); e[i, j+n] = 1; e[j, i+n] = 1; e) for i in 1:n for j in i+1:n]
    gs = [(e = zeros(Int, 2n, 2n); e[i+n, j] = 1; e[j+n, i] = 1; e) for i in 1:n for j in i+1:n]
    hs = [(e = zeros(Int, 2n, 2n); e[i, i] = 1; e[i+n, i+n] = -1; e) for i in 1:n]
    return [as..., bs..., cs..., ds..., fs..., gs..., hs...]
end

function liealgebra_sp_symbols(n::Int)
    ["x_$(i)_$(j)" for i in 1:n for j in i+1:n]
    as = ["x_a_$(i)" for i in 1:n]
    bs = ["x_b_$(i)" for i in 1:n]
    cs = ["x_c_$(i)_$(j)" for i in 1:n for j in i+1:n]
    ds = ["x_d_$(i)_$(j)" for i in 1:n for j in i+1:n]
    fs = ["x_f_$(i)_$(j)" for i in 1:n for j in i+1:n]
    gs = ["x_g_$(i)_$(j)" for i in 1:n for j in i+1:n]
    hs = ["x_h_$(i)" for i in 1:n]
    return [as..., bs..., cs..., ds..., fs..., gs..., hs...]
end

function liealgebra_sp_struct_const(n::Int) # sp_2n
    dimL = 2 * n^2 + n
    basisL = liealgebra_sp_basis(n)

    struct_const_L = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimL)
    for i in 1:dimL, j in 1:dimL
        commutator = basisL[i] * basisL[j] - basisL[j] * basisL[i]

        struct_const_L[i, j] = []
        for (k, e) in enumerate(basisL)
            tmp = e .* commutator
            if !iszero(tmp)
                c = tmp[findfirst(x -> !iszero(x), tmp)]
                push!(struct_const_L[i, j], (c, k))
            end
        end
    end

    return dimL, struct_const_L
end

function liealgebra_standard_module_sp_basis(n::Int)
    return [std_basis(i, 2n) for i in 1:2n]
end

function liealgebra_symmpowers_standard_module_sp_symbols(n::Int, e::Int)
    return e == 1 ? ["v_$(i)" for i in 1:2n] :
           ["v_$(js)" for js in Combinatorics.with_replacement_combinations(1:2n, e)]
end

function liealgebra_symmpowers_standard_module_sp_struct_const(n::Int, e::Int) # sp_2n, e-th symm power of the standard rep
    basisL = liealgebra_sp_basis(n)
    basis_standardV = liealgebra_standard_module_sp_basis(n)
    dimL = length(basisL)
    if e == 1
        dimV = 2n
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        for i in 1:dimL, j in 1:dimV
            struct_const_V[i, j] = [(c, k) for (k, c) in enumerate(basisL[i] * basis_standardV[j]) if !iszero(c)]
        end
    elseif e > 1
        dimV = binomial(e + 2n - 1, e)
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        index = Dict{Vector{Int}, Int}()
        for (j, js) in enumerate(Combinatorics.with_replacement_combinations(1:2n, e))
            index[js] = j
        end
        for i in 1:dimL, js in Combinatorics.with_replacement_combinations(1:2n, e)
            struct_const_V[i, index[js]] = [
                (c, index[sort([js[1:l-1]; k; js[l+1:end]])]) for l in 1:e for
                (k, c) in enumerate(basisL[i] * basis_standardV[js[l]]) if !iszero(c)
            ]
        end
    else
        error("non-negative power")
    end

    return dimV, struct_const_V
end

function liealgebra_outpowers_standard_module_sp_symbols(n::Int, e::Int)
    return e == 1 ? ["v_$(i)" for i in 1:2n] : ["v_$(js)" for js in Combinatorics.combinations(1:2n, e)]
end

function liealgebra_outpowers_standard_module_sp_struct_const(n::Int, e::Int) # sp_2n, e-th outer power of the standard rep
    basisL = liealgebra_sp_basis(n)
    basis_standardV = liealgebra_standard_module_sp_basis(n)
    dimL = length(basisL)
    if e == 1
        dimV = 2n
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        for i in 1:dimL, j in 1:dimV
            struct_const_V[i, j] = [(c, k) for (k, c) in enumerate(basisL[i] * basis_standardV[j]) if !iszero(c)]
        end
    elseif e > 1
        dimV = binomial(2n, e)
        struct_const_V = Matrix{Vector{Tuple{Int, Int}}}(undef, dimL, dimV)
        index = Dict{Vector{Int}, Int}()
        for (j, js) in enumerate(Combinatorics.combinations(1:2n, e))
            index[js] = j
        end
        for i in 1:dimL, js in Combinatorics.combinations(1:2n, e)
            struct_const_V[i, index[js]] = [
                (levicivita(sortperm([js[1:l-1]; k; js[l+1:end]])) * c, index[sort([js[1:l-1]; k; js[l+1:end]])])
                for l in 1:e for (k, c) in enumerate(basisL[i] * basis_standardV[js[l]]) if
                !iszero(c) && allunique([js[1:l-1]; k; js[l+1:end]])
            ]
        end
    else
        error("non-negative power")
    end

    return dimV, struct_const_V
end