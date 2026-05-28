defmodule Composition.InventoryReactor do
  use Reactor

  input(:product_id)
  input(:quantity)

  step :check_availability do
    argument(:product_id, input(:product_id))
    argument(:quantity, input(:quantity))

    run(fn %{product_id: product_id, quantity: quantity}, _context ->
      available = 50

      if quantity <= available do
        {:ok, %{product_id: product_id, available: available}}
      else
        {:error, "Not enough inventory"}
      end
    end)
  end

  step :reserve_items do
    argument(:availability, result(:check_availability))
    argument(:quantity, input(:quantity))

    run(fn %{availability: avail, quantity: qty}, _context ->
      reservation = %{
        product_id: avail.product_id,
        quantity: qty,
        reserved_at: DateTime.utc_now()
      }

      {:ok, reservation}
    end)
  end

  return(:reserve_items)
end
