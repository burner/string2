module string2test;

import string2;

unittest {
    auto s = String("Hello");
    assert(s.length == 5);
    assert(s == "Hello");

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
