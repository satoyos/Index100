class SelectedStatus100
  extend Forwardable

  SIZE = 100
  INITIAL_STATUS = false

  def initialize
    @status = (0..SIZE-1).to_a.map{|idx| INITIAL_STATUS}
  end

  def_delegators :@status, :[], :[]=, :size, :each, :count

  def of_number(idx)
    raise "invalid index [#{idx}]" if idx < 1 || idx > SIZE
    self[idx-1]
  end

  def select_in_number(idx)
    set_status(true, of_number: idx)
    self
  end

  def cancel_in_number(idx)
    set_status(false, of_number: idx)
    self
  end

  def cancel_all
    (1..SIZE).each{|idx| self.cancel_in_number(idx)}
    self
  end

  def select_all
    (1..SIZE).each{|idx| self.select_in_number(idx)}
    self
  end

  def selected_num
    count(true)
  end

  def select_in_numbers(collection)
    collection.each {|idx| select_in_number(idx)}
  end

  def cancel_in_numbers(collection)
    collection.each {|idx| cancel_in_number(idx)}
  end

  def reverse_in_index(idx)
    self[idx] = !self[idx]
  end

  :private

  def set_status(value, of_number: idx)
    raise "invalid index [#{idx}]" if idx < 1 || idx > SIZE
    self[idx-1] = value
  end


end