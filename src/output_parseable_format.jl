import Base:show
using InteractiveUtils

"""
MechanicalUnits defines the bullet operator `∙` (Unicode U+2219, \vysmblkcircle + tab in Julia). 

The intention of defining it is being able to copy unitful output in the REPL without
having to print units with the `*` symbol.
""" 
∙(a, b) = *(a,b)


#=
We want to print quantities without a space between value and unit.
This means replacing a Unitful method, but enables copying output for easy redefinitions.
For easier reading, we'll also put a bit of colour on units.

Setting the IOContext options
* :showoperators=>true prints a `*` as in Unitful's version.
* :showoperators=>false prints a `∙` instead of space.
=#
Base.delete_method( which( show, (IO, Quantity)))
Base.delete_method( which( show, (IO, MIME"text/plain", Quantity)))

function show(io::IO, x::Quantity)
    show(io, x.val)
    # TODO: Use typeinfo in the same way as normal vector show.... Not true or false.
    # Consider division by the supplied type.
    if !isunitless(unit(x))
        if !get(io, :typeinfo, false)
            show(io, unit(x))
        end
    end
end

function show(io::IO, x::Quantity{T,D,U}) where {T<:Rational, D, U}
    # Add paranthesis: 1//1000m² -> (1//1000)m²
    print(io, "(")
    show(io, x.val)
    print(io, ")")
    if !isunitless(unit(x))
        if !get(io, :typeinfo, false)
            show(io, unit(x))
        end
    end
end

#=
We want to print `typeof` output in a format that works as a constructor. 
Unitful would print 'Quantity{Int64,𝐋,FreeUnits{(m,),𝐋,nothing}}'
We want             'Quantity{Int64,Length,FreeUnits{(Unit{:Meter,Length}(0, 1//1),),Length,nothing}}'
Example
```julia
julia> typeof(2m)(40)
40m
```
=#
Base.delete_method( which( show, (IO, Type{T} where T<:Quantity)))
function show(io::IO, x::Type{T}) where T<:Quantity
    invoke(show, Tuple{IO, typeof(x)}, IOContext(io, :showoperators=>true, :showconstructor=>true), x)
end
#=
We want to print "1kg*2m -> 2kg·m".
This means replacing a Unitful method, but enables copying output for easy redefinitions.

Setting the IOContext options
* :showoperators=>true prints a `*` as in Unitful's version.
* :showoperators=>false prints a `∙` instead of scace.
=#
Base.delete_method( which( show, (IO, Unitlike)))
"""
    show(io::IO, x::Unitlike)
Call showrep on each object in the tuple that is the type
variable of a `Units` or `Dimensions` object.
"""
function show(io::IO, x::Unitlike)
    showoperators = get(io, :showoperators, false)
    first = ""
    sep = showoperators ? "*" : "∙"
    foreach(sortexp(typeof(x).parameters[1])) do y
        print(io,first)
        showrep(io,y)
        first = sep
    end
    nothing
end
show(io::IO, x::typeof(°C)) = printstyled(io, color = :cyan, "°C")
show(io::IO, x::typeof(°F)) = printstyled(io, color = :cyan, "°F")

#=
We want to print units with a somewhat distinguished colour or font.
:cyan is a compromise, seeming visible and not obtrusive on the tried displays.
=#
Base.delete_method( which( showrep, (IO, Unit)))
"""
    showrep(io::IO, x::Unit)
Show the unit, prefixing with any decimal prefix and appending the exponent as
formatted by `superscript`.
Also prints with color when allowed by io.
"""
function showrep(io::IO, x::Unit)
    p = power(x)
    supers = if p == 1//1
                ""
            elseif p == 2//1
                "²"
            elseif p == 3//1
                "³"
            elseif p == 4//1
                "⁴"
            else
                superscript(p)
            end
    if get(io, :showconstructor, false)
        print(io, typeof(x), "(", tens(x), ", ", power(x), ")")
    else
        printstyled(io, color = :cyan, prefix(x), abbr(x), supers)
    end
end


Base.delete_method( which( showrep, (IO, Dimension)))
"""
    showrep(io::IO, x::Dimension)
Show the dimension, appending any exponent as formatted by `superscript`.
"""
function showrep(io::IO, x::Dimension)
    print(io, abbr(x))
    print(io, (power(x) == 1//1 ? "" : superscript(power(x))))
end
