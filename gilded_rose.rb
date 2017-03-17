class QualityUpdater
  def update_item(item)
    updaters = {
      "Backstage passes to a TAFKAL80ETC concert" => lambda { BackstagePassesUpdater.new.update_quality(item) },
      "Aged Brie" => lambda { AgedBrieUpdater.new.update_quality(item) },
      "Sulfuras, Hand of Ragnaros" => lambda { SulfurasUpdater.new.update_quality(item) },
    }
    updaters.default = lambda { DafaultUpdater.new.update_quality(item) }
    updaters[item.name].call
  end

  def mientras(item, sym)
    operator = {:menor_50 => -1}
    item.quality + operator[sym]
  end
end

class BackstagePassesUpdater
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
    if item.sell_in < 0
      item.quality = 0
    end
  end
end

class AgedBrieUpdater
  def update_quality(item)
    if item.quality < 50 
      item.quality +=1
    end
    item.sell_in -= 1
    if item.sell_in < 0
      if item.quality < 50
        item.quality +=1
      end
    end
  end
end

class SulfurasUpdater
  def update_quality(item)
    if item.quality < 50
      item.quality += 1
    end
  end
end

class DafaultUpdater
  def update_quality(item)
    if item.quality > 0
      item.quality -= 1
    end
    item.sell_in -= 1
    if item.sell_in < 0
      if item.quality > 0
        item.quality -= 1
      end
    end
  end
end
def second_evaluation(item)
  if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
    if item.quality > 0
      if item.name != 'Sulfuras, Hand of Ragnaros'
        item.quality -= 1
      end
    end
  else
    if item.quality < 50
      item.quality += 1
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11
          if item.quality < 50
            item.quality += 1
          end
        end
        if item.sell_in < 6
          if item.quality < 50
            item.quality += 1
          end
        end
      end
    end
  end
  if item.name != 'Sulfuras, Hand of Ragnaros'
    item.sell_in -= 1
  end
  if item.sell_in < 0
    if item.name != "Aged Brie"
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            item.quality -= 1
          end
        end
      else
        item.quality = item.quality - item.quality
      end
    else
      if item.quality < 50
        item.quality += 1
      end
    end
  end
end
def update_quality(items)
  items.each do |item|
    QualityUpdater.new.update_item(item)
    #second_evaluation(item)
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

