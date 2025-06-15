module string2.type;

import core.internal.hash;
import core.exception : RangeError;
import core.memory;
import std.stdio;

import string2.helper;

struct String {
@safe pure:
	enum SmallStringSize = 59;
	package struct Ptr {
		ulong capacity;
		char* ptr;
	}
	package union {
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

	size_t opHash() const {
		return hashOf(this.toStringD());
	}

	char opIndex(size_t idx) const {
		if(idx >= this.length) {
			throw new RangeError("out of bounds access attempt");
		}
		if(this.len < SmallStringSize) {
			return this.direct[idx];
		} else {
			return () @trusted {
				return this.ptr.ptr[idx];
			}();
		}
	}

	String opSlice(size_t low, size_t high) {
		if(low > high) {
			throw new Exception("The low slice index must not be greater than "
					~ "the high slice index");
		}
		if(high > this.length) {
			throw new Exception("The high slice index must not be greater than "
					~ "the length of the String to slice");
		}

		size_t toStore = high - low + 1;
		String ret;
		if(toStore < SmallStringSize) {
			if(this.len < SmallStringSize) {
				ret.direct = this.direct[low .. high];
				ret.direct[high] = '\0';
			} else {
				() @trusted {
					ret.direct = this.ptr.ptr[low .. high];
				}();
				ret.direct[high] = '\0';
			}
		} else {
			() @trusted {
				ret.ptr.capacity = roundUpTo64(toStore);
				ret.ptr.ptr = allocateCharArray(ret.ptr.capacity);
				ret.ptr.ptr[0 .. toStore] = this.ptr.ptr[low .. high];
			}();
		}
		ret.len = cast(uint)toStore;
		return ret;
	}

	void opIndexAssign(char v, size_t idx) {
		if(idx >= this.length) {
			throw new RangeError("out of bounds access attempt");
		}
		if(this.len < SmallStringSize) {
			this.direct[idx] = v;
		} else {
			() @trusted {
				this.ptr.ptr[idx] = v;
			}();
		}
	}

	String opBinary(string op: "~")(ref const(String) rhs) const {
		String ret;
		String.append(ret, this);
		String.append(ret, rhs);
		return ret;
	}

	String opBinary(string op: "~")(string rhs) const {
		String ret;
		String.append(ret, this);
		String.append(ret, rhs);
		return ret;
	}

	void opOpAssign(string op: "~")(ref const(String) rhs) {
		String.append(this, rhs);
	}

	void opOpAssign(string op: "~")(String rhs) {
		String.append(this, rhs);
	}

	void opOpAssign(string op: "~")(string rhs) {
		String.append(this, rhs);
	}

	void opOpAssign(string op: "~")(char rhs) {
		uint newLen = this.len + 1;
		if(newLen < SmallStringSize) {
			this.direct[this.len] = rhs;
			this.len = cast(uint)(this.len + 1);
			this.direct[this.len] = '\0';
		} else if(newLen >= SmallStringSize) {
			() @trusted {
			if(this.len < SmallStringSize) {
				String tmp = this;
				this.ptr.capacity = roundUpTo64(newLen);
				this.ptr.ptr = allocateCharArray(this.ptr.capacity);
				this.ptr.ptr[0 .. tmp.len] = tmp.direct[0 .. tmp.len];
				this.ptr.ptr[tmp.len] = rhs;
				this.ptr.ptr[tmp.len + 1] = '\0';
			} else {
				if(newLen > this.ptr.capacity) {
					this.ptr.capacity = roundUpTo64(newLen);
					this.ptr.ptr = cast(char*)GC.realloc(cast(void*)this.ptr.ptr
							, this.ptr.capacity);
				}
				this.ptr.ptr[this.len] = rhs;
				this.ptr.ptr[this.len + 1] = '\0';
			}
			}();
			this.len = cast(uint)newLen;
		}
	}

	bool isNullTerminated() const {
		if(this.len < SmallStringSize) {
			return this.direct[this.len] == '\0';
		} else {
			return () @trusted {
				return this.ptr.ptr[this.len] == '\0';
			}();
		}
	}

	@property bool empty() const nothrow {
		return this.len == 0;
	}

	@property bool notEmpty() const nothrow {
		return this.len > 0;
	}

	scope const(char)* toStringC() const @trusted {
		if(this.len < SmallStringSize) {
			return this.direct.ptr;
		} else {
			return this.ptr.ptr;
		}
	}

	scope string toStringD() const @trusted {
		return cast(string)this.toStringC()[0 .. this.len];
	}

	void popFront(uint cntToPop) {
		cntToPop = cntToPop > this.len ? this.len : cntToPop;
		uint remaining = this.len - cntToPop;
		if(this.len < SmallStringSize) {
			for(uint i = 0; i < remaining; ++i) {
				this.direct[i] = this.direct[i + cntToPop];
			}
			this.direct[remaining] = '\0';
		} else if(remaining < SmallStringSize && this.len > SmallStringSize) {
			// heap can be freed now
			() @trusted {
				const(char)* ptrC = this.ptr.ptr;
				for(uint i = 0; i < remaining; ++i) {
					this.direct[i] = ptrC[i + cntToPop];
				}
				GC.free(cast(void*)ptrC);
			}();
			this.direct[remaining] = '\0';
		} else { // stays on the heap
			() @trusted {
				for(uint i = 0; i < remaining; ++i) {
					this.ptr.ptr[i] = this.ptr.ptr[i + cntToPop];
				}
				this.ptr.ptr[remaining] = '\0';
			}();
		}
		this.len = remaining;
	}

	void popBack(size_t cntToPop) {
		cntToPop = cntToPop > this.len ? this.len : cntToPop;
		uint remaining = cast(uint)(this.len - cntToPop);
		if(this.len < SmallStringSize) {
			this.direct[remaining] = '\0';
		} else if(remaining < SmallStringSize && this.len > SmallStringSize) {
			// heap can be freed now
			() @trusted {
				const(char)* ptrC = this.ptr.ptr;
				for(uint i = 0; i < remaining; ++i) {
					this.direct[i] = ptrC[i];
				}
				GC.free(cast(void*)ptrC);
			}();
			this.direct[remaining] = '\0';
		} else { // stays on the heap
			() @trusted {
				this.ptr.ptr[remaining] = '\0';
			}();
		}
		this.len = remaining;
	}

	int opApply(scope int delegate(char n) @safe dg) {
		const(char)* strPtr = this.toStringC();
		auto del = assumePure(dg);
		for(size_t i = 0; i < this.len; ++i) {
			int result = del(() @trusted { return strPtr[i]; }());
			if(result) {
				return result;
			}
		}
		return 0;
	}

	int opApply(scope int delegate(size_t idx, char n) @safe dg) {
		const(char)* strPtr = this.toStringC();
		auto del = assumePure(dg);
		for(size_t i = 0; i < this.len; ++i) {
			int result = del(i, () @trusted { return strPtr[i]; }());
			if(result) {
				return result;
			}
		}
		return 0;
	}

	private void assign(ref const(String) rhs) {
		if(rhs.length < SmallStringSize) {
			this.direct[0 .. rhs.length + 1] = rhs.direct[0 .. rhs.length + 1];
		} else {
			() @trusted {
				this.ptr.capacity = roundUpTo64(rhs.length);
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
				this.ptr.capacity = roundUpTo64(s.length);
				this.ptr.ptr = allocateCharArray(this.ptr.capacity);
				this.ptr.ptr[0 .. s.length] = s[];
				this.ptr.ptr[s.length] = '\0';
			}();
		}
		this.len = cast(uint)s.length;
	}

	static void append(ref String sink, string src) {
		/* ss = small space, h = Heap
			| Sink | Rslt | Copy From ss |
			| ss   | ss   | No
			| ss   | h	  | Yes
			| h	   | h	  | No
		*/
		const newLen = sink.len + src.length;
		if(newLen < SmallStringSize) {
			sink.direct[sink.len .. sink.len + src.length] = src[0 .. src.length];
			sink.len = cast(uint)(sink.len + src.length);
			sink.direct[sink.len] = '\0';
		} else if(newLen >= SmallStringSize) {
			() @trusted {
			if(sink.len < SmallStringSize) {
				String tmp = sink;
				sink.ptr.capacity = roundUpTo64(newLen);
				sink.ptr.ptr = allocateCharArray(sink.ptr.capacity);
				sink.ptr.ptr[0 .. tmp.len] = tmp.direct[0 .. tmp.len];
				sink.ptr.ptr[tmp.len .. tmp.len + src.length] = src[0 .. src.length];
				sink.ptr.ptr[tmp.len + src.length] = '\0';
			} else {
				if(newLen > sink.ptr.capacity) {
					sink.ptr.capacity = roundUpTo64(newLen);
					sink.ptr.ptr = cast(char*)GC.realloc(cast(void*)sink.ptr.ptr, newLen);
				}
				sink.ptr.ptr[sink.len .. sink.len + src.length] = src[0 .. src.length];
				sink.ptr.ptr[sink.len + src.length] = '\0';
			}
			}();
			sink.len = cast(uint)newLen;
		}
	}

	static void append(ref String sink, ref inout(String) src) {
		/* ss = small space, h = Heap
			| Sink | Src | Rslt | Copy From SS |
			| ss   | ss  | ss   | No
			| ss   | ss  | h	| Yes
			| ss   | h   | h	| Yes
			| h	   | ss  | h	| No
			| h	   | h   | h	| No
		*/
		const newLen = sink.len + src.len;
		if(newLen < SmallStringSize) {
			sink.direct[sink.len .. sink.len + src.len] = src.direct[0 .. src.len];
			sink.len = sink.len + src.len;
			sink.direct[sink.len] = '\0';
		} else if(newLen >= SmallStringSize) {
			() @trusted {
			if(sink.len < SmallStringSize && src.len < SmallStringSize) {
				String tmp = sink;
				sink.ptr.capacity = roundUpTo64(newLen);
				sink.ptr.ptr = allocateCharArray(sink.ptr.capacity);
				sink.ptr.ptr[0 .. tmp.len] = tmp.direct[0 .. tmp.len];
				sink.ptr.ptr[tmp.len .. tmp.len + src.len] = src.direct[0 .. src.len];
				sink.ptr.ptr[tmp.len + src.len] = '\0';
			} else if(sink.len < SmallStringSize && src.len >= SmallStringSize) {
				String tmp = sink;
				sink.ptr.capacity = roundUpTo64(newLen);
				sink.ptr.ptr = allocateCharArray(sink.ptr.capacity);
				sink.ptr.ptr[0 .. tmp.len] = tmp.direct[0 .. tmp.len];
				sink.ptr.ptr[tmp.len .. tmp.len + src.len] = src.ptr.ptr[0 .. src.len];
				sink.ptr.ptr[tmp.len + src.len] = '\0';
			} else if(sink.len >= SmallStringSize && src.len < SmallStringSize) {
				if(newLen > sink.ptr.capacity) {
					sink.ptr.capacity = roundUpTo64(newLen);
					sink.ptr.ptr = cast(char*)GC.realloc(cast(void*)sink.ptr.ptr, newLen);
				}
				sink.ptr.ptr[sink.len .. sink.len + src.len] = src.direct[0 .. src.len];
				sink.ptr.ptr[sink.len + src.len] = '\0';
			} else { // if(sink.len >= SmallStringSize && src.len >= SmallStringSize) {
				if(newLen > sink.ptr.capacity) {
					sink.ptr.capacity = roundUpTo64(newLen);
					sink.ptr.ptr = cast(char*)GC.realloc(cast(void*)sink.ptr.ptr, newLen);
				}
				sink.ptr.ptr[sink.len .. sink.len + src.len] = src.ptr.ptr[0 .. src.len];
				sink.ptr.ptr[sink.len + src.len] = '\0';
			}
			}();
			sink.len = newLen;
		}
	}
}

static assert(String.sizeof == 64);

private char* allocateCharArray(size_t len) @trusted pure {
	return cast(char*)GC.malloc(len);
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
