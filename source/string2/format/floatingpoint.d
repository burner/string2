module string2.format.floatingpoint;

import core.stdc.math : pow, lround;

import string2.type;
import string2.reverse;
import string2.helper;

import string2.format.formatspec;
import string2.format.insertseparator;
import string2.format.integer;

@safe pure:

void fformattedWriteImplNatural(ref String array, FormatSpec spec, double value) {
	long integral = cast(long)value;
	fformattedWriteImpl(array, spec, integral);

	array ~= '.';

	double f = (value - cast(double)integral) 
            * cast(double)(fpow(10, (spec.precision == 0
					? 6
					: spec.precision)));
	long frac = abs(assumePure(&lround, f));
	String fracArr;
	fformattedWriteImpl(fracArr, spec, frac);
	array ~= fracArr;
}

double fpow(double a, double b) {
    return assumePure(pow(a, b));
}

long abs(long i) @safe pure nothrow {
    return i < 0 ? -i : i;
}
