module string2test;

import string2;
import core.stdc.stdio : printf;

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
