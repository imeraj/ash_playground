defmodule Composition.OrderProcessingReactor do
  use Reactor

  input(:user_id)
  input(:product_id)
  input(:quantity)
  input(:amount)

  # Step 1: Validate user
  compose :user_validation, Composition.UserValidationReactor do
    argument(:user_id, input(:user_id))
  end

  # Step 2: Check inventory (can run in parallel with payment)
  compose :inventory_check, Composition.InventoryReactor do
    argument(:product_id, input(:product_id))
    argument(:quantity, input(:quantity))
  end

  # Step 3: Process payment
  compose :payment_processing, Composition.PaymentReactor do
    argument(:user_id, input(:user_id))
    argument(:amount, input(:amount))
  end

  # Step 4: Create final order (depends on all previous steps)
  step :create_order do
    argument(:user, result(:user_validation))
    argument(:reservation, result(:inventory_check))
    argument(:payment, result(:payment_processing))

    run(fn %{user: user, reservation: res, payment: pay}, _context ->
      order = %{
        order_id: "order_#{:rand.uniform(1000)}",
        user: user,
        product_id: res.product_id,
        quantity: res.quantity,
        payment_id: pay.payment_id,
        total: pay.amount,
        created_at: DateTime.utc_now()
      }

      {:ok, order}
    end)
  end

  return(:create_order)
end
