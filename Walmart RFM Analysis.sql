Use walmart;

-- RFM Analysis
With RFM as (
	Select 
		Concat(City,'-',Customer_Name) as CityCustomer, 
		Max(Order_Date) as LastOrderDay,
		DATEDIFF((Select Max(Order_Date) from walmart),Max(Order_Date)) as Recency,
		Count(Order_Date) as Frequency, 
		sum(Sales) as TotalMonetaryValue,
		Avg(Sales) as AvgMonetaryValue
	From walmart
	Group by  Concat(City,'-',Customer_Name)
	Order by AvgMonetaryValue desc),
    
	RFM_Score as( 
	Select *,
		NTILE(5) over (Order by Recency desc) as Recency_Score, 
		NTILE(5) over (Order by Frequency) as Frequency_Score, 
		NTILE(5) over (Order by AvgMonetaryValue) as Monetary_Score
	From RFM),
    
	Concat_Score as(
	Select *, 
		CONCAT(Recency_Score,Frequency_Score,Monetary_Score) as Concat_Score
	from RFM_Score)

Select	
	*,
    CASE 
		When Concat_Score in (555, 554, 544, 545, 454, 455, 445) then 'Champion' 
		When Concat_Score in (543, 444, 435, 355, 354, 345, 344, 335) then 'Loyal'
        When Concat_Score in (553, 551, 552, 541, 542, 533, 532, 531, 452, 451, 442, 441, 431, 453, 433, 432, 423, 353, 352, 351, 342, 341, 333, 323) then 'Potential Loyalist'
        When Concat_Score in (512, 511, 422, 421, 412, 411, 311) then 'New Customer'
        When Concat_Score in (525, 524, 523, 522, 521, 515, 514, 513, 425,424, 413,414,415, 315, 314, 313.) then 'Promising'
        When Concat_Score in (535, 534, 443, 434, 343, 334, 325, 324) then 'Need Attention'
        When Concat_Score in (155, 154, 144, 214,215,115, 114, 113) then 'Cant Lose'
        When Concat_Score in (331, 321, 312, 221, 213) then 'About To Sleep'
        When Concat_Score in (255, 254, 245, 244, 253, 252, 243, 242, 235, 234, 225, 224, 153, 152, 145, 143, 142, 135, 134, 133, 125, 124) then 'At Risk'
        When Concat_Score in (332, 322, 231, 241, 251, 233, 232, 223, 222, 132, 123, 122, 212, 211.) then 'Hibernating'
        When Concat_Score in (111, 112, 121, 131, 141, 151) then 'Lost'
	End RFM_Segment
from Concat_Score
Order by Frequency desc



