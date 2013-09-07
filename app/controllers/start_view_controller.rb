# coding: utf-8

class StartViewController < UITableViewController

  READ_PROPERTIES = [:table]
  READ_PROPERTIES.each do |prop|
    attr_reader prop
  end

  ACCESS_PROPERTIES = []
  ACCESS_PROPERTIES.each do |prop|
    attr_accessor prop
  end

  START_VIEW_SECTIONS = [
      {section_id: :settings,
       header_title: '設定',
       items: [
           {id: :number_of_poems, title: '使う歌の数'},
           {id: :show_wrong_asap, title: '間違えたらすぐにお知らせ',
            detail: '誤った文字を押した時点で通知します'},
       ]
      },
      {section_id: :games,
       header_title: 'ゲーム開始',
       items: [
           {id: :start_test, title: 'テスト(時間計測なし)'}
       ]
      },
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
    START_VIEW_SECTIONS.size
  end

  def tableView(tableView, titleForHeaderInSection: section)
    START_VIEW_SECTIONS[section][:header_title]
  end

  def tableView(tableView, numberOfRowsInSection: section)
    START_VIEW_SECTIONS[section][:items].size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell_style, cell_accessory_type =
        case id_of_section(indexPath.section)
          when :games
            [UITableViewCellStyleDefault,
             UITableViewCellAccessoryNone]
          when :settings
            case item_hash(indexPath)[:id]
              when :number_of_poems
                [UITableViewCellStyleValue1,
                 UITableViewCellAccessoryDetailDisclosureButton]
              when :show_wrong_asap
                [UITableViewCellStyleSubtitle,
                UITableViewCellAccessoryNone]
              else ; [nil, nil]
            end

          else ; [nil, nil]
        end
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(cell_style,
                                            reuseIdentifier: @reuseIdentifier)


    cell.tap do |c|
      c.textLabel.text = item_hash(indexPath)[:title]
      if c.detailTextLabel
        c.detailTextLabel.text = detail_text(indexPath)
      else
        c.textLabel.textAlignment = UITextAlignmentCenter
        c.textLabel.textColor = UIColor.redColor
      end
      c.accessoryType= cell_accessory_type
      c.accessibilityLabel = "#{item_hash(indexPath)[:id]}"
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)

    method_name = case id_of_section(indexPath.section)
                    when :settings ; "set_#{item_hash(indexPath)[:id]}"
                    when :games    ; "#{item_hash(indexPath)[:id]}"
                  end
    puts "- 呼び出すメソッド => [#{method_name}]"
    self.send("#{method_name}")
  end

  def detail_text(indexPath)
    case item_hash(indexPath)[:id]
      when :number_of_poems ; "#{PoemsNumberPicker.poems_num}"
      when :show_wrong_asap ; item_hash(indexPath)[:detail]
      else ; '未設定'
    end
  end

  def id_of_section(section_idx)
    START_VIEW_SECTIONS[section_idx][:section_id]
  end

  def item_hash(indexPath)
    START_VIEW_SECTIONS[indexPath.section][:items][indexPath.row]
  end

  def start_test
    UIApplication.sharedApplication.setStatusBarHidden(true, animated: true)
    navigationController.pushViewController(
    ExamController.alloc.initWithHash(
        {
          shuffle_with_size: PoemsNumberPicker.poems_num,
          wrong_char_allowed: true,
        }),
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