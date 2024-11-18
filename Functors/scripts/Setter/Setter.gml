/// @param { Function|Struct.Functor|Struct.FunctionBinder} delegate
/// @param { Any } [value]
function Setter(delegate) constructor
{
	myValue = 0 < argument_count ? argument[0] : undefined
	myDelegate = delegate

	/// @param { Any } value
	/// @self Setter
	static Set = function(value)
	{
		myValue = value

		if is_struct(myDelegate)
		{
			myDelegate.Invoke(value)
		}
		else if is_callable(myDelegate)
		{
			myDelegate(value)
		}
		else
		{
			Assert(false, "Invalid delegate.")
		}
	}

	/// @return { Any }
	/// @self Setter
	/// @pure
	static Get = function()
	{
		return myValue
	}
}
