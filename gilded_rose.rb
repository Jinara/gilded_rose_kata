def increase_q
  @item.quality +=1
end

def decrease_q
  @item.quality -=1
end
def q_mayor_que_0
  if @item.name != 'Sulfuras, Hand of Ragnaros'
    decrease_q
  end
end

def q_menor_50
  if @item.quality < 50
    increase_q
  end
end

def first_evalutation
  if @item.name != 'Aged Brie' && @item.name != 'Backstage passes to a TAFKAL80ETC concert'
    if @item.quality > 0
      q_mayor_que_0
    end
  else
    if @item.quality < 50
      @item.quality += 1
      if @item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if @item.sell_in < 11
          q_menor_50
        end
        if @item.sell_in < 6
          q_menor_50
        end
      end
    end
  end
end

def second_evaluation
  if @item.name != 'Sulfuras, Hand of Ragnaros'
    @item.sell_in -= 1
  end
  if @item.sell_in < 0
    if @item.name != "Aged Brie"
      if @item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if @item.quality > 0
          if @item.name != 'Sulfuras, Hand of Ragnaros'
            increase_q
          end
        end
      else
        @item.quality = @item.quality - @item.quality
      end
    else
      q_menor_50
    end
  end
end

def update_quality(items)
  items.each do |item|
    @item = item
    first_evalutation
    second_evalutation
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

