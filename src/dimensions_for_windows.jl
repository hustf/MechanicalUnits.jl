export Time, Length, Mass, Temperature
# Time, length and mass (and their exponents) are of type Dimension. 
# Their symbols unfortunately can't be shown 
# in Windows terminals. We replace them, which 
# makes method signatures even longer. 
const global Time = Unitful.𝐓
const global Length = Unitful.𝐋
const global Mass = Unitful.𝐌
const global Temperature = Unitful.𝚯

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

