module string2.format.floatingpoint;

import string2.type;
import string2.reverse;
import string2.helper;

import string2.format.formatspec;
import string2.format.insertseparator;
import string2.format.integer;
import string2.format.insertwidth;

@safe pure:

void fformattedWriteImplNatural(ref String sOut, FormatSpec spec, double value) {
	String array;
	long integral = cast(long)value;
	FormatSpec cp = spec;
	cp.width = 0;
	fformattedWriteImpl(array, cp, integral);

	array ~= '.';

	double f = (value - cast(double)integral)
			* cast(double)(powP(10, (spec.precision == 0
					? 6
					: spec.precision)));
	long frac = abs(lroundP(f));
	String fracArr;

	cp.minus = false;
	cp.plus = false;
	fformattedWriteImpl(fracArr, cp, frac);
	array ~= fracArr;
	insertWidth(array, spec);

	sOut ~= array;
}

long powP(long base, long exp) nothrow {
	long ret = 1;
	foreach(i; 0 .. exp) {
		ret *= base;
	}
	return ret;
}

long lroundP(double a) nothrow {
	long l = cast(long)a;
	double frac = a - l;

	return  frac < 0.5 ? l : (l + 1);
}

unittest {
	assert(lroundP(1.5) == 2);
	assert(lroundP(1.4999) == 1);
}

long abs(long i) nothrow {
	return i < 0 ? -i : i;
}
