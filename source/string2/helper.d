module string2.helper;

auto assumePure(T,Args...)(T t, Args args) @safe pure {
    import std.traits : FunctionAttribute, SetFunctionAttributes
        , isFunctionPointer, isDelegate, functionAttributes, functionLinkage;

    static assert(isFunctionPointer!T || isDelegate!T);
    enum attrs = functionAttributes!T | FunctionAttribute.pure_;
    return () @trusted { return cast(SetFunctionAttributes!(T, functionLinkage!T, attrs))t; }(args);
}
