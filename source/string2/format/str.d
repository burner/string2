module string2.format.str;

import string2.type;

import string2.format.formatspec;
import string2.format.insertseparator;

@safe pure:

void fformattedWriteImpl(ref String sOut, FormatSpec spec, string value) {
    String array = value;
	insertSeparator(array, spec);
    sOut ~= array;
}
