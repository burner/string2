module string2.indexof;

import string2.type;

@safe pure:

size_t indexOf(in const(String) toSearchIn, char toSearch) {
	const(char)* ptr = toSearchIn.toStringC();
	for(size_t idx = 0; idx < toSearchIn.length; ++idx) {
		if(() @trusted { return ptr[idx]; }() == toSearch) {
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

	const(char)* toSearchInPtr = toSearchIn.toStringC();
	const(char)* toSearchPtr = toSearch.toStringC();

	outer: for(size_t idx = 0; idx <= toSearchIn.length - toSearch.length; ++idx) {
		for(size_t jdx = 0; jdx < toSearch.length; ++jdx) {
			if(() @trusted { return toSearchPtr[jdx] != toSearchInPtr[idx + jdx]; }()) {
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

	const(char)* toSearchInPtr = toSearchIn.toStringC();
	outer: for(size_t idx = 0; idx <= toSearchIn.length - toSearch.length; ++idx) {
		for(size_t jdx = 0; jdx < toSearch.length; ++jdx) {
			if(() @trusted { return toSearch[jdx] != toSearchInPtr[idx + jdx]; }()) {
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
