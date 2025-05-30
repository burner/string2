module string2.startswithtests;

import string2.type;
import string2.startswith;

@safe pure:

unittest {
    assert(String("Hello").startsWith("He"));
    assert(String("Hello").startsWith(String("He")));

    assert(!String("Hello").startsWith("he"));
    assert(!String("Hello").startsWith(String("he")));
}

