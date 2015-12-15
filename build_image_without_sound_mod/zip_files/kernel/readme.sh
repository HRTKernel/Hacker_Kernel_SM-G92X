#!/sbin/sh
# Base by glewarne
# Modded for more tweaking by thehacker911

# This is a info file for rom developer.
# Rom developer can same create a kernel profil.
# Create a file with the name "kernel.prop" under /system/ (/system/kernel.prop)
# Add your kernel settings in the file to kernel.prop
#
#------------------------------------------
# Example:
# kernel.scheduler=cfq
#------------------------------------------
#
# None of the kernel settings must be present twice!
#
#------------------------------------------
# Example GOD kernel settings:
# kernel.scheduler=cfq
#
# Example BAD kernel settings:
# kernel.scheduler=cfq
# kernel.scheduler=bfq
#------------------------------------------
#
# Happy tweaking ;)
#
#------------------------------------------
#
# Example kernel settings
# SCHEDULER (set your scheduler)
#
# CFQ
# kernel.scheduler=cfq
#
# BFQ
# kernel.scheduler=bfq
#
# DEADLINE
# kernel.scheduler=deadline
#
# FIOPS
# kernel.scheduler=fiops
#
# NOOP
# kernel.scheduler=noop
#
# SIOPLUS
# kernel.scheduler=sioplus
#
# TRIPNDROID
# kernel.scheduler=tripndroid
#----------------------------
# Governor
#
# ALUCARD
# kernel.governor=alucard
#
# BIOSHOCK
# kernel.governor=bioshock
#
# CONSERVATIVE
# kernel.governor=conservative
#
# CONSERVATIVEX
# kernel.governor=conservativex
#
# DANCEDANCE
# kernel.governor=dancedance
#
# DARKNESS
# kernel.governor=darkness
#
# HYPER
# kernel.governor=hyper
#
# INTERACTIVE
# kernel.governor=interactive
#	
# INTEREXTREM
# kernel.governor=interextrem	
#
# LIONHEART
# kernel.governor=lionheart
#
# NIGHTMARE
# kernel.governor=nightmare
#
# ONDEMAND
# kernel.governor=ondemand
#
# ONDEMANDPLUS
# kernel.governor=ondemandplus
#
# PERFORMANCE
# kernel.governor=performance
#
# PRESERVATIVE
# kernel.governor=preservative
#
# SMARTASS2
# kernel.governor=smartass2
#
# USERSPACE
# kernel.governor=userspace
#
# WHEATLEY
# kernel.governor=wheatley
#----------------------------
# CPU CLOCK A53 (set min/max on A53 Cluster)
# A53-200
# kernel.cpu.a53.min=200000
#
# A53-300
# kernel.cpu.a53.min=300000
#
# A53-400
# kernel.cpu.a53.min=400000
#
#
# A53-1500
# kernel.cpu.a53.max=1500000
#
# A53-1600
# kernel.cpu.a53.max=1600000
#----------------------------
# CPU CLOCK A57 (set min/max on A57 Cluster)
#
# A57-200
# kernel.cpu.a57.min=200000
#
# A57-300
# kernel.cpu.a57.min=300000
#
# A57-400
# kernel.cpu.a57.min=400000
#
# A57-500
# kernel.cpu.a57.min=500000
#
# A57-600
# kernel.cpu.a57.min=600000
#
# A57-700
# kernel.cpu.a57.min=700000
#
# A57-800
# kernel.cpu.a57.min=800000
#
# A57-2100
# kernel.cpu.a57.max=2100000
#
# A57-2200
# kernel.cpu.a57.max=2200000
#
# A57-2304
# kernel.cpu.a57.max=2304000
#----------------------------
# TURBO (set turbo mod on)
# kernel.turbo=true
#
# NO_TURBO (set turbo mod 0ff)
# kernel.turbo=false
#----------------------------
# AUTO_INITD (init.d if Auto or ROM control)
# kernel.initd=true
#
# NO_INITD
# kernel.initd=false
#----------------------------
# FIX_GAPPS (GApps wakelock fix)
# kernel.gapps=true (set GApps wakelock fix on)
#
# kernel.gapps=false (set GApps wakelock fix off)
#----------------------------
# KNOX (remove knox apks)
# kernel.knox=true
#------------------------------------------
#
# default kernel setting in aroma
#
#----------------------------
# Stock Settings
#
# kernel.scheduler=cfq
# kernel.turbo=false
# kernel.governor=interactive
# kernel.cpu.a53.min=400000
# kernel.cpu.a53.max=1500000
# kernel.cpu.a57.min=800000
# kernel.cpu.a57.max=2100000
# kernel.initd=false
# kernel.gapps=false 
#
#----------------------------
# PERFORMANCE Settings
#
# kernel.scheduler=bfq
# kernel.turbo=true
# kernel.governor=performance
# kernel.cpu.a53.min=400000
# kernel.cpu.a53.max=1500000
# kernel.cpu.a57.min=800000
# kernel.cpu.a57.max=2100000
# kernel.initd=true
# kernel.gapps=false 
#
#----------------------------
# BATTERY Settings
#
# kernel.scheduler=noop
# kernel.turbo=false
# kernel.governor=interactive
# kernel.cpu.a53.min=200000
# kernel.cpu.a53.max=1500000
# kernel.cpu.a57.min=200000
# kernel.cpu.a57.max=2100000
# kernel.initd=false
# kernel.gapps=true
#
#------------------------------------------
#
# End of Read me


