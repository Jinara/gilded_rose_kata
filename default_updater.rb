class DefaultUpdater < ItemUpdater

  def initialize
  end

  def update_quality(item)
    operations(item, :q_mayor_0)
    item.sell_in -= 1
    operations(item, :s_menor_0) do
      operations(item, :q_mayor_0)
    end
  end

  def true_value(item, &block)
    block_given? ? yield : (item.quality -= 1)
  end
end

