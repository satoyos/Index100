class SettingCellWithArrow < UITableViewCell
  CELL_STYLE = UITableViewCellStyleValue1
  CELL_ACCESSORY = UITableViewCellAccessoryDisclosureIndicator

  def initWithText(text, detail: detail_text, reuseIdentifier: reuseIdentifier)
    initWithStyle(CELL_STYLE, reuseIdentifier: reuseIdentifier)
    textLabel.text = text
    detailTextLabel.text = detail_text
    self.accessoryType = CELL_ACCESSORY
    self
  end
end