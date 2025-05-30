module string2.indexof;

debug import std.stdio;
import string2.type;

@safe pure:

size_t indexOf(String toSearchIn, char toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(ref const(String) toSearchIn, char toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

unittest {
    assert(indexOf(String("Hello"), 'e') == 1);
}

private size_t indexOfImpl(ref const(String) toSearchIn, char toSearch) {
    for(size_t idx = 0; idx < toSearchIn.length; ++idx) {
        if(toSearchIn[idx] == toSearch) {
            return idx;
        }
    }
    return toSearchIn.length;
}

size_t indexOf(String toSearchIn, string toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(ref const(String) toSearchIn, string toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(String toSearchIn, String toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(ref const(String) toSearchIn, String toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(String toSearchIn, ref const(String) toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

size_t indexOf(ref const(String) toSearchIn, ref const(String) toSearch) {
    return indexOfImpl(toSearchIn, toSearch);
}

unittest {
    assert(indexOf(String("Hello World"), "World") == 6);
    assert(indexOf(String("Hello World"), String("World")) == 6);
}

size_t indexOfImpl(ref const(String) toSearchIn, string toSearch) {
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

size_t indexOfImpl(ref const(String) toSearchIn, ref const(String) toSearch) {
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
