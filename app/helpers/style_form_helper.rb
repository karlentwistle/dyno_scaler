# frozen_string_literal: true

module StyleFormHelper
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

  def checkbox_input_container_class
    'flex items-center h-5'
  end

  def checkbox_input_class
    [
      'w-4 ',
      'h-4 ',
      'text-blue-600 ',
      'bg-gray-100 ',
      'border-gray-300 ',
      'rounded ',
      'focus:ring-blue-500 ',
      'dark:focus:ring-blue-600 ',
      'dark:ring-offset-gray-800 ',
      'dark:focus:ring-offset-gray-800 ',
      'focus:ring-2 ',
      'dark:bg-gray-700 ',
      'dark:border-gray-600'
    ]
  end

  def checkbox_label_container_class
    'ml-2 text-sm'
  end

  def checkbox_label_class
    'font-medium text-gray-900 dark:text-gray-300'
  end

  def checkbox_label_additional_info_class
    'text-xs font-normal text-gray-500 dark:text-gray-400'
  end
end
