module string2.helper;

import std.traits : FunctionAttribute, SetFunctionAttributes
    , isFunctionPointer, isDelegate, functionAttributes, functionLinkage;

auto assumePure(T)(T t) @safe pure {
    static assert(isFunctionPointer!T || isDelegate!T);
    enum attrs = functionAttributes!T | FunctionAttribute.pure_;
    return () @trusted { return cast(SetFunctionAttributes!(T, functionLinkage!T, attrs))t; }();
}
