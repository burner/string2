module string2.format.impl;

import string2.type;
import string2.format.impl;
import string2.format.formatspec;
import string2.format.integer;
import string2.format.floatingpoint;
import string2.format.str;

@safe pure:

void fformattedWrite(Args...)(ref String sOut, string format, Args args) {
	//Array arr;
	size_t last = 0;
	size_t cur = 0;
	size_t cur2 = 0;
	size_t argsIdx = 0;
	bool prevIsAmp;
	FormatSpec spec;
	outer: for(; cur < format.length; ) {
		if(prevIsAmp && format[cur] == '%') { // %%
			//arr.reset();
			//sOut(arr, format[last .. cur]);
			sOut ~= format[last .. cur];
			++cur;
			last = cur;
		} else if(prevIsAmp && format[cur] == '.') {
			cur2 = 1;
			int preci = 4;
			if(cur + cur2 < format.length
					&& format[cur + cur2] >= '0'
					&& format[cur + cur2] <= '9')
			{
				preci = format[cur + cur2] - '0';
				++cur2;
			}
			if(cur + cur2 < format.length
					&& format[cur + cur2] >= '0'
					&& format[cur + cur2] <= '9')
			{
				preci = preci * 10 + format[cur + cur2] - '0';
				++cur2;
			}
			cur += cur2;
			spec.precision = cast(ubyte)preci;
		} else if(prevIsAmp && format[cur] == 's') { // %X
			long argIdx;
			//arr.reset();
			//sOut(arr, format[last .. cur - 1 - cur2]);
			sOut ~= format[last .. cur - 1 - cur2];
			static foreach(arg; args) {{
				if(argIdx == argsIdx) {
					formatWriteForward(sOut, spec, arg);
					spec = FormatSpec.init;
					++cur;
					last = cur;
					continue outer;
				}
				++argIdx;
			}}
		} else if(!prevIsAmp && format[cur] == '%') { // %
			prevIsAmp = true;
			++cur;
		} else {
			++cur;
		}
	}
	if(last < cur) {
		//arr.reset();
		//sOut(arr, format[last .. cur]);
		sOut ~= format[last .. cur];
	}
}

private:

void formatWriteForward(T)(ref String sOut, FormatSpec spec, T t) {
	static if(__traits(isUnsigned, T)) {{
		fformattedWriteImpl(sOut, spec, cast(ulong)t);
	}} else static if(__traits(isIntegral, T)) {{
		fformattedWriteImpl(sOut, spec, cast(long)t);
	}} else static if(__traits(isFloating, T)) {{
		fformattedWriteImplNatural(sOut, spec, cast(double)t);
	}} else static if(is(T == string)) {{
		fformattedWriteImpl(sOut, spec, t);
	}}
}
