module string2.opapplytest;

import string2.type;

unittest {
    string h = "Hello";
    String g = h;
    foreach(idx, c; g) {
        assert(c == h[idx]);
    }
}

unittest {
    string h = "Hello";
    String g = h;
    size_t idx;
    foreach(c; g) {
        assert(c == h[idx]);
        ++idx;
    }
}
