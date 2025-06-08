module string2.format.insertwidth;

import string2.type;
import string2.format.formatspec;

@safe pure:

void insertWidth(ref String arr, FormatSpec spec) {
	String tmp;
	int toPad = cast(int)(spec.width - arr.length);
	if(toPad > 0) {
		foreach(_; 0 .. toPad) {
			tmp ~= spec.zero ? '0' : ' ';
		}
		arr = tmp;
	}
}
