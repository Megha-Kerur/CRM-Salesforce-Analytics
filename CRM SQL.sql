use crm;
show tables;
select * from account;
select * from `lead`;
select * from `oppertuninty table`;
select * from `opportunity product`;
select * from `user table`;

#Closed Won opprtunites by Lead_source
select `Lead Source` , count(`opportunity Id`) as No_of_leads
from `Oppertuninty Table`
where stage = 'Closed Won'
group by `Lead Source` 
order by No_of_leads desc;

#Closed Lost opportunities by Reasons
select `closed lost reason`, count(`opportunity id`) as Reasons_count
from `Oppertuninty Table`
where stage = 'Closed Lost'
group by `closed lost reason`
order by Reasons_count desc;


#Account Ratings and no of Closed Won opportunities
select a.`Account ID`, a.`Account Name`, a.`Account Rating`,a.`Billing Country`,count(ot.`opportunity id`) as No_of_opportunities
from Account as a inner join `Oppertuninty Table` as ot
on a.`account id` = ot.`Account id`
where ot.stage = 'Closed Won'
group by a.`Account ID`, a.`Account Name`, a.`Account Rating`,a.`Billing Country`
order by No_of_opportunities desc ;

#Oportunity Table
#Win Rate
SELECT 
    CAST(closed_won AS FLOAT) / total * 100 AS Win_Rate, 
    closed_won,
    total
FROM (
    SELECT 
        (SELECT COUNT(`opportunity id`) 
         FROM `Oppertuninty Table` 
         WHERE stage = 'Closed Won') AS closed_won,
        COUNT(`opportunity id`) AS total
    FROM `Oppertuninty Table`
) AS t;


#Opportunities By Industry
select industry,count(`opportunity id`)as No_of_Opportunity
from `Oppertuninty Table`
group by industry
order by `No_of_Opportunity` desc;

#Active Opportunities
select count(`opportunity id`) as Active_opportunities
from `Oppertuninty Table`
where stage not in ('Closed Won','Closed Lost');

#Running Total Expected vs Commit Forecast Amount over time
select `Opportunity ID`,`Expected Amount`,`Created Date`,sum(`Expected Amount`) over(order by `Created Date`, `Opportunity id`) as Running_total
from `Oppertuninty Table`;

# -- Oppurtunity Amount
select `Opportunity id`, `Created Date`, Amount
from `Oppertuninty Table`
where `Forecast Category` = 'Commit'
order by `Created Date`;

# -- Leads
#Total Leads
select count(`Lead ID`) as Total_Leads from `Lead`;

#--Expected Amount from converted leads
select ot.`Account ID`,ot.`Opportunity ID`,ot.`Industry`,l.`Lead Source`,
case when ot.`Expected Amount` is Null then 0 else ot.`Expected Amount` end as Expected_Amount
from `Lead` as l inner join `Oppertuninty Table` as ot
on l.`Converted Account ID` = ot.`Account ID`;

#-- Conversion Rates
SELECT 
    CAST(
        (SELECT COUNT(`Lead ID`) 
         FROM `Lead` 
         WHERE Converted = 'True') AS FLOAT
    ) / CAST(COUNT(`Lead ID`) AS FLOAT) * 100 AS Conversion_Rates
FROM `Lead`;


#Converted Accounts
select count(`Converted Account ID`) as Converted_Accounts
from `Lead` where `Converted Account ID` is not NULL;

#Converted Opportunities
select count(`Converted Opportunity ID`) as Converted_Oppotunities
from `Lead` where `Converted Opportunity ID` is not NULL;

#Lead By Source
select case 
when `Lead Source` is Null then 'Other' 
else `Lead Source` 
end as `Lead_Source`,
count(`Lead ID`) as No_of_Leads
from `Lead`
group by `Lead Source`;

#Lead By Industry
select case when `Industry` is Null then 'Other' else `Industry` end as Industry,count(`Lead ID`) as No_of_Leads
from `Lead`
group by `Industry`;

