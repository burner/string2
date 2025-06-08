module string2.strip;

import string2.type;

pure @safe:

void stripLeftInPlace(ref String str, in String toStrip) {
	uint striped;

	const(char)* strPtr = str.toStringC();
	const(char)* toStripPtr = toStrip.toStringC();

	outer: for(; striped < str.length; ++striped) {
		for(uint i = 0; i < toStrip.length; ++i) {
			if(() @trusted { return strPtr[striped] != toStripPtr[i]; }()) {
				break outer;
			}
		}
	}
	str.popFront(striped);
}

void stripRightInPlace(ref String str, in String toStrip) {
	int striped;

	const(char)* strPtr = str.toStringC();
	const(char)* toStripPtr = toStrip.toStringC();

	outer: for(; striped < str.length; ++striped) {
		for(uint i = 0; i < toStrip.length; ++i) {
			if(() @trusted { return strPtr[str.length - 1 - striped] != toStripPtr[i]; }()) {
				break outer;
			}
		}
	}
	str.popBack(striped);
}
