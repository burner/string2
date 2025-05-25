module string2;

import core.exception : RangeError;
import core.memory;

struct String {
@safe:
    enum SmallStringSize = 59;
    private struct Ptr {
        uint capacity;
        char* ptr;
    }
    private union {
        // 59 + trailing \0
        char[SmallStringSize + 1] direct;
        Ptr ptr;
    }
    private uint len;

    size_t length() @property const nothrow {
        return this.len;
    }

    this(string s) {
        this.assign(s);
    }

    this(ref return scope String rhs) {
        this.assign(rhs);
    }

    ~this() {
        if(this.len > SmallStringSize) {
            () @trusted {
                GC.free(this.ptr.ptr);
            }();
        }
    }

    void opAssign(string s) {
        this.assign(s);
    }

    void opAssign(String s) {
        this.assign(s);
    }

    bool opEquals(string s) const nothrow {
        if(this.len != s.length) {
            return false;
        } else if(this.len < SmallStringSize) {
            return this.direct[0 .. this.len] == s;
        } else {
            return () @trusted {
                return this.ptr.ptr[0 .. this.len] == s;
            }();
        }
    }

    char opIndex(size_t idx) const {
        if(idx >= this.length) {
            throw new RangeError("out of bounds access attempt");
        }
        if(idx < SmallStringSize) {
            return this.direct[idx];
        } else {
            return () @trusted {
                return this.ptr.ptr[idx];
            }();
        }
    }

    private void assign(ref return scope String rhs) {
        if(rhs.length < SmallStringSize) {
            this.direct[0 .. rhs.length + 1] = rhs.direct[0 .. rhs.length + 1];
        } else {
            () @trusted {
                this.ptr.capacity = cast(uint)roundUpTo64(rhs.length);
                this.ptr.ptr = allocateCharArray(this.ptr.capacity);
                this.ptr.ptr[0 .. rhs.length] = rhs.ptr.ptr[0 .. rhs.length];
                this.ptr.ptr[rhs.length] = '\0';
            }();
        }
        this.len = cast(uint)rhs.length;
    }

    private void assign(string s) {
        if(s.length < SmallStringSize) {
            this.direct[0 .. s.length] = s;
            this.direct[s.length] = '\0';
        } else {
            () @trusted {
                this.ptr.capacity = cast(uint)roundUpTo64(s.length);
                this.ptr.ptr = allocateCharArray(this.ptr.capacity);
                this.ptr.ptr[0 .. s.length] = s[];
                this.ptr.ptr[s.length] = '\0';
            }();
        }
        this.len = cast(uint)s.length;
    }
}

static assert(String.sizeof == 64);

private char* allocateCharArray(size_t len) @trusted {
    const toAlloc = roundUpTo64(len);
    return cast(char*)GC.malloc(toAlloc);
}

private size_t roundUpTo64(size_t len) @safe nothrow pure {
    len++;
    size_t ret = ((len + 63) >> 6) << 6;
    return ret;
}

unittest {
    assert(roundUpTo64(0) == 64);
    assert(roundUpTo64(1) == 64);
    assert(roundUpTo64(64) == 128);
    assert(roundUpTo64(65) == 128);
    assert(roundUpTo64(128) == 192);
}
