module string2.format.integer;

import string2.type;
import string2.reverse;

import string2.format.formatspec;
import string2.format.insertseparator;

@safe pure:

void fformattedWriteImpl(ref String sOut, FormatSpec spec, long value) {
    String array;
	int base = spec.base == 0
		? 10
		: spec.base;

	long tmp_value;

	do {
		tmp_value = value;
		value /= base;
		array ~= numChars[35 + (tmp_value - value * base)];
	} while(value);

	if(tmp_value < 0) {
		array ~= '-';
	}
	reverse(array);

	insertSeparator(array, spec);
    sOut ~= array;
}

static const char[71] numChars = 
	"zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz";
