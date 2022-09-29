# This file imports, 'expands' and exports a handpicked set of units and derived dimensions.
# 'Expands' meaning that exponents -4 to 4 are also defined as symbols, where applicable.
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
const global MECH_UNITS = Vector{Symbol}()
# units with standard prefixes
@import_expand ~m ~s ~g
@import_expand rad ° K Ra
@import_expand minute d atm bar
# units with a small set of prefixes
@import_expand N daN kN MN GN
@import_expand Pa kPa MPa GPa
@import_expand J kJ MJ GJ
# In order to avoid awkwardness like 'm∙N', we define the product as its own unit.
# It is used to represent a moment, rather than energy.
begin
    @unit Nmm     "Nmm"     NewtonMilliMeter  (1//1000)N*m false
    @unit Nm     "Nm"       NewtonMeter      (1//1)N*m false
    @unit daNm   "daNm"     dekaNewtonMeter  (10//1)N*m false
    @unit kNm    "kNm"      kiloNewtonMeter  (1000//1)N*m false
    @unit MNm    "MNm"      MegaNewtonMeter  (1000000//1)N*m false
    @unit GNm    "GNm"      GigaNewtonMeter  (1000000000//1)N*m false
    push!(MECH_UNITS, :Nmm)
    push!(MECH_UNITS, :Nm)
    push!(MECH_UNITS, :daNm)
    push!(MECH_UNITS, :kNm)
    push!(MECH_UNITS, :MNm)
    push!(MECH_UNITS, :GNm)
    export Nmm, Nm, daNm, kNm, MNm, GNm
    eval(exponents_superscripts(:Nmm))
    eval(exponents_superscripts(:Nm))
    eval(exponents_superscripts(:daNm))
    eval(exponents_superscripts(:kNm))
    eval(exponents_superscripts(:MNm))
    eval(exponents_superscripts(:GNm))
end

# U.S. units
@import_expand inch ft lb lbf
# affine units
@import_affine_from_Unitfu °C °F
# Note, not sure why this was needed at an earlier point: 
# abbr(::genericunit(°C)) = "°C" 
# abbr(::genericunit(°F)) = "°F"

# preferred capitalization units
begin
    @unit h      "h"       hour        (3600//1)s false
    push!(MECH_UNITS, :h)
    export h
    eval(exponents_superscripts(:h))
end
begin
    @unit yr     "yr"      JulianYear  (31557600//1)s false
    push!(MECH_UNITS, :yr)
    export yr
    eval(exponents_superscripts(:yr))
end

begin
    @unit l     "l"      liter  (1//1000)m³ false
    push!(MECH_UNITS, :l)
    export l
    eval(exponents_superscripts(:l))
end

begin
    @unit dl     "dl"      DesiLiter  (1//10000)m³ false
    push!(MECH_UNITS, :dl)
    export dl
    eval(exponents_superscripts(:dl))
end

begin
    @unit cl     "cl"      CentiLiter  (1//100000)m³ false
    push!(MECH_UNITS, :cl)
    export cl
    eval(exponents_superscripts(:cl))
end

begin
    @unit ml     "ml"      MilliLiter  (1//1000000)m³ false
    push!(MECH_UNITS, :ml)
    export ml
    eval(exponents_superscripts(:ml))
end

begin
    @unit g     "g"      "StandardGravity"  9.80665m/s² false
    push!(MECH_UNITS, :g)
    export g
    eval(exponents_superscripts(:g))
end

begin
    @unit kip     "kip"      "KiloPoundForce"  1000lbf false
    push!(MECH_UNITS, :kip)
    export kip
    eval(exponents_superscripts(:kip))
end

begin
    @unit shton     "shton"      "ShortTon"  2000lb false
    push!(MECH_UNITS, :shton)
    export shton
    eval(exponents_superscripts(:shton))
end

@show MECH_UNITS


# Define derived dimensions promotions
#= example
[100000.0N 10daN]
1×2 Array{Float64{kN},2}:
 100.0  0.1
=#

Unitfu.promote_unit(::S, ::T) where
{S<:ForceFreeUnits, T<:ForceFreeUnits} = kN

#= example
[10N/mm^2 100000000N/m^2]
1×2 Array{Rational{Int64}{MPa},2}:
(10//1)  (100//1)
=#
Unitfu.promote_unit(::S, ::T) where
{S<:PressureFreeUnits, T<:PressureFreeUnits} = MPa

#= example
[10000000N*mm 1000.0J]
1×2 Array{Float64{kNm},2}:
 10.0  1.0
=#
Unitfu.promote_unit(::S, ::T) where
{S<:EnergyFreeUnits, T<:EnergyFreeUnits} = kNm

#= example
[1.0kg/mm³ 2kg/m/m/m]

1×2 Array{Float64{cm²},2}:
 1000.0  100.0
=#
Unitfu.promote_unit(::S, ::T) where
{S<:AreaFreeUnits, T<:AreaFreeUnits} = cm²


#= example
 [1.0mg/mm³ 2kg/m/m/m]
1×2 Array{Float64{kg∙m^-3},2}:
 1000.0  2.0
=#
Unitfu.promote_unit(::S, ::T) where
{S<:DensityFreeUnits, T<:DensityFreeUnits} = kg/m³

#= example
[1/12*100mm*40mm^3/50mm 1l]
1×2 Array{Float64{cm³},2}:
 0.00666667  1000.0
=#
Unitfu.promote_unit(::S, ::T) where
{S<:VolumeFreeUnits, T<:VolumeFreeUnits} = cm³
