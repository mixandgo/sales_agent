module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)

    markdown.render(text).html_safe
  end
end
