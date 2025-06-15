module string2.testhelper;

import core.exception : AssertError;
import core.stdc.stdio : printf;
import std.conv;

import string2.type;

@safe pure:

void cmpString(ref const(String) a, string b, string file = __FILE__, int line = __LINE__) {
    if(a.length != b.length) {
        throw new AssertError("a.length = "
            ~ to!(string)(a.length)
            ~ " != b.length = "
            ~ to!(string)(b.length)
			~ " '"
			~ a.toStringD()
			~ "'"
			, file, line);
    }
    foreach(idx; 0 .. a.length) {
        if(a[idx] != b[idx]) {
            throw new AssertError("idx " ~ to!(string)(idx)
                ~ " a = '" ~ a[idx] ~ "' b = '" ~ b[idx] ~ "'"
				~ " '"
				~ a.toStringD()
				~ "'"
                ,  file, line);
        }
    }
}
