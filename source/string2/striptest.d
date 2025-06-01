module string2.striptest;

import string2.type;
import string2.strip;

import string2.testhelper;

@safe pure:

unittest {
    String h = "Hello";
    stripLeftInPlace(h, String("H"));
    cmpString(h, "ello");
}
