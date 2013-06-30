class ExamController < UIViewController
  PROPERTIES = [:fuda_view]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def viewDidLoad
    super

    @fuda_view = 1
  end

end