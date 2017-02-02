# Encoding: utf-8
module Statuses
  STATUSES = { opened: 'Запит прийнято',
               pending: 'Очікує на модерацію',
               declined: 'Запит відхилено',
               closed: 'Запит вирішено' }.with_indifferent_access.freeze
  STATUSES_SYM = STATUSES.keys.map(&:to_sym)
end
