class MarkdownCell < Cell::Rails
  include Yard
  
  def markdown_widget(args)
    @options = args[:options]
    @snip_id = args[:snip_id]
    render
  end
  
  helper_method :format_text
  def format_text(t)
    Lesstile.format_as_html(t, :code_formatter => Lesstile::CodeRayFormatter, :text_formatter => lambda { |text|
      text = BlueCloth::new(text).to_html
    }).html_safe
  end
end