module MechanicalUnits
export ∙
# Import / exports for shorter type signatures
import Unitful: Time, Length, Mass, Temperature, Current, Luminosity, Amount
import Unitful: ᵀ , ᴸ , ᴹ , ᶿ, ᴶ , ᴺ
export Time, Length, Mass, Temperature, Current, Luminosity, Amount
export ᵀ , ᴸ , ᴹ , ᶿ , ᴶ , ᴺ
export FreeUnits, Affine, AffineUnits, AffineQuantity, Unitlike, Unit, Quantity, Dimensions, Dimension
# Convenience / info / testing
export @import_from_unitful
export uconvert, upreferred, ustrip, unit, preferunits, dimension, numtype
export mech_units
# Units are exported in 'import_export_units.jl' and also 'exponents_2_to_4.jl'
using Unitful
import Unitful: FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Quantity, Dimension, Dimensions, Units
import Unitful: isunitless, unit, sortexp, showrep, abbr, prefix, power, superscript, tens, numtype, genericunit
import Unitful: promote_unit, preferunits, dimension, numtype
# derived dimensions
import Unitful: @derived_dimension
import Unitful: Area, Acceleration, Force, Pressure, Density
import Unitful: Velocity
import Unitful:ForceFreeUnits, PressureFreeUnits, EnergyFreeUnits, AreaFreeUnits, DensityFreeUnits, VolumeFreeUnits
export Area, Acceleration, Force, Pressure, Density, Velocity
# For adding division
import Base./

# TODO cleanup imports after show methods have been moved out.

# Used for registering units with Unitful macros during initialisation.
const localunits = Unitful.basefactors
include("exponents_2_to_4.jl")
include("import_export_units.jl")

"""
MechanicalUnits defines the bullet operator `∙` (Unicode U+2219, \vysmblkcircle + tab in Julia).

The intention of defining it is being able to copy unitful output in the REPL without
having to print units with the `*` symbol.

A modified version of Unitful is used, where this operator is used for printing.
"""
∙(a, b) = *(a,b)



"""
Are there possible ambiguities with this operation? See Unitful issue #225.
If so, it seems important enough to consider including anyway, since
useablity is important here. It was allowed in e.g. SIUnits.jl.
"""
/(A::AbstractArray, B::Units) = broadcast(/, A, B)




# TODO consider printing units to a buffer during precompilation, check speed.

function __init__()
    # This is for evaluating Unitful macros in the context of this package.
    merge!(Unitful.basefactors, localunits)
    # This enables any units defined here to be used in the @u_str
    Unitful.register(MechanicalUnits)
    # This pre-selects some useful units for the mechanical engineering domain
   preferunits(kg, mm, s, K)
end


end # module
