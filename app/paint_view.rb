class PaintView < UIView

  def initWithFrame(frame)
    if super
      @hue = 0.0;
      self.init_cache_context(frame.size)
    end
    self
  end

  def init_cache_context(size)
    bitmap_bytes_per_row = size.width * 4
    bitmap_byte_count = bitmap_bytes_per_row * size.height

    cache_bitmap = Pointer.new(:char, bitmap_byte_count)
    @cached_context = CGBitmapContextCreate(cache_bitmap, size.width, size.height, 8, bitmap_bytes_per_row, CGColorSpaceCreateDeviceRGB(), KCGImageAlphaNoneSkipFirst)
    true
  end

  def touchesMoved(touches, withEvent:event)
    @touch = touches.anyObject
    self.draw_to_cache(@touch)
  end

  def draw_to_cache(touch)
    color = UIColor.colorWithHue(@hue, saturation:0.7, brightness:1.0, alpha:1.0)

    CGContextSetStrokeColorWithColor(@cached_context, color.CGColor)
    CGContextSetLineCap(@cached_context, KCGLineCapRound)
    CGContextSetLineWidth(@cached_context, 15)
    
    last_point = @touch.previousLocationInView(self)
    new_point = @touch.locationInView(self)

    CGContextMoveToPoint(@cached_context, last_point.x, last_point.y)
    CGContextAddLineToPoint(@cached_context, new_point.x, new_point.y)
    CGContextStrokePath(@cached_context)
    self.setNeedsDisplay()
  end

  def drawRect(rect)
    context = UIGraphicsGetCurrentContext()
    cache_image = CGBitmapContextCreateImage(@cached_context)
    CGContextDrawImage(context, self.bounds, cache_image)
  end

end
