-- ============================================================================
-- File:        textobj_sentence.vim
-- Description: load functions for vim-textobj_sentence plugin
-- Maintainer:  preservim <https://github.com/preservim>
-- Created:     January 25, 2013
-- License:     The MIT License (MIT)
-- ============================================================================

local M = {}

local function select(pattern)
	vim.fn.search(pattern, "bc")
	local start = vim.fn.getpos(".")
	vim.fn.search(pattern, "ce")
	local ed = vim.fn.getpos(".")
	return { "v", start, ed }
end

function M.select_a()
	if not vim.b.textobj_sentence_re_a then
		M.setup()
	end
	return select(vim.b.textobj_sentence_re_a)
end

function M.select_i()
	if not vim.b.textobj_sentence_re_i then
		M.setup()
	end
	return select(vim.b.textobj_sentence_re_i)
end

function M.setup(opts)
	opts = opts or {}

	local double_pair = opts.double or vim.g["textobj#sentence#doubleDefault"]
	local single_pair = opts.single or vim.g["textobj#sentence#singleDefault"]

	-- obtain the individual quote characters
	local d_arg = vim.fn.split(double_pair, [[\zs]])
	local s_arg = vim.fn.split(single_pair, [[\zs]])
	vim.b.textobj_sentence_quote_dl = d_arg[0]
	vim.b.textobj_sentence_quote_dr = d_arg[1]
	vim.b.textobj_sentence_quote_sl = s_arg[0]
	vim.b.textobj_sentence_quote_sr = s_arg[1]

	local quotes_std = '"*_'
	local leading = [[(\[]] .. quotes_std .. vim.b.textobj_sentence_quote_sl .. vim.b.textobj_sentence_quote_dl
	local trailing = [==[)\]]==] .. quotes_std .. vim.b.textobj_sentence_quote_sr .. vim.b.textobj_sentence_quote_dr

	-- Avoid matching where more of the sentence can be found on preceding line(s)
	local re_negative_lookback = "(["
		.. leading
		.. "[:alnum:]–—()"
		.. [==[\[\]]==]
		.. "_*,;:-]"
		.. [[\_s]]
		.. "*)@2000<!"

	-- body (sans terminator) starts with start-of-file, or
	-- an uppercase character
	local re_sentence_body = [[(%^\zs|\n\s*\n\s*\zs|[]] .. leading .. "]*[[:upper:]][^.])" .. [[\_.{-}]]

	local abbreviations = opts.abbreviations or vim.g["textobj#sentence#abbreviations"]
	local bounded_abbrs = #abbreviations and "|<(" .. table.concat(abbreviations, "|") .. ")>" or ""

	local max_abbrev_len = 10 -- allow for lookback on -1.2345678
	local re_abbrev_neg_lookback = "([-0-9]+" .. bounded_abbrs .. ")@" .. max_abbrev_len .. "<!"

	-- matching against end of sentence, '!', '?', and non-abbrev '.'
	local re_term = "([!?]|(" .. re_abbrev_neg_lookback .. [[\.))+[]] .. trailing .. "]*"

	-- sentence can also end when followed by at least two line feeds
	local re_sentence_term = "(" .. re_term .. [[|\ze(\s*\n\s*\n\s*|\_s*%$))]]

	-- the 'inner' pattern
	vim.b.textobj_sentence_re_i = "\v" .. re_negative_lookback .. re_sentence_body .. re_sentence_term

	-- include all whitespace to end of line
	vim.b.textobj_sentence_re_a = vim.b.textobj_sentence_re_i .. [[\s*]]

	if type(vim.fn["textobj#user#plugin"]) == "function" then
		vim.fn["textobj#user#plugin"]("sentence", {
			select = {
				["select-a"] = "a" .. vim.g["textobj#sentence#select"],
				["select-i"] = "i" .. vim.g["textobj#sentence#select"],
				["*select-a-function*"] = M.select_a,
				["*select-i-function*"] = M.select_i,
			},
			move = {
				pattern = vim.b.textobj_sentence_re_i,
				["move-p"] = vim.g["textobj#sentence#move_p"],
				["move-n"] = vim.g["textobj#sentence#move_n"],
				["move-P"] = "g" .. vim.g["textobj#sentence#move_p"],
				["move-N"] = "g" .. vim.g["textobj#sentence#move_n"],
			},
		})
	end
end

return M
