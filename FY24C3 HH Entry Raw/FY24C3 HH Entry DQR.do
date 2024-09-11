**************************FY24C3 HH Entry DQR************************************************
/*
	purpose of DQR: 
	-Check correct visit detail was selected and reasons for surveys not being completed
	-Investigate any duplicate surveys 
	-Create a time difference variable based on timestamps 
	-Check the number of household members stated versus the actual number of members listed
	-Separate data into functional datasets 
	-Check key variables for any data quality issues or missing data 
	-Confirm all households in sample have been surveyed 
*/
import delimited "C:\Users\RamandhanMasudi\Desktop\Work File\Work File\FY24C3 HH Entry Raw\Raw\FY24C3_Household_Entry_Survey_Part_2_(v1)_2748_5570.csv", varnames(2)
des,short
ta office,mi
keep if office=="Yumbe"
duplicates report hh_id
duplicates tag hh_id, gen (Dups)
ta Dups
li hh_name startdate hh_id mobileuser bm_cycle if Dups>=1
br hh_name startdate hh_id mobileuser bm_cycle if Dups>=1
/*
     +--------------------------------------------------------------------------------------------------+
     |       hh_name                  startdate    hh_id           mobileuser                  bm_cycle |
     |--------------------------------------------------------------------------------------------------|
  1. | Khemisa Moses   2024-05-27 17:01:45+0300   505218   Sadam Khamis Banya   FY24C3 Glorious Ayikoru |
  2. | Achirin Dhieu   2024-05-27 17:01:47+0300   500141        Amina Drateru       FY24C3 Edward Amono |
  3. | Achirin Dhieu   2024-05-27 17:02:18+0300   500141       Phillimon Waka       FY24C3 Edward Amono |
  4. |     Ameer Dut   2024-05-27 17:16:07+0300   500255         Swali Muradi       FY24C3 Edward Amono |
  5. | Achirin Dhieu   2024-05-27 17:16:22+0300   500141        Nadia Manzubo       FY24C3 Edward Amono |
     |--------------------------------------------------------------------------------------------------|
  7. | Achirin Dhieu   2024-05-27 17:21:21+0300   500141       Hidaya Driciru       FY24C3 Edward Amono |
170. |   Angeth Ajah   2024-06-04 12:21:37+0300   504675       Zulaika Majuma       FY24C3 Edward Amono |
182. |     Ameer Dut   2024-06-04 14:18:56+0300   500255   Sadam Khamis Banya       FY24C3 Edward Amono |
189. |   Angeth Ajah   2024-06-04 15:07:29+0300   504675   Sadam Khamis Banya       FY24C3 Edward Amono |
261. |     Ameer Dut   2024-06-06 11:50:22+0300   500255       Zulaika Majuma       FY24C3 Edward Amono |
     |--------------------------------------------------------------------------------------------------|
274. | Khemisa Moses   2024-06-06 13:51:19+0300   505218       Kenedy Munguci   FY24C3 Glorious Ayikoru |
308. | Achirin Dhieu   2024-06-07 10:34:09+0300   500141       Zulaika Majuma       FY24C3 Edward Amono |
     +--------------------------------------------------------------------------------------------------+
*/
drop if date=="2024-05-27"
ta survey_type,mi

*checking the time stamps

    gen str time_start = substr(startdate, 1,16)	
	gen double dt_start = clock(time_start, "YMD hm")
	format dt_start %tc
	
	gen str time_end = substr(enddate, 1,16)
	gen double dt_end = clock(time_end, "YMD hm")
	format dt_end %tc
	
	gen time_diff = minutes(dt_end - dt_start)
	ta time_diff // Check for surveys done in less than 10 min - and drop those survies		
	sum time_diff //ave 50 mins 
	bysort mobileuser : sum time_diff
	save "C:\Users\Ramandhanmasudi\Desktop\Work File\Work File\FY24C3 HH Entry Raw\Raw\FY24C3_Household_Entry_Survey_Part_1_(v3", replace 
	import delimited "C:\Users\Ramandhanmasudi\Desktop\Work File\Work File\FY24C3 HH Entry Raw\Raw\FY24C3_Household_Entry_Survey_Part_1_(v3)_2564_5224.csv", varnames(2)
	


