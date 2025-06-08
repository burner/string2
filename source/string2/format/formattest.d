module string2.format.formattest;

import string2.type;
import string2.format.impl;
import string2.testhelper;

unittest {
    String s;
    fformattedWrite(s, "Hello %s", 10);
    cmpString(s, "Hello 10");
}

unittest {
    String s;
    fformattedWrite(s, "Hello %s", "World");
    cmpString(s, "Hello World");
}

unittest {
    String s;
    fformattedWrite(s, "%5s", 10);
    cmpString(s, "   10");
}
