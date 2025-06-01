module string2.startswith;

import string2.type;

@safe pure:

bool startsWith(in const(String) toSearchIn, in const(String) toSearch) {
    if(toSearchIn.length < toSearch.length) {
        return false;
    }

    const(char)* toSearchInPtr = toSearchIn.toStringZ();
    const(char)* toSearchPtr = toSearch.toStringZ();

    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(() @trusted { return toSearchPtr[idx] != toSearchInPtr[idx]; }()) {
            return false;
        }
    }
    return true;
}

bool startsWith(in const(String) toSearchIn, in const(string) toSearch) {
    if(toSearchIn.length < toSearch.length) {
        return false;
    }
    const(char)* toSearchInPtr = toSearchIn.toStringZ();

    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(() @trusted { return toSearch[idx] != toSearchInPtr[idx]; }()) {
            return false;
        }
    }
    return true;
}
