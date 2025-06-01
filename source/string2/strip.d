module string2.strip;

import string2.type;

pure @safe:

void stripLeftInPlace(ref String str, in String toStrip) {
    uint striped;

    const(char)* strPtr = str.toStringZ();
    const(char)* toStripPtr = str.toStringZ();

    outer: for(; striped < str.length; ++striped) {
        for(uint i = 0; i < toStrip.length; ++i) {
            if(() @trusted { return strPtr[striped] != toStripPtr[i]; }()) {
                break outer;
            }
        }
    }
    str.popFront(striped);
}
