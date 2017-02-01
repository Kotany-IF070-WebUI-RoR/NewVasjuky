# Encoding: utf-8
module Statuses
  STATUSES = { 'opened' => 'Запит прийнято',
               'pending' => 'Очікує на модерацію',
               'declined' => 'Запит відхилено',
               'closed' => 'Запит вирішено' }.freeze

  STATUSES_SYM = [:pending, :declined, :opened, :closed].freeze
end
