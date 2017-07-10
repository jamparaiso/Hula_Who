
--Early Modern Age Restrictions

local M = {}

function selectRestriction(param)
	local i = tonumber(param)

	
	local myTable = {
--level 1		
		{ 
			level = {
				timeRes = 35,
				corAns = 5,
				wroAns = 5,
				reward = 25,
				}
			},
-- level 2
		{
			level = {
				timeRes = 34,
				corAns = 5,
				wroAns = 5,
				reward = 40,
				}
			},
--level 3				
		{
			level = {
				timeRes = 33,
				corAns = 5,
				wroAns = 5,
				reward = 35,
				}
			},
--level 4
		{
			level = {
				timeRes = 32,
				corAns = 7,
				wroAns = 4,
				reward = 35,
				}
			},
--level 5
		{
			level = {
				timeRes = 31,
				corAns = 7,
				wroAns = 4,
				reward = 30,
				}
			},	
--level 6
		{
			level = {
				timeRes = 30,
				corAns = 7,
				wroAns = 4,
				reward = 30,
				}
			},	
--level 7
		{
			level = {
				timeRes = 29,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},
--level 8
		{
			level = {
				timeRes = 28,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},	
--level 9
		{
			level = {
				timeRes = 27,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},		
--level 10
		{
			level = {
				timeRes = 26,
				corAns = 9,
				wroAns = 3,
				reward = 30,
				}
			},
--level 11
		{
			level = {
				timeRes = 25,
				corAns = 9,
				wroAns = 3,
				reward = 30,
				}
			},
--level 12
		{
			level = {
				timeRes = 24,
				corAns = 9,
				wroAns = 3,
				reward = 30,
				}
			},
--level 13
		{
			level = {
				timeRes = 23,
				corAns = 10,
				wroAns = 2,
				reward = 30,
				}
			},
--level 14
		{
			level = {
				timeRes = 22,
				corAns = 10,
				wroAns = 2,
				reward = 30,
				}
			},
--level 15
		{
			level = {
				timeRes = 21,
				corAns = 10,
				wroAns = 2,
				reward = 30,
				}
			},
}

return myTable[i].level
	
end
M.selectRestriction = selectRestriction

return M