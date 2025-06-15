module string2.opopassigntest;

import string2.type;
import string2.testhelper;

@safe pure:

unittest {
	string h = "Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World ";

	String r;
	foreach(idx; 0 .. h.length) {
		r ~= h[idx];
		cmpString(r, h[0 .. idx + 1]);
	}
	cmpString(r, h);
}
