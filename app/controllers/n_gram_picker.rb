class NGramPicker < UITableViewController
  N_GRAM_SECTIONS = [
      {section_id: :one,
       header_title: '一枚札',
       items: [
           {id: :just_one, title: '「む,す,め,ふ,さ,ほ,せ」で始まる歌'},
       ]
      },
      {section_id: :two,
       header_title: '二枚札',
       items: [
           {id: :u,   title: '「う」で始まる歌'},
           {id: :tsu, title: '「つ」で始まる歌'},
           {id: :shi, title: '「し」で始まる歌'},
           {id: :mo,  title: '「も」で始まる歌'},
           {id: :yu,  title: '「ゆ」で始まる歌'},
       ]
      },
  ]

  BC_HALF_IMG_FILE = 'blue_circle_half.png'

  def viewDidLoad
    super

    view.backgroundColor = UIColor.whiteColor
    self.title = '1文字目で選ぶ'
    self.view.initWithFrame(self.view.bounds,
                            style: UITableViewStyleGrouped)
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
    cell.imageView.image =
        ResizeUIImage.resizeImage(UIImage.imageNamed(BC_HALF_IMG_FILE),
                                  newSize: CGSizeMake(height_of(cell),
                                                      height_of(cell)))

    cell
  end

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

end