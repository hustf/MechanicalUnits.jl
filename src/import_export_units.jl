# This file deals with a handpicked set of units and derived dimensions.
# The macros are adapted from https://github.com/JuliaAstro/UnitfulAstro.jl/blob/master/src/UnitfulAstro.jl
# 
const global mechanical_si_prefixes = (:n, :μ, :μ, :m, :c, :d, Symbol(""), :k, :M, :G, :T, :P)
const global exclude_import = (:ng, :μg, :μg, :g, :dg, :Mg, :Gg, :Tg, :Pg,
                              :cs, :ds, :ks, :Ms, :Gs, :Ts, :Ps,
                              )
"""
A list of available unit symbols. All are exported by default, which means that some may 
crash with symbols defined. One way to solve such issues is importing just what you need:
```example
import MechanicalUnits: kg, m
```
"""
const global mech_units = Vector{Symbol}()
"Import non-affine units from Unitful"
macro import_from_unitful(args...)
    expr = Expr(:block)
    for arg in args
        use_SI_prefixes, sym = should_we_use_SI_prefixes(arg)
        if use_SI_prefixes
            # We have defined a smaller subset of SI prefixes commonly used in this domain.
            for prefix in mechanical_si_prefixes
                sym′ = Symbol(prefix, sym)
                # Some prefix+baseunit are excluded:
                if sym′ ∉ exclude_import
                    push!(expr.args, :(import MechanicalUnits.Unitful.$sym′))
                    # AstroUnits don't reexport, but we do:
                    push!(expr.args, :(export $sym′))
                    push!(mech_units, sym′)
                    push!(expr.args, exponents_2_to_4(sym′))
                end
            end
        else
            push!(expr.args, :(import MechanicalUnits.Unitful.$sym))
            # AstroUnits don't reexport, but we do:
            push!(expr.args, :(export $sym))
            push!(mech_units, sym)
            push!(expr.args, exponents_2_to_4(sym))
        end
    end
    esc(expr)
end
"Import affine units from Unitful."
macro import_affine_from_unitful(args...)
    expr = Expr(:block)
    for arg in args
        push!(expr.args, :(import MechanicalUnits.Unitful.$arg))
        # AstroUnits don't reexport, but we do:
        push!(expr.args, :(export $arg))
        push!(mech_units, arg)
    end
    esc(expr)
end

function should_we_use_SI_prefixes(arg::Expr)
    if arg.head == :(call)
        if arg.args[1] == :(~)
            return true, arg.args[2]
        else
            error("incorrect first argument $arg")
        end
    else
        error("incorrect expression head: $arg")
    end
end
should_we_use_SI_prefixes(arg::Symbol) = false, arg
# units with standard prefixes
@import_from_unitful ~m ~s ~g 
@import_from_unitful rad ° K Ra
@import_from_unitful minute d atm bar
# units with a small set of prefixes
@import_from_unitful N daN kN MN GN
@import_from_unitful Pa kPa MPa GPa
@import_from_unitful J kJ MJ GJ
# In order to avoid awkwardness like 'm∙N', we define the product as its own unit.
# It is used to represent a moment, rather than energy.
begin
    @unit Nm     "Nm"       NewtonMeter  (1//1)N*m false
    @unit daNm   "daNm"     dekaNewtonMeter  (10//1)N*m false
    @unit kNm    "kNm"      kiloNewtonMeter  (1000//1)N*m false
    @unit MNm    "MNm"      MegaNewtonMeter  (1000000//1)N*m false
    @unit GNm    "GNm"      GigaNewtonMeter  (1000000000//1)N*m false
    push!(mech_units, :Nm)
    push!(mech_units, :daNm)
    push!(mech_units, :kNm)
    push!(mech_units, :MNm)
    push!(mech_units, :GNm)
    export Nm, daNm, kNm, MNm, GNm
    eval(exponents_2_to_4(:Nm))
    eval(exponents_2_to_4(:daNm))
    eval(exponents_2_to_4(:kNm))
    eval(exponents_2_to_4(:MNm))
    eval(exponents_2_to_4(:GNm))
end

# U.S. units
@import_from_unitful inch ft lb lbf
# affine units
@import_affine_from_unitful °C °F
abbr(::genericunit(°C)) = "°C"
abbr(::genericunit(°F)) = "°F"
# preferred capitalization units
begin
    @unit h      "h"       hour        (3600//1)s false
    push!(mech_units, :h)
    export h
    eval(exponents_2_to_4(:h))
end
begin
    @unit yr     "yr"      JulianYear  (31557600//1)s false
    push!(mech_units, :yr)
    export yr
    eval(exponents_2_to_4(:yr))
end

begin
    @unit l     "l"      liter  (1//1000)m³ false
    push!(mech_units, :l)
    export l
    eval(exponents_2_to_4(:l))
end

begin
    @unit dl     "dl"      DesiLiter  (1//10000)m³ false
    push!(mech_units, :dl)
    export dl
    eval(exponents_2_to_4(:dl))
end

begin
    @unit cl     "cl"      CentiLiter  (1//100000)m³ false
    push!(mech_units, :cl)
    export cl
    eval(exponents_2_to_4(:cl))
end

begin
    @unit ml     "ml"      MilliLiter  (1//1000000)m³ false
    push!(mech_units, :ml)
    export ml
    eval(exponents_2_to_4(:ml))
end

begin
    @unit g     "g"      "StandardGravity"  9.80665m/s² false
    push!(mech_units, :g)
    export g
    eval(exponents_2_to_4(:g))
end
# more strange units
begin
    @unit kip     "kip"      "KiloPoundForce"  1000lbf false
    push!(mech_units, :kip)
    export kip
    eval(exponents_2_to_4(:kip))
end

begin
    @unit shton     "shton"      "ShortTon"  2000lb false
    push!(mech_units, :shton)
    export shton
    eval(exponents_2_to_4(:shton))
end

for u in mech_units
    print(u, "\t")
end


# Define derived dimensions promotions
#= example
[100000.0N 10daN]
1×2 Array{Float64{kN},2}:
 100.0  0.1
=# 

Unitful.promote_unit(::S, ::T) where
{S<:ForceFreeUnits, T<:ForceFreeUnits} = kN

#= example
[10N/mm^2 100000000N/m^2]
1×2 Array{Rational{Int64}{MPa},2}:
(10//1)  (100//1)
=#
Unitful.promote_unit(::S, ::T) where
{S<:PressureFreeUnits, T<:PressureFreeUnits} = MPa


Unitful.promote_unit(::S, ::T) where
{S<:EnergyFreeUnits, T<:EnergyFreeUnits} = kN∙m


# In order to avoid ambiguities, we don't define preferred promotions for e.g. Volume, which is indistinguishable 
# from moment of resistance.
# Moment is ambiguous with Energy.


println()
