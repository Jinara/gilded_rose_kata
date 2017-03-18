class AgedBrieUpdater < ItemUpdater

  def initialize
  end

  def update_quality(item)
    operations(item, :q_menor_50)

    item.sell_in -= 1

    operations(item, :s_menor_0) do
      operations(item, :q_menor_50)
    end
  end

  def true_value(item, &block)
    block_given? ? yield : (item.quality += 1)
  end
end

