module string2test;

import string2;
import core.exception : AssertError;
import core.stdc.stdio : printf;
import std.conv;

unittest {
    auto s = String("Hello");
    assert(s.length == 5);
    assert(s == "Hello");
    assert(s != "World");
    assert(s != "Wor");

    auto r = String(s);
    assert(r == "Hello");
    s = "Hello";
    assert(s == "Hello");
    r = s;
    assert(r == "Hello");
}

unittest {
    string i = "Hello World Hello World Hello World Hello World Hello "
        ~ "World Hello World Hello World Hello World Hello World Hello World";
    auto s = String(i);
    assert(s.length > 60);
    assert(s == i);

    auto r = String(s);
    assert(r == i);
    s = r;
    assert(s == i);
}

unittest {
    string i = "Hello";
    auto s = String(i);
    foreach(c; 0 .. i.length) {
        assert(s[c] == i[c]);
    }
}

unittest {
    String s = "Hello";
    s[0] = 'h';
    assert(s == "hello");
}

unittest {
    string i = "Hello World Hello World Hello World Hello World Hello "
        ~ "World Hello World Hello World Hello World Hello World Hello World";
    auto s = String(i);
    assert(s.length > 60);
    s[0] = 'h';
    assert(s[0] == 'h');
}

unittest {
    String h = "Hello ";
    String w = "World";
    String.append(h, w);
    assert(h == "Hello World");
}

unittest {
    String h = "Hello Hello Hello Hello Hello Hello Hello ";
    String w = "Hello Hello Hello Hello Hello Hello Hello ";
    string ct = "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello "
        ~ "Hello Hello Hello Hello ";
    String.append(h, w);
    cmpString(h, ct);
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
