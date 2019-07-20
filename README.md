# MechanicalUnits

[![Build Status](https://ci.appveyor.com/api/projects/status/github/hustf/MechanicalUnits.jl?svg=true)](https://ci.appveyor.com/project/hustf/MechanicalUnits-jl)
[![Coveralls](https://coveralls.io/repos/github/hustf/MechanicalUnits.jl/badge.svg?branch=master)](https://coveralls.io/github/hustf/MechanicalUnits.jl?branch=master)

  - [Units](#units)
  - [Usage](#usage)
  - [Goals](#goals)
  - [Alternatives](#alternatives)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [License](#license)


### Convenient units in the REPL
Units can be part of the side calculations mechanical and other engineers do every few minutes of a work day. Using units must be quick, nice and easy. That's the aim of this package, built on a slight modification of [Unitful.jl](https://github.com/hustf/Unitful.jl).

The benefits?
* Fewer mistakes
* More pattern recognition
* Hints to find wrong input
* Quicker problem solving
* More ways to understand a problem or read a calculation
* You could pick plot recipes based on units
* You could pick table formats based on units


## Units
| Units | (Derived) dimension | Dimensions |
| ------------- | ------------- | ------------- |
| nm μm μm mm cm dm m km Mm Gm Tm Pm inch ft    | Length       | ᴸ |
| ns μs μs ms s minute d h yr                   | Time         | ᵀ |  
| mg cg kg lb shton                             | Mass         | ᴹ |
| K Ra °C °F                                    | Temperature  | ᶿ |
| Angles                                        | NoDims        | rad ° | 
| N daN kN MN GN lbf kip                        | Force        | ᴸ∙ ᴹ ∙ ᵀ⁻² |
| Pa kPa MPa GPa atm bar                        | Pressure      | ᴹ ∙ ᴸ⁻¹ ∙ ᵀ⁻² |
| J kJ MJ GJ                                    | Energy        | ᴸ² ∙ ᴹ ∙ ᵀ⁻² | 
| Nmm Nm daNm kNm MNm GNm                       | Moment        | ᴸ² ∙ ᴹ ∙ ᵀ⁻² | 
| l dl cl ml                                    | Volume        | ᴸ³ | 
| g                                             | Acceleration  | ᴸ ∙ ᵀ⁻² | 

## Derived dimensions
These are mostly useful for dispatching. We avoid defining common and ambigious derived dimensions. For example, the derived dimension for Length³ = ᴸ³ could be a volume, or just as usefully a first area moment.

| Derived dimension | Dimensions | 
| ------------- | ------------- |
| Area         | ᴸ²            |
| Velocity     | ᴸ / ᵀ         |
| Acceleration | ᴸ / ᵀ²        |
| Force        | ᴸ ∙ ᴹ / ᵀ²    |
| Pressure     | ᴹ / (ᵀ² ∙ ᴸ ) |
| Density      | ᴹ / ᴸ³        |

## Usage
```
julia > ]add MechanicalUnits
```
Colors won't show here. But let us do some side calculations:
```julia
julia> using MechanicalUnits

julia> m_air = 1000kg; c_p = 1.00kJ/(kg*K)
1.0kJ∙kg⁻¹∙K⁻¹

julia> @import_expand ~W   # Watt = Joule / Second is not exported by default.

julia> Q_cp(T1, T2) = m_air*c_p*(T2-T1) |> (kW*h)
Q_cp (generic function with 1 method)

julia> Q_cp(20°C, 985°C)
268.05555555555554kW∙h

julia> dm |> upreferred
mm

julia> preferunits(m)

julia> m_s = [30kg/m 28.8lb/ft]
1×2 Array{Float64{kg∙m⁻¹},2}:
 30.0  42.8591

julia> l_s = 93ft*[3 4]m/s
372ft

julia> m_s.*l_s |> (kg*m)
1×2 Array{Float64{kg∙m∙s⁻¹},2}:
 2551.18  4859.61

julia> E=206GPa; h_y = 100mm; b = 30mm; I = 1/12 * b * h_y^3
2.5e6mm⁴

julia> L = 2m; F=100kg*g |> N
980.665N

julia> F*L^3/(3E*I) |> mm
5.0778770226537215mm

julia> l_wire = 20m

julia> k(d) = E * 0.691 * π/4 * d^2 / l_wire |> N/mm
k (generic function with 1 method)

julia> k.([5 6 8]mm)
1×3 Array{Float64{N∙mm⁻¹},2}:
 139.748  201.237  357.755

julia> δ(d)= F / k(d) |> mm
δ (generic function with 1 method)

julia> δ.([5, 6, 8]mm)
3-element Array{Float64{mm},1}:
  7.017388381199098
  4.873186375832707
 2.7411673364058977

julia> d = 6mm
ERROR: cannot assign variable Unitful.d from module Main
Stacktrace:
 [1] top-level scope at none:0

julia> dimension(d)
 ᵀ

julia> 1d |> s
(86400//1)s

julia> @import_expand ~V ~W ~A  G

julia> sqrt(1G²)
6.6743e-11m³∙kg⁻¹∙s⁻²

julia> [1V*12.0A 2W 1kg*g*1m/2s]*30minute |> kJ
1×3 Array{Float64{kJ},2}:
 21.6  3.6  8.82598

julia> ω = 50*2π*rad/s
π = 3.1415926535897...rad∙s⁻¹

julia> t = (0:0.006:0.02)s
0.0s:0.006s:0.018s

julia> u = 220V*exp.(im∙(ω∙t))
4-element Array{Complex{Float64}{V},1}:
                              220.0 + 0.0im
   -67.98373876248841 + 209.2324335849338im
 -177.98373876248843 - 129.31275550434407im
  177.98373876248843 - 129.31275550434412im

julia> u*1.5A |> J
4-element Array{Complex{Float64}{J∙s⁻¹},1}:
                             330.0 + 0.0im
 -101.97560814373261 + 313.8486503774007im
 -266.97560814373264 - 193.9691332565161im
  266.97560814373264 - 193.9691332565162im

```

As we encountered above, the global namespace is quite cluttered with units by default. For clarity, import just what you need:
```julia
import MechanicalUnits: N, kg, m, s, MPa
```

## Goals
This adaption of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) aims to be a preferable tool for quick side calculations in an office computer with limited user permissions.

This means:
* We adapt to the limitations of Windows Powershell, Julia REPL or VSCode. Substitute symbols which can't be displayed.: `𝐓 -> ᵀ`
* Units have color, which are sort of tweakable: `show(IOContext(stderr, :unitsymbolcolor=>:bold), 1minute)`
* We pick a set of units as commonly used in mechanical industry
* `h` is an hour, not Planck's constant
* `in` is reserved by Julia; `inch` is a unit
* `g` is gravity's acceleration, not a gramme
* Prefer `mm` and `MPa`
* Support division in a similar way as multiplication  , thus: `[1,2]m/s`
* REPL output can always be parsed as input. We define the bullet operator `∙` (U+2219, \vysmblkcircle + tab) and print e.g. `2.32m∙s⁻¹`
* Export dimensions to get shorter type signatures:
```julia
julia> 1m |> typeof
Quantity{Int64, ᴸ,FreeUnits{(Unit{:Meter, ᴸ}(0, 1//1),), ᴸ,nothing}
```
* Units are never plural
* Array output moves the units outside or to the header:
```julia
julia> dist = [900mm, 1.1m]
2-element Array{Float64{mm},1}:
  900.0
 1100.0

julia> print(dist)
[900.0, 1100.0]mm
```
  * support unitful complex numbers

* We would like to:
  * tweak dimension sorting to customary order, thus: `m∙N -> N∙m`. A good alternative is e.g. 
  ```julia
julia> 43N*mm |> Nmm
(43//1)Nmm

```
  * support rounding and customary engineering number formatting, but in a separate package.
  * have supporting plot recipes, but in a separate package.
  * return, instead of an error: `10m |>s -> 10m∙s^-1∙s` 
  * support colorful units with Atom's mime type
  * not rely on a tweaked fork of Unitful, but the original
  * register the package and have full test coverage

## Alternatives
[Unitful.jl](https://github.com/PainterQubits/Unitful.jl) lists similar adaptions for other fields.


## Am I missing some essential feature?

- Open an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and let's make this better together!

- *Bug reports, feature requests, patches, and well-wishes are always welcome.* 

## FAQ

- ***Is this for real?***

Yes. And for imaginary units as well. What about dual numbers? We have not tested yet.

*What does this cost?*

Your time. It may save some, too.

## Contributing

It's the usual github way: fork, develop locally, push a commit to your fork, make a pull request.
For traceability and discussions, please make an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and refer to the pull request.


## License

MechanicalUnits is released under the [MIT License](http://www.opensource.org/licenses/MIT).