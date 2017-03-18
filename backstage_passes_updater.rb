class BackstagePassesUpdater < ItemUpdater

  def initialize
  end

  def update_quality(item)
    operations(item, :q_menor_50) do
      item.quality +=1
      operations(item, :s_menor_11) do
        operations(item, :q_menor_50)
      end
      operations(item, :s_menor_6) do
        operations(item, :q_menor_50)
      end
    end
    item.sell_in -= 1
    operations(item, :s_mayor_o_igual_0)
  end

  def evaluator(condition, item, &block)
    evaluators = {
      "true" => lambda { true_value(item, &block) },
      "special_case" => lambda { special_case_value(item, &block) }
    }
    evaluators.default = lambda { nil }
    evaluators[condition.to_s].call
  end

  def true_value(item, &block)
    block_given? ? yield : (item.quality += 1)
  end

  def special_case_value(item, &block)
    block_given? ? yield : (item.quality = 0)
  end
end
