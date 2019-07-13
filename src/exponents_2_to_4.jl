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
