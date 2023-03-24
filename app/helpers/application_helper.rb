# frozen_string_literal: true

module ApplicationHelper
  def header(text)
    content_tag(:h1, class: 'mb-4 text-3xl font-extrabold text-gray-900 dark:text-white md:text-5xl lg:text-6xl') do
      content_tag(:span, class: 'text-transparent bg-clip-text bg-gradient-to-r to-purple-600 from-sky-400') do
        text
      end
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
    [
      'peer-focus:font-medium',
      'absolute',
      'text-sm',
      'text-gray-500',
      'dark:text-gray-400',
      'duration-300',
      'transform',
      '-translate-y-6',
      'scale-75',
      'top-3',
      '-z-10',
      'origin-[0]',
      'peer-focus:left-0',
      'peer-focus:text-blue-600',
      'peer-focus:dark:text-blue-500',
      'peer-placeholder-shown:scale-100',
      'peer-placeholder-shown:translate-y-0',
      'peer-focus:scale-75',
      'peer-focus:-translate-y-6'
    ]
  end

  def field_class
    [
      'block',
      'py-2.5',
      'px-0',
      'w-full',
      'text-sm',
      'text-gray-900',
      'bg-transparent',
      'border-0',
      'border-b-2',
      'border-gray-300',
      'appearance-none',
      'dark:text-white',
      'dark:border-gray-600',
      'dark:focus:border-blue-500',
      'focus:outline-none',
      'focus:ring-0',
      'focus:border-blue-600',
      'peer'
    ]
  end
end
