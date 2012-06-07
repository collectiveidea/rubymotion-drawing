class MainViewController < UIViewController
  def viewDidLoad
    super

    paintView = PaintView.alloc.initWithFrame(self.view.bounds)
    view.addSubview(paintView)
  end
end
