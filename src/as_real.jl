@concrete struct AsReal <: Real
    val
end
AsReal{T}(val) where {T} = AsReal(T(val))
# AsReal{T}(val::AsReal{T}) where {T} = AsReal(T(val.val))

const ℝ = AsReal

as_real(x::Real) = x
as_real(x) = AsReal(x)

for op in [+, -, inv, zero, sign, sqrt, deg2rad, rad2deg, abs, abs2, sin, cos, tan, sind, cosd, tand, sinh, cosh, tanh, asin, acos, atan, asind, acosd, atand, asinh, acosh, atanh, exp, exp2, exp10, log, log2, log10]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(x::ℝ) = ℝ($m.$f(x.val))
    end)
end

for op in [signbit, !]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(x::ℝ) = $m.$f(x.val)
    end)
end

for op in [+, -, *, /, //, ^, atan, atand, hypot, max, min,]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(a::ℝ, b::Number) = ℝ($m.$f(a.val, b))
        $m.$f(a::Number, b::ℝ) = ℝ($m.$f(a, b.val))
        $m.$f(a::ℝ, b::ℝ) = ℝ($m.$f(a.val, b.val))
    end)
end

for op in [+, -]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(a::ℝ, b::Complex) = Complex($m.$f(a, b.re), b.im)
        $m.$f(a::Complex, b::ℝ) = Complex($m.$f(a.re, b), a.im)
        $m.$f(a::ℝ, b::Complex{Bool}) = Complex($m.$f(a, b.re), b.im)
        $m.$f(a::Complex{Bool}, b::ℝ) = Complex($m.$f(a.re, b), a.im)
    end)
end

for op in [*, /, //]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(a::ℝ, b::Complex) = Complex($m.$f(a, b.re), $m.$f(a, b.im))
        $m.$f(a::Complex, b::ℝ) = Complex($m.$f(a.re, b), $m.$f(a.im, b))
        $m.$f(a::ℝ, b::Complex{Bool}) = Complex($m.$f(a, b.re), $m.$f(a, b.im))
        $m.$f(a::Complex{Bool}, b::ℝ) = Complex($m.$f(a.re, b), $m.$f(a.im, b))
    end)
end

for op in [==, <, >]
    f = nameof(op)
    m = Base.parentmodule(op)
    eval(quote
        $m.$f(a::ℝ, b::Number) = $m.$f(a.val, b)
        $m.$f(a::Number, b::ℝ) = $m.$f(a, b.val)
        $m.$f(a::ℝ, b::ℝ) = $m.$f(a.val, b.val)
    end)
end

Base.:(^)(a::ℝ, b::Integer) = ℝ(a.val^b)

Base.promote_rule(::Type{ℝ{T1}}, ::Type{T2}) where {T1,T2} = ℝ{promote_type(T1, T2)}
Base.promote_rule(::Type{ℝ{T1}}, ::Type{ℝ{T2}}) where {T1,T2} = ℝ{promote_type(T1, T2)}

Base.convert(::Type{ℝ{T1}}, x::T2) where {T1,T2<:Number} = promote_type(ℝ{T1}, T2)(x)
Base.convert(::Type{ℝ{T1}}, x::ℝ{T2}) where {T1,T2} = ℝ{promote_type(T1, T2)}(x.val)

Base.show(io::IO, x::ℝ) = print(io, "ℝ($(x.val))")
Base.show(io::IO, z::Complex{<:ℝ}) = print(io, "$(z.re) + $(z.im)im")