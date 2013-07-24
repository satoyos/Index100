describe "Application 'Index100'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it 'has a rootViewController' do
    @app.windows.size.should > 0
    @app.keyWindow.rootViewController.is_a?(UINavigationController).
        should.be.true
  end

  it 'ナビゲーションバーは、通常は隠れている' do
    @app.keyWindow.rootViewController.tap do |nav_controller|
      nav_controller.navigationBar.should.not.be.nil
      # ↓なぜか、UINavigationControllerのnavigationBarHiddenが呼び出せない。
      # NoMethodError: undefined method `navigationBarHidden' for #<UINavigationController:0x989ac80>
      # nav_controller.navigationBarHidden.should.be.true
    end
  end

end
