function Functor() constructor
{
	static objIndex = 0

	id = objIndex++

	myContext = undefined
	myRunner = undefined

	/// @param { Any } [args...]
	/// @self Functor
	static Invoke = function()
	{
		RaiseNullReferenceFound(not is_undefined(myContext), "myContext")

		if weak_ref_alive(myContext)
		{
			RaiseNullReferenceFound(not is_undefined(myRunner), "myRunner")

			if 0 < argument_count
			{
				var params = array_create(argument_count)

				for (var i = 0; i < argument_count; ++i)
				{
					params[i] = argument[i]
				}

				with myContext.ref
				{
					return script_execute_ext(myRunner, params)
				}
			}
			else
			{
				return myRunner()
			}
		}
		else
		{
			return myRunner()
		}
	}

	/// @param { Array } params
	/// @self Functor
	static InvokeFrom = function(params)
	{
		RaiseNullReferenceFound(not is_undefined(myContext), "myContext")

		if weak_ref_alive(myContext)
		{
			RaiseNullReferenceFound(not is_undefined(myRunner), "myRunner")

			with myContext.ref
			{
				return script_execute_ext(myRunner, params)
			}
		}
		else
		{
			return script_execute_ext(myRunner, params)
		}
	}

	/// @param { Function|Struct|Id.Instance} target - function or context
	/// @param { Asset.GMScript|Function } [method]
	/// @self Functor
	static SetPredicate = function(target)
	{
		if 1 < argument_count
		{
			Assert(is_callable(argument[1]), "The runner is not a callable object.")
			Assert(is_struct(target) or instance_exists(target), "There is no reference of target.")

			myContext = weak_ref_create(target)
			myRunner = method(target, argument[1])
		}
		else
		{
			Assert(is_callable(target), "The runner is not a callable object.")

			myRunner = target
		}
	}

	/// @self Delegate
	/// @pure
	static toString = function()
	{
		return $"Functor {id}"
	}
}
