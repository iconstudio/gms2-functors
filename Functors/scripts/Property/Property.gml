	/// @param { Any } [value]
function Property() constructor
{
	/// @param { Any } current_value
	/// @param { Any } value
	/// @param { Any } [args...]
	/// @self Property
	/// @pure
	static defaultSetter = function(current_value, value)
	{
		return value
	}

	/// @param { Any } current_value
	/// @self Property
	/// @pure
	static defaultGetter = function(current_value)
	{
		return current_value
	}

	myValue = 0 < argument_count ? argument[0] : undefined
	mySetter = defaultSetter
	myGetter = defaultGetter

	/// @param { Function|Struct.Functor|Undefined } setter - function(current, value, ...) -> value
	/// @self Property
	static SetSetter = function(setter)
	{
		if is_method(setter)
		{
			mySetter = setter
		}
		else if is_callable(setter)
		{
			mySetter = method(self, setter)
		}
		else if is_struct(setter)
		{
			mySetter = setter
		}
		else if is_undefined(setter)
		{
			mySetter = setter
		}
		else
		{
			RaiseInvalidTypeOfParameter(false, "setter")
		}
	}

	/// @param { Function|Struct.Functor|Undefined } getter
	/// @self Property
	static SetGetter = function(getter)
	{
		if is_method(getter)
		{
			myGetter = getter
		}
		else if is_callable(getter)
		{
			myGetter = method(self, getter)
		}
		else if is_struct(getter)
		{
			myGetter = getter
		}
		else if is_undefined(getter)
		{
			myGetter = getter
		}
		else
		{
			RaiseInvalidTypeOfParameter(false, "getter")
		}
	}

	/// @param { Any } value
	/// @param { Any } [args...]
	/// @self Property
	static Set = function(value)
	{
		if is_callable(mySetter)
		{
			if 1 < argument_count
			{
				var temp = [myValue, value]

				for (var i = 0; i < argument_count; ++i)
				{
					array_push(temp, argument[i])
				}

				script_execute_ext(mySetter, temp)
			}
			else
			{
				myValue = mySetter(myValue, value)
			}
		}
		else if is_struct(mySetter) and is_instanceof(mySetter, Functor)
		{
			if 1 < argument_count
			{
				var temp = [myValue, value]

				for (var i = 0; i < argument_count; ++i)
				{
					array_push(temp, argument[i])
				}

				myValue = mySetter.InvokeFrom(temp)
			}
			else
			{
				myValue = mySetter.Invoke(myValue, value)
			}
		}
		else if isundef(mySetter)
		{
			Assert(argument_count == 1, "Null reference found at the setter while getting invoked with multiple parameters.")

			myValue = value
		}
		else
		{
			RaiseInvalidTypeOfParameter(false, "setter")
		}
	}

	/// @self Property
	/// @pure
	static Get = function()
	{
		if is_callable(myGetter)
		{
			return myGetter(myValue)
		}
		else if is_struct(myGetter) and is_instanceof(myGetter, Functor)
		{
			return myGetter.Invoke(myValue)
		}
		else if is_struct(myGetter) and is_instanceof(myGetter, FunctionBinder)
		{
			return myGetter.Invoke(myValue)
		}
		else if isundef(myGetter)
		{
			return myValue
		}
		else
		{
			RaiseInvalidTypeOfParameter(false, "getter")
		}
	}
}
