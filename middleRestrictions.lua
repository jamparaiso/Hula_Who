
--Middle Age Restrictions

local M = {}

function selectRestriction(param)
	local i = tonumber(param)

	
	local myTable = {
--level 1		
		{ 
			level = {
				timeRes = 43,
				corAns = 5,
				wroAns = 5,
				reward = 30,
				}
			},
-- level 2
		{
			level = {
				timeRes = 42,
				corAns = 5,
				wroAns = 5,
				reward = 20,
				}
			},
--level 3				
		{
			level = {
				timeRes = 41,
				corAns = 5,
				wroAns = 5,
				reward = 30,
				}
			},
--level 4
		{
			level = {
				timeRes = 40,
				corAns = 7,
				wroAns = 4,
				reward = 30,
				}
			},
--level 5
		{
			level = {
				timeRes = 39,
				corAns = 7,
				wroAns = 4,
				reward = 30,
				}
			},
--level 6
		{
			level = {
				timeRes = 38,
				corAns = 7,
				wroAns = 4,
				reward = 30,
				}
			},
--level 7
		{
			level = {
				timeRes = 37,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},
--level 8
		{
			level = {
				timeRes = 36,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},
--level 9
		{
			level = {
				timeRes = 35,
				corAns = 8,
				wroAns = 3,
				reward = 30,
				}
			},
--level 10
		{
			level = {
				timeRes = 34,
				corAns = 9,
				wroAns = 3,
				reward = 30,
				}
			},				
}

return myTable[i].level
	
end
M.selectRestriction = selectRestriction

return M