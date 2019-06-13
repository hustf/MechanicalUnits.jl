# The below is preliminary code. 
# TODO; Test, fix and improvefor a few units
# Then, write macros to bring in a set of prefixes and derived units.
module MechanicalUnits
export ∙
# Convenience / info / testing
export @u_str, uconvert, upreferred, basefactor, ustrip, unit, preferunits
# To shorten type signature ouput
export Time, Length, Mass, Temperature
export FreeUnits, AffineUnits, Unitlike, Unit, Quantity, Dimensions
# To shorten unit output, and enabling the same format in input
export m, m², m³, m⁴, s, s², s³, s⁴, kg, kg², kg³, kg⁴
export °C, °F
export Ra, Ra², Ra³, Ra⁴, K, K², K³, K⁴
export h, μm, minute
export h², μm², minute²
export h³, μm³, minute³
export h⁴, μm⁴, minute⁴
import Base:show
using InteractiveUtils
#using Formatting (or implement elsewhere....)
using Unitful
import Unitful: FreeUnits, AffineUnits, Unitlike, Unit, Quantity, Dimension, Dimensions
import Unitful: isunitless, unit, sortexp, showrep, abbr, prefix, power, superscript
# Convenience
import Unitful: uconvert, upreferred, basefactor, ustrip, preferunits
# temporary imports
#import Unitful: tens, dimension

# Time, length and mass (and their exponents) are of type Dimension. 
# Their symbols unfortunately can't be shown 
# in Windows terminals. We replace them, which 
# makes method signatures even longer. 
const global Time = Unitful.𝐓
const global Length = Unitful.𝐋
const global Mass = Unitful.𝐌
const global Temperature = Unitful.𝚯
# Most basic units
m = Unitful.m
s = Unitful.s
kg = Unitful.kg
# Special temperature units, 'Affine units'.
°C = Unitful.°C
°F = Unitful.°F
# Fahrenheit intervals, Kelvin
Ra = Unitful.Ra 
K = Unitful.K 
# Directly derived units
μm = Unitful.μm
minute = Unitful.minute

