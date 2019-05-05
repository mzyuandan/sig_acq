##############################################  
#		AUTHOR:			MZ 
#		DATE:				2012.8.2 
#		REV:				1.0
############################################# 
 
#----------------------------------------- GLOBAL ------------------------------------------# 
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"  

#----------------------------------------- PLL constrate ------------------------------------------# 


#----------------------------------------- GLOBLE signals ------------------------------------------# 
set_location_assignment PIN_27 -to clk_in
set_location_assignment PIN_29 -to rst_in


#----------------------------------------- LED ------------------------------------------#
set_location_assignment PIN_120 -to led[0]
set_location_assignment PIN_124 -to led[1]
set_location_assignment PIN_130 -to led[2]


#----------------------------------------- UART ------------------------------------------#
set_location_assignment PIN_60 -to rxd0
set_location_assignment PIN_59 -to txd0
set_location_assignment PIN_54 -to rxd1
set_location_assignment PIN_52 -to txd1


#----------------------------------------- ADC0 ------------------------------------------#
set_location_assignment PIN_70 -to cs0
set_location_assignment PIN_66 -to int0
set_location_assignment PIN_62 -to slck0
set_location_assignment PIN_64 -to fs0
set_location_assignment PIN_65 -to sdo0
set_location_assignment PIN_69 -to sdi0
set_location_assignment PIN_47 -to cstart0


#----------------------------------------- ADC1 ------------------------------------------#
set_location_assignment PIN_79 -to cs1
set_location_assignment PIN_77 -to int1
set_location_assignment PIN_74 -to slck1
set_location_assignment PIN_75 -to fs1
set_location_assignment PIN_76 -to sdo1
set_location_assignment PIN_78 -to sdi1
set_location_assignment PIN_80 -to cstart1


#----------------------------------------- ADC2 ------------------------------------------#
set_location_assignment PIN_110 -to cs2
set_location_assignment PIN_113 -to int2
set_location_assignment PIN_119 -to slck2
set_location_assignment PIN_118 -to fs2
set_location_assignment PIN_114 -to sdo2
set_location_assignment PIN_111 -to sdi2
set_location_assignment PIN_30 -to cstart2


#----------------------------------------- Pulse signal ------------------------------------------#
set_location_assignment PIN_81 -to x9b51_st
set_location_assignment PIN_85 -to x9b57_tr
set_location_assignment PIN_84 -to x9b54_tp
set_location_assignment PIN_86 -to x9b63_fsdp
set_location_assignment PIN_105 -to x9b60_agc
set_location_assignment PIN_87 -to x10b1_lmt
set_location_assignment PIN_92 -to x10b4_fht
set_location_assignment PIN_93 -to x10b7_mdp
set_location_assignment PIN_99 -to x10b10_prf
set_location_assignment PIN_97 -to x10b13_frm
set_location_assignment PIN_100 -to x10b16_sdp
set_location_assignment PIN_101 -to x10b19_rdw
set_location_assignment PIN_102 -to x10b34_sd
set_location_assignment PIN_106 -to rad_pwr_on

#----------------------------------------- Backup signals ------------------------------------------#
set_location_assignment PIN_50 -to wdi
set_location_assignment PIN_6 -to bk_din[0]
set_location_assignment PIN_7 -to bk_din[1]
set_location_assignment PIN_8 -to bk_din[2]
set_location_assignment PIN_10 -to bk_din[3]
set_location_assignment PIN_11 -to bk_din[4]
set_location_assignment PIN_12 -to bk_din[5]
set_location_assignment PIN_13 -to bk_din[6]
set_location_assignment PIN_14 -to bk_din[7]
set_location_assignment PIN_21 -to bk_v28_d[0]
set_location_assignment PIN_22 -to bk_v28_d[1]
set_location_assignment PIN_24 -to bk_v28_d[2]
set_location_assignment PIN_25 -to bk_v28_d[3]
set_location_assignment PIN_131 -to bk_v28_d[4]
set_location_assignment PIN_132 -to bk_v28_d[5]
set_location_assignment PIN_140 -to bk_v28_d[6]
set_location_assignment PIN_141 -to bk_v28_d[7]


#----------------------------------------- ARM signals ------------------------------------------#	
set_location_assignment PIN_33 -to clk_arm
set_location_assignment PIN_38 -to rst_arm
set_location_assignment PIN_46 -to ssi0_clk
set_location_assignment PIN_45 -to ssi0_fss
set_location_assignment PIN_44 -to ssi0_xdat0
set_location_assignment PIN_43 -to ssi0_xdat1
set_location_assignment PIN_41 -to ssi0_xdat2
set_location_assignment PIN_39 -to ssi0_xdat3

#-----------------------------------------CURRENT_STRENGTH------------------------------------------# 
