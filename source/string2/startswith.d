module string2.startswith;

import string2.type;

@safe pure:

bool startsWith(in const(String) toSearchIn, in const(String) toSearch) {
    if(toSearchIn.length < toSearch.length) {
        return false;
    }
    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(toSearch[idx] != toSearchIn[idx]) {
            return false;
        }
    }
    return true;
}

bool startsWith(in const(String) toSearchIn, in const(string) toSearch) {
    if(toSearchIn.length < toSearch.length) {
        return false;
    }
    for(size_t idx = 0; idx < toSearch.length; ++idx) {
        if(toSearch[idx] != toSearchIn[idx]) {
            return false;
        }
    }
    return true;
}
