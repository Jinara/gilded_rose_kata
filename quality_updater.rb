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

