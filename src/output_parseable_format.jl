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
    show_unit(io, x)
end
function show(io::IO, x::Quantity{T,D,U}) where {T<:Rational, D, U}
    # Add paranthesis: 1//1000m² -> (1//1000)m²
    print(io, "(")
    show(io, x.val)
    print(io, ")")
    show_unit(io, x)
end
"""
Show the unit of x provided io does not have a dictionary entry with the type info.
In that case, the unit information has already been shown.
"""
function show_unit(io::IO, x)
    typeinfo = get(io, :typeinfo, Any)::Type
    if !(x isa typeinfo)
        typeinfo = Any
    end
    eltype_ctx = Base.typeinfo_eltype(typeinfo)
    eltype_x = eltype(x)
    if eltype_ctx != eltype_x
        if !isunitless(unit(x))
            # For elements in abstract arrays, we use typeinfo to get the 
            # wanted format for the header info. In this method, we do not
            # want to redundantly display the remaining type info. 
            # TODO but how? Consider specializing on 
            # Base showarg(io, Quantity, toplevel), or on summary(io, Quantity)
            if !get(io, :dontshowlocalunits, false)
                # The return type is an instance U() of the singleton type U in Quantity{T,D,U},
                # i.e. 'show' dispatches to (io, ::FreeUnits{N,D,A}).
                # Which is great, but the numeric type of x is lost.
                show(io, unit(x))
            end
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
    if get(io, :shorttype, false)
        # Given the shorttype context argument (as in an array of quanities description), 
        # the numeric type and unit symbol is enough info to superficially represent the type.
        print(io, numtype(x),"{")
        ioc = IOContext(io, :dontshowlocalunits=>false)
        show_unit(ioc, T)
        print(io, "}")
    else
        # We show a complete or partial description.
        # This pair in IOContext specifies as fallback a full formal type representation,
        # provided the opposite is not already specified by the caller:
        pa = Pair(:showconstructor, get(io, :showconstructor, true))
        ioc = IOContext(io, :showoperators=>true, pa)
        invoke(show, Tuple{IO, typeof(x)}, ioc, x)
    end
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
# Consider dispatching on AffineUnits{N,D,A}
show(io::IO, x::FreeUnits{N,D,A}) where {N, D, A<:Affine} = showrep(io, x)

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
Pass in 
    IOContext(..., :showconstructor=>true) 
to show a longer more formal form of the unit type, which can be used as a constructor.
This is done internally when the output of vanilla Julia types would also double as constructor.
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
        # Print a longer, more formal definition which can be used as a constructor or inform the interested user.
        print(io, typeof(x), "(", tens(x), ", ", power(x), ")")
    else
        # Print the shortest representation of the unit (of a number), i.e. prefix, unit symbol, superscript.
        # Color output is context-aware. 
        col = get(io, :unitsymbolcolor, :cyan)
        printstyled(io, color = col, prefix(x), abbr(x), supers)
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
function showrep(io::IO, x::FreeUnits{N,D,A}) where {N, D, A<:Affine}
    if get(io, :showconstructor, false)
        # Print a longer, more formal definition which can be used as a constructor or inform the interested user.
        print(io, "FreeUnits{", N, ",", D, ",", A, "}")
    else
        # Print the shortest representation of the affine unit.
        # Color output is context-aware. 
        col = get(io, :unitsymbolcolor, :cyan)
        printstyled(io, color = col, abbr(x))
    end
end