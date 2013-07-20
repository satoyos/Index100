class ButtonSlot < Array

  PROPERTIES = [:limit_size]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initialize(limit_size)
    super(0)
    @limit_size = limit_size

    self
  end

  def transfer(obj, to: target_slot)
    return nil unless self.steal(obj)
    target_slot << obj
  end

  def <<(obj)
    case self.size
      when @limit_size ; raise OverLimitError
      else super
    end
  end

  def steal(obj)
    return nil unless (index = self.find_index(obj))
    self[index] = nil
    true
  end

  def is_full?
    self.size == @limit_size
  end
end

OverLimitError = Class.new(StandardError)