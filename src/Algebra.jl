abstract type Algebra{C} <: NCRing end
abstract type AlgebraElem{C} <: NCRingElem end

parent(a::AlgebraElem{C}) where {C <: RingElement} = a.parent

base_ring(A::Algebra{C}) where {C <: RingElement} = A.base_ring::parent_type(C)

base_ring(a::AlgebraElem{C}) where {C <: RingElement} = base_ring(parent(a))

coefficient_ring(A::Algebra{C}) where {C <: RingElement} = A.base_ring::parent_type(C)

coefficient_ring(a::AlgebraElem{C}) where {C <: RingElement} = coefficient_ring(parent(a))

parent_type(a::AlgebraElem{C}) where {C <: RingElement} = parent_type(typeof(a))

elem_type(A::Algebra{C}) where {C <: RingElement} = elem_type(typeof(A))

symbols(A::Algebra) = A.S

ngens(A::Algebra) = A.num_gens

function gen(A::Algebra{C}, i::Int) where {C <: RingElement}
    1 <= i <= A.num_gens || throw(ArgumentError("Invalid generator index `i`."))
    return elem_type(A)(A, [one(A.base_ring)], [[i]])
end

function gens(A::Algebra{C}) where {C <: RingElement}
    return [gen(A, i) for i in 1:A.num_gens]
end

# variables actually occuring in a.
function vars(a::AlgebraElem{C}) where {C <: RingElement}
    return [gen(parent(a), i) for i in var_ids(a)]
end

function var_ids(a::AlgebraElem{C}) where {C <: RingElement}
    return sort!(unique!(flatten(a.monoms)))
end

function check_parent(a1::AlgebraElem{C}, a2::AlgebraElem{C}, throw::Bool=true) where {C <: RingElement}
    b = parent(a1) !== parent(a2)
    b & throw && error("Incompatible quadratic algebra elements")
    return !b
end

# TODO: monomial vector manipulation

function coeff(a::AlgebraElem, i::Int)
    return a.coeffs[i]
end

function coeff(a::AlgebraElem{C}, m::Vector{Int}) where {C <: RingElement}
    i = get_index(a, m)
    return isnothing(i) ? zero(C) : a.coeffs[i]
end

function coeff(a::AlgebraElem{C}, m::AlgebraElem{C}) where {C <: RingElement}
    is_monomial(m) || throw(ArgumentError("`m` needs to be a monomial"))
    return coeff(a, m.monoms[1])
end

# TODO: setcoeff!

function get_index(a::AlgebraElem{C}, m::Vector{Int}) where {C <: RingElement}
    return findfirst(x -> x == m, a.monoms)
end

function Base.hash(a::AlgebraElem{C}, h::UInt) where {C <: RingElement}
    b1 = 0x39fec7cd66dff6b4 % UInt
    b2 = 0x1e9a94f334b676fc % UInt
    h1 = xor(h, b1)
    h2 = xor(h, b2)

    p = sortperm(a.monoms)

    for i in 1:length(a)
        h1 = hash(a.coeffs[p[i]], h1)
        h2 = hash(a.monoms[p[i]], h2)
    end

    return xor(h1, h2)
end

# TODO function is_unit(a::AlgebraElem{C}) where C <: RingElement

function monomial(a::AlgebraElem, i::Int)
    R = base_ring(a)
    return parent(a)([one(R)], [a.monoms[i]])
end

# TODO monomial!

function term(a::AlgebraElem, i::Int)
    return parent(a)([deepcopy(a.coeffs[i])], [a.monoms[i]])
end

function length(a::AlgebraElem)
    return a.length
end

function zero(A::Algebra{C}) where {C <: RingElement}
    return A()
end

function zero(a::AlgebraElem)
    return zero(parent(a))
end

function one(A::Algebra{C}) where {C <: RingElement}
    return A(one(A.base_ring))
end

function one(a::AlgebraElem)
    return one(parent(a))
end

function canonical_unit(a::AlgebraElem{C}) where {C <: RingElement}
    if iszero(a)
        return one(parent(a))
    end
    ind = argmin(a.monoms[1:length(a)])
    return canonical_unit(a.coeffs[ind])
end

