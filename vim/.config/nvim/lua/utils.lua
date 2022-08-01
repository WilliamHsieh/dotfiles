local utils = {}

function utils.insert_table(ts)
  return function(t)
    table.insert(ts, t)
  end
end

return utils
