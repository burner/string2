module string2.tests;

import string2.type;
import core.exception : AssertError;
import core.stdc.stdio : printf;
import std.conv;

unittest {
    auto s = String("Hello");
    assert(s.isNullTerminated());
    assert(s.length == 5);
    assert(s == "Hello");
    assert(s != "World");
    assert(s != "Wor");

    auto r = String(s);
    assert(r.isNullTerminated());
    assert(r == "Hello");
    s = "Hello";
    assert(s.isNullTerminated());
    assert(s == "Hello");
    r = s;
    assert(r.isNullTerminated());
    assert(r == "Hello");
}

unittest {
    string i = "Hello World Hello World Hello World Hello World Hello "
        ~ "World Hello World Hello World Hello World Hello World Hello World";
    auto s = String(i);
    assert(s.isNullTerminated());
    assert(s.length > 60);
    assert(s == i);

    auto r = String(s);
    assert(r.isNullTerminated());
    assert(r == i);
    s = r;
    assert(s.isNullTerminated());
    assert(s == i);
}

unittest {
    string i = "Hello";
    auto s = String(i);
    assert(s.isNullTerminated());
    foreach(c; 0 .. i.length) {
        assert(s[c] == i[c]);
    }
}

unittest {
    String s = "Hello";
    s[0] = 'h';
    assert(s.isNullTerminated());
    assert(s == "hello");
}

unittest {
    string i = "Hello World Hello World Hello World Hello World Hello "
        ~ "World Hello World Hello World Hello World Hello World Hello World";
    auto s = String(i);
    assert(s.isNullTerminated());
    assert(s.length > 60);
    s[0] = 'h';
    assert(s[0] == 'h');
    assert(s.isNullTerminated());
}

unittest {
    String h = "Hello ";
    assert(h.isNullTerminated());
    String w = "World";
    assert(w.isNullTerminated());
    String.append(h, w);
    assert(h == "Hello World");
    assert(h.isNullTerminated());
}

unittest {
    String h = "Hello Hello Hello Hello Hello Hello Hello ";
    assert(h.isNullTerminated());
    String w = "Hello Hello Hello Hello Hello Hello Hello ";
    assert(w.isNullTerminated());
    string ct = "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello "
        ~ "Hello Hello Hello Hello ";
    String.append(h, w);
    assert(h.isNullTerminated());
    cmpString(h, ct);
}

unittest {
    String h = "Hello Hello Hello Hello Hello Hello Hello ";
    assert(h.isNullTerminated());
    string w = "Hello Hello Hello Hello Hello Hello Hello ";
    string ct = "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello "
        ~ "Hello Hello Hello Hello ";
    String.append(h, w);
    assert(h.isNullTerminated());
    cmpString(h, ct);
}

unittest {
    String s = "Hello";
    s ~= " World";
    s ~= String("!");

    cmpString(s, "Hello World!");
}

/** popFront
*/
unittest { // stay in direct
    String h = "Hello World";
    h.popFront(6);
    assert(h.isNullTerminated());
    cmpString(h, "World");
}

unittest { // move from heap to direct
    string ct = "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello "
        ~ "Hello Hello Hello Hello ";
    String h = ct;
    h.popFront(40);
    assert(h.isNullTerminated());
    cmpString(h, ct[40 .. $]);
}

unittest { // stay in heap
    string ct = "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello "
        ~ "Hello Hello Hello Hello ";
    String h = ct;
    h.popFront(4);
    assert(h.isNullTerminated());
    cmpString(h, ct[4 .. $]);
}

void cmpString(ref const(String) a, string b, int line = __LINE__) {
    if(a.length != b.length) {
        throw new AssertError("a.length = "
            ~ to!(string)(a.length)
            ~ " != b.length = "
            ~ to!(string)(b.length), __FILE__, line);
    }
    foreach(idx; 0 .. a.length) {
        if(a[idx] != b[idx]) {
            throw new AssertError("idx " ~ to!(string)(idx)
                ~ " a = '" ~ a[idx] ~ "' b = '" ~ b[idx] ~ "'"
                ,  __FILE__, line);
        }
    }
}
