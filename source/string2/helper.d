module string2.helper;

auto assumePure(T)(T t) @safe pure {
    import std.traits : FunctionAttribute, SetFunctionAttributes
        , isFunctionPointer, isDelegate, functionAttributes, functionLinkage;

    static assert(isFunctionPointer!T || isDelegate!T);
    enum attrs = functionAttributes!T | FunctionAttribute.pure_;
    return () @trusted { return cast(SetFunctionAttributes!(T, functionLinkage!T, attrs))t; }();
}

auto assumePureFun(T)(T t) @safe pure {
    import std.traits : FunctionAttribute, SetFunctionAttributes
        , isFunctionPointer, isDelegate, functionAttributes, functionLinkage;

    static assert(isFunctionPointer!T || isDelegate!T);
    enum attrs = functionAttributes!T | FunctionAttribute.pure_;
    return () @trusted { return cast(SetFunctionAttributes!(T, functionLinkage!T, attrs))t; };
}
