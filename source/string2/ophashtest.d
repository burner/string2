module string2.ophashtest;

import string2.type;

@safe pure:

unittest {
	String h = "Hello";
	size_t hh = h.opHash();
	String w = "hello";
	size_t wh = w.opHash();
	assert(hh != wh);
}
