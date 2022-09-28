module MechanicalUnits
using Unitfu
# Exported infix function / operator
export ∙
# Import / exports for short and parseable type signatures
import Unitfu: Time, Length, Mass, Temperature, Current, Luminosity, Amount
import Unitfu: 𝐓 , 𝐋 , 𝐌 , 𝚯, 𝐉 , 𝐍
import Unitfu: lookup_units, promote_to_derived
export Time, Length, Mass, Temperature, Current, Luminosity, Amount, Level
export 𝐓 , 𝐋 , 𝐌 , 𝚯 , 𝐉 , 𝐍
export Quantity, DimensionlessQuantity, NoUnits, NoDims
import Unitfu:
        FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Dimension, Dimensions, Units
export  FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Dimensions, Dimension, Units
export  Level, Gain

# For importing from Unitfu, or defining more units
export @import_expand, @unit, @u_str

# Reexported functions from Unitfu
export logunit, unit, absoluteunit, dimension, uconvert, ustrip, upreferred, ∙
export uconvertp, uconvertrp, reflevel, linear

# Useful functions that are not exported by Unitfu.
export preferunits, convfact, promote_to_derived

# A vector of all the exported units. This is printed during precompilation.
export MECH_UNITS

import Unitfu: isunitless, sortexp, showrep, abbr, prefix, power, superscript, tens, genericunit
import Unitfu: promote_unit, preferunits, convfact
# derived dimensions
import Unitfu: Area, Acceleration, Force, Pressure, Density
import Unitfu: Velocity
import Unitfu:ForceFreeUnits, PressureFreeUnits, EnergyFreeUnits, AreaFreeUnits, DensityFreeUnits, VolumeFreeUnits
export Area, Acceleration, Force, Pressure, Density, Velocity

# Extend base. This could perhaps reside in Unitfu
import Base: tryparse_internal, parse

# Units are exported in 'import_export_units.jl'.

include("internal_functions.jl")
include("import_export_units.jl")
# We have defined and exported e.g. m². Now do the same for dimension symbbols,
# so that e.g.  𝐓² == 𝐓 ^². This way, output could be used as constructors.
eval(exponents_superscripts(:𝐓))
eval(exponents_superscripts(:𝐋))
eval(exponents_superscripts(:𝐌))
eval(exponents_superscripts(:𝚯))
eval(exponents_superscripts(:𝐉))
eval(exponents_superscripts(:𝐍))

# Used for registering units with Unitfu macros during initialisation.
const localunits = Unitfu.basefactors

include("parse.jl")
function __init__()
    # This is for evaluating Unitfu macros in the context of this package.
    merge!(Unitfu.basefactors, localunits)
    # This enables any units defined here to be used in the @u_str
    Unitfu.register(MechanicalUnits)
    # This pre-selects some useful units for the mechanical engineering domain
    preferunits(kg, mm, s, K)
    Sys.iswindows() && push!(ENV, "UNITFUL_FANCY_EXPONENTS" => "true")
    Sys.isapple() && push!(ENV, "UNITFUL_FANCY_EXPONENTS" => "true")
end


end # module
