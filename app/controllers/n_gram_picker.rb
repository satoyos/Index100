class NGramPicker < RMViewController
  include SelectedStatusHandler
  include NGramSections


  BC_FULL_IMG_FILE = 'blue_circle_full.png'
  BC_HALF_IMG_FILE = 'blue_circle_half.png'
  BC_NONE_IMG_FILE = 'blue_circle_empty.png'

  TITLE = '1字目で選ぶ'

  attr_reader :table_view

  def viewDidLoad
    super

    view.backgroundColor = UIColor.whiteColor
    self.title = TITLE
    @status100 = SelectedStatus100.new(loaded_selected_status)
    init_table_view_frame()
    self.view.addSubview(@table_view)
  end

  def init_table_view_frame
    @table_view = UITableView.alloc.initWithFrame(self.view.bounds,
                                                  style: UITableViewStyleGrouped)
    @table_view.dataSource = self
    @table_view.delegate = self

    unless RUBYMOTION_ENV == 'test'
      frame = @table_view.frame
      frame.size.height -= navigationController.navigationBar.frame.size.height
      @table_view.frame = frame
#      puts "@table_view.frameの高さ => #{@table_view.frame.size.height}"
#      puts "toolabar.frameの高さ    => #{navigationController.toolbar.frame.size.height}"
    end

  end


  def viewDidAppear(animated)
    @table_view.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    N_GRAM_SECTIONS.size
  end

  def tableView(tableView, titleForHeaderInSection: section)
    N_GRAM_SECTIONS[section][:header_title]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    N_GRAM_SECTIONS[section][:items].size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # 一応慣例に従ってreuseIdentifierは作成するが、
    # この画面を作る負荷は小さいので、問題が出ない限り使わない。
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                               reuseIdentifier: @reuseIdentifier)
    cell.textLabel.text = text_of(indexPath)
    cell.accessibilityLabel = "#{id_of(indexPath)}"
    cell.imageView.image =
        ui_image_for_status(selected_status_of_char(id_of(indexPath)),
                            of_height: height_of(cell))
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    puts "- 選ばれた1文字目は[#{id_of(indexPath)}]です。"
    case selected_status_of_char(id_of(indexPath))
      when :full ; release_poems_of_char(id_of(indexPath))
      else       ; select_all_poems_of_char(id_of(indexPath))
    end
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    @table_view.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    self.navigationItem.prompt = '選択中: %d首' % @status100.selected_num
  end


  def select_all_poems_of_char(char_sym)
    @status100.select_in_numbers(NGramNumbers.of(char_sym))
    save_selected_status(@status100.status_array)
  end

  def release_poems_of_char(char_sym)
    @status100.cancel_in_numbers(NGramNumbers.of(char_sym))
    save_selected_status(@status100.status_array)
  end


  def selected_status_of_char(sym)
    raise "Invalid argument type #{sym}" unless sym.is_a?(Symbol)
    numbers = NGramNumbers.of(sym)
    raise "Couldn't get NgramNumbers for #{sym}" unless numbers
    if numbers.inject(true){|result, num| result &&= @status100.of_number(num)}
      :full # 該当する歌が全て選択されているとき
    elsif !numbers.inject(false) { |result, num| result ||= @status100.of_number(num) }
      :none # 該当する歌が一つも選択されてないとき
    else
      :partial # 中途半端に選択されているとき
    end
  end

  def test_set_status100(bool_or_booleans)
    @status100 = SelectedStatus100.new(bool_or_booleans)
  end

  :private

  # @param [UIView] view
  def height_of(view)
    view.frame.size.height
  end

  def item_hash(indexPath)
    N_GRAM_SECTIONS[indexPath.section][:items][indexPath.row]
  end

  def text_of(indexPath)
    item_hash(indexPath)[:title]
  end

  def id_of(indexPath)
    item_hash(indexPath)[:id]
  end

  def ui_image_for_status(status_symbol, of_height: height)
    image_name = case status_symbol
                   when :full    ; BC_FULL_IMG_FILE
                   when :partial ; BC_HALF_IMG_FILE
                   when :none    ; BC_NONE_IMG_FILE
                   else ; raise "Invalid status #{status_symbol}"
                 end
    ResizeUIImage.resizeImage(UIImage.imageNamed(image_name),
                              newSize: CGSizeMake(height, height))
  end

end