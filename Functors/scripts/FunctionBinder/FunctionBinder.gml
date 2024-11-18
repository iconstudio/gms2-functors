/// @param { Function|Struct.Functor|Struct.Delegate} fun
function FunctionBinder(fun) constructor
{
	myData = fun

	myPlaceholders = []
	/// @ignore
	preplacedParams = []
	/// @ignore
	isCached = false

	/// @param { Struct.IFunctionParameterPlaceholder} placeholder
	/// @self FunctionBinder
	static AddPlaceholder = function(placeholder)
	{
		Assert(not is_undefined(placeholder), "Null reference found at the parameter 'placeholder'.")

		var index = placeholder.GetIndex()
		Assert(not array_contains(preplacedParams, index), $"Duplicated placed parameters are not allowed at {index}.")

		array_push(myPlaceholders, placeholder)

		array_push(preplacedParams, index)

		isCached = false
	}

	/// @self FunctionBinder
	static ClearPlaceholders = function()
	{
		array_foreach(myPlaceholders, function(p, i) { delete p })

		myPlaceholders = []
		preplacedParams = []

		isCached = false
	}

	/// @param { Any } [args...]
	/// @return Any*
	/// @self FunctionBinder
	static Invoke = function()
	{
		var len = array_length(myPlaceholders)
		var cnt = argument_count + len

		var params = array_create(cnt)

		if 0 < len // There are binded parameters
		{
			if not isCached
			{}

			for (var i = 0; i < len; ++i)
			{
				var placeholder = myPlaceholders[i]
				Assert(not is_undefined(placeholder), "Null reference found.")

				var index = placeholder.GetIndex()
				Assert(0 <= index, "Invalid placeholder, cannot use negative index.")
				Assert(index < cnt, $"A placeholder at {index} is out of range.")
				//

				params[index] = placeholder.Get()
			}
		}
		else // There is no binded arguments
		{}

		if not isCached
		{
			isCached = true
		}

		if 0 < argument_count // There are extra parameters
		{
			var preplaced_cnt = array_length(preplacedParams)

			var arg_place = 0
			var arg_next = 0

			while arg_next < argument_count
			{
				if array_contains(preplacedParams, arg_place)
				{
					// Continue
					arg_place += 1
				}
				else
				{
					params[arg_place++] = argument[arg_next++]
				}
			}
		}
		else
		{}

		if 0 == cnt
		{
			if is_struct(myData)
			{
				if is_instanceof(myData, Functor)
				{
					return myData.Invoke()
				}
				else if is_instanceof(myData, Delegate)
				{
					return myData.Invoke()
				}
				else
				{
					Assert(false, "The invoker has wrong type.")
				}
			}
			else
			{
				Assert(is_callable(myData), "The invocable object is not alive.")

				return myData()
			}
		}
		else
		{
			if is_struct(myData)
			{
				if is_instanceof(myData, Functor)
				{
					return myData.InvokeFrom(params)
				}
				else if is_instanceof(myData, Delegate)
				{
					return myData.InvokeFrom(params)
				}
				else
				{
					Assert(false, "The invoker has a wrong type.")
				}
			}
			else
			{
				Assert(is_callable(myData), "The invocable object is not alive.")

				return script_execute_ext(myData, params)
			}
		}
	}
}
