module ApplicationHelper

  def hidden_tag_if(condition, tag_name, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag(tag_name, attributes, &block)
  end
end
