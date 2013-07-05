class ButtonSlot < Array

  PROPERTIES = [:limit_size]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initialize(limit_size)
    super
    @limit_size = limit_size

    self
  end

end