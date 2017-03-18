class SulfurasUpdater < ItemUpdater

  def initialize
  end

  def update_quality(item)
    operations(item, :q_menor_50)
  end

  def true_value(item, &block)
    block_given? ? yield : (item.quality += 1)
  end
end

