export Time, Length, Mass, Temperature
# Time, length and mass (and their exponents) are of type Dimension. 
# Their Uniful symbols unfortunately can't be shown 
# in Windows terminals. We replace them, which 
# makes method signatures longer. This is somewhat compensated by exporting
# module name and rewriting type signatures in some contexts.
const global Time = Unitful.𝐓
const global Length = Unitful.𝐋
const global Mass = Unitful.𝐌
const global Temperature = Unitful.𝚯
const global Current = Unitful.𝐈
const global Luminosity = Unitful.𝐉
const global Amount = Unitful.𝐍
# Since Unitful's Dimension symbols 𝐓, 𝐌 𝐋 and 𝚯 are not printable, we'll replace 
# those with our substitutions
Base.delete_method( which( abbr, (Dimension{:Length},)))
Base.delete_method( which( abbr, (Dimension{:Mass},)))
Base.delete_method( which( abbr, (Dimension{:Time},)))
Base.delete_method( which( abbr, (Dimension{:Temperature},)))
Base.delete_method( which( abbr, (Dimension{:Current},)))
Base.delete_method( which( abbr, (Dimension{:Luminosity},)))
Base.delete_method( which( abbr, (Dimension{:Amount},)))
abbr(::Dimension{:Length}) = "Length"
abbr(::Dimension{:Mass}) = "Mass"
abbr(::Dimension{:Time}) = "Time"
abbr(::Dimension{:Temperature}) = "Temperature"
abbr(::Dimension{:Current}) = "Current"
abbr(::Dimension{:Luminosity}) = "Luminosity"
abbr(::Dimension{:Amount}) = "Amount"
