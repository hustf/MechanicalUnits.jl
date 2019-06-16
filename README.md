# MechanicalUnits

[![Build Status](https://ci.appveyor.com/api/projects/status/github/hustf/MechanicalUnits.jl?svg=true)](https://ci.appveyor.com/project/hustf/MechanicalUnits-jl)
[![Coveralls](https://coveralls.io/repos/github/hustf/MechanicalUnits.jl/badge.svg?branch=master)](https://coveralls.io/github/hustf/MechanicalUnits.jl?branch=master)


  - [Usage](#usage)
  - [Goals](#goals)
  - [Alternatives](#alternatives)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [License](#license)


### Low-effort calculator with units in the REPL
If you're working with quantities, units can be of help. Still, we tend to drop them while doing side calculations or writing programs. Using units has to come at practically no cost if we're not going to drop them while doing quick side calculations. That's the aim of this package.

Keeping the units in gives:
* Fewer mistakes
* More pattern recognition
* Hints to find wrong input
* Quicker problem solving
* More ways to understand a physical problem or read a calculation

## Usage
```julia
using MechanicalUnits
# which car to use?
70l / 42MJ/kg / 0.745kg/l / 0.8l/10km

75kWh/12.2kWh/100km

# Which wire rope diameter to pick?
E=206GPa
A = 1mm*1mm*0.741
E*A/10100mmm
20.40N/mm
ans*100kg*g
2000mm
```
Base.delete_method(@which foo(0.2))
Or even better, put 'using MechanicalUnits' in the .julia/config/startup.jl

The exported units can be listed:
```varinfo(MechanicalUnits)```

You may get warning messages when also loading other packages. If that happens, switch to importing just what you need
```import MechanicalUnits: N, kg, m, s, MPa```


## Goals
This adaption of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) aims to make Julia a preferable tool for quick side calculations in an office computer with very limited user permissions.

This means:
* We adapt to the limitations of Windows Powershell, Julia REPL or VSCode.
* We import and reexport a handpicked set of units commonly encountered by mechanical engineers
* Four significant digits output for floating numbers, no trailing zeros. Don't round when that would display zeros to the left of decimal point: `(991mm)^2` -> `983_322mm²`
* `h` is an hour, not Planck's constant
* `in` is reserved by Julia; `inch` is a unit
* `g` is gravity's acceleration, not a gramme
* REPL output can always be parsed as input. We define the bullet operator `∙` (U+2219, \vysmblkcircle + tab) and print e.g. `2.32m∙s^-1`
* Export dimensions to get short type signatures:
```julia
julia> 1m |> typeof
Quantity{Int64,Length,FreeUnits{(m,),Length,nothing}}
``` 
* Prefer length prefixes `μ` and `mm` by default
* Prefer force and moment prefix `k`
* Prefer `MPa`over `N/m²`
* Thousands separator is supported, but limited to an acceptable format for Julia input: ```983_322N∙m```
* Array output moves the units outside: `[0.900mm, 9832inches]` -> `[0.9, 239_912]mm`
* Substitute symbols which can't be displayed in Windows terminals: `𝐓 -> Time`, `𝐋 -> Length`, `𝐌 -> Mass`
* We would like to support unitful complex numbers, as they often appear while solving equations.
* We would like to have supporting plot recipes, but in a separate package.

## Alternatives

[Unitful.jl](https://github.com/PainterQubits/Unitful.jl) lists similar adaptions for other fields.


## Am I missing some essential feature?

- **Nothing is impossible!**

- Open an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and let's make this better together!

- *Bug reports, feature requests, patches, and well-wishes are always welcome.* :heavy_exclamation_mark:

## FAQ

- ***Is this for real?***

Yes. Unlike complex numbers. This is not so far for complex numbers.

*What does this cost?*

It costs nothing if your time is free.

## Contributing

It's the usual github way: fork, develop locally, push a commit to your fork, make a pull request.
For traceability and discussions, please make an [issue](https://github.com/hustf/MechanicalUnits/issues/new) and refer to the pull request.


## License

MechanicalUnits is released under the [MIT License](http://www.opensource.org/licenses/MIT).