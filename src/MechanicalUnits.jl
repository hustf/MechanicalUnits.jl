module MechanicalUnits
export ∙
# Convenience / info / testing
export @u_str, uconvert, upreferred, ustrip, unit, preferunits, dimension, numtype
export mech_units
# To shorten type signature ouput
export FreeUnits, Affine, AffineUnits, AffineQuantity, Unitlike, Unit, Quantity, Dimensions, Dimension
# Units are exported in 'import_export_units.jl' and also 'exponents_2_to_4.jl'
import Base:show
using InteractiveUtils
using Unitful
import Unitful: FreeUnits, AffineUnits, Affine, AffineQuantity, Unitlike, Unit, Quantity, Dimension, Dimensions
import Unitful: isunitless, unit, sortexp, showrep, abbr, prefix, power, superscript, tens, numtype, genericunit
import Unitful: promote_unit, preferunits, dimension, numtype
# temporary imports
import Unitful: Units


# Used for registering units with Unitful macros during initialisation.
const localunits = Unitful.basefactors
include("exponents_2_to_4.jl")

include("import_export_units.jl")
include("dimensions_for_windows.jl")
include("output_parseable_format.jl")
include("output_abstractarrays.jl")

function __init__()
    # This is for evaluating Unitful macros in the context of this package.
    merge!(Unitful.basefactors, localunits)
    # This enables any units defined here to be used in the @u_str
    Unitful.register(MechanicalUnits)
    # This pre-selects some useful units for the mechanical engineering domain
   preferunits(kg, mm, s, K)
end


end # module
