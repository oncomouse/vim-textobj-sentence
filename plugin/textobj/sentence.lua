-- ============================================================================
-- File:        textobj_sentence.vim
-- Description: load functions for vim-textobj_sentence plugin
-- Maintainer:  preservim <https://github.com/preservim>
-- Created:     January 27, 2013
-- License:     The MIT License (MIT)
-- ============================================================================

if not vim.g["textobj#sentence#select"] then
	vim.g["textobj#sentence#select"] = "s"
end

if not vim.g["textobj#sentence#move_p"] then
	vim.g["textobj#sentence#move_p"] = "("
end

if not vim.g["textobj#sentence#move_n"] then
	vim.g["textobj#sentence#move_n"] = ")"
end

vim.g["textobj#sentence#doubleStandard"] = "“”"
vim.g["textobj#sentence#singleStandard"] = "‘’"

if not vim.g["textobj#sentence#doubleDefault"] then
	--  “double”
	vim.g["textobj#sentence#doubleDefault"] = vim.g["textobj#sentence#doubleStandard"]
end
if not vim.g["textobj#sentence#singleDefault"] then
	--  ‘single’
	vim.g["textobj#sentence#singleDefault"] = vim.g["textobj#sentence#singleStandard"]
end

if not vim.g["textobj#sentence#abbreviations"] then
	vim.g["textobj#sentence#abbreviations"] = {
		"[ABCDIMPSUabcdegimpsv]",
		"l[ab]",
		"[eRr]d",
		"Ph",
		"[Ccp]l",
		"[Lli]n",
		"[cn]o",
		"[Oe]p",
		"[DJMSh]r",
		"[MVv]s",
		"[CFMPScfpw]t",
		"alt",
		"[Ee]tc",
		"div",
		"es[pt]",
		"[Ll]td",
		"min",
		"[MD]rs",
		"[Aa]pt",
		"[Aa]ve?",
		"[Ss]tr?",
		"[Aa]ssn",
		"[Bb]lvd",
		"[Dd]ept",
		"incl",
		"Inst",
		"Prof",
		"Univ",
		"Messrs",
	}
end
