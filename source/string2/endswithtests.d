module string2.endswithtest;

import string2.type;
import string2.endswith;

@safe pure:

unittest {
    assert(String("Hello").endsWith("lo"));
    assert(String("Hello").endsWith(String("lo")));

    assert(!String("Hello").endsWith("He"));
    assert(!String("Hello").endsWith(String("He")));
}


