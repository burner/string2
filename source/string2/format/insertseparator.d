module string2.format.insertseparator;

import string2.type;
import string2.format.formatspec;

void insertSeparator(ref String arr, FormatSpec spec) {
	String tmp;

	if(spec.seperator == '\0' && spec.seperatorWidth == 0) {
		return;
	}

	char sep = spec.seperator;
	ubyte step = spec.seperatorWidth == 0
		? 4
		: spec.seperatorWidth;

	foreach(idx; 0 .. arr.length) {
		if(idx != 0 && idx % step == 0) {
			tmp ~= sep;
		}
		tmp ~= arr[idx];
	}

    arr = tmp;
}
