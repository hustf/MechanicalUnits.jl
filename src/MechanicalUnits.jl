module MechanicalUnits
using Unitful
import Unitful: FreeUnits, isunitless, unit
# Time, length, mass
import Unitful: 𝐓, 𝐋, 𝐌
export m ,  m² ,  m³ ,  s ,  s² ,  s³ ,  kg ,  kgm ,  kgm² ,  kgm³
export kgs ,  kgs² ,  kgs³, N

const m = 1.0u"m"
const m² = 1.0u"m^2"
const m³ = 1.0u"m^3"
const s = 1.0u"s"
const s² = 1.0u"s^2"
const s³ = 1.0u"s^3"
const kg = 1.0u"kg"
const kgm = kg*m
const kgm² = kg*m²
const kgm³ = kg*m³
const kgs = kg*s
const kgs² = kg*s²
const kgs³ = kg*s³
const N = kgm/s²
# TODO: Move to using this approach:
@unit transportdistance "Nm" TransportDistance 1u"kg*m" false

#=
We want to print quantities without a space between value and unit.
This enables copying output for easy redefinitions.
For easier reading, we'll also put a bit of colour on units.
julia> 1kg
1.0kg

julia> 1 kg
ERROR: syntax: extra token "kg" after end of expression
=#
function show(io::IO, x::Quantity)
    show(io,x.val)
    if !isunitless(unit(x))
        printstyled(io, unit(x); color=:cyan)
    end
    nothing
end


end # module
