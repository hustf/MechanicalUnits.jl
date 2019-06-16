# The below is preliminary code. 
# TODO; Test, fix and improvefor a few units
# Then, write macros to bring in a set of prefixes and derived units.
module MechanicalUnits
export ∙
# Convenience / info / testing
export @u_str, uconvert, upreferred, basefactor, ustrip, unit, preferunits, dimension
export mech_units
# To shorten type signature ouput
export FreeUnits, AffineUnits, AffineQuantity, Unitlike, Unit, Quantity, Dimensions, Dimension
# Units are exported in 'import_export_units.jl' and also 'exponents_2_to_4.jl'
import Base:show
using InteractiveUtils
#using Formatting (or implement elsewhere....)
using Unitful
import Unitful: FreeUnits, AffineUnits, Unitlike, Unit, Quantity, Dimension, Dimensions
import Unitful: isunitless, unit, sortexp, showrep, abbr, prefix, power, superscript, tens
import Unitful: promote_unit, preferunits, dimension
# temporary imports
import Unitful: Units


# Used for registering units with Unitful macros during initialisation.
const localunits = Unitful.basefactors
include("exponents_2_to_4.jl")

include("import_export_units.jl")
include("dimensions_for_windows.jl")
include("output_parseable_format.jl")



function show(io::IO, p::Array{Quantity{T,D,U}, N})  where {T,D,U,N} # short form
    numerictype = eltype(ustrip(p))
    ioc = IOContext(io, :typeinfo => numerictype)
    show(ioc, ustrip(p))
    # Now show the unit.
    show_unit(io, first(p))
end
show(io::IO, ::MIME"text/plain", p::Array{Quantity{T,D,U}, N})  where {T,D,U,N} = show(io, p)# long form, REPL output
#=

Todo:
Output for tuples, dictionaries.
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
    # This pre-selects some useful units for the mechanical engineering domain
   # preferunits(u"m,s,A,K,cd,kg,mol"...)
   preferunits(kg, mm, s, K)
end


end # module
