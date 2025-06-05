module string2.reversetest;

import string2.type;
import string2.reverse;
import string2.testhelper;

@safe pure:
unittest {
    String s = "Hello";
    s.reverse();
    cmpString(s, "olleH");
}

unittest {
    String s = "abcd";
    s.reverse();
    cmpString(s, "dcba");
}

unittest {
    string i = "Hello World Hello World Hello World Hello World Hello World "
        ~ "Hello World Hello World Hello World Hello World Hello World"
        ~ "Hello World Hello World Hello World Hello World Hello World";
    String s;
    s.reverse();
    foreach(idx; 0 .. s.length) {
        assert(s[idx] == i[$ - idx - 1]);
    }
}
