defmodule CountdownReactor do
  use Reactor

  input(:current_number)

  step :countdown_step do
    argument(:current_number, input(:current_number))

    run(fn %{current_number: num}, _context ->
      new_number = num - 1
      IO.inspect("Current number: #{new_number}")
      {:ok, %{current_number: new_number}}
    end)
  end

  return(:countdown_step)
end

defmodule Iterative.CountdownExample do
  use Reactor

  input(:start_number)

  recurse :countdown, CountdownReactor do
    argument(:current_number, input(:start_number))
    max_iterations(100)
    exit_condition(fn %{current_number: num} -> num <= 0 end)
  end

  step :show_result do
    argument(:final_state, result(:countdown))
    argument(:start_number, input(:start_number))

    run(fn %{final_state: state, start_number: start}, _context ->
      result = %{
        started_at: start,
        finished_at: state.current_number,
        message: "Counted down from #{start} to #{state.current_number}"
      }

      {:ok, result}
    end)
  end

  return(:show_result)
end
