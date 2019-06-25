# These methods pass the correct IOContext to show methods for the type.
# The intention is hiding duplicate output of type info.
function show(io::IO, x::AbstractArray{Quantity{T,D,U}, N})  where {T,D,U,N} # short form
    ioc = IOContext(io, :typeinfo => T)
    show(ioc, ustrip.(x))
    # Now show the unit.
    show_unit(io, first(x))
end
function show(io::IO, mime::MIME"text/plain", x::AbstractArray{Quantity{T,D,U}, N}) where {T,D,U,N} # long form
    # For abstract arrays, the REPL output can't normally be used to make a new and identical instance of 
    # the array. So we don't bother to do that either, in this context.
    # This pair in IOContext specifies an informal type representation,
    # if the opposite is not already specified from upstream.
    pai = Pair(:shorttype, get(io, :shorttype, true))
    ioc = IOContext(io, pai, :dontshowlocalunits=>true)
    # Now call the method which would normally have been called if we didn't slightly interfere here. 
    invoke(show, Tuple{IO, MIME{Symbol("text/plain")}, AbstractArray}, ioc, mime, x)
end
# Todo dictionaries?