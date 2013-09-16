# coding: utf-8

class StartViewController < UITableViewController
  include SelectedStatusHandler

  attr_reader :table, :wrong_asap_cell

  TITLE = '百首決まり字'

  START_VIEW_SECTIONS = [
      {section_id: :settings,
       header_title: '設定',
       items: [
           {id: :poems_selected, title: '使う歌(工事中)'},
           {id: :number_of_poems, title: 'テストする歌の数'},
           {id: :show_wrong_asap, title: '間違ったらすぐお知らせ',
            detail: '誤った文字を押した時点で通知します',
            no_action: true},
           {id: :main_button_sound, title: '字を選んだ時の音'},
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
    self.title = TITLE
#    UIApplication.sharedApplication.setStatusBarHidden(false, animated: false)
    self.view.initWithFrame(self.view.bounds,
                            style: UITableViewStyleGrouped)
  end

  def viewWillAppear(animated)
#    super
    unless RUBYMOTION_ENV == 'test'
#      navigationController.setNavigationBarHidden(true, animated: false)
      navigationController.setNavigationBarHidden(false, animated: false)
      navigationController.navigationBar.translucent = false
      navigationController.navigationBar.alpha = 1.0
    end
    self.view.reloadData
    self.navigationItem.title = TITLE
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
    # 一応慣例に従ってreuseIdentifierは作成するが、
    # この画面を作る負荷は小さいので、問題が出ない限り使わない。
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    case id_of_section(indexPath)
      when :games
        GameStartCell.alloc.initWithText(text_of(indexPath),
                                         reuseIdentifier: @reuseIdentifier)
      when :settings
        case id_of_item(indexPath)
          when :number_of_poems
            SettingCellWithArrow.alloc.initWithText(text_of(indexPath),
                                                    detail: detail_text(indexPath),
                                                    reuseIdentifier: @reuseIdentifier)
          when :show_wrong_asap
            @wrong_asap_cell =
                SettingCellWithSwitch.alloc.initWithText(text_of(indexPath),
                                                         detail: detail_text(indexPath),
                                                         on_status: initial_wrong_asap,
                                                         reuseIdentifier: @reuseIdentifier)
            @wrong_asap_cell.set_callback(self, method: 'save_wrong_asap_flg')
            @wrong_asap_cell
          when :main_button_sound
            SettingCellWithArrow.alloc.initWithText(text_of(indexPath),
                                                    detail: detail_text(indexPath),
                                                    reuseIdentifier: @reuseIdentifier)

          when :poems_selected
            SettingCellWithArrow.alloc.initWithText(text_of(indexPath),
                                                    detail: detail_text(indexPath),
                                                    reuseIdentifier: @reuseIdentifier)
          else
            nil
        end
      else
        nil
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    return if item_hash(indexPath)[:no_action]
    method_name = case id_of_section(indexPath)
                    when :settings ; "set_#{item_hash(indexPath)[:id]}"
                    when :games    ; "#{item_hash(indexPath)[:id]}"
                    else ; nil
                  end
    puts "- 呼び出すメソッド => [#{method_name}]"
    self.send("#{method_name}")
  end

  def detail_text(indexPath)
    case item_hash(indexPath)[:id]
      when :number_of_poems ; "#{PoemsNumberPicker.poems_num}"
      when :show_wrong_asap ; item_hash(indexPath)[:detail]
      when :main_button_sound ; MainButtonSoundPicker.current_label_name
      when :poems_selected  ; "#{selected_poems_number}首"
      else ; '未設定'
    end
  end

  def id_of_section(indexPath)
    START_VIEW_SECTIONS[indexPath.section][:section_id]
  end

  def item_hash(indexPath)
    START_VIEW_SECTIONS[indexPath.section][:items][indexPath.row]
  end

  def id_of_item(indexPath)
    item_hash(indexPath)[:id]
  end


  def text_of(indexPath)
    item_hash(indexPath)[:title]
  end

  def start_test
    UIApplication.sharedApplication.setStatusBarHidden(true, animated: true)
#    save_wrong_asap_flg()
    navigationController.pushViewController(
    ExamController.alloc.initWithHash(
        {
          shuffle_with_size: PoemsNumberPicker.poems_num,
          wrong_char_allowed: !@wrong_asap_cell.switch_on?,
        }),
        animated: true)
  end

  def save_wrong_asap_flg
#    puts '- saving [wrong_asap]'
    UIApplication.sharedApplication.delegate.settings.wrong_asap = @wrong_asap_cell.switch_on?
  end

  def initial_wrong_asap
    saved_flg = UIApplication.sharedApplication.delegate.settings.wrong_asap
    case saved_flg
      when nil; false
      else    ; saved_flg
    end
  end

  def set_number_of_poems
#    puts '  → これから歌の数を設定します！'
    navigationController.pushViewController(
        PoemsNumberPicker.alloc.initWithNibName(nil, bundle: nil),
        animated: true)
  end

  def set_main_button_sound
    puts '  → これからメインボタンを押したときのサウンドを設定します！'
    navigationController.pushViewController(
        MainButtonSoundPicker.alloc.init,
        animated: true)
  end

  def set_poems_selected
    navigationController.pushViewController(
        PoemPicker.alloc.init,
        animated: true
    )
  end

  def selected_poems_number
    status_array = loaded_selected_status || []
    status_array.select{|stat| stat}.size
  end

end