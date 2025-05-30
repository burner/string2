module string2.indexof;

import string2.type;

@safe pure:

size_t indexOf(in const(String) toSearchIn, char toSearch) {
    for(size_t idx = 0; idx < toSearchIn.length; ++idx) {
        if(toSearchIn[idx] == toSearch) {
            return idx;
        }
    }
    return toSearchIn.length;
}

unittest {
    assert(indexOf(String("Hello"), 'e') == 1);
}

size_t indexOf(in const(String) toSearchIn, in const(String) toSearch) {
    if(toSearch.length > toSearchIn.length) {
        return toSearchIn.length;
    }

    outer: for(size_t idx = 0; idx <= toSearchIn.length - toSearch.length; ++idx) {
        for(size_t jdx = 0; jdx < toSearch.length; ++jdx) {
            if(toSearch[jdx] != toSearchIn[idx + jdx]) {
                continue outer;
            }
        }
        return idx;
    }
    return toSearchIn.length;
}

size_t indexOf(in const(String) toSearchIn, in const(string) toSearch) {
    if(toSearch.length > toSearchIn.length) {
        return toSearchIn.length;
    }

    outer: for(size_t idx = 0; idx <= toSearchIn.length - toSearch.length; ++idx) {
        for(size_t jdx = 0; jdx < toSearch.length; ++jdx) {
            if(toSearch[jdx] != toSearchIn[idx + jdx]) {
                continue outer;
            }
        }
        return idx;
    }
    return toSearchIn.length;
}

unittest {
    assert(indexOf(String("Hello World"), "World") == 6);
    assert(indexOf(String("Hello World"), String("World")) == 6);
}
