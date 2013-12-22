class SettingCellWithArrow < UITableViewCell
  CELL_STYLE = UITableViewCellStyleValue1
  CELL_ACCESSORY = UITableViewCellAccessoryDisclosureIndicator

  def initWithText(text, detail: detail_text, acc_label: acc_label, reuseIdentifier: reuseIdentifier)
    initWithStyle(CELL_STYLE, reuseIdentifier: reuseIdentifier)
    textLabel.text = text
    detailTextLabel.text = detail_text
    self.accessibilityLabel = acc_label
    self.accessoryType = CELL_ACCESSORY
    self
  end
end