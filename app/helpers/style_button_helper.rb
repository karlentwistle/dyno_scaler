# frozen_string_literal: true

module StyleButtonHelper
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

  def blue_button_class(*additonals)
    (button_base_class + [
      'bg-blue-700',
      'hover:bg-blue-800',
      'focus:ring-blue-300',
      'dark:bg-blue-600',
      'dark:hover:bg-blue-700',
      'dark:focus:ring-blue-800'
    ] + additonals)
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
end
