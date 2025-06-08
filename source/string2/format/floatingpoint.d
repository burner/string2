module string2.format.floatingpoint;

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
            * cast(double)(powP(10, (spec.precision == 0
					? 6
					: spec.precision)));
	long frac = abs(lroundP(f));
	String fracArr;
	fformattedWriteImpl(fracArr, spec, frac);
	array ~= fracArr;
}

long powP(long base, long exp) pure {
    long ret = 1;
    foreach(i; 0 .. exp) {
        ret *= base;
    }
    return ret;
}

long lroundP(double a) pure {
    long l = cast(long)a;
    double frac = a - l;

    return  frac < 0.5 ? l : (l + 1);
}

unittest {
    assert(lroundP(1.5) == 2);
    assert(lroundP(1.4999) == 1);
}

long abs(long i) @safe pure nothrow {
    return i < 0 ? -i : i;
}
