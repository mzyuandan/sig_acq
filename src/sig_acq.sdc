###########################################################################
#
# Generated by : Version 10.0 Build 262 08/18/2010 Service Pack 1 SJ Full Version
#
# Project      : wb_hf_phy
# Revision     : wb_hf_phy
#
# Date         : Sat Jul 21 10:20:42 +0800 2012
#
###########################################################################
 
 
# WARNING: Expected ENABLE_CLOCK_LATENCY to be set to 'ON', but it is set to 'OFF'
#          In SDC, create_generated_clock auto-generates clock latency
#
# ------------------------------------------
#
# Create generated clocks based on PLLs
derive_pll_clocks -use_tan_name
#
# ------------------------------------------


# Original Clock Setting Name: clk_in
create_clock -period "54.253 ns"  -name {clk_in} {clk_in}
# ---------------------------------------------


# ** Clock Latency
#    -------------

# ** Clock Uncertainty
derive_clock_uncertainty -overwrite
#    -----------------

# ** Multicycles
#    -----------

# ** False Path
#    -----------

# ** Cuts
#    ----

# ** Input/Output Delays

#    -------------------




# ** Tpd requirements
#    ----------------

# ** Setup/Hold Relationships
#    ------------------------

# ** Tsu/Th requirements
#    -------------------


# ** Tco/MinTco requirements
#    -----------------------

#
# Entity Specific Timing Assignments found in
# the Timing Analyzer Settings report panel
#


# ---------------------------------------------

