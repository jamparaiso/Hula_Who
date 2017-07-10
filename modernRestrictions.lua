
--Modern Age Restrictions

local M = {}

function selectRestriction(param)
	local i = tonumber(param)

	
	local myTable = {
--level 1		
		{ 
			level = {
				timeRes = 27,
				corAns = 5,
				wroAns = 5,
				reward = 50,
				}
			},
-- level 2
		{
			level = {
				timeRes = 26,
				corAns = 5,
				wroAns = 5,
				reward = 40,
				}
			},
--level 3				
		{
			level = {
				timeRes = 25,
				corAns = 5,
				wroAns = 5,
				reward = 45,
				}
			},
--level 4				
		{
			level = {
				timeRes = 24,
				corAns = 7,
				wroAns = 4,
				reward = 45,
				}
			},	
--level 5				
		{
			level = {
				timeRes = 23,
				corAns = 7,
				wroAns = 4,
				reward = 45,
				}
			},
--level 6				
		{
			level = {
				timeRes = 22,
				corAns = 7,
				wroAns = 4,
				reward = 45,
				}
			},
--level 7				
		{
			level = {
				timeRes = 21,
				corAns = 8,
				wroAns = 3,
				reward = 45,
				}
			},
--level 8				
		{
			level = {
				timeRes = 20,
				corAns = 8,
				wroAns = 3,
				reward = 45,
				}
			},	
--level 9				
		{
			level = {
				timeRes = 19,
				corAns = 8,
				wroAns = 3,
				reward = 45,
				}
			},			
--level 10				
		{
			level = {
				timeRes = 18,
				corAns = 9,
				wroAns = 3,
				reward = 45,
				}
			},			
--level 11				
		{
			level = {
				timeRes = 17,
				corAns = 9,
				wroAns = 3,
				reward = 45,
				}
			},			
--level 12				
		{
			level = {
				timeRes = 16,
				corAns = 9,
				wroAns = 3,
				reward = 45,
				}
			},			
--level 13				
		{
			level = {
				timeRes = 15,
				corAns = 10,
				wroAns = 2,
				reward = 45,
				}
			},	
--level 14				
		{
			level = {
				timeRes = 14,
				corAns = 10,
				wroAns = 2,
				reward = 45,
				}
			},			
--level 15				
		{
			level = {
				timeRes = 13,
				corAns = 10,
				wroAns = 2,
				reward = 45,
				}
			},							
}

return myTable[i].level
	
end
M.selectRestriction = selectRestriction

return M