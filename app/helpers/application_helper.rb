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

  def button_base_class
    [
      'focus:outline-none',
      'text-white',
      'focus:ring-4',
      'font-medium',
      'rounded-lg',
      'text-sm',
      'px-5',
      'py-2.5',
      'mr-2',
      'mb-2'
    ]
  end

  def blue_button_class
    button_base_class + [
      'bg-blue-700',
      'hover:bg-blue-800',
      'focus:ring-blue-300',
      'dark:bg-blue-600',
      'dark:hover:bg-blue-700',
      'dark:focus:ring-blue-800'
    ]
  end

  def red_button_class
    button_base_class + [
      'bg-red-700',
      'hover:bg-red-800',
      'focus:ring-red-300',
      'dark:bg-red-600',
      'dark:hover:bg-red-700',
      'dark:focus:ring-red-900'
    ]
  end

  def label_class
    'block mb-2 text-sm font-medium text-gray-900 dark:text-white'
  end

  def field_class
    [
      'shadow-sm',
      'bg-gray-50',
      'border',
      'border-gray-300',
      'text-gray-900',
      'text-sm',
      'rounded-lg',
      'focus:ring-blue-500',
      'focus:border-blue-500',
      'block',
      'w-full',
      'p-2.5',
      'dark:bg-gray-700',
      'dark:border-gray-600',
      'dark:placeholder-gray-400',
      'dark:text-white',
      'dark:focus:ring-blue-500',
      'dark:focus:border-blue-500',
      'dark:shadow-sm-light'
    ]
  end

  def select_class
    [
      'bg-gray-50',
      'border',
      'border-gray-300',
      'text-gray-900',
      'text-sm',
      'rounded-lg',
      'focus:ring-blue-500',
      'focus:border-blue-500',
      'block',
      'w-full',
      'p-2.5',
      'dark:bg-gray-700',
      'dark:border-gray-600',
      'dark:placeholder-gray-400',
      'dark:text-white',
      'dark:focus:ring-blue-500',
      'dark:focus:border-blue-500'
    ]
  end
end
