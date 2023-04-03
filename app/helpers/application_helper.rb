# frozen_string_literal: true

module ApplicationHelper
  def header(text)
    content_tag(:h1, class: 'text-3xl font-extrabold text-gray-900 dark:text-white md:text-5xl lg:text-6xl') do
      content_tag(:span, class: 'text-transparent bg-clip-text bg-gradient-to-r to-purple-600 from-sky-400') do
        text
      end
    end
  end

  def subheader(text)
    content_tag(:h2, class: 'font-extrabold dark:text-white text-2xl md:text-3xl lg:text-4xl') do
      text
    end
  end
end
