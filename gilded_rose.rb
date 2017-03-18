class ItemUpdater

  def initialize(item_type)
    @item_type = Object.const_get(item_type, Class.new)
  end

  def update_item(item)
    @item_type.new.update_quality(item)
  end

  def operations(item, sym, &block)
    conditions = {
      :q_menor_50 => (item.quality < 50),
      :s_menor_0 => (item.sell_in < 0),
      :q_mayor_0 => (item.quality > 0)
    }
    evaluator(conditions[sym], item, &block)
  end

  def evaluator(condition, item, &block)
    evaluators = {
      "true" => lambda { true_value(item, &block) }
    }
    evaluators.default = lambda { nil }
    evaluators[condition.to_s].call
  end

end

class BackstagePassesUpdater < ItemUpdater

  def initialize
  end

  def update_quality(item)
    if item.quality < 50 
      item.quality +=1
      if item.sell_in < 11
        if item.quality < 50
          item.quality +=1
        end
      end
      if item.sell_in < 6
        if item.quality < 50
          item.quality += 1
        end
      end
    end
    item.sell_in -= 1
    operations(item, :s_menor_0)
  end

  def true_value(item, &block)
    block_given? ? yield : (item.quality = 0)
  end

  def false_value(item, &block)
    block_given? ? yield : (item.quality = 0)
  end
end

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

class QualityUpdater

  def update_item_quality(item)
    updaters = {
      "Backstage passes to a TAFKAL80ETC concert" => lambda { ItemUpdater.new("BackstagePassesUpdater").update_item(item) },
      "Aged Brie" => lambda { ItemUpdater.new("AgedBrieUpdater").update_item(item) },
      "Sulfuras, Hand of Ragnaros" => lambda { ItemUpdater.new("SulfurasUpdater").update_item(item) },
    }
    updaters.default = lambda { ItemUpdater.new("DefaultUpdater").update_item(item) }
    updaters[item.name].call
  end
end

def update_quality(items)
  items.each do |item|
    QualityUpdater.new.update_item_quality(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

