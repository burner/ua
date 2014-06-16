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
    	foreach(it; __traits(getAttributes, T)) {
    		if(is(typeof(it) == A)) {
    			A ret;
    			ret.value = it.value;
    			return ret;
    		}
    	}
    
    	assert(false);
    }
    
    unittest {
    	A a = getA!C();
    	assert(a.value == "hello");
    }
    
    unittest {
    	A a = getA!B();
    	assert(a.value == "");
    }