function show(io::IO, A::Algebra)
    local max_gens = 5 # largest number of generators to print
    n = A.num_gens
    print(io, showname(typeof(A)) * " with ")
    if n > max_gens
        print(io, A.num_gens)
        print(io, " generators ")
    end
    for i in 1:min(n - 1, max_gens - 1)
        print(io, string(A.S[i]), ", ")
    end
    if n > max_gens
        print(io, "..., ")
    end
    print(io, string(A.S[n]))
    print(io, " over ")
    print(IOContext(io, :compact => true), base_ring(A))
end

function show(io::IO, a::AlgebraElem{C}) where {C <: RingElement}
    if iszero(a)
        print(io, "0")
    else
        S = parent(a).S
        for i in 1:length(a)
            if i > 1
                print(io, " + ")
            end
            if isempty(a.monoms[i])
                print(io, a.coeffs[i])
            else
                if !isone(a.coeffs[i])
                    print(io, a.coeffs[i])
                    print(io, "*")
                end
                g = groupBy(a.monoms[i])
                for (j, s) in enumerate(g)
                    if j > 1
                        print(io, "*")
                    end
                    print(io, S[s[1]])
                    if length(s) > 1
                        print(io, "^")
                        print(io, length(s))
                    end
                end
            end
        end
    end
end


###############################################################################
#
#   Comparison functions
#
###############################################################################

Base.:(==)(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement} = isequal(a, b)

function Base.isequal(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement}
    check_parent(a, b, false) || return false
    return iszero(a - b)
end

Base.:(==)(n::Union{Integer, Rational, AbstractFloat}, a::AlgebraElem) = isequal(a, n)
Base.isequal(n::Union{Integer, Rational, AbstractFloat}, a::AlgebraElem) = isequal(a, n)
Base.:(==)(a::AlgebraElem, n::Union{Integer, Rational, AbstractFloat}) = isequal(a, n)

function Base.isequal(a::AlgebraElem, n::Union{Integer, Rational, AbstractFloat})
    return iszero(a - parent(a)(n))
end

Base.:(==)(n::C, a::AlgebraElem{C}) where {C <: RingElem} = isequal(a, n)
Base.:isequal(n::C, a::AlgebraElem{C}) where {C <: RingElem} = isequal(a, n)
Base.:(==)(a::AlgebraElem{C}, n::C) where {C <: RingElem} = isequal(a, n)

function Base.isequal(a::AlgebraElem{C}, n::C) where {C <: RingElem}
    return iszero(a - parent(a)(n))
end


###############################################################################
#
#   Arithmetic functions
#
###############################################################################

function Base.:-(a::AlgebraElem{C}) where {C <: RingElement}
    r = zero(a)
    fit!(r, length(a))
    for i in 1:length(a)
        r.coeffs[i] = -a.coeffs[i]
        r.monoms = deepcopy(a.monoms)
    end
    return r
end


function Base.:+(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement}
    check_parent(a, b)
    r = deepcopy(a)
    for i in 1:length(b)
        j = get_index(a, b.monoms[i])
        if isnothing(j)
            fit!(r, length(r) + 1)
            r.coeffs[end] = deepcopy(b.coeffs[i])
            r.monoms[end] = deepcopy(b.monoms[i])
        else
            r.coeffs[j] += b.coeffs[i]
        end
    end
    zeroinds = findall(iszero, r.coeffs)
    deleteat!(r.coeffs, zeroinds)
    deleteat!(r.monoms, zeroinds)
    r.length -= length(zeroinds)
    return r
end

function Base.:+(a::AlgebraElem{C1}, b::C2) where {C1 <: RingElement, C2 <: RingElement}
    r = deepcopy(a)
    j = get_index(a, Int[])
    if isnothing(j)
        fit!(r, length(r) + 1)
        r.coeffs[end] = deepcopy(b)
        r.monoms[end] = deepcopy(Int[])
    else
        r.coeffs[j] += b
    end
    zeroinds = findall(iszero, r.coeffs)
    deleteat!(r.coeffs, zeroinds)
    deleteat!(r.monoms, zeroinds)
    r.length -= length(zeroinds)
    return r
end

function Base.:+(a::C1, b::AlgebraElem{C2}) where {C1 <: RingElement, C2 <: RingElement}
    return b + a
end


function Base.:-(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement}
    check_parent(a, b)
    r = deepcopy(a)
    for i in 1:length(b)
        j = get_index(a, b.monoms[i])
        if isnothing(j)
            fit!(r, length(r) + 1)
            r.coeffs[end] = -b.coeffs[i]
            r.monoms[end] = deepcopy(b.monoms[i])
        else
            r.coeffs[j] -= b.coeffs[i]
        end
    end
    zeroinds = findall(iszero, r.coeffs)
    deleteat!(r.coeffs, zeroinds)
    deleteat!(r.monoms, zeroinds)
    r.length -= length(zeroinds)
    return r
