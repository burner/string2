module string2.popbacktest;

import string2.type;
import string2.testhelper;

@safe pure:

unittest {
	String h = "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World ";

	h.popBack(h.length);
}

unittest {
	string s = "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World "
		~ "Hello World Hello World Hello World Hello World Hello World ";
	String h = s;

	h.popBack(5);
	cmpString(h, s[0 .. $ - 5]);
}
