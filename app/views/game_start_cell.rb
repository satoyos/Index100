class GameStartCell < UITableViewCell
  CELL_STYLE = UITableViewCellStyleDefault
  CELL_ACCESSORY = UITableViewCellAccessoryNone

  def initWithText(text, acc_label: acc_label, reuseIdentifier: reuseIdentifier)
    initWithStyle(CELL_STYLE, reuseIdentifier: reuseIdentifier)
    textLabel.text = text
    textLabel.textAlignment = UITextAlignmentCenter
    textLabel.textColor = UIColor.redColor
    self.accessibilityLabel = acc_label

    self
  end
end