end


function Base.:*(c::C, a::AlgebraElem{C}) where {C <: RingElem}
    parent(c) === base_ring(a) || throw(ArgumentError("Incompatible coefficient rings"))
    r = zero(a)
    if !iszero(c)
        fit!(r, length(a))
        for i in 1:length(a)
            r.coeffs[i] = c * a.coeffs[i]
            r.monoms = deepcopy(a.monoms)
        end
        zeroinds = findall(iszero, r.coeffs)
        deleteat!(r.coeffs, zeroinds)
        deleteat!(r.monoms, zeroinds)
        r.length -= length(zeroinds)
    end
    return r
end

function Base.:*(c::C, a::AlgebraElem) where {C <: RingElement}
    r = zero(a)
    if !iszero(c)
        fit!(r, length(a))
        for i in 1:length(a)
            r.coeffs[i] = c * a.coeffs[i]
            r.monoms = deepcopy(a.monoms)
        end
        zeroinds = findall(iszero, r.coeffs)
        deleteat!(r.coeffs, zeroinds)
        deleteat!(r.monoms, zeroinds)
        r.length -= length(zeroinds)
    end
    return r
end

function Base.:*(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement}
    check_parent(a, b)
    r = zero(a)
    for i in 1:length(a), j in 1:length(b)
        c = a.coeffs[i] * b.coeffs[j]
        if !iszero(c)
            m = [a.monoms[i]; b.monoms[j]]

            k = get_index(r, m)
            if isnothing(k)
                fit!(r, length(r) + 1)
                r.coeffs[end] = c
                r.monoms[end] = m
            else
                r.coeffs[k] += c
            end
        end
    end
    zeroinds = findall(iszero, r.coeffs)
    deleteat!(r.coeffs, zeroinds)
    deleteat!(r.monoms, zeroinds)
    r.length -= length(zeroinds)
    return r
end


function Base.:^(a::AlgebraElem{C}, n::Int) where {C <: RingElement}
    n >= 0 || throw(DomainError(n, "The exponent needs to be nonnegative."))

    r = one(a)
    while n > 0
        if !iszero(n & 1)
            r = r * a
        end
        n >>= 1
        a = a * a
    end
    zeroinds = findall(iszero, r.coeffs)
    deleteat!(r.coeffs, zeroinds)
    deleteat!(r.monoms, zeroinds)
    r.length -= length(zeroinds)
    return r
end


function comm(a::AlgebraElem{C}, b::AlgebraElem{C}) where {C <: RingElement}
    return a * b - b * a
end

function divexact(a::AlgebraElem{C}, c::C) where {C <: RingElement}
    a = deepcopy(a)
    for i in 1:length(a)
        a.coeffs[i] = divexact(a.coeffs[i], c)
    end
    a
end

###############################################################################
#
#   Unsafe functions
#
###############################################################################

## TODO: continue

function fit!(a::AlgebraElem{C}, n::Int) where {C <: RingElement}
    if length(a) < n
        resize!(a.coeffs, n)
        resize!(a.monoms, n)
        a.length = n
    end
    return nothing
end

## TODO: continue

###############################################################################
#
#   Parent object call overload
#
###############################################################################

function (A::Algebra{C})(c::Vector{C}, m::Vector{Vector{Int}}) where {C <: RingElement}
    return elem_type(A)(A, c, m)
end

function (A::Algebra{C})(b::RingElement) where {C <: RingElement}
    return A(base_ring(A)(b))
end

function (A::Algebra{C})() where {C <: RingElement}
    return elem_type(A)(A)
end

function (A::Algebra{C})(b::Union{Integer, Rational, AbstractFloat}) where {C <: RingElement}
    return iszero(b) ? A() : elem_type(A)(A, base_ring(A)(b))
end

function (A::Algebra{C})(b::C) where {C <: RingElement}
    parent(b) === base_ring(A) || throw(ArgumentError("Non-matching base rings"))
    return elem_type(A)(A, b)
end

function (A::Algebra{C})(b::AlgebraElem{C}) where {C <: RingElement}
    parent(b) === A || throw(ArgumentError("Non-matching algebras"))
    return b
end
