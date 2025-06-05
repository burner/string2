module string2.reverse;

import string2.type;

@safe pure:

void reverse(ref String str) {
    long left = 0;
    long right = str.length - 1;

    char* ptr;
    () @trusted {
        if(str.length < String.SmallStringSize) {
            ptr = str.direct.ptr;
        } else {
            ptr = str.ptr.ptr;
        }
    }();

    while(left < right) {
        () @trusted {
            char t = ptr[left];
            ptr[left] = ptr[right];
            ptr[right] = t;
        }();
        left++;
        right--;
    }
}
