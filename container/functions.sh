
# {{{ start_banner()
start_banner()
{
	echo "############################################################"
	echo "# START SCRIPT"
	echo "############################################################"
}
# }}}

# {{{ finish_banner()
# $1: time to start this script
finish_banner()
{
	S_TIME=$1
	E_TIME=$(date +%s)
	DURATION=$((E_TIME - S_TIME))
	echo "############################################################"
	echo "# FINISH SCRIPT ($DURATION seconds)"
	echo "############################################################"
}
# }}}

# {{{ call_own_fname()
call_own_fname()
{
	OFNM=$(basename $0)
	echo "$OFNM"
}
# }}}

# {{{ call_show_start_banner()
# $0: the name of the script being executed 
call_show_start_banner()
{
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n> START: Script = [$(call_own_fname)]\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
}
# }}}

# {{{ call_show_finish_banner()
# $0: the name of the script being executed 
call_show_finish_banner()
{
	echo "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n< FINISH: Script = [$(call_own_fname)]\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
}
# }}}

# {{{ show_list_container()
show_list_container()
{
	echo "\n### START: Show a list of container ##########"
	docker ps -a
}
# }}}
