module string2.format.str;

import string2.type;

import string2.format.formatspec;
import string2.format.insertseparator;
import string2.format.insertwidth;

@safe pure:

void fformattedWriteImpl(ref String sOut, FormatSpec spec, string value) {
    String array = value;
	insertSeparator(array, spec);
	insertWidth(array, spec);
    sOut ~= array;
}
