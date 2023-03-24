# frozen_string_literal: true

module ApplicationHelper
  def header(text)
    content_tag(:h1, class: 'mb-4 text-3xl font-extrabold text-gray-900 dark:text-white md:text-5xl lg:text-6xl') do
      content_tag(:span, class: 'text-transparent bg-clip-text bg-gradient-to-r to-purple-600 from-sky-400') do
        text
      end
    end
  end
end
