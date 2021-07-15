BasisIndex = Int64
Coefficient = Rational{Int64}
BasisElement = Tuple{Symbol, Int64}
Monomial{T} = Vector{T}
Scaled{T} = Tuple{Coefficient, T}
LinearCombination{T} = Vector{Scaled{T}}
AlgebraElement = LinearCombination{Monomial{BasisElement}}
StandardOperand = Union{BasisElement, Monomial{BasisElement}, Scaled{Monomial{BasisElement}}, AlgebraElement}

function monomials(a::AlgebraElement) :: Vector{Monomial{BasisElement}}
    return unique([mon for (coeff, mon) in a])
end

function basisElements(a::AlgebraElement) :: Vector{BasisElement}
    return unique(vcat(monomials(a)...))
end

function collectSummands(a::Union{AlgebraElement, Vector{AlgebraElement}}) :: AlgebraElement
    a = isa(a, AlgebraElement) ? a : AlgebraElement(vcat(a...))
    res = AlgebraElement()

    for (coeff, mon) in a
        i = findfirst(x -> x[2] == mon, res)

        if i === nothing
            push!(res, (coeff, mon))
        else
            res[i] = (res[i][1] + coeff, res[i][2])
        end
    end

    return filter(x -> !iszero(x[1]), res)
end

function sameSum(a1::StandardOperand, a2::StandardOperand) :: Bool
    return issetequal(collectSummands(algebraElement(a1)), collectSummands(algebraElement(a2)))
end


# emtpy list represents empty sum, which is 0
algebraElement() = AlgebraElement()
algebraElement(c::Union{Int64, Coefficient}) = iszero(c) ? AlgebraElement() : [(Coefficient(c), Monomial{BasisElement}())] :: AlgebraElement
algebraElement(b::BasisElement) = [(Coefficient(1), [b])] :: AlgebraElement
algebraElement(m::Monomial{BasisElement}) = [(Coefficient(1), m)] :: AlgebraElement
algebraElement(s::Scaled{Monomial{BasisElement}}) = [s] :: AlgebraElement
algebraElement(a::AlgebraElement) = a :: AlgebraElement


function Base.:(+)(x::Union{Int64, Coefficient, StandardOperand}, as::Vararg{StandardOperand}) :: AlgebraElement
    return collectSummands(map(algebraElement, [x, as...]))
end

function Base.:(+)(a::StandardOperand, c::Union{Int64, Coefficient}) :: AlgebraElement
    return c + a
end


function Base.:(*)(x::Union{BasisElement, Monomial{BasisElement}},
                   y::Union{BasisElement, Monomial{BasisElement}}) :: Monomial{BasisElement}
    return [x; y]
end

function Base.:(*)(c::Union{Int64, Coefficient}, a::StandardOperand) :: AlgebraElement
    return [(c*coeff, mon) for (coeff, mon) in algebraElement(a)]
end

function Base.:(*)(a::StandardOperand, c::Union{Int64, Coefficient}) :: AlgebraElement
    return c * a
end

function Base.:(*)(a1::Union{Scaled{Monomial{BasisElement}}, AlgebraElement},
                   a2::Union{Scaled{Monomial{BasisElement}}, AlgebraElement}) :: AlgebraElement
   return collectSummands([(c1*c2, [m1;m2]) for (c1, m1) in algebraElement(a1) for (c2, m2) in algebraElement(a2)])
end

function Base.:(*)(x::Union{Scaled{Monomial{BasisElement}}, AlgebraElement},
                   y::Union{BasisElement, Monomial{BasisElement}}) :: AlgebraElement
    return x * algebraElement(y)
end

function Base.:(*)(m::Union{BasisElement, Monomial{BasisElement}}, a::AlgebraElement) :: AlgebraElement
    return algebraElement(m) * a
end


function Base.:(^)(m::Union{BasisElement, Monomial{BasisElement}}, n::Int64) :: Monomial{BasisElement}
    @assert n >= 0
    return prod([m for _ in 1:n], init=Monomial{BasisElement}())
end

function Base.:(^)(a::Union{Scaled{Monomial{BasisElement}}, AlgebraElement}, n::Int64) :: AlgebraElement
    @assert n >= 0
    return prod([a for _ in 1:n], init=algebraElement(1))
end


function Base.:(-)(a::StandardOperand) :: AlgebraElement
    return (-1)*a
end

function Base.:(-)(x::Union{Int64, Coefficient, StandardOperand}, y::StandardOperand) :: AlgebraElement
    return x + (-y)
end

function Base.:(-)(a::StandardOperand, c::Union{Int64, Coefficient}) :: AlgebraElement
    return a + (-c)
end


comm(x, y) = x*y - y*x