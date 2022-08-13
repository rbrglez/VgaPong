##########################################################################################
# Applications must define the 32-bitFirmware Version Number
##########################################################################################
export PRJ_VERSION = 0x00000001

##########################################################################################
# Application have the option to remove unused source code from Vivado project
#     If GIT_BYPASS = 0, building will fail if code isn't committed
#     If GIT_BYPASS = 1, building will pass, even if all of the code isn't committed
##########################################################################################
export GIT_BYPASS = 1

##########################################################################################
# Application have the option to remove unused source code from Vivado project
#     If REMOVE_UNUSED_CODE = 0, all source code is kept after importing to Vivado project
#     If REMOVE_UNUSED_CODE = 1, all unused source code is removed from Vivado project
##########################################################################################
export REMOVE_UNUSED_CODE = 0

##########################################################################################
# Application have the option to ignore "Unsafe" and/or "Unconstrained Clocks" issues
#     If TIG_UNSAFE = true, ignore "Unsafe" and/or "Unconstrained Clocks" issues
#     If TIG_UNSAFE = false, exit on "Unsafe" and/or "Unconstrained Clocks" issues
##########################################################################################
export TIG_UNSAFE = true

##########################################################################################
# Override location of a build directory
##########################################################################################
export TOP_DIR = $(abspath $(PWD)/../..)

##########################################################################################
############################  DO NOT EDIT THE CODE BELOW  ################################
##########################################################################################

# Define target output
target: prom

# Define target part
export PRJ_PART = xc7a35ticsg324-1L

# Use top level makefile
include $(TOP_DIR)/submodules/ruckus/system_vivado.mk