class PoemPicker < UITableViewController

  FONT_SIZE = 16
  SELECTED_BG_COLOR = ColorFactory.str_to_color('#eebbcb') #撫子色

  attr_reader :poems, :selected

  def viewDidLoad
    super

    @poems = Deck.original_deck.poems
    # ちゃんと初期状態を実装するまで、無選択状態で開始。
    cancel_all_poems()
    setToolbarItems(toolbar_items, animated: true)

  end

  def toolbar_items
    [
        UIBarButtonItem.alloc.initWithTitle('全て取消',
                                            style: UIBarButtonItemStyleBordered,
                                            target: self,
                                            action: :cancel_all_poems),
        self.barButtonSystemItem(UIBarButtonSystemItemFlexibleSpace),
        UIBarButtonItem.alloc.initWithTitle('全て選択',
                                            style: UIBarButtonItemStyleBordered,
                                            target: self,
                                            action: :select_all_poems),
        self.barButtonSystemItem(UIBarButtonSystemItemFlexibleSpace),
        UIBarButtonItem.alloc.initWithTitle('1字目で選ぶ',
                                            style: UIBarButtonItemStyleBordered,
                                            target: self,
                                            action: :select_by_ngram)

    ]
  end

  def barButtonSystemItem(system_item)
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(system_item,
                                                      target: nil,
                                                      action: nil)
  end

  def select_all_poems
    @selected = (0..99).map{true}
    self.view.reloadData
  end

  def cancel_all_poems
    @selected = (0..99).map{false}
    self.view.reloadData
  end

  def select_by_ngram
    puts 'ここはこれから作ります。'
  end

  def viewWillAppear(animated)
    super
    unless RUBYMOTION_ENV == 'test'
      navigationController.setToolbarHidden(false, animated: true)
    end
  end

  def viewWillDisappear(animated)
    super
    unless RUBYMOTION_ENV == 'test'
      navigationController.setToolbarHidden(true, animated: true)
    end
  end
  
  def tableView(tableView, numberOfRowsInSection: section)
    100
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle,
                                            reuseIdentifier: @reuseIdentifier)

    poem = @poems[indexPath.row]
    cell.tap do |c|
      c.textLabel.text = '%3d. %s %s %s' % [poem.number, poem.liner[0], poem.liner[1], poem.liner[2]]
      c.textLabel.font = UIFont.systemFontOfSize(FONT_SIZE)
      c.detailTextLabel.text = "　　 #{poem.poet}"
    end

    cell.accessoryType = case @selected[indexPath.row]
                           when true ; UITableViewCellAccessoryCheckmark
                           else ; UITableViewCellAccessoryNone
                         end
=begin
    if @selected[indexPath.row]
      cell.accessoryType = UITableViewCellAccessoryCheckmark
      cell.backgroundColor = UIColor.blueColor
    else
      cell.accessoryType = UITableViewCellAccessoryNone
      cell.backgroundColor = UIColor.whiteColor
    end
=end
    cell
  end


  # @param [UITableView] tableView
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
#    puts "cell[#{indexPath.row}] is selected!"
    @selected[indexPath.row] = !@selected[indexPath.row]
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tableView.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.backgroundColor = case @selected[indexPath.row]
                             when true ; SELECTED_BG_COLOR
                             else ; UIColor.whiteColor
                           end
    self.title = '選択中: %d首' % @selected.count(true)
  end

end