defmodule Composition.PaymentReactor do
  use Reactor

  input(:user_id)
  input(:amount)

  step :validate_payment do
    argument(:user_id, input(:user_id))
    argument(:amount, input(:amount))

    run(fn %{user_id: user_id, amount: amount}, _context ->
      if amount > 0 and amount < 10000 do
        {:ok, %{user_id: user_id, amount: amount, valid: true}}
      else
        {:error, "Invalid payment amount"}
      end
    end)
  end

  step :process_payment do
    argument(:payment_info, result(:validate_payment))

    run(fn %{payment_info: info}, _context ->
      payment = %{
        payment_id: "pay_#{:rand.uniform(1000)}",
        user_id: info.user_id,
        amount: info.amount,
        status: :completed,
        processed_at: DateTime.utc_now()
      }

      {:ok, payment}
    end)
  end

  return(:process_payment)
end
