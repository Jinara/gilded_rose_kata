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
      :q_mayor_0 => (item.quality > 0),
      :s_menor_11 => (item.sell_in < 11),
      :s_menor_6 => (item.sell_in < 6),
      :s_mayor_o_igual_0 => ((item.sell_in >= 0) ? false : "special_case"),
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
