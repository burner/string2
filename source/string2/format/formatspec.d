module string2.format.formatspec;

struct FormatSpec {
    ubyte width : 7;
    ubyte base : 5;
    ubyte seperatorWidth : 4;
    char seperator : 8;
    ubyte precision : 5;
}

static assert(FormatSpec.sizeof < 8);
