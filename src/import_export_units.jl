# This file deals with a handpicked set of units and derived dimensions.
# The macros are adapted from https://github.com/JuliaAstro/UnitfulAstro.jl/blob/master/src/UnitfulAstro.jl
# 
# TODO
# Pick some preferred units for the mechanical engineering domain.
#Unitful.promote_unit(::S, ::T) where {S<:Unitful.EnergyUnits, T<:Unitful.EnergyUnits} = u"g*cm^2/s^2"
# TODO add abbr(arg) to macros (where relevant? Check examples.)

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
@import_from_unitful N daN kN MN
@import_from_unitful J kJ MJ GJ
# Affine units
@import_affine_from_unitful °C °F
abbr(::genericunit(°C)) = "°C"
abbr(::genericunit(°F)) = "°F"
# own definition(s)
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
for u in mech_units
    print(u, "\t")
end
println()
