local path = {}

path.api_infix = ".cmake/api/v1/"
path.query_infix = path.api_infix .. "query/"
path.client_query_infix = path.query_infix .. "client-nvim/"
path.client_stateful_query_suffix = path.query_infix .. "client-nvim/query.json"
path.reply_infix = path.api_infix .. "reply/"
path.reply_file_infix = path.reply_infix .. "index-"
path.reply_file_suffix = ".json"

return path
