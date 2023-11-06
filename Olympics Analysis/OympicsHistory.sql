Create Database Olympics;
Use Olympics;

Select * From athlete_events;

Select * From noc_regions;

Create View OlympicHistory as
Select a.NOC,region From athlete_events as a
Left Join noc_regions as b
on a.NOC = b.NOC;

Select Distinct NOC,region From OlympicHistory Order by 1 asc;

-- 1
Select Count(Distinct Games) From athlete_events;

-- 2
Select  Distinct Games,Year From athlete_events Order by Year;

-- 3
Select Games,Count(DISTINCT NOC) From athlete_events
Group By Games;

-- 4
Select Games,Count(Distinct NOC) as Teams_Played From athlete_events
GROUP BY Games Order By 2 Asc;
Select Games,Count(Distinct NOC) as Teams_Played From athlete_events
GROUP BY Games Order By 2 Desc;

-- 5
With AllGamesPlayed as 
(Select NOC,Count(Distinct Games) as Games_Played From athlete_events 
Group By NOC Order BY 2 Desc)
Select NOC From AllGamesPlayed 
Where Games_Played = 
(Select Count(Distinct Games) From athlete_events);

-- 6
With SummerGamesPlayed as 
(Select Sport,Count(Distinct Games) as Summer_Played From athlete_events
 Where substring_index(Games,' ',-1) = "Summer"
Group By Sport Order BY 2 Desc)
Select Sport From SummerGamesPlayed 
Where Summer_Played = 
(Select Count(Distinct Games) From athlete_events  
Where substring_index(Games,' ',-1) = "Summer") ORDER BY Sport Asc;

-- 7
select Sport,Count( Distinct Games) from athlete_events Group by Sport order by 2;

-- 8 
Select Games,Count(Distinct Sport) from athlete_events group by Games order by 2 desc;

-- 9
Select Name,Age from athlete_events where Medal="Gold" and Age != "NA" order by Age Desc;

-- 11
With t1 as
(Select Name,Medal from athlete_events where Medal = "Gold")
Select Name,Count(Medal) as Golds from t1 Group by Name Order By 2 Desc;

-- 12 
With t1 as
(Select Name,Medal from athlete_events where Medal = "Gold" or Medal = "Silver" or Medal = "Bronze")
Select Name,Count(Medal) from t1 Group by Name Order By 2 Desc Limit 5 ;

-- 13
With t3 as
(select region,Medal from athlete_events as a
left join noc_regions as b
on a.NOC = b.NOC
Where Medal != "NA")
Select region,Count(Medal) from t3 Group by region Order by 2 desc Limit 5;

-- 14
 
With t4 as
(select region,Medal from athlete_events as a
left join noc_regions as b
on a.NOC = b.NOC
Where Medal != "NA"),
t5 as
(Select region,Medal as Gold from t4 where Medal = "Gold"),
t6 as
(Select region,Medal as Silver from t4 where Medal = "Silver"),
t7 as
(Select region,Medal as Bronze from t4 where Medal = "Bronze")
Select t4.region,Count(Gold),Count(Silver),Count(Bronze) from t4,t5,t6,t7 Group by region Order By 2 Desc Limit 5;



select b.region,Medal,Count(medal) from athlete_events as a
left join noc_regions as b
on a.NOC = b.NOC
Where Medal != "NA" 
GROUP BY b.region,medal
Order by b.region,medal;





 

