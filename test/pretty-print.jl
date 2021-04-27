using MechanicalUnits
using Test
# Note that the printing functionality has been moved from here to a clone/ fork of Unitful.
# This is now mostly redundant.
shortp(x) = repr(x, context = :color=>true)
longp(x) = repr(:"text/plain", x, context = :color=>true)

global const sInt = typeof(Int(1)) == Int64 ? "Int64" : "Int32"

@testset "Most basic" begin
    testunits = [m ,  s ,  kg ]
    teststrings = ["m" ,  "s" ,  "kg" ]
    for (u, su) in zip(testunits, teststrings)
        st = "2\e[36m$su\e[39m"
        @test shortp(2u) == st
        @test longp(2u) == st
    end
    # Products of most basic quantities
    q1, q2, res = m , s , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(q1 * q2) == longp(q1 * q2)
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = m , kg , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , m , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , kg , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , m , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , s , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
end

@testset "Special temperature units, Affine units" begin
    testunits = [°C, °F]
    teststrings = ["°C", "°F"]
    for (u, su) in zip(testunits, teststrings)
        st = "3\e[36m$su\e[39m"
        @test shortp(3u) == st
        @test longp(3u) == st
    end
    # These quantities can't be multiplied, so that's it.
end


@testset "Fahrenheit intervals, Kelvin, directly derived units" begin
    testunits = [Ra, K, h, μm, minute]
    teststrings = ["Ra", "K", "h", "μm", "minute"]
    for (u, su) in zip(testunits, teststrings)
        st = "2\e[36m$su\e[39m"
        @test shortp(2u) == st
        @test longp(2u) == st
    end
    q1, q2, res = m , s , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = m , kg , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , m , "6\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = s , kg , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , m , "6\e[36mkg\e[39m∙\e[36mm\e[39m"
    @test shortp(2q1 * 3q2) == res
    q1, q2, res = kg , s , "6\e[36mkg\e[39m∙\e[36ms\e[39m"
    @test shortp(2q1 * 3q2) == res
end

@testset "Rational quantities" begin
    shortp((1//100)kg) == "(1//100)\e[36mkg\e[39m"
    longp((1//100)kg) == "(1//100)\e[36mkg\e[39m"
end
@testset "Constructors from type signatures" begin
    # Unitfu now prints shorter type signatures, which
    # on reconstruction makes FreeUnits instead of the original.
    # The shorter output is more readable.
end

@testset "Type signatures, exponents -4 to 4" begin
    dimdi = Dict([m => " ᴸ", s => " ᵀ", kg => " ᴹ",
            Ra => " ᶿ", K => " ᶿ", h => " ᵀ",
            μm => " ᴸ", minute => " ᵀ"])
    for bu in ["m", "s", "kg", "Ra", "K", "h", "μm", "minute"],
        di in ["⁻⁴" , "⁻³", "⁻²" , "⁻¹", "²", "³", "⁴"]
        res = shortp(typeof(eval(Symbol(bu*di))))
        expec1 = "FreeUnits{(\e[36m" * bu * di* "\e[39m,),"
        expec2a = ""
        expec2b = " "
        expec3 = dimdi[eval(Meta.parse(bu)) ]
        expec4 =  di * ", nothing}"
        @test res == expec1*expec2a*expec3*expec4 ||
              res == expec1*expec2b*expec3*expec4
    end
end

@testset "Arrays with units" begin
    a1 = [1 2]m
    st ="[2 4]\e[36mm\e[39m"
    @test shortp(2a1) == st

    st = "1×2 Matrix{Quantity{Int64,  ᴸ, FreeUnits{(\e[36mm\e[39m,),  ᴸ, nothing}}}:\n 2  4"
    @test longp(2a1) == st

    a2 = [1 2]m*s^-1
    st = "[2 4]\e[36mm\e[39m∙\e[36ms⁻¹\e[39m"
    @test shortp(2a2) == st

    a3 = [10, 6, 2, -2]m
    st = "[20, 12, 4, -4]\e[36mm\e[39m"
    @test shortp(2a3) == st

    st = "4-element Vector{Quantity{Int64,  ᴸ, FreeUnits{(\e[36mm\e[39m,),  ᴸ, nothing}}}:\n 20\n 12\n  4\n -4"
    @test longp(2a3) == st
end

@testset "Tuples with units" begin
    a1 = (1, 2)m
    st ="(2, 4)\e[36mm\e[39m"
    @test shortp(2 .*a1) == st
    @test longp(2 .*a1) == st
    a2 = (1, 2)m*s^-1
    st = "(2, 4)\e[36mm\e[39m∙\e[36ms⁻¹\e[39m"
    @test shortp(2 .*a2) == st
    a3 = (10, 6, 2, -2)m
    st = "(10, 6, 2, -2)\e[36mm\e[39m"
    @test shortp(a3) == st
end

@testset "Ranges" begin
    a1 = 1m:2m:5m
    st = "(2:4:10)\e[36mm\e[39m"
    @test shortp(2 .*a1) == st
    @test longp(2 .*a1) == st
    a2 = (5:-2:-1)m*s^-1
    st = "[10, 6, 2, -2]\e[36mm\e[39m∙\e[36ms⁻¹\e[39m"
    @test shortp(collect(2 .*a2)) == st
end

#
@testset "Dimensions" begin
    u  = s*m*kg*K
    @test shortp(u) == "\e[36mkg\e[39m∙\e[36mK\e[39m∙\e[36mm\e[39m∙\e[36ms\e[39m"
    @test shortp(dimension(u)) == " ᴸ∙ ᴹ∙ ᶿ∙ ᵀ"
    st = "FreeUnits{(\e[36mkg\e[39m, \e[36mK\e[39m, \e[36mm\e[39m, \e[36ms\e[39m),  ᴸ∙ ᴹ∙ ᶿ∙ ᵀ, nothing}"
    @test shortp(typeof(u)) == st

    @test shortp(typeof(dimension(u))) == "Dimensions{(Dimension{:Length}(1//1), Dimension{:Mass}(1//1), Dimension{:Temperature}(1//1), Dimension{:Time}(1//1))}"
    @test shortp(dimension(u^2)) == " ᴸ²∙ ᴹ²∙ ᶿ²∙ ᵀ²"
    @import_expand A mol
    v  = A * mol
    @test shortp(v) == "\e[36mA\e[39m∙\e[36mmol\e[39m"
    @test shortp(dimension(v)) == " ᴺ∙ ᴵ"
    st = "FreeUnits{(\e[36mA\e[39m, \e[36mmol\e[39m),  ᴺ∙ ᴵ, nothing}"
    @test shortp(typeof(v)) == st
    @test shortp(typeof(dimension(v))) == "Dimensions{(Dimension{:Amount}(1//1), Dimension{:Current}(1//1))}"
    @test shortp(dimension(v^2)) == " ᴺ²∙ ᴵ²"
end
