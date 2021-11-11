local const = {}

const.api_infix = ".cmake/api/v1/"

const.codemodel = "codemodel"
const.cache = "cache"
const.cmake_files = "cmakeFiles"
const.toolchains = "toolchains"

const.query_infix = const.api_infix .. "query/"
const.client_query_infix = const.query_infix .. "client-nvim/"
const.client_stateful_query_file_name = "query.json"
const.client_stateful_query_suffix = const.client_query_infix
  .. const.client_stateful_query_file_name

const.reply_infix = const.api_infix .. "reply/"
const.reply_file_infix = const.reply_infix .. "index-"
const.reply_file_suffix = ".json"

const.old_lazy_key = "jsonFile"
const.new_lazy_key = "lazy"

const.client_name = "client-nvim"

const.scheduled_key = "scheduled"

return const
