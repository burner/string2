module string2.indexoftests;

import string2.type;
import string2.indexof;

@safe pure:

unittest {
    assert(String("Hello").indexOf('H') == 0);
    assert(String("Hello").indexOf('h') == 5);
}

unittest {
    assert(String("Hello World").indexOf("World") == 6);
    assert(String("Hello World").indexOf(String("World")) == 6);

    String h = "Hello World";
    String w = "World";
    assert(h.indexOf(w) == 6);
    assert(h.indexOf("World") == 6);
}

unittest {
    String h = "Hello";
    String w = "Hello World";
    String j = "olloh";

    assert(h.indexOf(w) == 5);
    assert(h.indexOf(j) == 5);
    assert(h.indexOf("Hello World") == 5);
    assert(h.indexOf("olloH") == 5);
}
