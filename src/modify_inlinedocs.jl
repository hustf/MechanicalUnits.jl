# This replaces some help texts from Unitful which contain unicode symbols that can't be displayed
# in windows terminals.
# Where methods are redefined in this package, the translated inline docs are defined in-place.
# TODO get rid of the original inline docs, which are tied to specific methods (in some cases)
# TODO moved this to the forked Unitful version.
#=
@u_str
ustrip
preferunits
dimension
FreeUnits
Unit
=#
# We replace this docstring to make dimensions readable on Windows terminals.
"""
    preferunits(u0::Units, u::Units...)
This function specifies the default fallback units for promotion.
Units provided to this function must have a pure dimension of power 1, like Length or Time
but not Length/Time or Length^2. The function will complain if this is not the case. Additionally,
the function will complain if you provide two units with the same dimension, as a
courtesy to the user. Finally, you cannot use affine units such as °C with this function.

Once [`Unitful.upreferred`](@ref) has been called or quantities have been promoted,
this function will appear to have no effect.

Usage example: `preferunits(u"m,s,A,K,cd,kg,mol"...)`
"""
function preferunits end
