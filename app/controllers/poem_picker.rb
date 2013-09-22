class PoemPicker < UITableViewController
  include SelectedStatusHandler
  extend Forwardable

  def_delegators :@status100, :select_in_number, :[], :[]=

  FONT_SIZE = 16
  SELECTED_BG_COLOR = ColorFactory.str_to_color('#eebbcb') #撫子色

  attr_reader :poems, :status100

  def viewDidLoad
    super

    @poems = Deck.original_deck.poems
    @status100 = SelectedStatus100.new(loaded_selected_status)
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
    @status100.select_all
    self.view.reloadData
  end

  def cancel_all_poems
    @status100.cancel_all
    self.view.reloadData
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
  end

  def viewWillDisappear(animated)
    super
    save_selected_status(@status100.status_array)
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

    cell.accessoryType = case @status100[indexPath.row]
                           when true ; UITableViewCellAccessoryCheckmark
                           else ; UITableViewCellAccessoryNone
                         end
    cell
  end


  # @param [UITableView] tableView
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @status100.reverse_in_index(indexPath.row)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    tableView.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    cell.backgroundColor = case @status100[indexPath.row]
                             when true ; SELECTED_BG_COLOR
                             else ; UIColor.whiteColor
                           end
    self.title = '選択中: %d首' % @status100.selected_num
  end

=begin
  def save_selected_status(status_array)
#    puts '- saving [selected_status]'
#    puts "  selected_status => #{@status100.status_array}, number_of(true) => #{@status100.selected_num}"
#    UIApplication.sharedApplication.delegate.settings.selected_status = @status100.status_array
    UIApplication.sharedApplication.delegate.settings[:selected_status] = status_array
  end

  def loaded_selected_status
#    puts '- loading [selected_status]'
    status_array = UIApplication.sharedApplication.delegate.settings.selected_status
    case status_array
      when nil ; nil
      else
#        puts "  loaded_status_array => #{status_array}"
        status_array.dup
    end
  end
=end
end
