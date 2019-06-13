# MechanicalUnits

[![Build Status](https://ci.appveyor.com/api/projects/status/github/hustf/MechanicalUnits.jl?svg=true)](https://ci.appveyor.com/project/hustf/MechanicalUnits-jl)
[![Coveralls](https://coveralls.io/repos/github/hustf/MechanicalUnits.jl/badge.svg?branch=master)](https://coveralls.io/github/hustf/MechanicalUnits.jl?branch=master)


  - [Usage](#usage)
  - [Goals](#goals)
  - [Alternatives](#alternatives)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [License](#license)


### a calculator with units in the REPL
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

You may get warning messages when also loading other packages. If that happens, switch to importing
just what you need
```import MechanicalUnits: N, kg, m, s, MPa```


## Goals
This adaption of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) aims to make Julia a preferable tool for quick side calculations in an office computer with very limited user permissions.

This means:
* We adapt to the limitation of specific consoles: Windows Powershell, Julia REPL or VSCode.
* We import and reexport a specialized set of units commonly encountered by the mechanical or structural engineer.
* Four significant digits output for floating numbers, no trailing zeros. Don't round when that would display zeros to the left of decimal point: `(991mm)^2` -> `983_322mm²`
* `h` is an hour, not Planck's constant
* `in` is reserved by Julia, `inch` is a unit
* REPL output can be always be parsed as input: `2.32 m s^-1` is printed as `2.32m/s`
* Define the bullet operator `∙` (U+2219, \vysmblkcircle + tab). With this, we can write `N∙s` in output and input.
* Export types to get readable and usable type signatures. This exporting may conflict with other unit packages.
* Prefer length prefixes `μ` and `mm` by default
* Prefer force and moment prefix `k`
* Prefer `MPa`over `N/m²`
* Thousands separator is supported, but limited to an acceptable format for Julia input: ```983_322N∙m```
* Array output moves the units outside: `[0.900mm, 9832inches]` -> `[0.9, 239_912]mm`,
* Substitute symbols which can't be displayed in Windows terminals: `𝐓 -> Time`, `𝐋 -> Length`, `𝐌 -> Mass`
* We would like to support unitful complex numbers, as they often appear while solving equations. 

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