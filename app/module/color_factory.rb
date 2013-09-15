module ColorFactory
  def str_to_color(string)
    # string like a "#0c92f2"
    raise "Unknown color scheme" if (string[0] != '#') || (string.length != 7)
    color = string[1..-1]
    r = color[0..1]
    g = color[2..3]
    b = color[4..5]
    UIColor.colorWithRed((r.hex/255.0), green:(g.hex/255.0), blue:(b.hex/255.0), alpha:1)
  end

  module_function :str_to_color
end