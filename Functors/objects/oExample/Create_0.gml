testFunctor = new Functor()

testDelegate1 = new Delegate()

testDelegate2 = new Delegate()

testBinder1 = new FunctionBinder(function(w, h)
	{
	}
)

testBinder2 = new FunctionBinder(testDelegate1)

testBinder3 = new FunctionBinder(testDelegate2)

testSetter = new Setter()

testProperty1 = new Property(0)


testProperty2 = new Property("")

function TestClass2() constructor
{
}

testProperty2 = new Property(new TestClass2())

screenSize = [0, 0]
