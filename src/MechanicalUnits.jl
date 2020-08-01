module MechanicalUnits
using Unitful
# Exported infix function / operator
export ∙
# Import / exports for short and parseable type signatures
import Unitful: Time, Length, Mass, Temperature, Current, Luminosity, Amount
import Unitful: ᵀ , ᴸ , ᴹ , ᶿ, ᴶ , ᴺ
export Time, Length, Mass, Temperature, Current, Luminosity, Amount, Level
export ᵀ , ᴸ , ᴹ , ᶿ , ᴶ , ᴺ
export Quantity, DimensionlessQuantity, NoUnits, NoDims
import Unitful:
        FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Dimension, Dimensions, Units
export  FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Dimensions, Dimension, Units
export  Level, Gain

# For importinng from Unitful, or defining more units
export @import_expand, @unit, @u_str

# Reexported functions from Unitful
export logunit, unit, absoluteunit, dimension, uconvert, ustrip, upreferred, ∙
export uconvertp, uconvertrp, reflevel, linear

# Useful functions that are not exported by Unitful.
export preferunits, convfact

# A vector of all the exported units. This is printed during precompilation.
export MECH_UNITS

import Unitful: isunitless, sortexp, showrep, abbr, prefix, power, superscript, tens, genericunit
import Unitful: promote_unit, preferunits, convfact
# derived dimensions
import Unitful: Area, Acceleration, Force, Pressure, Density
import Unitful: Velocity
import Unitful:ForceFreeUnits, PressureFreeUnits, EnergyFreeUnits, AreaFreeUnits, DensityFreeUnits, VolumeFreeUnits
export Area, Acceleration, Force, Pressure, Density, Velocity
# Units are exported in 'import_export_units.jl'.

include("internal_functions.jl")
include("import_export_units.jl")
# We have defined and exported e.g. m². Now do the same for dimension symbbols,
# so that e.g.  ᵀ² == ᵀ ^². This way, output could be used as constructors.
eval(exponents_superscripts(:ᵀ))
eval(exponents_superscripts(:ᴸ))
eval(exponents_superscripts(:ᴹ))
eval(exponents_superscripts(:ᶿ))
eval(exponents_superscripts(:ᴶ))
eval(exponents_superscripts(:ᴺ))

# Used for registering units with Unitful macros during initialisation.
const localunits = Unitful.basefactors

function __init__()
    # This is for evaluating Unitful macros in the context of this package.
    merge!(Unitful.basefactors, localunits)
    # This enables any units defined here to be used in the @u_str
    Unitful.register(MechanicalUnits)
    # This pre-selects some useful units for the mechanical engineering domain
    preferunits(kg, mm, s, K)
    Sys.iswindows() && push!(ENV, "UNITFUL_FANCY_EXPONENTS" => "true")
    Sys.isapple() && push!(ENV, "UNITFUL_FANCY_EXPONENTS" => "true")
end

end # module
