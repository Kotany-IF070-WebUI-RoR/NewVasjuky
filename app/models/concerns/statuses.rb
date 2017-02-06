# Encoding: utf-8
module Statuses
  STATUSES = { pending:  'очікує',
               opened:   'прийнято',
               declined: 'відхилено',
               closed:   'вирішено' }.with_indifferent_access.freeze
  STATUSES_SYM = STATUSES.keys.map(&:to_sym)
end
