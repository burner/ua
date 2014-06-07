module ua.mysql;

struct MySQLRsltType(T) {
	T front() @trusted {
		T ret;
		return ret;
	}	

	void popFront() @trusted {
	}

	bool empty() @trusted {
		return true;
	}
}

struct MySQL {
	static MySQL opCall() @trusted {
		MySQL ret;
		return ret;
	}

	MySQLRsltType!T select(T, Args...)(Args args) {
		MySQLRsltType!T ret;
		return ret;
	}
}