#h = Unitful.hr # Nah, redefine!
@unit h      "h"       hour      (3600//1)s false



# For all the exported units, we also need to understand superscripts 2 to 4, 
# as they appear in printed units and may be copied as inputs.
# Also including prefixes.

const global m² = m^2
const global m³ = m^3
const global m⁴ = m^4
const global s² = s^2
const global s³ = s^3
const global s⁴ = s^4
const global kg² = kg^2
const global kg³ = kg^3
const global kg⁴ = kg^4
const global Ra² = Ra^2
const global Ra³ = Ra^3
const global Ra⁴ = Ra^4
const global K² = K^2
const global K³ = K^3
const global K⁴ = K^4
const global h² = h^2
const global h³ = h^3
const global h⁴ = h^4
const global μm² = μm^2
const global μm³ = μm^3
const global μm⁴ = μm^4
const global minute² = minute^2
const global minute³ = minute^3
const global minute⁴ = minute^4
const global h² = h^2
const global h³ = h^3
const global h⁴ = h^4

# Automatic conversion











# This is probably used by Unitful when registering 'h'
const localunits = Unitful.basefactors

"""
MechanicalUnits defines the bullet operator `∙` (Unicode U+2219, \vysmblkcircle + tab in Julia). 

The intention of defining it is being able to copy unitful output in the REPL without
having to print units with the `*` symbol.
""" 
∙(a, b) = *(a,b)


#=
We want to print quantities without a space between value and unit.
This means replacing a Unitful method, but enables copying output for easy redefinitions.
For easier reading, we'll also put a bit of colour on units.
=#
Base.delete_method( which( show, (IO, Quantity)))
Base.delete_method( which( show, (IO, MIME"text/plain", Quantity)))

function show(io::IO, x::Quantity)
    show(io, x.val)
    if !isunitless(unit(x))
        show(io, unit(x))
    end
end
function show(io::IO, mime::MIME"text/plain", x::Quantity)
    show(io, mime, x.val)
    if !isunitless(unit(x))
        show(io, mime, unit(x))
    end
end
function show(io::IO, x::Quantity{T,D,U}) where {T<:Rational, D, U}
    # Add paranthesis: 1//1000m² -> (1//1000)m²
    print(io, "(")
    show(io, x.val)
    print(io, ")")
    if !isunitless(unit(x))
        show(io, unit(x))
    end
end
function show(io::IO, mime::MIME"text/plain", x::Quantity{T,D,U}) where {T<:Rational, D, U}
    # Add paranthesis: 1//1000m² -> (1//1000)m²
    print(io, "(")
    show(io, x.val)
    print(io, ")")
    if !isunitless(unit(x))
        show(io, mime, unit(x))
    end
end

#=
We want to print quantities with "product units" without a space between value and unit.
This means replacing a Unitful method, but enables copying output for easy redefinitions.

Setting the IOContext options
* :showoperators=>true prints a `*` as in Unitful's version.
* :showoperators=>false prints a `∙` instead of scace.
=#
Base.delete_method( which( show, (IO, Unitlike)))
"""
    show(io::IO, x::Unitlike)
Call [`Unitful.showrep`] on each object in the tuple that is the type
variable of a [`Unitful.Units`] or [`Unitful.Dimensions`] object.
"""
function show(io::IO, x::Unitlike)
    showoperators = get(io, :showoperators, false)
    first = ""
    sep = showoperators ? "*" : "∙"
    foreach(sortexp(typeof(x).parameters[1])) do y
        print(io,first)
        showrep(io,y)
        first = sep
    end
    nothing
end
show(io::IO, x::typeof(°C)) = printstyled(io, color = :cyan, "°C")
show(io::IO, x::typeof(°F)) = printstyled(io, color = :cyan, "°F")

#=
We want to print units with a somewhat distinguished colour or font.
:cyan is a compromise, seeming visible and not obtrusive on the tried displays.
=#
Base.delete_method( which( showrep, (IO, Unit)))
"""
    showrep(io::IO, x::Unit)
Show the unit, prefixing with any decimal prefix and appending the exponent as
formatted by [`Unitful.superscript`].
Also prints with color when allowed by io.
"""
function showrep(io::IO, x::Unit)
    p = power(x)
    supers = if p == 1//1
                ""
            elseif p == 2//1
                "²"
            elseif p == 3//1
                "³"
            elseif p == 4//1
                "⁴"
            else
                superscript(p)
            end
    printstyled(io, color = :cyan, prefix(x), abbr(x), supers)
end

# Since Unitful's Dimension symbols 𝐓, 𝐌 𝐋 and 𝚯 are not printable, we'll replace 
# those with our substitutions

Base.delete_method( which( abbr, (Dimension{:Length},)))
Base.delete_method( which( abbr, (Dimension{:Mass},)))
Base.delete_method( which( abbr, (Dimension{:Time},)))
Base.delete_method( which( abbr, (Dimension{:Temperature},)))
abbr(::Dimension{:Length}) = "Length"
abbr(::Dimension{:Mass}) = "Mass"
abbr(::Dimension{:Time}) = "Time"
abbr(::Dimension{:Temperature}) = "Temperature"


#=

Todo: use :typeinfo to convey if units should be printed, or already has. 
baremodule subset...
end

The 'position vector' probably is redundant here? Dispatch on Vector{Length} instead of Pos?

Anyway, position vector, force vector, moment vector could be useful. But would need 
more readable names than just Pos. And to be fast, fixed size vectors are better.

"Position vector"
const Pos = Vector{Quantity{T,𝐋,U}} where {T,U}
Pos(p::Pos) = Vector(p)

function show(io::IO, p::Pos) # short form
    typ = typeof(p)
    ioc = IOContext(io, :typeinfo => typ)
    show(ioc, ustrip(p))
    printstyled(ioc, unit(eltype(typ)); color=:cyan)
end
function show(io::IO, ::MIME"text/plain", p::Pos{T}) where T# long form
    typ = typeof(p)
    ioc = IOContext(io, :typeinfo => typ)
    print(ioc, "Pos{", T, "}(")
    show(ioc, ustrip(p))
    printstyled(ioc, unit(eltype(typ)); color=:cyan)
    print(ioc, ")")
end

=#

function __init__()
    # This is for evaluating Unitful macros in the context of this package.
    merge!(Unitful.basefactors, localunits)
    # This enables any units defined here to be used in the @u_str
    Unitful.register(MechanicalUnits)
end


end # module
