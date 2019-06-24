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
