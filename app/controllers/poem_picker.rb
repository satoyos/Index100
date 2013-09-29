class PoemPicker < RMViewController
  include SelectedStatusHandler
  extend Forwardable

  def_delegators :@status100, :select_in_number, :[], :[]=

  TITLE = '使う歌'
  FONT_SIZE = 16
  DETAIL_FONT_SIZE = 11
  SELECTED_BG_COLOR = ColorFactory.str_to_color('#eebbcb') #撫子色

  attr_reader :poems, :status100, :table_view

  def viewDidLoad
    super

    @poems = Deck.original_deck.poems
    @status100 = SelectedStatus100.new(loaded_selected_status)
    setToolbarItems(toolbar_items, animated: true)

    init_table_view_frame()

    self.title = TITLE
    self.view.backgroundColor = UIColor.whiteColor
    self.view.addSubview(@table_view)

  end

  def init_table_view_frame
    @table_view = UITableView.alloc.initWithFrame(self.view.frame)
    @table_view.dataSource = self
    @table_view.delegate = self

    unless RUBYMOTION_ENV == 'test'
      frame = @table_view.frame
      frame.size.height -= navigationController.navigationBar.frame.size.height
      frame.size.height -= navigationController.toolbar.frame.size.height
      @table_view.frame = frame
    end

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
    @status100.select_all
    save_selected_status(@status100.status_array)
    @table_view.reloadData
  end

  def cancel_all_poems
    @status100.cancel_all
    save_selected_status(@status100.status_array)
    @table_view.reloadData
  end

  def select_by_ngram
    navigationController.pushViewController(
        NGramPicker.alloc.init,
        animated: true)
  end

  def viewWillAppear(animated)
    super
    @status100 = SelectedStatus100.new(loaded_selected_status)
    unless RUBYMOTION_ENV == 'test'
      navigationController.setToolbarHidden(false, animated: true)
    end
    @table_view.reloadData
  end

  def viewWillDisappear(animated)
    super
#    save_selected_status(@status100.status_array)
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
#      c.textLabel.font = UIFont.systemFontOfSize(FONT_SIZE)
      c.textLabel.font = FontFactory.create_font_with_type(:japaneseW6,
                                                           size: FONT_SIZE)
      c.detailTextLabel.text = "　　 #{poem.poet}"
      c.detailTextLabel.font =
          FontFactory.create_font_with_type(:japanese,
                                            size: DETAIL_FONT_SIZE)
    end

    cell.accessoryType = case @status100[indexPath.row]
                           when true ; UITableViewCellAccessoryCheckmark
                           else ; UITableViewCellAccessoryNone
                         end
    cell
  end


  # @param [UITableView] tableView
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @status100.reverse_in_index(indexPath.row)
    save_selected_status(@status100.status_array)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tableView.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.backgroundColor = case @status100[indexPath.row]
                             when true ; SELECTED_BG_COLOR
                             else ; UIColor.whiteColor
                           end
#    self.title = '選択中: %d首' % @status100.selected_num
    self.navigationItem.prompt = '選択中: %d首' % @status100.selected_num
  end

end
