defmodule AccumulatorReactor do
  use Reactor

  input(:current_total)
  input(:target_total)

  step :add_random_amount do
    argument(:current_total, input(:current_total))
    argument(:target_total, input(:target_total))

    run(fn %{current_total: current, target_total: target}, _context ->
      # Add a random amount between 1 and 10
      addition = :rand.uniform(10)
      new_total = current + addition

      IO.inspect("Running total: #{new_total}")

      reached_target = new_total >= target

      {:ok,
       %{
         current_total: new_total,
         target_total: target,
         last_addition: addition,
         reached_target: reached_target
       }}
    end)
  end

  return(:add_random_amount)
end

defmodule Iterative.AccumulatorExample do
  use Reactor

  input(:target_score)

  recurse :accumulate, AccumulatorReactor do
    argument(:current_total, value(0))
    argument(:target_total, input(:target_score))
    max_iterations(50)
    exit_condition(fn %{reached_target: reached} -> reached == true end)
  end

  step :show_results do
    argument(:final_state, result(:accumulate))
    argument(:target, input(:target_score))

    run(fn %{final_state: state, target: target}, _context ->
      result = %{
        target_score: target,
        final_total: state.current_total,
        last_addition: state.last_addition,
        message: "Reached #{state.current_total} (target was #{target})"
      }

      {:ok, result}
    end)
  end

  return(:show_results)
end
