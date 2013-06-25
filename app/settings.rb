# Qiitaに掲載されていたコード。
# http://qiita.com/torshinor/items/2c783d9ae4696e31a98b

class Settings
  # 各種設定の名前
  PROPERTIES = %w(volume)

  class << self
    def instance
      Dispatch.once { @instance ||= Settings.new }
      @instance
    end
  end



  # getter、setterを動的に生成
  PROPERTIES.each do |name|
    define_method("#{name}=") do |v|
      App::Persistence[name] = v
    end
    define_method("#{name}") do
      App::Persistence[name]
    end
  end
end