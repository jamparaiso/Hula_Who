
--Ancient Era Restrictions

local M = {}

function selectRestriction(param)
	local i = tonumber(param)

	
	local myTable = {
--level 1		
		{ 
			level = {
				timeRes = 51,
				corAns = 5,
				wroAns = 5,
				level = 1,
				}
			},
-- level 2
		{
			level = {
				timeRes = 50,
				corAns = 5,
				wroAns = 5,
				level = 2,
				}
			},
--level 3				
		{
			level = {
				timeRes = 49,
				corAns = 5,
				wroAns = 5,
				level = 3,
				}
			},
--level 4
		{
			level = {
				timeRes = 48,
				corAns = 7,
				wroAns = 4,
				level = 4,
				}
			},
--level 5
		{
			level = {
				timeRes = 47,
				corAns = 7,
				wroAns = 4,
				level = 5,
				}
			},
--level 6
		{
			level = {
				timeRes =46 ,
				corAns = 7,
				wroAns = 4,
				level = 6,
				}
			},
--level 7
		{
			level = {
				timeRes =45 ,
				corAns = 8,
				wroAns = 3,
				level = 7,
				}
			},
--level 8
		{
			level = {
				timeRes =44 ,
				corAns = 8,
				wroAns = 3,
				level = 8,
				}
			},
--level 9
		{
			level = {
				timeRes =43 ,
				corAns = 8,
				wroAns = 3,
				level = 9,
				}
			},
--level 10
		{
			level = {
				timeRes =42 ,
				corAns = 9,
				wroAns = 3,
				level = 10,
				}
			},																			
}

return myTable[i].level
	
end
M.selectRestriction = selectRestriction

return M