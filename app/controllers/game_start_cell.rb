class GameStartCell < UITableViewCell
  CELL_STYLE = UITableViewCellStyleDefault
  CELL_ACCESSORY = UITableViewCellAccessoryNone

  def initWithText(text, reuseIdentifier: reuseIdentifier)
    initWithStyle(CELL_STYLE, reuseIdentifier: reuseIdentifier)
    textLabel.text = text
    textLabel.textAlignment = UITextAlignmentCenter
    textLabel.textColor = UIColor.redColor

    self
  end
end