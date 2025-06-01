module string2.endswith;

import string2.type;

@safe pure:

bool endsWith(in const(String) toSearchIn, in const(String) toSearch) {
    if(toSearch.length == 0) {
        return false;
    }

    if(toSearchIn.length < toSearch.length) {
        return false;
    }

    const offSet = toSearchIn.length - toSearch.length;
    const(char)* toSearchInPtr = toSearchIn.toStringZ();
    const(char)* toSearchPtr = toSearch.toStringZ();

    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(() @trusted { return toSearchPtr[idx] != toSearchInPtr[idx + offSet]; }()) {
            return false;
        }
    }
    return true;
}

bool endsWith(in const(String) toSearchIn, in const(string) toSearch) {
    if(toSearch.length == 0) {
        return false;
    }

    if(toSearchIn.length < toSearch.length) {
        return false;
    }

    const offSet = toSearchIn.length - toSearch.length;
    const(char)* toSearchInPtr = toSearchIn.toStringZ();

    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(() @trusted { return toSearch[idx] != toSearchInPtr[idx + offSet]; }()) {
            return false;
        }
    }
    return true;
}
