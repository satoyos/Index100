class StartViewController < UITableViewController


  READ_PROPERTIES = [:table]
  READ_PROPERTIES.each do |prop|
    attr_reader prop
  end

  ACCESS_PROPERTIES = []
  ACCESS_PROPERTIES.each do |prop|
    attr_accessor prop
  end

  SECTIONS = [
      {id: :settings, header_title: '設定'},
      {id: :games, header_title: 'ゲーム開始'}
  ]

  SETTING_ITEMS = [
      {id: :number_of_poems, title: '使う歌の数'},
#      {id: :how_to_select  , title: '使う歌の選び方'}
  ]

  GAMES = [
      {id: :start_test, title: 'テスト(時間計測なし)'}
  ]

  def viewDidLoad
    super

    view.backgroundColor = UIColor.whiteColor
    self.title = '百首決まり字'
    self.view.initWithFrame(self.view.bounds,
                            style: UITableViewStyleGrouped)
  end

  def viewWillAppear(animated)
    super
    unless RUBYMOTION_ENV == 'test'
      navigationController.navigationBar.translucent = false
      navigationController.navigationBar.alpha = 1.0
    end
    self.view.reloadData
  end

  :private


  def numberOfSectionsInTableView(tableView)
    SECTIONS.size
  end

  def tableView(tableView, titleForHeaderInSection: section)
    SECTIONS[section][:header_title]
  end

  def tableView(tableView, numberOfRowsInSection: section)
    case SECTIONS[section][:id]
      when :settings ; SETTING_ITEMS.size
      when :games    ; GAMES.size
      else ; 0
    end

  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell_style, cell_accessory_type =
        case id_of_section(indexPath.section)
          when :games
            [UITableViewCellStyleDefault,
             UITableViewCellAccessoryNone]
          else
            [UITableViewCellStyleValue1,
             UITableViewCellAccessoryDetailDisclosureButton]
        end
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(cell_style,
                                            reuseIdentifier: @reuseIdentifier)

    hash =  case id_of_section(indexPath.section)
              when :settings ; SETTING_ITEMS[indexPath.row]
              when :games    ; GAMES[indexPath.row]
            end
    cell.tap do |c|
      c.textLabel.text = hash[:title]
      if c.detailTextLabel
        c.detailTextLabel.text = detail_text(SETTING_ITEMS[indexPath.row][:id])
      else
        c.textLabel.textAlignment = UITextAlignmentCenter
        c.textLabel.textColor = UIColor.redColor
      end
      c.accessoryType= cell_accessory_type
      c.accessibilityLabel = "#{hash[:id]}"
    end

    cell
  end

  def detail_text(setting_id)
    case setting_id
      when :number_of_poems ; "#{PoemsNumberPicker.poems_num}"
      else ; '未設定'
    end
  end

  def id_of_section(section_idx)
    SECTIONS[section_idx][:id]
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    method_name = case id_of_section(indexPath.section)
            when :settings ; "set_#{SETTING_ITEMS[indexPath.row][:id]}"
            when :games    ; "#{GAMES[indexPath.row][:id]}"
          end
    puts "- 呼び出すメソッド => [#{method_name}]"
    self.send("#{method_name}")
  end

  def start_test
    navigationController.pushViewController(
        ExamController.alloc.initWithNibName(nil,
                                             bundle: nil,
                                             shuffle_with_size: PoemsNumberPicker.poems_num),
        animated: true)
  end

  def set_number_of_poems
    puts '  → これから歌の数を設定します！'
    navigationController.pushViewController(
        PoemsNumberPicker.alloc.initWithNibName(nil, bundle: nil),
        animated: true)
  end

  def set_how_to_select
    puts '  → これから歌の選択方法を設定します！'
  end


end