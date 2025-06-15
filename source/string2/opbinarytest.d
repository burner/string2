module string2.opbinarytest;

import string2.type;
import string2.testhelper;

@safe pure:

unittest {
	String h = "Hello";
	String w = "World";

	String hw = h ~ " " ~ w;

}
