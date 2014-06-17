    struct A {
    	static A opCall(T...)(T args) {
    		A ret;
    		ret.value = args[0];
    		return ret;
    	}
    
    	string value;
    }
    
    @A struct B {
    }
    
    @A("hello") struct C {
    }
    
    A getA(T)() {
    	A ret;
    	foreach(it; __traits(getAttributes, T)) {
    		static if(is(typeof(it) == A)) {
    			ret.value = it.value;
				break;
    		}
    	}

    	return ret;
    }
    
    unittest {
    	A a = getA!C();
    	assert(a.value == "hello");
    }
    
    unittest {
    	A a = getA!B();
    	assert(a.value == "");
    }
