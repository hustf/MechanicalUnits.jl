
#=
# To shorten unit output, and enabling the same format in input
export m², m³, m⁴, s², s³, s⁴ #, kg², kg³, kg⁴
export Ra², Ra³, Ra⁴, K², K³, K⁴
export h², μm², minute²
export h³, μm³, minute³
export h⁴, μm⁴, minute⁴

# For all the exported units, we also need to understand superscripts 2 to 4, 
# as they appear in printed units and may be copied as inputs.
# Also including prefixes.

const global m² = m^2
const global m³ = m^3
const global m⁴ = m^4
const global s² = s^2
const global s³ = s^3
const global s⁴ = s^4
#=
const global kg² = kg^2
const global kg³ = kg^3
const global kg⁴ = kg^4
=#
const global Ra² = Ra^2
const global Ra³ = Ra^3
const global Ra⁴ = Ra^4
const global K² = K^2
const global K³ = K^3
const global K⁴ = K^4
const global h² = h^2
const global h³ = h^3
const global h⁴ = h^4
const global μm² = μm^2
const global μm³ = μm^3
const global μm⁴ = μm^4
const global minute² = minute^2
const global minute³ = minute^3
const global minute⁴ = minute^4
const global h² = h^2
const global h³ = h^3
const global h⁴ = h^4
=#
function exponents_2_to_4(sy::Symbol)
    syexp2 = Symbol(sy, "²")
    syexp3 = Symbol(sy, "³")
    syexp4 = Symbol(sy, "⁴")
    quote
        const global $syexp2 = $sy^2
        const global $syexp3 = $sy^3
        const global $syexp4 = $sy^4
        export $syexp2, $syexp3, $syexp4
    end
end