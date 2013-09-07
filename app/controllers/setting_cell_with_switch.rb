class SettingCellWithSwitch < UITableViewCell
#  CELL_STYLE = UITableViewCellStyleSubtitle
  CELL_STYLE = UITableViewCellStyleDefault
  CELL_ACCESSORY = UITableViewCellAccessoryNone

  SWITCH_MARGIN = 30


  def initWithText(text, detail: detail_text, on_status: on_status, reuseIdentifier: reuseIdentifier)
    initWithStyle(CELL_STYLE, reuseIdentifier: reuseIdentifier)
    textLabel.text = text
    detailTextLabel.text = detail_text if detailTextLabel
    self.selectionStyle = UITableViewCellSelectionStyleNone
    @switch_view = self.switch_view
    @switch_view.on = on_status
    self.contentView.addSubview(@switch_view)
    self
  end

  def set_callback(controller, method: callback_method)
    @switch_view.addTarget(controller, action: callback_method, forControlEvents: UIControlEventValueChanged)
  end

  def switch_view
    sw_view = UISwitch.alloc.init
    sw_view.center = self.center # まずは縦方向のセンタリンク目的で、ど真ん中に。
    sw_view.frame = switch_frame(sw_view) # その上で、フレームを再設定
    sw_view
  end

  def switch_on?
    @switch_view.on?
  end


  # @param [UISwitch] sw_view
  def switch_frame(sw_view)
    [CGPointMake(self.frame.size.width -
                     sw_view.frame.size.width -
                     SWITCH_MARGIN,
                 sw_view.frame.origin.y),
     sw_view.frame.size]
  end



end