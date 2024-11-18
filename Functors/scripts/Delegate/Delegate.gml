function Delegate() constructor
{
	static objIndex = 0

	id = objIndex++

	myRunners = []

	/// @param { Function|Struct|Id.Instance} target - function or context
	/// @param { Asset.GMScript|Function } [method]
	/// @self Delegate
	static Add = function(target)
	{
		if 1 < argument_count
		{
			Assert(is_callable(argument[1]))

			var functor = new Functor()
			functor.SetPredicate(target, argument[1])
			//functor.SetPredicate(method(target, argument[1]))

			array_push(myRunners, functor)
		}
		else
		{
			Assert(is_callable(target))

			var functor = new Functor()
			functor.SetPredicate(target)

			array_push(myRunners, functor)
		}
	}

	/// @param { Function|Struct|Id.Instance} target - function or context
	/// @param { Asset.GMScript|Function } [method]
	/// @return Bool
	/// @self Delegate
	static TryAddUnique = function(target)
	{
		if array_length(myRunners) == 0
		{
			if 1 < argument_count
			{
				Assert(is_callable(argument[1]))

				var functor = new Functor()
				functor.SetPredicate(target, argument[1])
				//functor.SetPredicate(method(target, argument[1]))

				array_push(myRunners, functor)
			}
			else
			{
				Assert(is_callable(target))

				var functor = new Functor()
				functor.SetPredicate(target)

				array_push(myRunners, functor)
			}

			return true
		}
		else
		{
			return false
		}
	}

	/// @param { Any } [args...]
	/// @self Delegate
	static Invoke = function()
	{
		var len = array_length(myRunners)

		if 0 < len
		{
			//show_debug_message("{0} has {1} functors and is getting invoked.", self, len)

			var deads = []

			if 0 < argument_count
			{
				var params = array_create(argument_count)

				for (var i = 0; i < argument_count; ++i)
				{
					params[i] = argument[i]
				}

				for (var i = 0; i < len; ++i)
				{
					var functor = myRunners[i]
					var context = functor.myContext
					var runner = functor.myRunner

					if isdef(context) and weak_ref_alive(context)
					{
						with context.ref
						{
							script_execute_ext(runner, params)
						}
					}
					else if isdef(runner)
					{
						script_execute_ext(runner, params)
					}
					else
					{
						show_debug_message("{0} will be destroyed.", functor)

						array_push(deads, i)
					}
				}
			}
			else
			{
				for (var i = 0; i < len; ++i)
				{
					var functor = myRunners[i]
					var context = functor.myContext
					var runner = functor.myRunner

					if isdef(context) and weak_ref_alive(context)
					{
						functor.Invoke()
					}
					else if isdef(runner)
					{
						functor.Invoke()
					}
					else
					{
						show_debug_message("{0} will be destroyed.", functor)

						array_push(deads, i)
					}
				}
			}

			var dlen = array_length(deads)

			if 0 < dlen
			{
				show_debug_message("{0} is removing {1} functors.", self, dlen)

				array_sort(deads, false)

				for (var k = 0; k < dlen; ++k)
				{
					array_delete(myRunners, deads[k], 1)
				}
			}
		}
	}

	/// @param { Struct|Id.Instance} target
	/// @self Delegate
	static Remove = function(target)
	{
		var len = array_length(myRunners)

		if 0 < len
		{
			var predicate =
			{
				/// @param { Struct.Functor} lhs
				/// @param { Real } i
				/// @pure
				operator : function(lhs, i)
				{
					var context = lhs.myContext

					return isdef(context) and context.ref != rhs
				},
				rhs : target
			}

			array_filter_ext(myRunners, predicate.operator)
		}
	}

	/// @self Delegate
	static Clear = function()
	{
		myRunners = []
	}

	/// @self Delegate
	static Destroy = function()
	{
		myRunners = []

		return self
	}

	/// @self Delegate
	/// @pure
	static HasInvoker = function()
	{
		return 0 < array_length(myRunners)
	}

	/// @self Delegate
	/// @pure
	static toString = function()
	{
		return $"Delegate {id}"
	}
}
